
    
    

select
    date as unique_field,
    count(*) as n_records

from "postgres"."justeattakeaway"."calendar_dimension"
where date is not null
group by date
having count(*) > 1


