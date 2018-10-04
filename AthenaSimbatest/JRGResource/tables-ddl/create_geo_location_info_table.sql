--The table for Geo-location information lookup.
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)

CREATE EXTERNAL TABLE IF NOT EXISTS datapipeline_${environment}.geo_location_info(
  `zip` varchar(10),
  `zip_type` varchar(20),
  `primary_city` varchar(100),
  `state` varchar(100),
  `county` varchar(100),
  `timezone` varchar(100),
  `area_codes` varchar(100),
  `latitude` double,
  `longitude` double,
  `world_region` varchar(50),
  `country` varchar(100),
  `notes` varchar(1000)
)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n'
LOCATION 's3://jrg-datapipeline-${environment}/athena/lookup-tables/geo_location_info/';
