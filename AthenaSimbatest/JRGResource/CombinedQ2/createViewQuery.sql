CREATE VIEW viewName AS SELECT 
  userid,
  date(dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', createstamp))) as lucktastic_day,
  case when presentationview = 'demo' then 1 else 0 end as is_demo,
  count(oppuniqueid) as opps_fulfilled
  from lucktastic.currentMonthTable q
  left join lucktastic.opp_presentation pres on q.oppid = pres.oppid
  group by 1, 2, 3
  union
  select
  userid,
  date(dateadd(hour, -5, convert_timezone('UTC', 'America/New_York', createstamp))) as lucktastic_day,
  case when presentationview = 'demo' then 1 else 0 end as is_demo,
  count(oppuniqueid) as opps_fulfilled
  from lucktastic.prevMonthTable q
  left join lucktastic.opp_presentation pres on q.oppid = pres.oppid
  where date(date_add('hour', -5, convert_timezone('UTC', 'America/New_York', createstamp))) >= dateadd(month, -1, dateadd(day, -datepart(day, dateadd(day, -1, current_date)),   current_date))
  group by 1, 2, 3;