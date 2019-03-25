{% macro time_field(field_name) %}
  {{ adapter_macro('heap.time_field', field_name) }}
{% endmacro %}

{% macro default__time_field(field_name) %}
    "time" as {{field_name}}
{% endmacro %}

{% macro snowflake__time_field(field_name) %}
    time as {{field_name}}
{% endmacro %}