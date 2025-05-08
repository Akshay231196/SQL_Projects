-- STEP 1: View sample energy data
SELECT TOP 10 * FROM energy_usage;


-- STEP 2: Total energy used by building
SELECT building_id, SUM(kwh_consumed) AS total_kwh
FROM energy_usage
GROUP BY building_id;


-- STEP 3: Energy per square foot
SELECT 
    e.building_id,
    ROUND(SUM(e.kwh_consumed) / b.sqft, 2) AS kwh_per_sqft
FROM energy_usage e
JOIN buildings b ON e.building_id = b.building_id
GROUP BY e.building_id, b.sqft;


-- STEP 4: Daily energy consumption per building
SELECT 
    building_id,
    CAST(timestamp AS DATE) AS usage_date,
    round(SUM(kwh_consumed),2) AS daily_kwh
FROM energy_usage
GROUP BY building_id, CAST(timestamp AS DATE);



-- STEP 5: Weekly energy trend per building
SELECT 
    building_id,
    DATEPART(ISO_WEEK, timestamp) AS week_number,
    Round(SUM(kwh_consumed),2) AS weekly_kwh
FROM energy_usage
GROUP BY building_id, DATEPART(ISO_WEEK, timestamp);



-- STEP 6: Rolling 7-day average energy usage
WITH DailyUsage AS (
    SELECT 
        building_id,
        CAST(timestamp AS DATE) AS usage_date,
        round(SUM(kwh_consumed),2) AS daily_kwh
    FROM energy_usage
    GROUP BY building_id, CAST(timestamp AS DATE)
)
SELECT 
    building_id,
    usage_date,
    daily_kwh,
    ROUND(AVG(daily_kwh) OVER (
        PARTITION BY building_id
        ORDER BY usage_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_7_day_avg
FROM DailyUsage;



-- STEP 7: Detect spikes (days when usage > 150% of rolling avg)
WITH DailyUsage AS (
    SELECT 
        building_id,
        CAST(timestamp AS DATE) AS usage_date,
        round(SUM(kwh_consumed),2) AS daily_kwh
    FROM energy_usage
    GROUP BY building_id, CAST(timestamp AS DATE)
),
DailyWithAvg AS (
    SELECT 
        building_id,
        usage_date,
        daily_kwh,
        ROUND(AVG(daily_kwh) OVER (
            PARTITION BY building_id
            ORDER BY usage_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2) AS rolling_7_day_avg
    FROM DailyUsage
)
SELECT *
FROM DailyWithAvg
WHERE daily_kwh > rolling_7_day_avg * 1.5;


-- STEP 8: Join energy with weather to analyze influence
SELECT 
    e.building_id,
    CAST(e.timestamp AS DATE) AS usage_date,
    round(w.avg_temperature_c,2) as temperature_c,
    round(SUM(e.kwh_consumed),2) AS total_kwh
FROM energy_usage e
JOIN buildings b ON e.building_id = b.building_id
JOIN weather w ON CAST(e.timestamp AS DATE) = w.date AND b.region = w.region
GROUP BY e.building_id, CAST(e.timestamp AS DATE), w.avg_temperature_c;


-- STEP 9: Avg kWh by temperature bucket
WITH UsageWeather AS (
    SELECT 
        e.building_id,
        w.avg_temperature_c,
        SUM(e.kwh_consumed) AS total_kwh
    FROM energy_usage e
    JOIN buildings b ON e.building_id = b.building_id
    JOIN weather w ON CAST(e.timestamp AS DATE) = w.date AND b.region = w.region
    GROUP BY e.building_id, w.avg_temperature_c
)
SELECT 
    CASE 
        WHEN avg_temperature_c < 0 THEN '<0°C'
        WHEN avg_temperature_c BETWEEN 0 AND 10 THEN '0-10°C'
        WHEN avg_temperature_c BETWEEN 11 AND 20 THEN '11-20°C'
        WHEN avg_temperature_c BETWEEN 21 AND 30 THEN '21-30°C'
        ELSE '>30°C'
    END AS temperature_range,
    ROUND(AVG(total_kwh), 2) AS avg_kwh
FROM UsageWeather
GROUP BY 
    CASE 
        WHEN avg_temperature_c < 0 THEN '<0°C'
        WHEN avg_temperature_c BETWEEN 0 AND 10 THEN '0-10°C'
        WHEN avg_temperature_c BETWEEN 11 AND 20 THEN '11-20°C'
        WHEN avg_temperature_c BETWEEN 21 AND 30 THEN '21-30°C'
        ELSE '>30°C'
    END;
