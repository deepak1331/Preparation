-- insert data to staging
WITH ad_events AS (
	select
	user_id,
	"timestamp",
	dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000)) as lucktastic_timestamp,
	lower(platform) as platform,
	event_type,
	opp_id,
	opp_type,
	oppdescription,
	replace(lower(json_extract_path_text(other_parameters, 'ad_network')), '_', '-') as ad_network,
	json_extract_path_text(other_parameters, 'placement') as placement,
	json_extract_path_text(other_parameters, 'inventory_type') as inventory_type,
	json_extract_path_text(other_parameters, 'campaign_id') as campaign_id,
	json_extract_path_text(other_parameters, 'reward_amount') as reward_amount,
	json_extract_path_text(other_parameters, 'list_campaign_id') as campaign_id_list,
	json_extract_path_text(other_parameters, 'total_offers') as total_offers,
	row_number() over (partition by event_id order by timestamp) as event_id_rn
	from spectrum_prod.datalake_events e
	left join spectrum_prod.mmillen_oppid_lookup ol on e.opp_id = ol.oppid
	where 
  	(
  	(year = cast(datepart(year, current_date) as varchar) 
  	and month = lpad(cast(datepart(month, current_date) as varchar), 2, '0')
  	and day = lpad(cast(datepart(day, current_date) as varchar), 2, '0'))
  	or 
  	(year = cast(datepart(year, dateadd(day, -1, current_date)) as varchar)
  	and month = lpad(cast(datepart(month, dateadd(day, -1, current_date)) as varchar), 2, '0')
  	and day = lpad(cast(datepart(day, dateadd(day, -1, current_date)) as varchar), 2, '0'))
  	)
  and date(dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) = dateadd(day, -1, current_date)
  /*
  where 
  	(
  	(year = '2018'
  	and month = '01'
  	and day = '23')
  	or 
  	(year = '2018'
  	and month = '01'
  	and day = '24')
  	)
  and date(dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) = '2018-01-23'
  */
	and (event_type in
	('ad_request', 'ad_start', 'ad_complete', 'opp_start', 'game_play_complete', 'ad_inventory',
	'revenue_offer_wall_view', 'revenue_offer_detail', 'revenue_offer_detail_click')
	or (event_type = 'postback' and json_extract_path_text(other_parameters, 'event_name') = 'install'))
	)
,
------------------------------
-- VIDEOS AND INTERSTITIALS --
------------------------------
-- TAKEOVER VIDEOS (HAMSTER WHEEL)
takeover_prep AS (
	select v.*,
	sum(case when event_type in ('opp_start', 'ad_inventory') then 1 else 0 end) 
	over (partition by user_id, opp_id, date(lucktastic_timestamp) order by timestamp rows unbounded preceding) as inventory_number
	from ad_events v
	where opp_type = 'contest takeover' 
	and lower(oppdescription) like '%video%'
	and event_type in ('opp_start', 'ad_inventory', 'ad_request', 'ad_start', 'ad_complete', 'postback')
	and event_id_rn = 1
	order by user_id, timestamp
	)
,
takeovers AS (
	select
	date(lucktastic_timestamp) as lucktastic_day,
	lucktastic_timestamp,
	case
	when coalesce(ad_network, '') = '' then 'Third Party / CPI Video'
	when ad_network = 'smartadserver' then 'CPI Video'
	when event_type = 'postback' then 'CPI Video'
	else 'Third Party'
	end::varchar as revenue_stream,
	platform,
	opp_type,
	ad_network,
	'pre-roll'::varchar as placement,
	campaign_id,
	user_id,
	opp_id,
	inventory_number,
	event_type,
	case
	when event_type in ('opp_start', 'ad_inventory') then 'potential'
	when event_type in ('ad_request') then 'request'
	when event_type in ('ad_start') then 'start'
	when event_type in ('ad_complete') and ad_network <> 'smartadserver' then 'complete'
	when event_type in ('postback') then 'complete'
	end::varchar as metric,
	reward_amount as cpi_revenue
	from takeover_prep
	order by user_id, opp_id, timestamp
	)
,
-- CARDS
cards_prep AS (
	select *,
	row_number() over (partition by date(lucktastic_timestamp), opp_id, user_id, inventory_number order by timestamp) as rn
	from
		(select v.*,
		sum(case when event_type in ('opp_start', 'game_play_complete') then 1 else 0 end) 
		over (partition by user_id, opp_id, date(lucktastic_timestamp) order by timestamp rows unbounded preceding) as inventory_number
		from ad_events v
		where opp_type = 'card' 
		and event_type in ('opp_start', 'game_play_complete', 'ad_request', 'ad_start', 'ad_complete', 'postback')
		and event_id_rn = 1
		order by user_id, timestamp
		) 
	)
