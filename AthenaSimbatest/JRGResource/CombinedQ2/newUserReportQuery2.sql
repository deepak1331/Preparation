INSERT INTO tableName
SELECT A.date_a,
       A.source,
       A.deviceos,
       A.spend,
       A.installs,
       A.profiles_created,
       B.new_dau,
       C.new_dash_dau,
       D.d1_usage,
       A.billable_spend_dau,
       A.billable_spend_profiles
FROM
 (
   select date_a,
       deviceos,
       source,
       sum(spend) as spend,
       sum(installs) as installs,
       sum(profiles_created) as profiles_created,
       sum(billable_spend_dau) as billable_spend_dau,
       sum(billable_spend_profiles) as billable_spend_profiles
from
   (Select acquisitiondate as date_a ,
        platform as deviceos,
        source,
        Sum(spend) as spend,
        Sum(installs) as installs,
        sum(billable_spend_dau) as billable_spend_dau,
        sum(billable_spend_profiles) as billable_spend_profiles,
        0 as profiles_created
From lucktastic.billable_spend D
where d.acquisitiondate = 'currentDate'
and date_a is not null
and source is not null
group by 1,2,3
union
SELECT date(dateadd(hour,-5,p.createdate)) as date_a,
       case when deviceos like 'Android%' then 'android'
       when deviceos like 'iOS%' then 'ios' else 'NA' end as deviceos,
       source ,
       0 as spend,
       0 as installs,
       0 as billable_spend_dau,
       0 as billable_spend_profiles,
       COUNT( * ) as profiles_created
FROM lucktastic.profile P
WHERE date(dateadd(hour,-5,p.createdate)) = 'currentDate'
group by 1,2,3)
group by 1,2,3
) A
Left JOIN (
select date(dateadd(hour,-5,p.createdate)) as date_c,
       case when deviceos like 'Android%' then 'android'
       when deviceos like 'iOS%' then 'ios' else 'NA' end as Deviceos,
       source ,
       count(distinct p.userid) as new_dash_dau
from lucktastic.profile p
join lucktastic.viewName q
on q.userid=p.userid
where date(dateadd(hour,-5,p.createdate)) = 'currentDate'
and q.is_demo = 0
and q.lucktastic_day = date(dateadd(hour,-5,p.createdate))
group by 1,2,3
) AS C
ON  A.date_a = C.date_c
AND A.deviceos = lower(C.deviceos)
AND A.source = C.source
    
left JOIN (
SELECT date(dateadd(hour,-5,p.createdate)) date_b,
       case when deviceos like 'Android%' then 'android'
       when deviceos like 'iOS%' then 'ios' else 'NA' end as Deviceos,
       source ,
       COUNT(DISTINCT P.UserID) AS new_dau
FROM lucktastic.profile P
JOIN lucktastic.viewName q
ON P.UserID = q.UserID
WHERE date(dateadd(hour,-5,p.createdate)) = 'currentDate'
group by 1,2,3
) AS B
ON
B.date_b = A.date_a
AND lower(B.deviceos) = A.deviceos
AND B.source = A.source
left JOIN (
     SELECT date(dateadd(day,1,date(dateadd(hour,-5, p.createdate)))) date_d, q.lucktastic_day as d1_date,
            case when deviceos like 'Android%' then 'Android' when deviceos like 'iOS%' then 'iOS' else 'NA' end as Deviceos,
            source ,
            COUNT(DISTINCT q.UserID) AS D1_usage
     FROM lucktastic.profile P
     JOIN lucktastic.viewName q
     ON P.UserID = q.UserID
     WHERE datediff(day,date(dateadd(hour,-5, p.createdate)) ,q.lucktastic_day) =1
     group by 1,2,3,4
) AS D
ON
D.d1_date = A.date_a
AND lower(D.deviceos) = A.deviceos
AND D.source = A.source
order by A.date_a, A.source;
