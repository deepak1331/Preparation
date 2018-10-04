--The table contains dash operations' ids.
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)

CREATE EXTERNAL TABLE IF NOT EXISTS datapipeline_${environment}.dash_opps (
  `id` int
)
ROW FORMAT DELIMITED
  LINES TERMINATED BY '\n'
LOCATION 's3://jrg-datapipeline-${environment}/athena/lookup-tables/dash_opps/';
