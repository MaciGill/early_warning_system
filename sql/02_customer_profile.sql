
-- ==========================================
-- CUSTOMER PROFILE
-- One row per customer
-- Aggregates observation coverage, delinquency, payment, and credit indicators.
-- AVG and MIN/MAX ignore NULL values; FILTER counts only matching observations.
-- ==========================================

SELECT

    customer_id,

    COUNT(*) AS observation_count,

    MIN(observation_month) AS first_observation,

    MAX(observation_month) AS last_observation,

    MIN(months_on_book) AS min_months_on_book,

    MAX(months_on_book) AS max_months_on_book,

    ROUND(AVG(dpd_current)::numeric, 2) AS avg_dpd,

    MAX(dpd_current) AS max_dpd,

    COUNT(*) FILTER (
        WHERE dpd_current > 0
    ) AS overdue_observations,

    COUNT(*) FILTER (
        WHERE payment_made = 1
    ) AS payments_made,

    ROUND(
        AVG(credit_score)::numeric,
        2
    ) AS avg_credit_score,

    ROUND(
        AVG(revolving_utilization)::numeric,
        4
    ) AS avg_revolving_utilization

FROM raw.monthl_perf

GROUP BY customer_id

ORDER BY customer_id;
