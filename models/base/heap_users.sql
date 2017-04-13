{%
    set window_clause = "partition by user_id order by last_modified rows
        between unbounded preceding and unbounded following"
%}

--this is kinda bullshit--it's only done because heap has a bug where it inserts duplicate records for users.

select distinct
  user_id,
  last_value("identity") over ( {{window_clause}} ) as "identity",
  last_value(lower(email)) over ( {{window_clause}} ) as email,
  min(joindate) over ( {{window_clause}} ) as joindate
from {{var('users_table')}}
