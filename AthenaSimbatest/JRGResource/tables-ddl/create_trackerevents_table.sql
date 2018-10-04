--The table schema corresponds to EventTracker's spesificaiton and data schema:
--https://lucktastic.atlassian.net/wiki/display/DATA/Event+Tracking+specification
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)

CREATE EXTERNAL TABLE IF NOT EXISTS datapipeline_${environment}.tracker_events (
  `event_id` string,
  `timestamp` bigint,
  `tracker_ip` string,
  `request_url` string,
  `request_query_string` string,
  `request_headers` string,
  `batch_id` string
) PARTITIONED BY (
  year string,
  month string,
  day string,
  hour string
)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  LINES TERMINATED BY '\n'
LOCATION 's3://jrg-datapipeline-${environment}/tracker-events/dump/';
