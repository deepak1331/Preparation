-- Inventory count by OS and opportunity
-- Pre-roll Inventory
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)
-- ${date_year} - Report year in YYYY format
-- ${date_month} - Report month in MM format
-- ${date_day} - Report day in DD format

SELECT os_name, opp_id, opp_name, sum(CAST(counter AS INTEGER))
FROM datapipeline_${environment}.inventory_reports_intermediate
WHERE counter != 'counter'
  AND event_type='game_play_start'
GROUP BY os_name, opp_id, opp_name;
