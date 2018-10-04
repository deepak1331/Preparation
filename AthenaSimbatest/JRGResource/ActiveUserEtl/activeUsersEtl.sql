-- PROFILE OPP METRICS FOR CURRENT MONTH
WITH transactions AS (
	select 
	lower(split_part(deviceos, ' ', 1)) as platform,
	userid,
	date_diff('day', cast(p.lucktastic_day as date), date(po.createstamp - interval '5' hour)) as dx,
	date_diff('month', date_trunc('month', cast(p.lucktastic_day as date)), date_trunc('month', po.createstamp - interval '5' hour)) as mx,
	date(createstamp - interval '5' hour) as lucktastic_day,
	count(1) as opp_complete,
	count(case when lower(coalesce(presentationview, 'missing')) not like 'demo%' then 1 end) as non_demo_opp_complete,
	row_number() over (partition by lower(split_part(deviceos, ' ', 1)), userid order by date(createstamp - interval '5' hour)) as opp_complete_rn,
	case 
	when count(case when lower(coalesce(presentationview, 'missing')) not like 'demo%' then 1 end) = 0 then null 
	else row_number() over (partition by lower(split_part(deviceos, ' ', 1)), userid, count(case when lower(coalesce(presentationview, 'missing')) not like 'demo%' then 1 end) > 0 
	order by date(createstamp - interval '5' hour)) 
	end as non_demo_opp_complete_rn
	from jrg_datalake_db_prod.lucktastic_profile_opp po
	left join jrg_datalake_db_prod.lucktastic_opportunities o on po.oppid = o.oppid
	left join profile_created p on po.userid = p.user_id
	where date(createstamp - interval '5' hour) >= cast(substring(cast(current_date - interval '1' day as varchar), 1, 7)||'-01' as date)
	and date(createstamp - interval '5' hour) < current_date
	and isfulfilled = true
	group by 1, 2, 3, 4, 5
	)
,
transaction_summary AS (
	-- monthly latest date
	select
	lucktastic_day as date,
	platform,
	'monthly' as metric_set,
	'daily' as granularity,
	case
	when coalesce(mx, 0) between 0 and 2 then 'M'||cast(coalesce(mx, 0) as varchar)
	when mx >= 3 then 'M3+'
	end as user_category,
	count(distinct case when opp_complete_rn = 1 then userid end) as opp_complete,
	count(distinct case when non_demo_opp_complete_rn = 1 then userid end) as non_demo_opp_complete
	from transactions 
	where coalesce(platform, '') in ('android', 'ios')
	and lucktastic_day = current_date - interval '1' day
	group by 1, 2, 3, 4, 5
	-- monthly totals
	union
	select
	current_date - interval '1' day as date,
	platform,
	'monthly' as metric_set,
	'monthly' as granularity,
	case
	when coalesce(mx, 0) between 0 and 2 then 'M'||cast(coalesce(mx, 0) as varchar)
	when mx >= 3 then 'M3+'
	end as user_category,
	count(distinct case when opp_complete > 0 then userid end) as opp_complete,
	count(distinct case when non_demo_opp_complete > 0 then userid end) as non_demo_opp_complete
	from transactions 
	where coalesce(platform, '') in ('android', 'ios')
	group by 1, 2, 3, 4, 5
	-- daily breakdown
	union
	select
	lucktastic_day as date,
	platform,
	'daily' as metric_set,
	'daily' as granularity,
	case when dx = 0 then 'New' else 'Repeat' end as user_category,
	count(distinct case when opp_complete > 0 then userid end) as opp_complete,
	count(distinct case when non_demo_opp_complete > 0 then userid end) as non_demo_opp_complete
	from transactions 
	where coalesce(platform, '') in ('android', 'ios')
	and lucktastic_day = current_date - interval '1' day
	group by 1, 2, 3, 4, 5
	)
