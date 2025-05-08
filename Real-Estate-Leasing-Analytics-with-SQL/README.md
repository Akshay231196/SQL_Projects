# Real Estate Leasing Analytics with SQL Server

This project provides a full SQL-based analysis of leasing performance, occupancy, and revenue across multiple properties. It is designed to extract valuable KPIs from lease agreements, property metadata, and tenant behavior using SQL Server.

## Objective

- Measure leasing performance and occupancy by property
- Track rent trends and payment behavior
- Analyze tenant churn and lease gaps
- Support property management with data-driven insights

## Datasets

1. leases.csv  
   - Lease agreement details: property ID, tenant ID, dates, rent, status

2. properties.csv  
   - Property metadata: location, type, unit count, features

3. tenants.csv  
   - Tenant demographic and contact information

## Key SQL Queries and Insights

- STEP 1: View sample lease data  
- STEP 2: Count active leases by property  
- STEP 3: Calculate current occupancy rate per property  
- STEP 4: Monthly rental revenue per property  
- STEP 5: Average lease duration (in months)  
- STEP 6: Identify lease renewals (tenants with multiple leases)  
- STEP 7: Tenant churn rate by property  
- STEP 8: Total revenue by city  
- STEP 9: Lease distribution by furnished vs. unfurnished  
- STEP 10: Average rent by property type  
- STEP 11: Leases expiring in the next 60 days  
- STEP 12: Gaps between leases (idle unit periods)  
- STEP 13: Year-over-year rent growth  
- STEP 14: Estimated rent per unit  
- STEP 15: Preferred lease payment methods  

## Techniques Used

- SQL window functions (e.g., LEAD)
- CTEs for churn and gap analysis
- Aggregate functions (SUM, AVG, COUNT, ROUND)
- Temporal filtering (DATEDIFF, GETDATE, DATEADD)
- Joins between leases, tenants, and property metadata

## How to Use

1. Import all three CSV files into Microsoft SQL Server
2. Run the queries sequentially or use them modularly for reporting
3. Optionally build a dashboard using Power BI or Excel for visualization

## Author

Akshay Prajapati  
Data & Business Analytics | SQL, Power BI, Python  
LinkedIn: https://www.linkedin.com/in/akshay-prajapati-888668122
