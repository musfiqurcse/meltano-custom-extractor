with source as (
    select * from {{var("schema")}}.eu_ecdc_daily
),
risk_area as (
    select
        country,
        SUM(deaths),
        CASE WHEN
          SUM(deaths) :: DECIMAL < 100
          THEN '1 - Small Risk '
        WHEN SUM(deaths) :: DECIMAL >= 100 AND SUM(deaths) :: DECIMAL < 1000
          THEN '2 - Medium Risk'
        WHEN SUM(deaths) :: DECIMAL >= 1000 AND SUM(deaths) :: DECIMAL < 2000
          THEN '3 - Moderate Risk'
        WHEN SUM(deaths) :: DECIMAL >= 2000
          THEN '4 - High Risk (>5k)'
        ELSE '5 - Unknown'
        END  AS risk_level
    from source
    where country != 'Total' 
    GROUP BY country
)

select * from risk_area