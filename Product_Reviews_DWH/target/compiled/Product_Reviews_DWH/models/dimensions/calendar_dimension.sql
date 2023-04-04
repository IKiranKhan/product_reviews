
WITH calendar_dimension AS (
    SELECT generate_series('1994-01-01'::date, current_date, '1 day'::interval)::date AS "date"
)
SELECT 
    "date",
    extract('year' from "date")::int4 AS year,
    extract('quarter' from "date")::int4 AS quarter,
    extract('month' from "date")::int4 AS month
FROM calendar_dimension

where "date" > coalesce((select max("date") from "postgres"."justeattakeaway"."calendar_dimension"),'1994-01-01')

ORDER BY "date"