{{
    config(
        materialized='incremental',
        unique_key=['review_date','reviewerid','asin'],
        on_schema_change='fail'
    )
}}
SELECT 
coalesce(reviewerid, 'Unknown')::varchar(100) as reviewerid,
COALESCE(asin, 'Unknown')::bpchar(10) as asin,
coalesce(LOWER(trim(regexp_replace(replace(reviewername,'%amp;',''), '\".*', ''))), 'Unknown')::varchar(200) as reviewer_name,
COALESCE(helpful,'Unknown')::varchar(200) as helpful,
COALESCE((helpful::json->>0)::integer,0) as up_votes,
COALESCE(((helpful::json->>1)::integer - (helpful::json->>0)::integer),0) as down_votes,
overall::float,
coalesce(summary, 'Unknown') as summary, 
review_date as review_date,
coalesce(reviewtext, 'Unknown') as review_text, 
ROW_NUMBER()OVER(PARTITION BY review_date,reviewerID,asin)::int4 as row_number,
0 as process_flag
from {{source('justeattakeaway','reviews_raw')}} rs 
WHERE review_date>='2006-01-01' and review_date<'2007-01-01'
AND reviewerID is not NULL and ASIN is not NULL
-- AND rs.record_status = '0'
