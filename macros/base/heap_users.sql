{% macro heap_users() %}

    {{ adapter_macro('heap.heap_users') }}

{% endmacro %}

{% macro default__heap_users() %}

{%
    set window_clause = "partition by user_id order by last_modified rows
        between unbounded preceding and unbounded following"
%}

--this is only done because heap has a bug where it inserts duplicate records for users.

select distinct

    user_id,
    last_value(
        {% if target.type == 'redshift' %}
            "identity"    
        {% else %}
            identity
        {% endif %}
        ) over ( {{window_clause}} ) as user_identity,
    last_value(lower(email)) over ( {{window_clause}} ) as email,
    min(joindate) over ( {{window_clause}} ) as joindate
    
from {{var('users_table')}}

{% endmacro %}