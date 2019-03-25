{% macro identity_field() %}
  {{ adapter_macro('heap.identity_field') }}
{% endmacro %}

{% macro default__identity_field() %}
    "identity"
{% endmacro %}

{% macro snowflake__identity_field() %}
    identity
{% endmacro %}