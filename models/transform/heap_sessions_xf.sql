with sessions as (

  select * from {{ref('heap_sessions')}}

), events as (

  select * from {{ref('heap_events')}}

), events_agg as (

  select
    session_id,
    max("time") as session_end_time,
    count(*) as event_count
  from events
  group by 1

)

select
  s.*,
  row_number() over (partition by s.user_id order by s.session_start_time) as user_sesionidx,
  ea.session_end_time,
  ea.event_count
from sessions s
  left outer join events_agg ea on s.session_id = ea.session_id
