{% snapshot reviewer_dimension %}

{{
    config(
      target_database='postgres',
      target_schema='justeattakeaway',
      unique_key='reviewerID',
      strategy='timestamp',
      updated_at='review_date'
    )
}}

{% set sql_statement %}
    select max(sk_reviewer_dim) from  {{ this }}
{% endset %}
{%- set results = dbt_utils.get_single_value(sql_statement) -%}

SELECT (row_number() over()+{{results}}) as sk_reviewer_dim, 
reviewerID, string_agg(distinct reviewer_name, '; ') as reviewer_name, max(review_date) as review_date 
FROM {{ source('justeattakeaway', 'reviews_dim_staging')}}
WHERE review_date= "'"{{results_date}}"'"
AND reviewer_name not in ('Unknown' ,'none','')
GROUP BY 2
{% endsnapshot %}