{{
    config(
        materialized = 'incremental',
        sort = 'session_start_time',
        dist = 'session_id',
        sql_where = 'TRUE',
        unique_key = 'session_id'
    )
}}

{%
set window_clause = "partition by session_id
    order by session_start_time
    rows between unbounded preceding and unbounded following"
%}


with base as (

    select * from {{var('sessions_table')}}

    {% if adapter.already_exists(this.schema, this.name) %}

    where "time" >=
        (select dateadd(hour, -1, max(session_start_time)) from {{this}})

    {% endif %}

),

cleaned as (

    select

        user_id,
        session_id,
        "time" as session_start_time,
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

        last_value(user_id) over ( {{ window_clause }} ) as user_id,
        last_value(session_start_time) over ( {{ window_clause }} )
            as session_start_time,
        last_value(library) over ( {{ window_clause }} ) as library,
        last_value(platform) over ( {{ window_clause }} ) as platform,
        last_value(device) over ( {{ window_clause }} ) as device,
        last_value(device_type) over ( {{ window_clause }} ) as device_type,
        last_value(carrier) over ( {{ window_clause }} ) as carrier,
        last_value(app_name) over ( {{ window_clause }} ) as app_name,
        last_value(app_version) over ( {{ window_clause }} ) as app_version,
        last_value(country) over ( {{ window_clause }} ) as country,
        last_value(region) over ( {{ window_clause }} ) as region,
        last_value(city) over ( {{ window_clause }} ) as city,
        last_value(ip) over ( {{ window_clause }} ) as ip,
        last_value(referrer) over ( {{ window_clause }} ) as referrer,
        last_value(landing_page) over ( {{ window_clause }} ) as landing_page,
        last_value(browser) over ( {{ window_clause }} ) as browser,
        last_value(search_keyword) over ( {{ window_clause }} )
            as search_keyword,
        last_value(utm_source) over ( {{ window_clause }} ) as utm_source,
        last_value(utm_campaign) over ( {{ window_clause }} ) as utm_campaign,
        last_value(utm_medium) over ( {{ window_clause }} ) as utm_medium,
        last_value(utm_term) over ( {{ window_clause }} ) as utm_term,
        last_value(utm_content) over ( {{ window_clause }} ) as utm_content

    from cleaned

)

select * from deduped
