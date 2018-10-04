select 
date(from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour) as lucktastic_day,
lower(platform) as platform,
opp_type,
case
when date_diff('day', cast(p.lucktastic_day as date), date(from_unixtime(e.timestamp/1000) at time zone 'America/New_York' - interval '5' hour)) between 0 and 30
then date_diff('day', cast(p.lucktastic_day as date), date(from_unixtime(e.timestamp/1000) at time zone 'America/New_York' - interval '5' hour))
when date_diff('day', cast(p.lucktastic_day as date), date(from_unixtime(e.timestamp/1000) at time zone 'America/New_York' - interval '5' hour)) between 31 and 60 then 31
when date_diff('day', cast(p.lucktastic_day as date), date(from_unixtime(e.timestamp/1000) at time zone 'America/New_York' - interval '5' hour)) between 61 and 90 then 61
when date_diff('day', cast(p.lucktastic_day as date), date(from_unixtime(e.timestamp/1000) at time zone 'America/New_York' - interval '5' hour)) between 91 and 180 then 91
when date_diff('day', cast(p.lucktastic_day as date), date(from_unixtime(e.timestamp/1000) at time zone 'America/New_York' - interval '5' hour)) between 181 and 365 then 181
when date_diff('day', cast(p.lucktastic_day as date), date(from_unixtime(e.timestamp/1000) at time zone 'America/New_York' - interval '5' hour)) between 366 and 730 then 366
when date_diff('day', cast(p.lucktastic_day as date), date(from_unixtime(e.timestamp/1000) at time zone 'America/New_York' - interval '5' hour)) > 730 then 731
end as dx,
lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) as network,
json_extract_scalar(other_parameters, '$.placement') as app_placement, 
replace(replace(json_extract_scalar(other_parameters, '$.step_payload'), chr(10), ''), '+', '') as step_payload,
case 
when lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) in ('fban', 'fban_rewarded')
then json_extract_scalar(replace(replace(json_extract_scalar(other_parameters, '$.step_payload'), chr(10), ''), '+', ''), '$.PlacementId')
when lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) in ('vungle')
then json_extract_scalar(replace(replace(json_extract_scalar(other_parameters, '$.step_payload'), chr(10), ''), '+', ''), '$.PlacementID')
when lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) in ('adcolony', 'admob')
then json_extract_scalar(replace(replace(json_extract_scalar(other_parameters, '$.step_payload'), chr(10), ''), '+', ''), '$.zoneid')
when lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) in ('apponboard')
then json_extract_scalar(replace(replace(json_extract_scalar(other_parameters, '$.step_payload'), chr(10), ''), '+', ''), '$.ZoneId')
when lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) in ('mopub', 'mobvista')
then json_extract_scalar(replace(replace(json_extract_scalar(other_parameters, '$.step_payload'), chr(10), ''), '+', ''), '$.AdUnitID')
when lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) in ('unityads')
then json_extract_scalar(replace(replace(json_extract_scalar(other_parameters, '$.step_payload'), chr(10), ''), '+', ''), '$.placement_id')
when lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) in ('applovin')
then json_extract_scalar(replace(replace(json_extract_scalar(other_parameters, '$.step_payload'), chr(10), ''), '+', ''), '$.Placement')
when lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) in ('tapjoy')
then json_extract_scalar(replace(replace(json_extract_scalar(other_parameters, '$.step_payload'), chr(10), ''), '+', ''), '$.PlacementName')
end as placement_id,
cast(json_extract_scalar(other_parameters, '$.mediation_step_number') as integer) as mediation_step,
count(case when event_type = 'ad_request' then 1 end) as requests,
count(case when event_type = 'ad_start' then 1 end) as starts,
count(case when event_type = 'ad_complete' then 1 end) as completes
from jrg_datalake_db_prod.datalake_events e
left join profile_created p on e.user_id = p.user_id
left join oppid_lookup ol on e.opp_id = ol.oppid
where 
	(
	(year = cast(year(current_date) as varchar) 
	and month = lpad(cast(month(current_date) as varchar), 2, '0')
	and day = lpad(cast(day(current_date) as varchar), 2, '0'))
	or 
	(year = cast(year(current_date - interval '1' day) as varchar) 
	and month = lpad(cast(month(current_date - interval '1' day) as varchar), 2, '0')
	and day = lpad(cast(day(current_date - interval '1' day) as varchar), 2, '0'))
	)
and date(from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour) = current_date - interval '1' day
and event_type in ('ad_request', 'ad_start', 'ad_complete')
and lower(replace(json_extract_scalar(other_parameters, '$.ad_network'), '-', '_')) <> 'smartadserver'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9
order by 1, 2, 3, 4, 5, 6, 7, 8, 9
;