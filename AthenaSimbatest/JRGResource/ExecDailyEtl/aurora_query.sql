select
date(changetime - interval '5' hour) as lucktastic_day,
case 
when source like '%150' then 'android'
when source like '%100' then 'ios'
when lower(deviceos) like 'android%' then 'android'
when lower(deviceos) like 'ios%' then 'ios'
end as platform,
sum(case when newtokens > coalesce(oldtokens, 0) then newtokens - coalesce(oldtokens, 0) end) as tokens_in,
-sum(case when newtokens < coalesce(oldtokens, 0) then newtokens - coalesce(oldtokens, 0) end) as tokens_out
from zaudit_bank b
left join profile p on b.userid = p.userid
where newtokens <> coalesce(oldtokens, 0) 
and changetime >= 'startDate' + interval '5' hour
and changetime < 'endDate' + interval '5' hour
group by 1, 2  ORDER BY platform;