
    
    

select
    sk_product_reviews_fact as unique_field,
    count(*) as n_records

from "postgres"."justeattakeaway"."product_reviews_fact"
where sk_product_reviews_fact is not null
group by sk_product_reviews_fact
having count(*) > 1


