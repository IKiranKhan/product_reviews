
    
    

select
    asin as unique_field,
    count(*) as n_records

from "postgres"."justeattakeaway"."products_dim_staging"
where asin is not null
group by asin
having count(*) > 1


