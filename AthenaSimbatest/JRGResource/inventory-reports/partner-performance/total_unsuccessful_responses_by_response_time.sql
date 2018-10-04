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
  ad_network AS ad_partner,
  min(response_time) AS min_response_time,
  max(response_time) AS max_response_time,
  avg(response_time) AS average_response_time
FROM (
  SELECT
    url_extract_parameter(full_request_url, 'event_type') AS event_type,
    url_extract_parameter(full_request_url, 'ad_network') AS ad_network,
    cast(url_extract_parameter(full_request_url, 'response_time') AS INTEGER) AS response_time
  FROM (
    SELECT concat(request_url, '?', request_query_string) AS full_request_url
    FROM datapipeline_${environment}.tracker_events
    WHERE year='${date_year}' AND month='${date_month}' AND day='${date_day}'
  )
)
WHERE event_type='ad_response'
GROUP BY ad_network;
