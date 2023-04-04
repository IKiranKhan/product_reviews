


SELECT 
row_number() over() +  as sk_product_dim,
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
FROM  "postgres"."justeattakeaway"."products_dim_staging" staging
LEFT JOIN "postgres"."justeattakeaway"."product_dimension" dim
ON staging.asin = dim.asin
WHERE dim.asin IS NULL