with source as (
    select * from {{var("schema")}}.eu_ecdc_daily
    order by date, country
),
daily_stats as (
    select
        date,
        country,
        deaths,
        round((cases/lag(cases)  over( order by date )) * 100 - 100, 1) as case_increase_percentage,
        round((deaths/lag(deaths)  over( order by date )) * 100 - 100, 1) as death_increase_percentage
    from source
    where country ='DE'
)

select * from daily_stats