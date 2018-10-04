INSERT INTO tableName (
SELECT
A.date_a,
A.source,
A.deviceos,
E.spend,
E.installs,
A.profiles_created,
B.new_dau,
C.new_dash_dau,
D.d1_usage
FROM (
SELECT date(dateadd(hour,-5,p.createdate)) as date_a,case when deviceos like 'Android%' then 'Android'
when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,source ,COUNT( * ) as profiles_created
FROM lucktastic.profile P
WHERE date(dateadd(hour,-5,p.createdate)) >= '2017-09-30'
group by 1,2,3
) A
INNER JOIN (
select date(dateadd(hour,-5,p.createdate)) as date_c,case when deviceos like 'Android%' then 'Android'
when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,source ,
count(distinct p.userid) as new_dash_dau
from lucktastic.profile p
join lucktastic.viewName q
on q.userid=p.userid
where date(dateadd(hour,-5,p.createdate)) >= '2017-09-30'
and q.is_demo = 0
and q.lucktastic_day = date(dateadd(hour,-5,p.createdate))
group by 1,2,3
) AS C
ON
A.date_a = C.date_c
AND A.deviceos = C.deviceos
AND A.source = C.source
 
INNER JOIN (
SELECT date(dateadd(hour,-5,p.createdate)) date_b,case when deviceos like 'Android%' then 'Android'
when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,source ,COUNT(DISTINCT P.UserID) AS new_dau
FROM lucktastic.profile P
JOIN lucktastic.viewName q
ON P.UserID = q.UserID
WHERE date(dateadd(hour,-5,p.createdate)) >= '2017-09-30'
group by 1,2,3
) AS B
ON
B.date_b = A.date_a
AND B.deviceos = A.deviceos
AND B.source = A.source
 
INNER JOIN (
SELECT date(dateadd(day,1,date(dateadd(hour,-5, p.createdate)))) date_d, q.lucktastic_day as d1_date,
case when deviceos like 'Android%' then 'Android' when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,source ,
COUNT(DISTINCT q.UserID) AS D1_usage FROM lucktastic.profile P JOIN lucktastic.viewName q ON P.UserID = q.UserID WHERE
datediff(day,date(dateadd(hour,-5, p.createdate)) ,q.lucktastic_day) =1
group by 1,2,3,4
) AS D
ON
D.d1_date = A.date_a
AND D.deviceos = A.deviceos
AND D.source = A.source
 
LEFT OUTER JOIN (
Select acquisitiondate as date_e,source, Sum(spend) as spend, Sum(installs) as installs
From lucktastic.daily_acquisition D where d.acquisitiondate >= '2017-09-30'
group by 1,2
) AS E
ON
A.date_a = E.date_e
AND A.source = E.source);