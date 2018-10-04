SELECT
A.date_a,
A.source,
A.type,
A.deviceos,
A.profiles_created,
b.new_users_entered,
c.new_dau,
d.new_dash_dau,
e.d1_usage,
f.spend,
f.installs
FROM 
(SELECT date(dateadd(hour,-5,p.createdate)) as date_a,
case when deviceos like 'Android%' then 'Android'
when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,
case when lower(source) like 'luck150'
or lower(source) like 'luck100'
THEN 'Organic' else 'Paid' end as Type,
source ,
COUNT( * ) as profiles_created
FROM lucktastic.profile P
WHERE date(dateadd(hour,-5,p.createdate)) = current_date - noOfDays
group by 1,2,3,4
) A
left join

(SELECT date(dateadd(hour,-5,p.createdate)) date_b,
case when deviceos like 'Android%' then 'Android'
when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,
source ,
COUNT(DISTINCT P.UserID) AS new_users_entered
FROM lucktastic.profile P
JOIN lucktastic.rprofile_opp_tableDate r
ON P.UserID = r.UserID 
WHERE date(dateadd(hour,-5,p.createdate))= current_date - noOfDays
group by 1,2,3)B
on B.date_b = A.date_a
AND B.deviceos = A.deviceos
AND B.source = A.source

left JOIN (
SELECT date(dateadd(hour,-5,p.createdate)) date_c,case when deviceos like 'Android%' then 'Android'
when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,
source ,COUNT(DISTINCT P.UserID) AS new_dau
FROM lucktastic.profile P
JOIN lucktastic.rprofile_opp_tableDate r
ON P.UserID = r.UserID 
WHERE date(dateadd(hour,-5,p.createdate)) = current_date - noOfDays
and r.isfulfilled = 1
group by 1,2,3
) AS C
ON 
c.date_c = A.date_a
AND c.deviceos = A.deviceos
AND c.source = A.source

left JOIN (
select date(dateadd(hour,-5,p.createdate)) as date_d,case when deviceos like 'Android%' then 'Android'
when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,
source ,
count(distinct p.userid) as new_dash_dau
from lucktastic.profile p
join lucktastic.rprofile_opp_tableDate r
on p.userid=r.userid
left join lucktastic.opp_presentation o
on r.oppid = o.oppid
where date(dateadd(hour,-5,p.createdate)) =current_date - noOfDays
and r.isfulfilled = 1
and o.presentationview != 'demo'
group by 1,2,3
) AS D
ON 
A.date_a = d.date_d
AND A.deviceos = d.deviceos
AND A.source = d.source

left JOIN (
SELECT date(dateadd(day,1,date(dateadd(hour,-5, p.createdate)))) date_d, 
q.lucktastic_day as d1_date, 
case when deviceos like 'Android%' then 'Android' when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,
source , 
COUNT(DISTINCT q.UserID) AS D1_usage 
FROM lucktastic.profile P 
JOIN lucktastic.combined_q2_test q 
ON P.UserID = q.UserID WHERE 
datediff(day,date(dateadd(hour,-5, p.createdate)) ,q.lucktastic_day) =1 
group by 1,2,3,4
) AS e
ON 
e.d1_date = A.date_a
AND e.deviceos = A.deviceos
AND e.source = A.source

LEFT JOIN (
Select acquisitiondate as date_f,source, Sum(spend) as spend, Sum(installs) as installs
From lucktastic.daily_acquisition D where d.acquisitiondate = current_date - noOfDays
group by 1,2
) AS f
ON 
A.date_a = f.date_f
AND A.source = f.source
order by a.date_a,a.source;