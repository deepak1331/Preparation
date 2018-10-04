-- Partner Performace
--   Total number of responses by Ad Partner
--     Unsuccessful Responses by reason:
--       count() where event_type=ad_response  and
--                     day(timestamp)={date} and
--                     success=false
--       group by ad_network, reason_for_failure
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)
-- ${date_year} - Report year in YYYY format
-- ${date_month} - Report month in MM format
-- ${date_day} - Report day in DD format

SELECT ad_network, sum(CAST(counter AS INTEGER)), reason_for_failure
FROM datapipeline_${environment}.inventory_reports_intermediate
WHERE counter != 'counter'
  AND event_type='ad_response' AND success='false'
GROUP BY ad_network, reason_for_failure;
