
-- ==========================================
-- PROJECT: BANK CUSTOMER DELINQUENCY ANALYTICS
-- MODULE: RAW DATA VALIDATION
-- ==========================================
-- Returns one row with table size, distinct entity/time counts, date bounds,
-- and NULL counts for key validation fields. PostgreSQL FILTER clauses
-- restrict each missing-value count to rows matching its condition.

SELECT

    COUNT(*) AS total_records,

    COUNT(DISTINCT customer_id) AS total_customers,

    COUNT(DISTINCT observation_month) AS total_months,

    MIN(observation_month) AS first_observation,

    MAX(observation_month) AS last_observation,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_id,

    COUNT(*) FILTER (
        WHERE observation_month IS NULL
    ) AS missing_observation_month,

    COUNT(*) FILTER (
        WHERE dpd_current IS NULL
    ) AS missing_dpd

FROM raw.monthl_perf;