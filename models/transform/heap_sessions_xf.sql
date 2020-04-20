{{ config(
    materialized = 'incremental',
    sort = 'session_start_time',
    dist = 'session_id',
    unique_key = 'session_id'
    )}}

--unfortunately, it doesn't seem that heap ensures uniqueness across values in session_id.
--this causes duplication when handling joins and these models don't yet account for it.

with sessions as (

    select * from {{ref('heap_sessions')}}
    {% if is_incremental() %}
    where session_start_time >= (select dateadd(hour, -3, max(session_start_time)) from {{this}})
    {% endif %}

), events as (

    select * from {{ref('heap_events')}}

    {% if is_incremental() %}
    where event_time >= (select dateadd(hour, -5, max(session_start_time)) from {{this}})
    {% endif %}

), referrers as (

    select * from {{ref('referrer_mapping')}}

), users as (

    select * from {{ref('heap_users')}}

), events_agg as (

    select distinct

        session_id,
        max(event_time) over (partition by session_id) as session_end_time,
        count(*) over (partition by session_id) as event_count,

        first_value(query) over (
            partition by session_id
            order by event_time
            rows between unbounded preceding and unbounded following
            ) as first_page_query

    from events

), referring_domains as (

    select

        *,
        ltrim({{dbt_utils.get_url_host('referrer')}}, 'www.')
            as referring_domain

    from sessions

), joined as (

    select

      s.*,
      users.joindate as user_joindate,
      row_number() over (partition by s.user_id order by s.session_start_time)
        as user_sessionidx,
      ea.session_end_time,
      ea.event_count,
      referrers.{{ adapter.quote('medium') }} as referrer_medium,
      referrers.{{ adapter.quote('source') }} as referrer_source,
      coalesce(users.user_identity, s.user_id::varchar) as blended_user_id,
      {{ dbt_utils.get_url_parameter('ea.first_page_query', 'gclid') }} as gclid

    from referring_domains s
      left outer join events_agg ea on s.session_id = ea.session_id
      left outer join referrers on s.referring_domain = referrers.{{ adapter.quote('domain') }}
      left outer join users on s.user_id = users.user_id

)

select * from joined
