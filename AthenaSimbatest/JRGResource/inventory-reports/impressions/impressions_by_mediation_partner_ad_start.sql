-- Impression count/Ad Start/Ad Complete count by mediation partner (Direct deal, each third party mediation partner)
-- Ad start count
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)
-- ${date_year} - Report year in YYYY format
-- ${date_month} - Report month in MM format
-- ${date_day} - Report day in DD format

SELECT ad_network, sum(CAST(counter AS INTEGER))
FROM datapipeline_${environment}.inventory_reports_intermediate
WHERE counter != 'counter'
  AND event_type='ad_start'
GROUP BY ad_network;
