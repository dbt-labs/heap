{{
    config(
        materialized = 'incremental',
        sort = 'session_start_time',
        dist = 'session_id',
        sql_where = 'TRUE',
        unique_key = 'session_id'
    )
}}

{% set this_exists = adapter.already_exists(this.schema, this.name) %}

with sessions as (

  select * from {{ref('heap_sessions')}}

  {% if this_exists %}

  where session_start_time >=
    (select dateadd(hour, -1, max(session_start_time)) from {{this}})

  {% endif %}

), events as (

  select * from {{ref('heap_events')}}

), referrers as (

    select * from {{ref('referrer_mapping')}}

), events_agg as (

  select
    session_id,
    max("time") as session_end_time,
    count(*) as event_count
  from events

  {% if this_exists %}

  where session_id in (select session_id from sessions)

  {% endif %}

  group by 1

), referring_domains as (

    select
        *,
        ltrim(split_part(split_part(referrer, '//', 2), '/', 1), 'www.') as referring_domain
    from sessions

)

select
  s.*,
  row_number() over (partition by s.user_id order by s.session_start_time) as user_sesionidx,
  ea.session_end_time,
  ea.event_count,
  referrers.medium as referrer_medium,
  referrers.source as referrer_source
from referring_domains s
  left outer join events_agg ea on s.session_id = ea.session_id
  left outer join referrers on s.referring_domain = referrers.domain
