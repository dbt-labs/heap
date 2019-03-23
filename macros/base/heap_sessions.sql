{% macro heap_sessions() %}

    {{ adapter_macro('heap.heap_sessions') }}

{% endmacro %}

{% macro default__heap_sessions() %}

{% set window_clause = 
    "over
        (partition by session_id
        order by session_start_time
        rows between unbounded preceding and unbounded following
    )"
%}

{% set last_value_columns = [

    'user_id',
    'session_start_time',
    'library',
    'platform',
    'device',
    'device_type',
    'carrier',
    'app_name',
    'app_version',
    'country',
    'region',
    'city',
    'ip',
    'referrer',
    'landing_page',
    'browser',
    'search_keyword',
    'utm_source',
    'utm_campaign',
    'utm_medium',
    'utm_term',
    'utm_content'
    
]%}

with base as (

    select * from {{var('sessions_table')}}

),

cleaned as (

    select

        user_id,
        session_id,
        {% if target.type == 'redshift' %}
            "time" as session_start_time,
        {% else %}
            time as session_start_time,
        {% endif %}
        
        library,
        platform,
        device,
        device_type,
        carrier,
        app_name,
        app_version,
        country,
        region,
        city,
        ip,
        referrer,
        rtrim(landing_page, '/') as landing_page,
        browser,
        search_keyword,
        nullif(utm_source, '') as utm_source,
        nullif(utm_campaign, '') as utm_campaign,
        nullif(utm_medium, '') as utm_medium,
        nullif(utm_term, '') as utm_term,
        nullif(utm_content, '') as utm_content

    from base

),

deduped as (
    --this sucks to have to do but heap frequently sends duplicate session data
    --and it forces us to have to deduplicate based on session_id in modeling

    select distinct

        session_id,

        {% for column in last_value_columns %}
            last_value({{ column }}) {{window_clause}} 
                as {{ column }}
            {% if not loop.last%} , {% endif %}
        {% endfor %}

    from cleaned

)

select * from deduped

{% endmacro %}