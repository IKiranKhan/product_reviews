
    
    

select
    sk_product_dim as unique_field,
    count(*) as n_records

from "postgres"."justeattakeaway"."products_dimension"
where sk_product_dim is not null
group by sk_product_dim
having count(*) > 1


