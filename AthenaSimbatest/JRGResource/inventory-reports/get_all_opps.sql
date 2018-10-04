-- Get all opportunities available in white list
--
-- Parameters:
-- ${environment} - Required environment (prod, qa, stress)

SELECT id AS opp_id, '' AS opp_name
FROM datapipeline_${environment}.dash_opps;
