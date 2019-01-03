{{ config(
    materialized = 'table',
    sort = 'session_start_time',
    dist = 'session_id'
    )}}

--unfortunately, it doesn't seem that heap ensures uniqueness across values in session_id.
--this causes duplication when handling joins and these models don't yet account for it.

with sessions as (

    select * from {{ref('heap_sessions')}}

), events as (

    select * from {{ref('heap_events')}}

), referrers as (

    select * from {{ref('referrer_mapping')}}

), users as (

    select * from {{ref('heap_users')}}

), events_agg as (

    select distinct 
        
        session_id,
        max("time") over (partition by session_id) as session_end_time,
        count(*) over (partition by session_id) as event_count,
        
        first_value(query) over (
            partition by session_id 
            order by "time" 
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
      row_number() over (partition by s.user_id order by s.session_start_time) as user_sesionidx,
      ea.session_end_time,
      ea.event_count,
      referrers.medium as referrer_medium,
      referrers.source as referrer_source,
      coalesce(users."identity", s.user_id::varchar) as blended_user_id,
      {{ dbt_utils.get_url_parameter('ea.first_page_query', 'gclid') }} as gclid
      
    from referring_domains s
      left outer join events_agg ea on s.session_id = ea.session_id
      left outer join referrers on s.referring_domain = referrers.domain
      left outer join users on s.user_id = users.user_id

)

select * from joined