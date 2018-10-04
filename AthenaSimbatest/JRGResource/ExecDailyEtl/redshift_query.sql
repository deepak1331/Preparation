SELECT
P.lucktastic_day,
P.platform,
coalesce(cpi_revenue, 0) + coalesce(non_cpi_revenue, 0) as revenue,
cpi_revenue,
non_cpi_revenue,
ACQ.spend as acquisition_cost,
billable_spend_dau,
billable_spend_profiles,
dau as total_dau,
O.new_dau,
repeat_dau,
new_organic_dau,
coalesce(O.new_dau, 0) - coalesce(new_organic_dau, 0) as new_paid_dau,
new_ddau,
d1_ddau,
new_dau_lead1 as new_dau_yesterday,
opps_fulfilled as opp_completes,
cpi_installs as total_installs,
wall_installs,
video_installs,
cpi_installers as unique_installers,
d0_opps_fulfilled as d0_opp_completes,
d0_cpi_installs as d0_installs,
d0_cpi_installers as d0_unique_installers,
d0_cpi_revenue
FROM
  -- profiles
  (select
  date(dateadd(hour, -5, createdate)) as lucktastic_day,
  case 
  when source like '%150' then 'android'
  when source like '%100' then 'ios'
  when lower(deviceos) like 'android%' then 'android'
  when lower(deviceos) like 'ios%' then 'ios'
  end as platform,
  count(1) as profiles_created,
  count(case when source like 'LUCK%' then 1 end) as organic_profiles_created,
  count(1) - count(case when source like 'LUCK%' then 1 end) as paid_profile_created
  from lucktastic.profile
  where date(dateadd(hour, -5, createdate)) = 'startDate'
  group by 1, 2
  ) P

LEFT JOIN
  -- spend and installs
  (select 
  acquisitiondate, 
  case 
  when split_part(source, '-', 1) like '%150' then 'android'
  when split_part(source, '-', 1) = 'MOTV100' then 'android'
  when split_part(source, '-', 1) like '%100' then 'ios'
  end as platform,
  sum(spend) as spend, 
  sum(installs) as installs
  from lucktastic.daily_acquisition
  where source not in ('FB100-FAN', 'FB100-IG', 'FB100-NF', 'FB150-FAN', 'FB150-IG', 'FB150-NF')
  and acquisitiondate = 'startDate'
  group by 1, 2
  ) ACQ ON P.lucktastic_day = ACQ.acquisitiondate AND P.platform = ACQ.platform


LEFT JOIN
  -- opps fulfilled
  (select 
  lucktastic_day,
  case 
  when source like '%150' then 'android'
  when source like '%100' then 'ios'
  when lower(deviceos) like 'android%' then 'android'
  when lower(deviceos) like 'ios%' then 'ios'
  end as platform,
  count(distinct q.userid) as dau,
  count(distinct case when is_demo = 0 then q.userid end) as ddau,
  count(distinct case when datediff(day, date(dateadd(hour, -5, createdate)), lucktastic_day) = 0 then q.userid end) as new_dau,
  count(distinct q.userid) - count(distinct case when datediff(day, date(dateadd(hour, -5, createdate)), lucktastic_day) = 0 then q.userid end) as repeat_dau,
  count(distinct case when datediff(day, date(dateadd(hour, -5, createdate)), lucktastic_day) = 0 and source like 'LUCK%' then q.userid end) as new_organic_dau,
  count(distinct case when datediff(day, date(dateadd(hour, -5, createdate)), lucktastic_day) = 0 and is_demo = 0 then q.userid end) as new_ddau,
  count(distinct case when datediff(day, date(dateadd(hour, -5, createdate)), lucktastic_day) = 1 and is_demo = 0 then q.userid end) as d1_ddau,
  lead (count(distinct case when datediff(day, date(dateadd(hour, -5, createdate)), lucktastic_day) = 0 then q.userid end)) over (partition by platform order by lucktastic_day desc) as new_dau_lead1,
  sum(opps_fulfilled) as opps_fulfilled,
  sum(case when datediff(day, date(dateadd(hour, -5, createdate)), lucktastic_day) = 0 then opps_fulfilled end) as d0_opps_fulfilled
  from lucktastic.combined_q2_test q
  left join lucktastic.profile p on q.userid = p.userid
  where lucktastic_day between 'previousDate' and 'startDate'
  group by 1, 2
  ) O on P.lucktastic_day = O.lucktastic_day AND P.platform = O.platform

LEFT JOIN
  -- in-app installs
  (select
  date(dateadd(hour, -5, timestamp)) as lucktastic_day,
  case 
  when v.source like '%150' then 'android'
  when v.source like '%100' then 'ios'
  when p.source like '%150' then 'android'
  when p.source like '%100' then 'ios'
  when lower(deviceos) like 'android%' then 'android'
  when lower(deviceos) like 'ios%' then 'ios'
  end as platform,
  count(1) as cpi_installs,
  count(case when lower(campaign_type) = 'cpi' then 1 end) as wall_installs,
  count(case when lower(campaign_type) <> 'cpi' then 1 end) as video_installs,
  count(distinct v.userid) as cpi_installers,
  sum(bounty) as cpi_revenue,
  count(case when datediff(day, date(dateadd(hour, -5, createdate)), date(dateadd(hour, -5, timestamp))) = 0 then 1 end) as d0_cpi_installs,
  count(distinct case when datediff(day, date(dateadd(hour, -5, createdate)), date(dateadd(hour, -5, timestamp))) = 0 then v.userid end) as d0_cpi_installers,
  sum(case when datediff(day, date(dateadd(hour, -5, createdate)), date(dateadd(hour, -5, timestamp))) = 0 then bounty end) as d0_cpi_revenue
  from lucktastic.vdav v
  left join lucktastic.profile p on v.userid = p.userid
  left join lucktastic.xcampaign c on v.campaignid = c.campaign_id
  where date(dateadd(hour, -5, timestamp)) = 'startDate'
  group by 1, 2
  ) CPI ON P.lucktastic_day = CPI.lucktastic_day AND P.platform = CPI.platform

LEFT JOIN
  -- non-cpi revenue
  (select
  date,
  lower(os) as platform,
  sum(revenue) as non_cpi_revenue
  from lucktastic.third_party_data
  where date = 'startDate'
  group by 1, 2
  ) CPV ON P.lucktastic_day = CPV.date AND P.platform = CPV.platform

LEFT JOIN
  -- billable_spend
  (select
  acquisitiondate,
  platform,
  sum(billable_spend_dau) as billable_spend_dau,
  sum(billable_spend_profiles) as billable_spend_profiles
  from lucktastic.billable_spend
  group by 1, 2
  ) B ON P.lucktastic_day = B.acquisitiondate AND P.platform = B.platform
  
ORDER BY 1, 2;