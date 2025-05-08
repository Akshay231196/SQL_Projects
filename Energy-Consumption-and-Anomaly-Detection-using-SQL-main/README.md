# Energy Usage Efficiency Dashboard using SQL Server

This project demonstrates how to analyze and optimize building-level energy consumption using SQL. It combines energy meter data, building metadata, and weather conditions to produce actionable insights through structured queries and window functions.

## Objective

- Track daily and weekly energy consumption per building
- Normalize usage by building size (kWh per square foot)
- Calculate rolling 7-day usage averages
- Detect abnormal spikes in energy consumption
- Correlate energy usage with temperature and weather patterns

## Datasets

1. buildings.csv  
   - Building metadata: ID, name, region, size, LEED certification, solar panels, etc.

2. energy_usage.csv  
   - Time-stamped energy readings: kWh consumed, voltage, current, meter info

3. weather.csv  
   - Daily weather logs: temperature, humidity, wind, precipitation, visibility

## Techniques Used

- SQL Joins (building, energy, weather)
- Grouping and time-based aggregation (by day, week)
- Window Functions (e.g., rolling averages)
- Conditional logic with CASE
- Spike detection based on dynamic thresholds
- Data normalization (e.g., per square foot)

## Key SQL Examples

- Total and per sq. ft energy usage by building
- Weekly and daily energy trend reports
- 7-day rolling average using AVG() OVER(...)
- Detection of high-usage days (spikes)
- Joining energy usage with weather data for correlation

## How to Use

1. Import all three CSVs into SQL Server tables.
2. Run SQL queries in sequence to build insights.
3. Use Power BI or Excel to create visuals like:
   - Line charts of daily kWh
   - Heatmaps by region or building
   - Bar charts comparing efficiency

## Potential Extensions

- Add cost data and calculate electricity bills
- Compare LEED vs non-LEED energy performance
- Forecast demand using trend + seasonality
- Add anomaly alerts for operational dashboards

## Author

Akshay Prajapati  
Data & Business Analytics | SQL, Power BI, Python  
LinkedIn: https://www.linkedin.com/in/akshay-prajapati-888668122
