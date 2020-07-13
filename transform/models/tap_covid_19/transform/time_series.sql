with source as (
    select * from {{var("schema")}}.eu_ecdc_daily
    order by date, country
),
deutschland_daily_stats as (
    select
        CAST(date AS DATE) as date,
        country,
        deaths,
        round((cases/lag(cases)  over( order by date )) * 100 - 100, 1) as case_increase_percentage,
        round((deaths/lag(deaths)  over( order by date )) * 100 - 100, 1) as death_increase_percentage
    from source
    where country ='DE'
),

france_daily_stats as (
    select
        CAST(date AS DATE) as date,
        country,
        deaths,
        round((cases/lag(cases)  over( order by date )) * 100 - 100, 1) as case_increase_percentage,
        round((deaths/lag(deaths)  over( order by date )) * 100 - 100, 1) as death_increase_percentage
    from source
    where country ='FR'
),

time_series as (
    select 
deutschland_daily_stats.date as case_date,
france_daily_stats.case_increase_percentage as france_case_increase_percentage,
france_daily_stats.death_increase_percentage as france_death_increase_percentage,
deutschland_daily_stats.case_increase_percentage as deutschland_case_increase_percentage,
deutschland_daily_stats.death_increase_percentage as deutschland_death_increase_percentage
from deutschland_daily_stats 
LEFT JOIN france_daily_stats 
 on france_daily_stats.date = deutschland_daily_stats.date
 )
 select * from time_series