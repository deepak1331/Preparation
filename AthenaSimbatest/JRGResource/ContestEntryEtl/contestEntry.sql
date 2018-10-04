select
date(timestamp - interval '5' hour) as lucktastic_day,
case when lower(deviceos) like 'ios%' then 'ios' else 'android' end as user_platform,
case 
when datediff(date(timestamp - interval '5' hour), date(createdate - interval '5' hour)) = 0 then 'D0'
when datediff(date(timestamp - interval '5' hour), date(createdate - interval '5' hour)) = 1 then 'D1'
when datediff(date(timestamp - interval '5' hour), date(createdate - interval '5' hour)) between 2 and 7 then 'D2 to D7'
when datediff(date(timestamp - interval '5' hour), date(createdate - interval '5' hour)) between 8 and 30 then 'D8 to D30'
when datediff(date(timestamp - interval '5' hour), date(createdate - interval '5' hour)) between 31 and 180 then 'D31 to D180'
when datediff(date(timestamp - interval '5' hour), date(createdate - interval '5' hour)) between 181 and 365 then 'D181 to D365'
when datediff(date(timestamp - interval '5' hour), date(createdate - interval '5' hour)) between 366 and 730 then 'Y1'
when datediff(date(timestamp - interval '5' hour), date(createdate - interval '5' hour)) > 730 then 'Y2+'
end as dx_band,
ce.oppid,
oppdescription,
p1.promo_id,
p2.promo_name,
case 
when oppuniqueid like 'o-%' then 'Enter Contests'
when oppuniqueid = 'RAFFLE' then 'Dash'
when oppuniqueid like 'PUBLIC_ACTION%' then 'Public Action'
when oppuniqueid like '%Hidden Deeplink%' then 'Hidden Deeplinks'
when oppuniqueid like '%deeplink%' then 'Hidden Deeplinks'
when oppuniqueid like '%Hidden Opp%' then 'Hidden Deeplinks'
when oppuniqueid like '%_Facebook_E%' then 'Facebook Share'
when oppuniqueid like '%_FB_AppInvite_E%' then 'Facebook Invite'
when oppuniqueid like '%_Instagram_E%' then 'Instagram Share'
when oppuniqueid like '%_Redeemed_E%' then 'Takeover Redemption'
when oppuniqueid like '%_Spinwheel_E%' then 'Spinwheel'
when oppuniqueid like '%_Twitter_E%' then 'Twitter Share'
when oppuniqueid like '%_Watch_Video_E%' then 'Watch More Videos'
when oppuniqueid like '%_Video_Entries' then 'Dash'
when oppuniqueid like '% Dash Contest Entry' then 'Dash'
when oppuniqueid like '%Mystery Bonus%' then 'Mystery Bonus'
when oppuniqueid = 'Daily_Challenge_Reward' then 'Daily Reward'
when oppuniqueid is null or oppuniqueid = '' then 'Unknown'
else oppuniqueid
end as entry_source,
count(distinct ce.userid) as users_entered,
count(1) as entry_events,
sum(numentries) as entries,
case
when oppuniqueid like 'o-%' then sum(numentries * exchangevalue) 
when lower(oppuniqueid) like '%redeemed%' then sum(discounttokens)
end as tokens_redeemed
from
	(select _id, userid, oppid, oppuniqueid, numentries, timestamp
	from contest_entries
 	where timestamp >= current_date - interval '1' day + interval '5' hour
 	and timestamp < current_date + interval '5' hour
	union
	select _id, userid, oppid, oppuniqueid, numentries, timestamp
	from contest_entries_legacy
 	where timestamp >= current_date - interval '1' day + interval '5' hour
 	and timestamp < current_date + interval '5' hour
	) ce
left join opportunities o on ce.oppid = o.oppid
left join opp_presentation op on o.oppid = op.oppid
left join 
	(select promo_id, android_contest_opp_id as oppid from xshared_raffle_promos
	union
	select promo_id, ios_contest_opp_id as oppid from xshared_raffle_promos
	union
	select promo_id, android_dash_opp_id as oppid from xshared_raffle_promos
	union
	select promo_id, ios_dash_opp_id as oppid from xshared_raffle_promos
	union
	select promo_id, opp_id as oppid from xshared_raffle_child_opps) p1 on ce.oppid = p1.oppid
left join xshared_raffle_promos p2 on p1.promo_id = p2.promo_id
left join (select distinct entries, discounttokens from contest_tiers) ct on ce.numentries = ct.entries
left join profile p on ce.userid = p.userid
group by 1, 2, 3, 4, 5, 6, 7, 8
order by 1, 2, 3, 4, 5, 6, 7, 8;