,	
cards AS (
	select
	date(lucktastic_timestamp) as lucktastic_day,
	lucktastic_timestamp,
	case
	when c1.event_type = 'postback' then 'CPI Video'
	when ad_network = 'smartadserver' then 'CPI Video'
	when coalesce(ad_network, '') = '' then 'Third Party / CPI Video'
	else 'Third Party'
	end::varchar as revenue_stream,
	platform,
	opp_type,
	ad_network,
	case 
	when c2.event_type = 'opp_start' then 'pre-roll'
	when c2.event_type = 'game_play_complete' and opp_type = 'card' then 'post-roll'
	when coalesce(placement, 'unknown') not in ('pre_roll', 'post_roll') then 'pre-roll'
	else replace(placement, '_', '-') 
	end as placement,
	campaign_id,
	c1.user_id,
	c1.opp_id,	
	c1.inventory_number,
	c1.event_type,
	case
	when c1.event_type in ('opp_start', 'game_play_complete') then 'potential'
	when c1.event_type in ('ad_request') then 'request'
	when c1.event_type in ('ad_start') then 'start'
	when c1.event_type in ('ad_complete') and ad_network <> 'smartadserver' then 'complete'
	when c1.event_type in ('postback') then 'complete'
	end::varchar as metric,
	reward_amount as cpi_revenue
	from cards_prep c1
	left join
		(select date(lucktastic_timestamp) as lucktastic_day,
		opp_id,
		user_id,
		inventory_number,
		event_type
		from cards_prep 
		where rn = 1
		) c2 on date(c1.lucktastic_timestamp) = c2.lucktastic_day and c1.opp_id = c2.opp_id and c1.user_id = c2.user_id and c1.inventory_number = c2.inventory_number
	order by c1.user_id, c1.opp_id, timestamp
	)
,
-- FUN PACKS
fun_packs AS (
	select
	date(lucktastic_timestamp) as lucktastic_day,
	lucktastic_timestamp,
	case
	when coalesce(ad_network, '') = '' then 'Third Party / CPI Video'
	when ad_network = 'smartadserver' then 'CPI Video'
	when event_type = 'postback' then 'CPI Video'
	else 'Third Party'
	end::varchar as revenue_stream,
	platform,
	opp_type,
	ad_network,
	case 
	when placement = 'pre_roll' then 'pre-roll'
	when placement = 'post_roll' then 'post-roll'
	else 'pre-roll'
	end as placement,
	campaign_id,
	user_id,
	opp_id,	
	1 as inventory_number,
	event_type,
	case
	when event_type in ('opp_start') then 'potential'
	when event_type in ('ad_request') then 'request'
	when event_type in ('ad_start') then 'start'
	when event_type in ('ad_complete') and ad_network <> 'smartadserver' then 'complete'
	when event_type in ('postback') then 'complete'
	end::varchar as metric,
	reward_amount as cpi_revenue
	from ad_events v
	where opp_type = 'fun pack' 
	and event_type in ('opp_start', 'ad_request', 'ad_start', 'ad_complete', 'postback')
	and event_id_rn = 1
	order by user_id, opp_id, timestamp
	)
,
-- SPECIAL PLACEMENTS
specials AS (
	select
	date(lucktastic_timestamp) as lucktastic_day,
	lucktastic_timestamp,
	'CPI Video'::varchar as revenue_stream,
	platform,
	opp_type,
	'smartadserver'::varchar as ad_network,
	'pre-roll'::varchar as placement,
	campaign_id,
	user_id,
	opp_id,	
	1 as inventory_number,
	event_type,
	case
	when event_type in ('opp_start') then 'potential'
	when event_type in ('ad_request') then 'request'
	when event_type in ('ad_start') then 'start'
	--when event_type in ('ad_complete') then 'complete'
	when event_type in ('postback') then 'complete'
	end::varchar as metric,
	reward_amount as cpi_revenue
	from ad_events v
	where opp_type = 'special' 
	and event_type in ('opp_start', 'ad_request', 'ad_start', 'ad_complete', 'postback')
	and event_id_rn = 1
	order by user_id, opp_id, timestamp
	)