,
-- TRACKER EVENTS FOR CURRENT MONTH WITH BACKFILL LOGIC
raw_events AS (
	select 
	from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour as lucktastic_timestamp,
	lower(platform) as platform,
	e.user_id,
	device_id,
	date_add('day', -dx, date(from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour)) as inferred_profile_date,
	case when event_type = 'dashboard_view_start' then 1 else 0 end as dash_event,
	case when event_type in 
	('opp_complete', 'game_play_complete', 'ad_start', 'funnel_10_entries_click', 'funnel_spinwheel_rollup_click', 'contests_entry_submitted', 'takeover_tiered_contest_success', 'postback',
	'organic_facebook_app_invites', 'takeover_share_facebook_complete', 'takeover_share_twitter_complete', 'funnel_twitter_share_complete', 'funnel_facebook_share_complete', 
	'onboarding_demo_card_complete') then 1 else 0 end as active_event,
	case when event_type in 
	('game_play_complete', 'ad_start', 'funnel_10_entries_click', 'funnel_spinwheel_rollup_click', 'contests_entry_submitted', 'takeover_tiered_contest_success', 'postback',
	'organic_facebook_app_invites', 'takeover_share_facebook_complete', 'takeover_share_twitter_complete', 'funnel_twitter_share_complete', 'funnel_facebook_share_complete') 
	or (event_type = 'opp_complete' and opp_type <> 'demo') then 1 else 0 end as non_demo_active_event
	from jrg_datalake_db_prod.datalake_events e
	left join jrg_datalake_db_prod.mmillen_oppid_lookup ol on e.opp_id = ol.oppid
	where (
		(year = cast(year(current_date - interval '1' day) as varchar)
		and month = lpad(cast(month(current_date - interval '1' day) as varchar), 2, '0'))
		or 
		(year = cast(year(current_date) as varchar)
		and month = lpad(cast(month(current_date) as varchar), 2, '0')
		and day = lpad(cast(day(current_date) as varchar), 2, '0'))
		)
	and date(from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour) >= cast(substring(cast(current_date - interval '1' day as varchar), 1, 7)||'-01' as date)
	and date(from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour) < current_date
	--  where year = '2018' and month = '02' and day in ('25', '26', '27', '28')
	and event_type in ('app_launch', 'onboarding_zip_code', 'onboarding_zip_view', 'dashboard_view_start', 'opp_start', 'onboarding_demo_card_complete',
	'opp_complete', 'game_play_complete', 'ad_start', 'funnel_10_entries_click', 'funnel_spinwheel_rollup_click', 'contests_entry_submitted', 'postback', 'takeover_tiered_contest_success', 
	'organic_facebook_app_invites', 'takeover_share_facebook_complete', 'takeover_share_twitter_complete', 'funnel_twitter_share_complete', 'funnel_facebook_share_complete')
	)
,
-- create mapping between device ids and user ids when user id exists
device_mapping AS (
	select 
	user_id, 
	device_id,
	min(lucktastic_timestamp) as min_timestamp,
	row_number() over (partition by device_id order by min(lucktastic_timestamp)) as rn
	from raw_events
	where coalesce(user_id, '') not in ('', '-1')
	and coalesce(device_id, '') <> ''
	group by 1, 2
	)
,
-- join mapped user ids back to events data
events AS (
	select
	e.*,
	case
	when coalesce(e.user_id, '') = '' and coalesce(dm.user_id, '') <> '' then dm.user_id
	when coalesce(e.user_id, '') = '' and coalesce(dm.user_id, '') = '' then e.device_id
	else e.user_id
	end as uid,
	coalesce(cast(p.lucktastic_day as date), inferred_profile_date) as profile_create_date,
	coalesce(date_diff('day', coalesce(cast(p.lucktastic_day as date), inferred_profile_date), date(e.lucktastic_timestamp)), 0) as dx,
	coalesce(date_diff('month', date_trunc('month', coalesce(cast(p.lucktastic_day as date), inferred_profile_date)), date_trunc('month', e.lucktastic_timestamp)), 0) as mx,
	date(e.lucktastic_timestamp) as lucktastic_day
	from raw_events e
	left join device_mapping dm on e.device_id = dm.device_id and dm.rn = 1
	left join profile_created p on case
	when coalesce(e.user_id, '') = '' and coalesce(dm.user_id, '') <> '' then dm.user_id
	else e.user_id end = p.user_id
	)
