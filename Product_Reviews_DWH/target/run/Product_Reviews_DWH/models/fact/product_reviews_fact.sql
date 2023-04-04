
      
        
            delete from "postgres"."justeattakeaway"."product_reviews_fact"
            where (
                sk_product_reviews_fact) in (
                select (sk_product_reviews_fact)
                from "product_reviews_fact__dbt_tmp160302161246"
            );

        
    

    insert into "postgres"."justeattakeaway"."product_reviews_fact" ("sk_product_reviews_fact", "date", "sk_product_dim", "sk_category_dim", "sk_price_bucket_dim", "sk_reviewer_dim", "product_price", "sales_rank", "overall_rating", "review_likes", "review_dislikes", "viewed_and_bought_count")
    (
        select "sk_product_reviews_fact", "date", "sk_product_dim", "sk_category_dim", "sk_price_bucket_dim", "sk_reviewer_dim", "product_price", "sales_rank", "overall_rating", "review_likes", "review_dislikes", "viewed_and_bought_count"
        from "product_reviews_fact__dbt_tmp160302161246"
    )
  