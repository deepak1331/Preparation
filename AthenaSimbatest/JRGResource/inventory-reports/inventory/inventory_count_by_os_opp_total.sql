-- Inventory count by OS and opportunity
-- Total Inventory
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)
-- ${date_year} - Report year in YYYY format
-- ${date_month} - Report month in MM format
-- ${date_day} - Report day in DD format

SELECT os_name, opp_id, opp_name, sum(CAST(counter AS INTEGER))
FROM datapipeline_${environment}.inventory_reports_intermediate
WHERE counter != 'counter'
  AND LENGTH(opp_id) < 10
  AND os_name!='iOS'
  AND (event_type='game_play_start' OR event_type='opp_complete'
  AND opp_id IN (SELECT DISTINCT CAST(id AS VARCHAR) FROM datapipeline_${environment}.dash_opps))
GROUP BY os_name, opp_id, opp_name;
