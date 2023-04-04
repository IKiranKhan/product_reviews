{{
    config(
        materialized='incremental',
        unique_key='sk_product_reviews_fact',
        on_schema_change='fail'
    )
}}
{% if is_incremental() %}
    {% set sql_statement %}
        select coalesce(max(sk_product_reviews_fact),0) from  {{ this }}
    {% endset %}
    {%- set results = dbt_utils.get_single_value(sql_statement) -%}
{% endif %}

SELECT  
row_number() over()+{{results}} as sk_product_reviews_fact,
'2000-01-01'::date as date,
coalesce(prd_dim.sk_product_dim,-1)::int4 as sk_product_dim,
coalesce(category.sk_category_dim,-1) as sk_category_dim,
coalesce(prd_bucket.sk_price_bucket_dim,-1) as sk_price_bucket_dim,
coalesce(reviewer_dim.sk_reviewer_dim,-1)::int4 as sk_reviewer_dim,
prd_dim_stg.price as product_price,
prd_dim_stg.sales_rank::int4 as sales_rank,
reviews_stag.overall::int4 as overall_rating,
reviews_stag.up_votes as review_likes,
reviews_stag.down_votes as review_dislikes,
prd_dim_stg.viewed_and_bought_count::int4 as viewed_and_bought_count
-- products dim table
FROM {{ source('justeattakeaway','product_dimension')}}  prd_dim
-- products staging table
JOIN {{ source('justeattakeaway','products_dim_staging')}}  prd_dim_stg 
ON prd_dim.asin = prd_dim_stg.asin
-- products category dim table
left join {{ source('justeattakeaway','product_category_dimension')}}  category
ON prd_dim_stg.category= category.category and prd_dim_stg.sub_category = category.sub_category 
-- price bucket dim table
LEFT JOIN {{ source('justeattakeaway','price_bucket_dimension')}}  prd_bucket
ON prd_dim_stg.price >= prd_bucket.bucket_lower_limit  and  prd_dim_stg.price<=prd_bucket.bucket_upper_limit
-- reviews staging table
LEFT JOIN {{ source('justeattakeaway','reviews_dim_staging')}}  as reviews_stag
ON prd_dim.asin = reviews_stag.asin and reviews_stag.review_date = '2000-01-01'
-- reviewer dim table
LEFT JOIN {{ source('justeattakeaway','reviewer_dimension')}}  reviewer_dim
ON reviews_stag.reviewerid =reviewer_dim.reviewerid and reviews_stag.review_date >=reviewer_dim.valid_from and reviews_stag.review_date <reviewer_dim.valid_to
