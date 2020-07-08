with source as (
    select * from {{var("schema")}}.eu_ecdc_daily
),
risk_area as (
    select
        country,
        deaths,
        CASE WHEN
          deaths :: DECIMAL < 100
          THEN '1 - Small Risk '
        WHEN deaths :: DECIMAL >= 100 AND deaths :: DECIMAL < 1000
          THEN '2 - Medium Risk'
        WHEN deaths :: DECIMAL >= 1000 AND deaths :: DECIMAL < 2000
          THEN '3 - Moderate Risk'
        WHEN SUM(deaths) :: DECIMAL >= 2000
          THEN '4 - High Risk (>5k)'
        ELSE '5 - Unknown'
        END  AS risk_level,
        CAST(date AS DATE) as case_date
    from source
    GROUP BY country,deaths,case_date
)

select * from risk_area