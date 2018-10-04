-- Partner Performace
--   Total number of responses by Ad Partner
--     Response Times:
--       min(response_time), max(response_time), average(response_time)
--       where event_type=ad_response  and  day(timestamp)={date}
--       group by ad_network
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)
-- ${date_year} - Report year in YYYY format
-- ${date_month} - Report month in MM format
-- ${date_day} - Report day in DD format

SELECT
  ad_network,
  MIN(CAST(response_time AS INTEGER)),
  MAX(CAST(response_time AS INTEGER)),
  approx_percentile(CAST(response_time AS INTEGER), 0.5) as median_response_time
FROM datapipeline_${environment}.inventory_reports_intermediate
WHERE counter != 'counter'
  AND event_type='ad_response'
  AND CAST(response_time AS INTEGER) > 0 AND CAST(response_time AS INTEGER) < 2000000000
GROUP BY ad_network;


-- DS-121: Commented the previos query and added new query below

--SELECT
--   ad_network AS ad_partner,
  -- min(response_time) AS min_response_time,
  -- max(response_time) AS max_response_time,
  -- approx_percentile(response_time, 0.5) as median_response_time
-- FROM (
  -- SELECT
    -- url_extract_parameter(full_request_url, 'event_type') AS event_type,
    -- UPPER(url_extract_parameter(full_request_url, 'ad_network')) AS ad_network,
    -- cast(url_extract_parameter(full_request_url, 'response_time') AS INTEGER) AS response_time
  -- FROM (
    -- SELECT concat(request_url, '?', request_query_string) AS full_request_url
    -- FROM datapipeline_${environment}.tracker_events
     -- WHERE year='${date_year}' AND month='${date_month}' AND day='${date_day}'
  -- )
-- )
-- WHERE event_type='ad_response'
--   AND response_time > 0 AND response_time < 2000000000
-- GROUP BY ad_network;