,
-- CONTEST DASH
contest_dash AS (
	select
	date(lucktastic_timestamp) as lucktastic_day,
	lucktastic_timestamp,
	case
	when coalesce(ad_network, '') = '' then 'Third Party / CPI Video'
	when ad_network = 'smartadserver' then 'CPI Video'
	when event_type = 'postback' then 'CPI Video'
	else 'Third Party'
	end::varchar as revenue_stream,
	platform,
	opp_type,
	ad_network,
	case 
	when placement = 'pre_roll' then 'pre-roll'
	when placement = 'post_roll' then 'post-roll'
	else 'pre-roll'
	end as placement,
	campaign_id,
	user_id,
	opp_id,	
	1 as inventory_number,
	event_type,
	case
	when event_type in ('opp_start') then 'potential'
	when event_type in ('ad_request') then 'request'
	when event_type in ('ad_start') then 'start'
	when event_type in ('ad_complete') and ad_network <> 'smartadserver' then 'complete'
	when event_type in ('postback') then 'complete'
	end::varchar as metric,
	reward_amount as cpi_revenue
	from ad_events v
	where opp_type = 'contest dash' 
	and event_type in ('opp_start', 'ad_request', 'ad_start', 'ad_complete', 'postback')
	and event_id_rn = 1
	order by user_id, opp_id, timestamp
	)
,
---------------
-- CPI WALLS --
---------------
-- join to oppid_lookup and assign placement based on opp_type and description
wall_opp_type AS (
	select w.*,
	case
	when opp_id in (238, 2251) then 'premium wall'
	when opp_id in (146) then 'standard wall'
	when opp_id in (226, 532) then 'gated wall'
	end::varchar as wall_placement
	from ad_events w
	where event_type in ('revenue_offer_wall_view', 'revenue_offer_detail', 'revenue_offer_detail_click', 'postback')
	and event_id_rn = 1
	)
,
-- generic counter from 1 to 100 used to explode lists
seq AS (
	select cast(row_number() over () as integer) as i
	from lucktastic.opportunities
	order by i
	limit 100
	)
,
-- explode list of campaign ids on revenue_offer_wall_view event
revenue_offer_wall_view AS (
	select *,
	replace(replace(replace(replace(replace(split_part(campaign_id_list, ',', i), '%20', ''), '[', ''), ']', ''), ' ', ''), '+', '') as campaign_id_split
	from wall_opp_type
	cross join seq
	where i <= cast(total_offers as integer)
	and event_type = 'revenue_offer_wall_view'
	and total_offers <> '0'
	and wall_placement is not null
	)
,
-- combine events at campaign id level
walls AS (
	-- revenue_offer_wall_view events exlpoded
	select
	date(lucktastic_timestamp) as lucktastic_day,
	lucktastic_timestamp,
	'CPI Wall'::varchar as revenue_stream,
	platform,
	opp_type,
	'N/A'::varchar as ad_network,
	wall_placement as placement,
	campaign_id_split as campaign_id,
	user_id,
	opp_id,
	1 as inventory_number,
	event_type,
	case
	when event_type in ('revenue_offer_wall_view') then 'potential'
	when event_type in ('revenue_offer_detail') then 'request'
	when event_type in ('revenue_offer_detail_click') then 'start'
	when event_type in ('postback') then 'complete'
	end::varchar as metric,
	reward_amount as cpi_revenue
	from revenue_offer_wall_view
	union all
	-- events excluding revenue_offer_wall_view
	select
	date(lucktastic_timestamp) as lucktastic_day,
	lucktastic_timestamp,
	'CPI Wall'::varchar as revenue_stream,
	platform,
	opp_type,
	'N/A'::varchar as ad_network,
	wall_placement as placement,
	campaign_id,
	user_id,
	opp_id,
	1 as inventory_number,
	event_type,
	case
	when event_type in ('revenue_offer_wall_view') then 'potential'
	when event_type in ('revenue_offer_detail') then 'request'
	when event_type in ('revenue_offer_detail_click') then 'start'
	when event_type in ('postback') then 'complete'
	end::varchar as metric,
	reward_amount as cpi_revenue
	from wall_opp_type
	where wall_placement is not null
	and event_type <> 'revenue_offer_wall_view'
	)
,
combined AS 
	(select * from walls
	union all
	select * from takeovers
	union all
	select * from cards
	union all
	select * from fun_packs
	union all
	select * from specials
	union all
	select * from contest_dash
	)
