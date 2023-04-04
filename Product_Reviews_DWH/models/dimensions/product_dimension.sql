{{
    config(
        materialized='incremental',
        unique_key='asin',
        on_schema_change='fail'
    )
}}
{% if is_incremental() %}
    {% set sql_statement %}
        select max(sk_product_dim) from  {{ this }}
    {% endset %}
    {%- set results = dbt_utils.get_single_value(sql_statement) -%}
{% endif %}

SELECT 
row_number() over() + {{results}} as sk_product_dim,
staging.asin,
staging.title,
staging.description, 
staging.image_url,
staging.also_viewed,
staging.also_bought,
staging.bought_together,
staging.buy_after_viewing,
staging.viewed_and_bought_flag,
staging.viewed_and_bought
FROM  {{ source('justeattakeaway','products_dim_staging')}} staging
LEFT JOIN {{ this }} dim
ON staging.asin = dim.asin
WHERE dim.asin IS NULL