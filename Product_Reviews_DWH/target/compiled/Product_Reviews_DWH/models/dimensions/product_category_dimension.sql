

    


SELECT 
row_number() over()+(select max(sk_category_dim) from "postgres"."justeattakeaway"."product_category_dimension") as sk_category_dim,
category,
sub_category 
from "postgres"."justeattakeaway"."products_dim_staging" 

where (category,sub_category) not in (select distinct category,sub_category from "postgres"."justeattakeaway"."product_category_dimension")

group by 2,3