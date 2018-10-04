INSERT INTO  tableName
SELECT a.date_a,
       a.total_dau,
       b.android_new_dau,
       c.iOS_new_dau,
       d.android_total_dau,
       e.iOS_total_dau,
       f.new_ddau 
FROM
(SELECT  lucktastic_day AS date_a,
         COUNT( DISTINCT q.UserID  ) AS total_dau 
FROM lucktastic.combined_q2_test q
where lucktastic_day = current_date-1
group by 1 ) AS A 
Join 
(SELECT lucktastic_day AS date_b, 
        COUNT(DISTINCT q.UserID) AS android_new_dau 
FROM lucktastic.profile P 
JOIN lucktastic.combined_q2_test q 
ON P.UserID = q.UserID 
AND date(dateadd(hour, -5,p.createdate))= q.lucktastic_day 
WHERE deviceos LIKE 'Android%' 
and lucktastic_day = current_date-1
GROUP BY 1) AS B 
on a.date_a =b.date_b 
JOIN 
(SELECT lucktastic_day as date_c, 
        COUNT(DISTINCT q.UserID) AS iOS_new_dau 
FROM  lucktastic.profile P 
JOIN lucktastic.combined_q2_test q 
ON P.UserID = q.UserID 
AND date(dateadd(hour, -5,p.createdate)) = q.lucktastic_day 
WHERE deviceos LIKE 'iOS%' 
and lucktastic_day = current_date-1
group by 1)c 
ON b.date_b=c.date_c 
JOIN 
(SELECT lucktastic_day AS date_d, 
        COUNT(DISTINCT q.UserID) AS android_total_dau 
FROM lucktastic.profile P 
JOIN lucktastic.combined_q2_test q 
ON P.UserID = q.UserID 
WHERE deviceos LIKE 'Android%'
and lucktastic_day = current_date-1
group by 1)d 
ON c.date_c=d.date_d 
JOIN 
(SELECT lucktastic_day AS date_e, 
        COUNT(DISTINCT q.UserID) AS iOS_total_dau
FROM  lucktastic.profile P 
JOIN lucktastic.combined_q2_test q 
ON P.UserID = q.UserID 
WHERE deviceos LIKE 'iOS%'
and lucktastic_day = current_date-1
GROUP BY 1)e 
ON d.date_d = e.date_e 
JOIN 
(SELECT lucktastic_day AS date_f, 
        COUNT(DISTINCT q.UserID) AS new_ddau
FROM lucktastic.profile P 
JOIN lucktastic.combined_q2_test q 
ON P.UserID = q.UserID AND
date(dateadd(hour, -5,p.createdate)) = q.lucktastic_day 
WHERE q.is_demo = 0 
and lucktastic_day = current_date-1
GROUP BY 1)f 
ON e.date_e=f.date_f;