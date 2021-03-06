-- Inventory count by OS and opportunity
-- Post-roll Inventory
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)
-- ${date_year} - Report year in YYYY format
-- ${date_month} - Report month in MM format
-- ${date_day} - Report day in DD format

SELECT os_name, opp_id, opp_name, sum(CAST(counter AS INTEGER))
FROM datapipeline_${environment}.inventory_reports_intermediate
WHERE counter != 'counter'
  AND event_type='opp_complete'
  AND opp_id IN (SELECT DISTINCT CAST(id AS VARCHAR) FROM datapipeline_${environment}.dash_opps)
GROUP BY os_name, opp_id, opp_name;