,
-- aggregate activity by uid
uid_agg AS (
	select 
	platform,
	uid,
	dx,
	mx,
	lucktastic_day,
	count(1) as any_event,
	count(case when dash_event = 1 then 1 end) as dash_view,
	count(case when active_event = 1 then 1 end) as active,
	count(case when non_demo_active_event = 1 then 1 end) as non_demo_active,
	row_number() over (partition by platform, uid order by lucktastic_day) as any_event_rn,
	case 
	when count(case when dash_event = 1 then 1 end) = 0 then null 
	else row_number() over (partition by platform, uid, count(case when dash_event = 1 then 1 end) > 0 order by lucktastic_day) 
	end as dash_view_rn,
	case 
	when count(case when active_event = 1 then 1 end) = 0 then null 
	else row_number() over (partition by platform, uid, count(case when active_event = 1 then 1 end) > 0 order by lucktastic_day) 
	end as active_rn,
	case 
	when count(case when non_demo_active_event = 1 then 1 end) = 0 then null 
	else row_number() over (partition by platform, uid, count(case when non_demo_active_event = 1 then 1 end) > 0 order by lucktastic_day) 
	end as non_demo_active_rn
	from events
	group by 1, 2, 3, 4, 5
	)
,
events_summary AS (
	-- monthly latest date
	select
	lucktastic_day as date,
	platform,
	'monthly' as metric_set,
	'daily' as granularity,
	case
	when coalesce(mx, 0) between 0 and 2 then 'M'||cast(coalesce(mx, 0) as varchar)
	when mx >= 3 then 'M3+'
	end as user_category,
	count(distinct case when any_event_rn = 1 then uid end) as any_event,
	count(distinct case when dash_view_rn = 1 then uid end) as dash_view,
	count(distinct case when active_rn = 1 then uid end) as active,
	count(distinct case when non_demo_active_rn = 1 then uid end) as non_demo_active
	from uid_agg 
	where uid not in ('', '-1')
	and coalesce(platform, '') <> '' 
	and lucktastic_day = current_date - interval '1' day
	group by 1, 2, 3, 4, 5
	-- monthly totals
	union
	select
	current_date - interval '1' day as date,
	platform,
	'monthly' as metric_set,
	'monthly' as granularity,
	case
	when coalesce(mx, 0) between 0 and 2 then 'M'||cast(coalesce(mx, 0) as varchar)
	when mx >= 3 then 'M3+'
	end as user_category,
	count(distinct case when any_event > 0 then uid end) as any_event,
	count(distinct case when dash_view > 0 then uid end) as dash_view,
	count(distinct case when active > 0 then uid end) as active,
	count(distinct case when non_demo_active > 0 then uid end) as non_demo_active
	from uid_agg 
	where uid not in ('', '-1')
	and coalesce(platform, '') <> '' 
	group by 1, 2, 3, 4, 5
	-- daily breakdown
	union
	select
	lucktastic_day as date,
	platform,
	'daily' as metric_set,
	'daily' as granularity,
	case when dx = 0 then 'New' else 'Repeat' end as user_category,
	count(distinct case when any_event > 0 then uid end) as any_event,
	count(distinct case when dash_view > 0 then uid end) as dash_view,
	count(distinct case when active > 0 then uid end) as active,
	count(distinct case when non_demo_active > 0 then uid end) as non_demo_active
	from uid_agg 
	where uid not in ('', '-1')
	and coalesce(platform, '') <> '' 
	and lucktastic_day = current_date - interval '1' day
	group by 1, 2, 3, 4, 5
	)
-- OUTPUT
select t.*,
any_event,
dash_view,
active,
non_demo_active
from transaction_summary t
left join events_summary e 
on t.date = e.date 
and t.platform = e.platform 
and t.metric_set = e.metric_set 
and t.granularity = e.granularity 
and t.user_category = e.user_category
order by 1, 2, 3, 4, 5
;