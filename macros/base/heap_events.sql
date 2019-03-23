{% macro heap_events() %}

    {{ adapter_macro('heap.heap_events') }}

{% endmacro %}

{% macro default__heap_events() %}

select 
    
    *,
    
    {% if target.type == 'redshift' %}
        "time" as event_time
    {% else %}
        time as event_time
    {% endif %}
    
from {{var('events_table')}}

{% endmacro %}