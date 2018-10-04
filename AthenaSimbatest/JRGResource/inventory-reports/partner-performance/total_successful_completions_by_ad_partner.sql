-- Partner Performace
--   Total successful completions by Ad Partner
--     count() where event_type=ad_complete  and  day(timestamp)={date}  group by ad_network
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)
-- ${date_year} - Report year in YYYY format
-- ${date_month} - Report month in MM format
-- ${date_day} - Report day in DD format

SELECT ad_network, sum(CAST(counter AS INTEGER))
FROM datapipeline_${environment}.inventory_reports_intermediate
WHERE counter != 'counter'
  AND event_type='ad_complete'
GROUP BY ad_network;
