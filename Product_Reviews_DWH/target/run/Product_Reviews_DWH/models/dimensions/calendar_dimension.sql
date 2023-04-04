
      
        
            delete from "postgres"."justeattakeaway"."calendar_dimension"
            where (
                date) in (
                select (date)
                from "calendar_dimension__dbt_tmp170651795978"
            );

        
    

    insert into "postgres"."justeattakeaway"."calendar_dimension" ("date", "year", "quarter", "month")
    (
        select "date", "year", "quarter", "month"
        from "calendar_dimension__dbt_tmp170651795978"
    )
  