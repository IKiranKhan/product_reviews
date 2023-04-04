
    
    

select
    sk_category_dim as unique_field,
    count(*) as n_records

from "postgres"."justeattakeaway"."product_category_dimension"
where sk_category_dim is not null
group by sk_category_dim
having count(*) > 1


