with source as (
    select * from {{"tap_covid_19.eu_ecdc_daily"}}
),
risk_area as (
    select
        country,
        SUM(deaths),
        CASE WHEN
          SUM(deaths) :: DECIMAL < 1000
          THEN '1 - Small Risk (<1k)'
        WHEN SUM(deaths) :: DECIMAL >= 1000 AND SUM(deaths) :: DECIMAL < 2500
          THEN '2 - Medium Risk (1k - 2.5k)'
        WHEN SUM(deaths) :: DECIMAL >= 2500 AND SUM(deaths) :: DECIMAL < 5000
          THEN '3 - Moderate Risk (2.5k - 5k)'
        WHEN SUM(deaths) :: DECIMAL >= 5000
          THEN '4 - High Risk (>5k)'
        ELSE '5 - Unknown'
        END  AS risk_level
    from source
    where country != 'Total' 
    GROUP BY country
)

select * from risk_area