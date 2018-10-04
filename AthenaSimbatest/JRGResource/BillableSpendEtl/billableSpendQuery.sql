INSERT INTO  tableName
(SELECT 
acquisitiondate,
case 
when ACQ.source like '%150' then 'android'
when ACQ.source = 'MOTV100' then 'android'
when ACQ.source like '%100' then 'ios'
end as platform,
ACQ.source,
spend,
installs,
new_dau,
profiles_created,
case
when split_part(ACQ.source, '1', 1) = 'ADC' then 2.35 * installs 
when split_part(ACQ.source, '1', 1) not in ( 'ADC', 'APL', 'CHEE', 'LIF' , 'MLC', 'BYTE','TPTA') then spend
when spend = 0 then 0
when installs = 0 then spend
else spend / installs * new_dau
end as billable_spend_dau,
case
when split_part(ACQ.source, '1', 1) = 'ADC' then 2.35 * installs 
when split_part(ACQ.source, '1', 1) not in ( 'ADC','APL','CHEE','LIF','MLC','BYTE','TPTA') then spend
when spend = 0 then 0
when installs = 0 then spend
else spend / installs * profiles_created
end as billable_spend_profiles
FROM
  -- acquisition spend and installs
  (select 
  acquisitiondate,
  split_part(source, '-', 1) as source,
  spend,
  installs
  from lucktastic.daily_acquisition 
  where source not in ('FB100-FAN', 'FB100-IG', 'FB100-NF', 'FB150-FAN', 'FB150-IG', 'FB150-NF') 
  and acquisitiondate = 'dateString'
  ) ACQ

LEFT JOIN
  -- new daus
  (select 
  lucktastic_day,
  source,
  count(distinct case when datediff(day, date(dateadd(hour, -5, createdate)), lucktastic_day) = 0 then q.userid end) as new_dau
  from lucktastic.combined_q2_test q
  left join lucktastic.profile p on q.userid = p.userid
  where lucktastic_day = 'dateString'
  group by 1, 2
  ) DAU ON ACQ.acquisitiondate = DAU.lucktastic_day AND ACQ.source = DAU.source

LEFT JOIN
  -- profiles created
  (select
  date(dateadd(hour, -5, createdate)) as lucktastic_day,
  source,
  count(1) as profiles_created
  from lucktastic.profile
  where date(dateadd(hour, -5, createdate)) = 'dateString'
  group by 1, 2
  ) P ON ACQ.acquisitiondate = P.lucktastic_day AND ACQ.source = P.source
  where acquisitiondate = 'dateString'
ORDER BY 1, 2, 3);