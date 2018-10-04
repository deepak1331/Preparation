-- insert data into table
INSERT INTO lucktastic.wall_campaign_activity
WITH events AS (
  select
  event_id,
  event_type,
  lower(platform) as platform,
  user_id,
  opp_id,
  case
  when opp_id in (238, 2264, 146, 2727, 2763, 2764, 2765) then 'CPI' 
  when opp_id in (226, 532) then 'Gated' 
  when opp_id in (554) then 'CPX' 
  end as wall_type,
  case 
  when opp_id in (238, 2264) then 'CPI - Premium' 
  when opp_id in (146) then 'CPI - Standard' 
  when opp_id in (2727) then 'CPI - Hidden Easter Egg' 
  when opp_id in (2763) then 'CPI - 0 Installs'
  when opp_id in (2764) then 'CPI - 1 Installs'
  when opp_id in (2765) then 'CPI - 2 Installs'
  when opp_id in (226) then 'Gated - $777' 
  when opp_id in (532) then 'Gated - $2,000' 
  when opp_id in (554) then 'CPX - Button' 
  end as wall_sub_type,
  dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000)) as lucktastic_timestamp,
  datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) as dx,
  case 
  when datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) between 0 and 7
  then datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000)))
  when datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) between 8 and 14 then 8
  when datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) between 15 and 30 then 15
  when datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) between 31 and 60 then 31
  when datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) between 61 and 90 then 61
  when datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) between 91 and 180 then 91
  when datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) between 181 and 365 then 181
  when datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) between 366 and 730 then 366
  when datediff(day, dateadd(hour, -5, p.createdate), dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) > 730 then 731
  end as dx_band,
  json_extract_path_text(other_parameters, 'campaign_id') as campaign_id,
  json_extract_path_text(other_parameters, 'list_campaign_id') as campaign_id_list,
  json_extract_path_text(other_parameters, 'total_offers') as total_offers,
  json_extract_path_text(other_parameters, 'reward_amount') as revenue,
  row_number() over (partition by event_id order by timestamp) as event_rn,
  sum(case when event_type = 'revenue_offer_wall_view' then 1 else 0 end) over (partition by platform, user_id, opp_id order by lucktastic_timestamp rows unbounded preceding) as view_rank
  from spectrum_prod.datalake_events e
  left join lucktastic.profile p on e.user_id = p.userid
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
  and date(dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', timestamp 'epoch' + ("timestamp" * interval '1 second')/1000))) = current_date - 1
  and event_type in ('revenue_offer_wall_view', 'revenue_offer_detail', 'revenue_offer_detail_click', 'postback')
  and opp_id in (238, 2264, 146, 226, 532, 2727, 2763, 2764, 2765)
  and user_id <> '-1'
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
-- explode list of campaign ids on revenue_offer_wall_view event and assign campaign position
impressions AS (
	select
	event_id,
	event_type,
	platform,
	user_id,
	opp_id,
	wall_type,
	wall_sub_type,
	lucktastic_timestamp,
	dx,
	dx_band,
	replace(replace(replace(replace(replace(split_part(campaign_id_list, ',', i), '%20', ''), '[', ''), ']', ''), ' ', ''), '+', '') as campaign_id,
	revenue,
	view_rank,
	i as campaign_position
	from events
	cross join seq
	where i <= cast(total_offers as integer)
	and event_type = 'revenue_offer_wall_view'
	and total_offers <> '0'
	and event_rn = 1
	)
,
-- apply campaign position back to other events and append impressions
events_clean AS (
  select
  e.event_id,
  e.event_type,
  e.platform,
  e.user_id,
  e.opp_id,
  e.wall_type,
  e.wall_sub_type,
  e.lucktastic_timestamp,
  e.dx,
  e.dx_band,
  e.campaign_id,
  e.revenue,
  e.view_rank,
  campaign_position
  from events e
  left join impressions i 
  on e.platform = i.platform 
  and e.user_id = i.user_id 
  and e.opp_id = i.opp_id 
  and e.view_rank = i.view_rank
  and e.campaign_id = i.campaign_id
  where e.event_type <> 'revenue_offer_wall_view'
  union
  select * from impressions
  )
,
-- order campaign impressions by position to get mode
modal_position AS (
  select
  date(lucktastic_timestamp) as date,
  opp_id,
  campaign_id,
  campaign_position,
  count(1) as impressions,
  row_number() over (partition by opp_id, campaign_id order by impressions desc, campaign_position) as rn
  from impressions
  group by 1, 2, 3, 4
  )
,
-- find the latest cap for each campaign
cap AS (
  select
  campaign_id,
  cap,
  row_number() over (partition by campaign_id order by _id desc) as rn
  from spectrum_prod.lucktastic_xcampaign_rules
  where cap is not null and split_part(focus, '_', 2) = campaign_id
  )
select
date(lucktastic_timestamp) as date,
e.platform,
e.opp_id,
wall_type,
wall_sub_type,
dx_band,
case when e.campaign_id in ('', 'none') then null else e.campaign_id::int end as campaign_id,
e.campaign_position,
mp.campaign_position as modal_position,
cn.campaign_name,
cap,
campaign_award_value as award_value,
sum(case when event_type = 'revenue_offer_wall_view' then e.campaign_position end) as sum_position,
count(case when event_type = 'revenue_offer_wall_view' then 1 end) as impressions,
count(case when event_type = 'revenue_offer_wall_view' and e.campaign_position <= 3 then 1 end) as viewable_impressions,
count(case when event_type = 'revenue_offer_detail' then 1 end) as detail_views,
count(case when event_type = 'revenue_offer_detail_click' then 1 end) as detail_clicks,
count(case when event_type = 'postback' then 1 end) as installs,
count(distinct case when event_type = 'revenue_offer_wall_view' then user_id end) as impression_users,
count(distinct case when event_type = 'revenue_offer_wall_view' and e.campaign_position <= 3 then user_id end) as viewable_impression_users,
count(distinct case when event_type = 'revenue_offer_detail' then user_id end) as detail_users,
count(distinct case when event_type = 'revenue_offer_detail_click' then user_id end) as detail_click_users,
count(distinct case when event_type = 'postback' then user_id end) as install_users,
sum(case when revenue <> '' then revenue::float end) as revenue,
max(case when event_type = 'revenue_offer_wall_view' then lucktastic_timestamp end) as last_impression_timestamp
from events_clean e
left join modal_position mp on date(e.lucktastic_timestamp) = mp.date and e.opp_id = mp.opp_id and e.campaign_id = mp.campaign_id and mp.rn = 1
left join spectrum_prod.lucktastic_xcampaign c on e.campaign_id = c.campaign_id
left join lucktastic.xcampaign_metrics_new cn on e.campaign_id = cn.campaign_id and date(e.lucktastic_timestamp) = cn.lastupdate
left join cap on e.campaign_id = cap.campaign_id and cap.rn = 1
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
;