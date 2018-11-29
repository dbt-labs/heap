view: web_sessions {
  sql_table_name: {{_user_attributes['dbt_schema']}}.fct_web_sessions ;;

  # ----------------------------------------------------- IDs

  dimension: session_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.session_id ;;
    hidden: yes
  }

  dimension: blended_user_id {
    type: string
    sql: ${TABLE}.blended_user_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  # ----------------------------------------------------- DATES

  dimension_group: session_start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.session_start_time ;;
  }

  dimension_group: session_end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.session_end_time ;;
  }

  # ----------------------------------------------------- REFERRER

  dimension: referrer {
    type: string
    sql: ${TABLE}.referrer ;;
    group_label: "Referrer"
  }

  dimension: referrer_source {
    type: string
    sql: ${TABLE}.referrer_source ;;
    group_label: "Referrer"
  }

  dimension: referring_domain {
    type: string
    sql: ${TABLE}.referring_domain ;;
    group_label: "Referrer"
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
    group_label: "Referrer"
  }

  # ----------------------------------------------------- DEVICE

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
    group_label: "Device"
  }

  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
    group_label: "Device"
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
    group_label: "Device"
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
    group_label: "Device"
  }


  # ----------------------------------------------------- GEO

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    group_label: "Geo"
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    group_label: "Geo"
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
    group_label: "Geo"
  }


  # ----------------------------------------------------- ATTRIBUTION

  dimension: utm_campaign {
    type: string
    sql: ${TABLE}.utm_campaign ;;
    group_label: "Attribution"
  }

  dimension: utm_content {
    type: string
    sql: ${TABLE}.utm_content ;;
    group_label: "Attribution"
  }

  dimension: utm_medium {
    type: string
    sql: ${TABLE}.utm_medium ;;
    group_label: "Attribution"
  }

  dimension: utm_source {
    type: string
    sql: ${TABLE}.utm_source ;;
    group_label: "Attribution"
  }

  dimension: utm_term {
    type: string
    sql: ${TABLE}.utm_term ;;
    group_label: "Attribution"
  }

  dimension: gclid {
    type: string
    sql: ${TABLE}.gclid ;;
    group_label: "Attribution"
  }


  # ----------------------------------------------------- OTHER DIMENSIONS

  dimension: user_sessionidx {
    label: "User's Session Number"
    type: number
    sql: ${TABLE}.user_sesionidx ;;
  }

  dimension: app_name {
    type: string
    sql: ${TABLE}.app_name ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension: event_count {
    type: number
    sql: ${TABLE}.event_count ;;
  }

  dimension: ip {
    type: string
    sql: ${TABLE}.ip ;;
  }

  dimension: landing_page {
    type: string
    sql: ${TABLE}.landing_page ;;
  }

  dimension: library {
    type: string
    sql: ${TABLE}.library ;;
  }

  dimension: new_vs_returning {
    type: string
    sql:
      case
        when ${user_sessionidx} = 1 then 'new'
        else 'returning'
      end ;;
  }

  dimension: user_bounced {
    label: "Bounced?"
    type: yesno
    sql: case when ${event_count} = 1 then true else false end ;;
  }

  # ----------------------------------------------------- MEASURES

  measure: sessions {
    type: count
    value_format_name: decimal_0
  }

  measure: distinct_users {
    label: "Distinct Users"
    type: count_distinct
    sql: ${blended_user_id} ;;
    value_format_name: decimal_0
  }

  measure: sessions_per_user {
    type: number
    sql: ${sessions}::float / nullif(${distinct_users}, 0) ;;
    value_format_name: decimal_2
  }

  measure: sessions_from_new_visitors {
    type: count
    filters: {
      field: new_vs_returning
      value: "new"
    }
    value_format_name: decimal_0
  }

  measure: sessions_from_returning_visitors {
    type: count
    filters: {
      field: new_vs_returning
      value: "returning"
    }
    value_format_name: decimal_0
  }

  measure: percent_new_visitors {
    type: number
    sql: ${sessions_from_new_visitors}::float / nullif(${sessions}, 0) ;;
    value_format_name: percent_1
  }

  measure: percent_returning_visitors {
    type: number
    sql: ${sessions_from_returning_visitors}::float / nullif(${sessions}, 0) ;;
    value_format_name: percent_1
  }

  measure: bounced_sessions {
    type: count
    filters: {
      field: user_bounced
      value: "yes"
    }
    value_format_name: decimal_0
  }

  measure: bounce_rate {
    type: number
    sql: ${bounced_sessions}::float / nullif(${sessions}, 0) ;;
    value_format_name: percent_1
  }

}

view: web_sessions_ad_performance {

  extends: [web_sessions]

  derived_table: {
    sql:
      select
          *,
          md5(
            ''
            {% if web_sessions_ad_performance.ad_platform._in_query %} || coalesce(ad_platform, '') {% endif %}
            {% if web_sessions_ad_performance.utm_medium._in_query %} || coalesce(utm_medium, '') {% endif %}
            {% if web_sessions_ad_performance.utm_source._in_query %} || coalesce(utm_source, '') {% endif %}
            {% if web_sessions_ad_performance.utm_campaign._in_query %} || coalesce(utm_campaign, '') {% endif %}
            {% if web_sessions_ad_performance.utm_term._in_query %} || coalesce(utm_term, '') {% endif %}
            {% if web_sessions_ad_performance.utm_content._in_query %} || coalesce(utm_content, '') {% endif %}

            ) as auto_ad_id
      from {{_user_attributes['dbt_schema']}}.web_sessions
    ;;
  }

  dimension: auto_ad_id {
    hidden: yes
    type: string
    sql: ${TABLE}.auto_ad_id ;;
  }

}
