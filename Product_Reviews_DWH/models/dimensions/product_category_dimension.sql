{{
    config(
        materialized='incremental',
        unique_key=['category','sub_category'],
        on_schema_change='fail'
    )
}}
{% if is_incremental() %}
    {% set max_id = "(select max(sk_category_dim) from " ~ this ~ ")" %}
{% else %}
    {% set max_id = 0 %}
{% endif %}

SELECT 
(row_number() over()+{{ max_id }})::int4 as sk_category_dim,
category,
sub_category 
from {{source('justeattakeaway','products_dim_staging')}} 
{% if is_incremental() %}
where (category,sub_category) not in (select distinct category,sub_category from {{ this }})
{% endif %}
group by 2,3