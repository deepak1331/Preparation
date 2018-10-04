select
date(lucktastic_timestamp) as lucktastic_day,
case when opp_id in (2264) then 'ios' else platform end as platform,
count(distinct case when event_type = 'revenue_offer_wall_view' and opp_id in (146, 238, 2264) then user_id end) as wall_view_users,
count(distinct case when event_type = 'postback' and opp_id in (146, 238, 2264) then user_id end) as wall_install_users,
count(case when event_type = 'revenue_offer_wall_view' and opp_id = 238 then 1 end) as premium_wall_views,
count(case when event_type = 'postback' and opp_id = 238 then 1 end) as premium_wall_installs,
count(distinct case when event_type = 'revenue_offer_wall_view' and opp_id = 238 then user_id end) as premium_wall_view_users,
count(distinct case when event_type = 'postback' and opp_id = 238 then user_id end) as premium_wall_install_users,
count(case when event_type = 'revenue_offer_wall_view' and opp_id in (146, 2264) then 1 end) as standard_wall_views,
count(case when event_type = 'postback' and opp_id in (146, 2264) then 1 end) as standard_wall_installs,
count(distinct case when event_type = 'revenue_offer_wall_view' and opp_id in (146, 2264) then user_id end) as standard_wall_view_users,
count(distinct case when event_type = 'postback' and opp_id in (146, 2264) then user_id end) as standard_wall_install_users
from
	(select
	from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour as lucktastic_timestamp,
	opp_id,
	user_id,
	lower(platform) as platform,
	event_type
	from jrg_datalake_db_prod.datalake_events e
	where concat(year,'-',month,'-',day) in ('startDate', 'endDate') 
	and date(from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour) = cast('startDate' as date)
	and event_type in ('revenue_offer_wall_view', 'postback')
	)
where case when opp_id in (2264) then 'ios' else platform end in ('android', 'ios')
group by 1, 2
order by 1, 2;