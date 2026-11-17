
-- ==========================================
-- DELINQUENCY PROFILE
-- DPD distribution by observation month
-- Assigns each observation to a delinquency bucket and summarizes its volume
-- and average DPD for each month. NULL and negative DPD values are Unknown.
-- ==========================================

SELECT

    observation_month,

    CASE
        WHEN dpd_current = 0 THEN '00. Current'
        WHEN dpd_current BETWEEN 1 AND 30 THEN '01. 1-30 DPD'
        WHEN dpd_current BETWEEN 31 AND 60 THEN '02. 31-60 DPD'
        WHEN dpd_current BETWEEN 61 AND 90 THEN '03. 61-90 DPD'
        WHEN dpd_current > 90 THEN '04. 90+ DPD'
        ELSE '99. Unknown'
    END AS dpd_bucket,

    COUNT(*) AS observations,

    COUNT(DISTINCT customer_id) AS customers,

    ROUND(
        AVG(dpd_current)::numeric,
        2
    ) AS avg_dpd

FROM raw.monthl_perf

GROUP BY
    observation_month,
    dpd_bucket

ORDER BY
    observation_month,
    dpd_bucket;
