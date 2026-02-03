{% macro distribution_center_columns(name)%}
{% set distribution_centers_list = dbt_utils.get_column_values(table=ref("stg_thelook_ecommerce__distribution_centers"),column = 'distribution_center_name')%}
{%for center_name in distribution_centers_list%}
 avg(case when '{{center_name}}' = {{name}} then DATE_DIFF(sold_at, created_at, DAY) else null end) AS days_{{ center_name | replace(" ", "_") | replace("/", "_") | replace("-", "_") }}
{%if not loop.last%}, {%endif%}
{%endfor%}

{% endmacro %}