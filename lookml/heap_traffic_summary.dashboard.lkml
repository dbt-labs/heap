- dashboard: heap_traffic_summary
  title: Heap Traffic Summary
  layout: newspaper
  elements:
  - title: Last Week Sessions
    name: Last Week Sessions
    model: marketing
    explore: web_sessions
    type: single_value
    fields:
    - web_sessions.sessions
    - web_sessions.session_start_week
    fill_fields:
    - web_sessions.session_start_week
    filters:
      web_sessions.session_start_week: ''
    sorts:
    - web_sessions.session_start_week desc
    limit: 500
    dynamic_fields:
    - table_calculation: last_week_sessions
      label: last_week_sessions
      expression: offset(${web_sessions.sessions}, 1)
      value_format:
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: wow_change
      label: wow_change
      expression: "(${web_sessions.sessions} - ${last_week_sessions}) / ${last_week_sessions}"
      value_format:
      value_format_name: percent_0
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: week-over-week
    series_types: {}
    hidden_fields:
    - last_week_sessions
    y_axes: []
    listen:
      Date Filter: web_sessions.session_start_date
    row: 2
    col: 0
    width: 8
    height: 4

  - title: Last Week Uniques
    name: Last Week Uniques
    model: marketing
    explore: web_sessions
    type: single_value
    fields:
    - web_sessions.session_start_week
    - web_sessions.distinct_users
    fill_fields:
    - web_sessions.session_start_week
    filters:
      web_sessions.session_start_week: ''
    sorts:
    - web_sessions.session_start_week desc
    limit: 500
    dynamic_fields:
    - table_calculation: last_week
      label: last_week
      expression: offset(${web_sessions.distinct_users}, 1)
      value_format:
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: wow_change
      label: wow_change
      expression: "(${web_sessions.distinct_users} - ${last_week}) / ${last_week}"
      value_format:
      value_format_name: percent_0
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: week-over-week
    series_types: {}
    hidden_fields:
    - last_week_sessions
    - last_week
    y_axes: []
    listen:
      Date Filter: web_sessions.session_start_date
    row: 2
    col: 8
    width: 8
    height: 4

  - title: New Users
    name: New Users
    model: marketing
    explore: web_sessions
    type: looker_line
    fields:
    - web_sessions.distinct_users
    - web_sessions.session_start_date
    fill_fields:
    - web_sessions.session_start_date
    filters:
      web_sessions.new_vs_returning: new
    sorts:
    - web_sessions.session_start_date desc
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_types: {}
    limit_displayed_rows: false
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: web_sessions.distinct_users
        name: Distinct Users
        axisId: web_sessions.distinct_users
      showLabels: false
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    show_null_points: true
    interpolation: linear
    listen:
      Date Filter: web_sessions.session_start_date
    row: 18
    col: 12
    width: 12
    height: 6

  - title: Average Sessions per User
    name: Average Sessions per User
    model: marketing
    explore: web_sessions
    type: single_value
    fields:
    - web_sessions.sessions_per_user
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    single_value_title: Average Sessions per User
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_types: {}
    limit_displayed_rows: false
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: web_sessions.distinct_users
        name: Distinct Users
        axisId: web_sessions.distinct_users
      showLabels: false
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    show_null_points: true
    interpolation: linear
    listen:
      Date Filter: web_sessions.session_start_date
    row: 2
    col: 16
    width: 8
    height: 4

  - title: New vs. Returning
    name: New vs. Returning
    model: marketing
    explore: web_sessions
    type: looker_line
    fields:
    - web_sessions.new_vs_returning
    - web_sessions.distinct_users
    - web_sessions.session_start_date
    pivots:
    - web_sessions.new_vs_returning
    fill_fields:
    - web_sessions.session_start_date
    sorts:
    - web_sessions.distinct_users desc 0
    - web_sessions.new_vs_returning
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    colors:
    - "#62bad4"
    - "#a9c574"
    - "#929292"
    - "#9fdee0"
    - "#1f3e5a"
    - "#90c8ae"
    - "#92818d"
    - "#c5c6a6"
    - "#82c2ca"
    - "#cee0a0"
    - "#928fb4"
    - "#9fc190"
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_colors: {}
    series_types: {}
    limit_displayed_rows: false
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: new - web_sessions.distinct_users
        name: new
        axisId: web_sessions.distinct_users
      - id: returning - web_sessions.distinct_users
        name: returning
        axisId: web_sessions.distinct_users
      showLabels: false
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    show_null_points: true
    interpolation: linear
    listen:
      Date Filter: web_sessions.session_start_date
    row: 24
    col: 0
    width: 24
    height: 7

  - title: Sessions
    name: Sessions
    model: marketing
    explore: web_sessions
    type: looker_line
    fields:
    - web_sessions.distinct_users
    - web_sessions.session_start_date
    fill_fields:
    - web_sessions.session_start_date
    filters: {}
    sorts:
    - web_sessions.session_start_date desc
    limit: 500
    dynamic_fields:
    - table_calculation: median
      label: median
      expression: median(${web_sessions.distinct_users})
      value_format:
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    hide_legend: true
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_colors:
      median: "#d9d9d9"
    series_types:
      median: area
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    show_null_points: true
    interpolation: linear
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: week-over-week
    hidden_fields:
    - last_week_sessions
    - last_week
    y_axes: []
    listen:
      Date Filter: web_sessions.session_start_date
    row: 6
    col: 0
    width: 24
    height: 6

  - name: Sessions
    type: text
    title_text: Sessions
    row: 0
    col: 0
    width: 24
    height: 2

  - name: Users
    type: text
    title_text: Users
    row: 12
    col: 0
    width: 24
    height: 2

  - title: Total Distinct Users
    name: Total Distinct Users
    model: marketing
    explore: web_sessions
    type: single_value
    fields:
    - web_sessions.distinct_users
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    single_value_title: Distinct Users
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    listen:
      Date Filter: web_sessions.session_start_date
    row: 14
    col: 0
    width: 8
    height: 4

  - title: New Users
    name: New Users
    model: marketing
    explore: web_sessions
    type: single_value
    fields:
    - web_sessions.distinct_users
    filters:
      web_sessions.new_vs_returning: new
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    single_value_title: New Users
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    listen:
      Date Filter: web_sessions.session_start_date
    row: 14
    col: 8
    width: 8
    height: 4

  - title: Total Users
    name: Total Users
    model: marketing
    explore: web_sessions
    type: looker_line
    fields:
    - web_sessions.distinct_users
    - web_sessions.session_start_date
    fill_fields:
    - web_sessions.session_start_date
    sorts:
    - web_sessions.session_start_date desc
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_types: {}
    limit_displayed_rows: false
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: web_sessions.distinct_users
        name: Distinct Users
        axisId: web_sessions.distinct_users
      showLabels: false
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    show_null_points: true
    interpolation: linear
    listen:
      Date Filter: web_sessions.session_start_date
    row: 18
    col: 0
    width: 12
    height: 6

  - title: Returning Users
    name: Returning Users
    model: marketing
    explore: web_sessions
    type: single_value
    fields:
    - web_sessions.distinct_users
    filters:
      web_sessions.new_vs_returning: returning
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    single_value_title: Returning Users
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    listen:
      Date Filter: web_sessions.session_start_date
    row: 14
    col: 16
    width: 8
    height: 4
    
  filters:
  - name: Date Filter
    title: Date Filter
    type: date_filter
    default_value: 30 days
    allow_multiple_values: true
    required: false