,
biz_tranx AS (
	select 
	c.lucktastic_day,
	case
	when revenue_stream in ('Third Party', 'CPI Video', 'Third Party / CPI Video') then 'Videos & Interstitials'
	when revenue_stream = 'CPI Wall' then 'Walls'
	end as inventory_type,
	revenue_stream,
	platform,
	opp_type,
	case when coalesce(ad_network, '') = '' then 'N/A' else ad_network end as ad_network,
	placement,
	case when revenue_stream = 'CPI Wall' then campaign_id else 'N/A' end as campaign_id, 
	-- revisit this for CPI Videos
	c.user_id,
	opp_id,
	metric,
	cpi_revenue,
	cast(c.lucktastic_day as varchar)||'_'||c.user_id||'_'||cast(opp_id as varchar)||'_'||cast(inventory_number as varchar) as inventory_id,
	case
	when datediff(day, date(dateadd(hour, -5, p.createdate)), c.lucktastic_day) < 0 then 'D31+'
	when datediff(day, date(dateadd(hour, -5, p.createdate)), c.lucktastic_day) <= 7 then 
	'D0'||cast(datediff(day, date(dateadd(hour, -5, p.createdate)), c.lucktastic_day) as varchar)
	when datediff(day, date(dateadd(hour, -5, p.createdate)), c.lucktastic_day) <= 30 then 'D08 to D30'
	when datediff(day, date(dateadd(hour, -5, p.createdate)), c.lucktastic_day) > 30 then 'D31+'
	end as dx_band,
	source as acquisition_source
	from combined c
	left join lucktastic.profile p on c.user_id = p.userid
	)
select *
into lucktastic.tmp_biz_tranx
from biz_tranx
;

-- insert aggregated data to production
insert into lucktastic.business_transaction_summary
select 
lucktastic_day,
coalesce(inventory_type, 'ALL') as inventory_type,
coalesce(revenue_stream, 'ALL') as revenue_stream,
coalesce(dx_band, 'ALL') as dx_band,
coalesce(acquisition_source, 'ALL') as acquisition_source,
coalesce(platform, 'ALL') as platform,
coalesce(opp_type, 'ALL') as opp_type,
coalesce(placement, 'ALL') as placement,
coalesce(ad_network, 'ALL') as ad_network,
coalesce(campaign_id, 'ALL') as campaign_id,
count(distinct case when metric = 'potential' then inventory_id end) as potential_inventory,
count(distinct case when metric = 'request' then inventory_id end) as requested_inventory,
count(distinct case when placement = 'gated wall' and metric = 'request' or metric = 'start' then inventory_id end) as started_transactions,
count(distinct case when metric = 'complete' then inventory_id end) as completed_transactions,
sum(case when cpi_revenue = '' then 0 else cast(cpi_revenue as decimal) end) as cpi_revenue,
0 as cpv_revenue
from lucktastic.tmp_biz_tranx
where platform in ('android', 'ios')
and dx_band is not null
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
union all
-- ALL value for revenue_stream and ad_network
select 
lucktastic_day,
coalesce(inventory_type, 'ALL') as inventory_type,
'ALL' as revenue_stream,
coalesce(dx_band, 'ALL') as dx_band,
coalesce(acquisition_source, 'ALL') as acquisition_source,
coalesce(platform, 'ALL') as platform,
coalesce(opp_type, 'ALL') as opp_type,
coalesce(placement, 'ALL') as placement,
'ALL' as ad_network,
coalesce(campaign_id, 'ALL') as campaign_id,
count(distinct case when metric = 'potential' then inventory_id end) as potential_inventory,
count(distinct case when metric = 'request' then inventory_id end) as requested_inventory,
count(distinct case when placement = 'gated wall' and metric = 'request' or metric = 'start' then inventory_id end) as started_transactions,
count(distinct case when metric = 'complete' then inventory_id end) as completed_transactions,
sum(case when cpi_revenue = '' then 0 else cast(cpi_revenue as decimal) end) as cpi_revenue,
0 as cpv_revenue
from lucktastic.tmp_biz_tranx
where platform in ('android', 'ios')
--and dx_band is not null
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
union all
-- ALL value for ad_network
select 
lucktastic_day,
coalesce(inventory_type, 'ALL') as inventory_type,
coalesce(revenue_stream, 'ALL') as revenue_stream,
coalesce(dx_band, 'ALL') as dx_band,
coalesce(acquisition_source, 'ALL') as acquisition_source,
coalesce(platform, 'ALL') as platform,
coalesce(opp_type, 'ALL') as opp_type,
coalesce(placement, 'ALL') as placement,
'ALL' as ad_network,
coalesce(campaign_id, 'ALL') as campaign_id,
count(distinct case when metric = 'potential' then inventory_id end) as potential_inventory,
count(distinct case when metric = 'request' then inventory_id end) as requested_inventory,
count(distinct case when placement = 'gated wall' and metric = 'request' or metric = 'start' then inventory_id end) as started_transactions,
count(distinct case when metric = 'complete' then inventory_id end) as completed_transactions,
sum(case when cpi_revenue = '' then 0 else cast(cpi_revenue as decimal) end) as cpi_revenue,
0 as cpv_revenue
from lucktastic.tmp_biz_tranx
where platform in ('android', 'ios')
--and dx_band is not null
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
order by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
;

-- drop staging
drop table if exists lucktastic.tmp_biz_tranx;
