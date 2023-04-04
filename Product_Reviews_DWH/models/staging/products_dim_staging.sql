{{
    config(
        materialized='incremental',
        unique_key='asin',
        on_schema_change='fail'
    )
}}
SELECT 
asin::bpchar(10) as asin, 
coalesce(title, 'Unknown') as title, 
coalesce(description, 'Unknown') as description, 
coalesce(image_url, 'Unknown') as image_url,
coalesce(also_viewed, 'Unknown') as also_viewed,
coalesce(also_bought, 'Unknown') as also_bought,
coalesce(bought_together, 'Unknown') as bought_together,
coalesce(buy_after_viewing, 'Unknown') as buy_after_viewing,
coalesce(CASE WHEN justeattakeaway.compare_ids(also_viewed,also_bought) ='[]' THEN 0 ELSE 1 END,0)::int2 as viewed_and_bought_flag,
coalesce(CASE WHEN justeattakeaway.compare_ids(also_viewed,also_bought) ='[]' THEN 0 ELSE 
array_length(string_to_array( justeattakeaway.compare_ids(also_viewed,also_bought),','),1) end,0)::int2 as viewed_and_bought_count,
coalesce(justeattakeaway.compare_ids(also_viewed,also_bought), 'Unknown') as viewed_and_bought,
COALESCE(price::float, 0) as price,
COALESCE(justeattakeaway.parse_base_category(categories), 'Unknown')::varchar(200) as category,
COALESCE(justeattakeaway.parse_sub_category(categories), 'Unknown')::varchar(200) as sub_category,
coalesce(nullif(replace(split_part(sales_rank, ':', 2),'}',''),'')::int8,0) as sales_rank,
0 as process_flag
from {{ source('justeattakeaway','products_raw')}}