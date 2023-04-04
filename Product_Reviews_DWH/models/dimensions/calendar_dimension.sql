{{
    config(
        materialized='incremental',
        unique_key="date",
        on_schema_change='fail'
    )
}}
WITH calendar_dimension AS (
    SELECT generate_series('1994-01-01'::date, current_date, '1 day'::interval)::date AS "date"
)
SELECT 
    "date",
    extract('year' from "date")::int4 AS year,
    extract('quarter' from "date")::int4 AS quarter,
    extract('month' from "date")::int4 AS month
FROM calendar_dimension
{% if is_incremental() %}
where "date" > coalesce((select max("date") from {{ this }}),'1994-01-01')
{% endif %}
ORDER BY "date"