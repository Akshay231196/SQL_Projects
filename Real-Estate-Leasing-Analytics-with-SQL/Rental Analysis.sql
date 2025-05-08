-- STEP 1: View sample lease data
SELECT TOP 10 * FROM leases;

-- STEP 2: Count of active leases by property
ALTER TABLE leases
ALTER COLUMN property_id INT; 


SELECT property_id, COUNT(*) AS active_lease_count
FROM leases
WHERE status = 'Active'
GROUP BY property_id;

-- STEP 3: Current occupancy rate per property
Alter table properties
Alter Column Property_id Int;

SELECT 
    p.property_id,
    p.units_total,
    COUNT(l.lease_id) AS units_leased,
    ROUND(COUNT(l.lease_id) * 1.0 / p.units_total, 2) AS occupancy_rate
FROM properties p
LEFT JOIN leases l ON p.property_id = l.property_id AND l.status = 'Active'
GROUP BY p.property_id, p.units_total;

-- STEP 4: Monthly revenue per property
SELECT 
    property_id,
    Round(SUM(monthly_rent),2) AS monthly_revenue
FROM leases
WHERE status = 'Active'
GROUP BY property_id;


-- STEP 5: Average lease duration in months
SELECT 
    property_id,
    ROUND(AVG(DATEDIFF(DAY, start_date, end_date) / 30),1) AS avg_lease_duration_months
FROM leases
GROUP BY property_id;


-- STEP 6: Lease renewal rate (repeated tenants)
SELECT 
    tenant_id,
    COUNT(*) AS lease_count
FROM leases
GROUP BY tenant_id
HAVING COUNT(*) > 1;



-- STEP 7: Tenant churn rate by property
WITH TotalLeases AS (
    SELECT property_id, COUNT(*) AS total_leases
    FROM leases
    GROUP BY property_id
),
TerminatedLeases AS (
    SELECT property_id, COUNT(*) AS terminated_leases
    FROM leases
    WHERE status = 'Terminated'
    GROUP BY property_id
)
SELECT 
    t.property_id,
    t.total_leases,
    ISNULL(tr.terminated_leases, 0) AS terminated_leases,
    ROUND(ISNULL(tr.terminated_leases * 1.0/ t.total_leases, 0), 2) AS churn_rate
FROM TotalLeases t
LEFT JOIN TerminatedLeases tr ON t.property_id = tr.property_id;



-- STEP 8: Revenue by city
SELECT 
    p.city,
    Round(SUM(l.monthly_rent),2) AS total_monthly_revenue
FROM leases l
JOIN properties p ON l.property_id = p.property_id
WHERE l.status = 'Active'
GROUP BY p.city;



-- STEP 9: Furnished vs unfurnished lease count
SELECT 
    furnished,
    COUNT(*) AS lease_count
FROM leases
GROUP BY furnished;



-- STEP 10: Average rent by property type
SELECT 
    p.type,
    ROUND(AVG(l.monthly_rent), 2) AS avg_rent
FROM leases l
JOIN properties p ON l.property_id = p.property_id
GROUP BY p.type;



-- STEP 11: Upcoming lease expirations in next 60 days
SELECT 
    lease_id,
    property_id,
    tenant_id,
    end_date,
    DATEDIFF(DAY, GETDATE(), end_date) AS days_to_expire
FROM leases
WHERE status = 'Active'
  AND end_date BETWEEN GETDATE() AND DATEADD(DAY, 60, GETDATE())
ORDER BY end_date;



-- STEP 12: Gap between leases (idle unit periods)

WITH SortedLeases AS (
    SELECT 
        unit_id,
        property_id,
        tenant_id,
        start_date,
        end_date,
        LEAD(start_date) OVER (PARTITION BY unit_id ORDER BY start_date) AS next_lease_start
    FROM leases
)
SELECT 
    unit_id,
    property_id,
    end_date AS last_end,
    next_lease_start,
    DATEDIFF(DAY, end_date, next_lease_start) AS gap_days
FROM SortedLeases
WHERE next_lease_start IS NOT NULL
  AND DATEDIFF(DAY, end_date, next_lease_start) > 0;



-- STEP 13: Rent growth by year
SELECT 
    YEAR(start_date) AS lease_year,
    ROUND(AVG(monthly_rent), 2) AS avg_rent
FROM leases
GROUP BY YEAR(start_date)
ORDER BY lease_year;



-- STEP 14: Average rent per unit (estimated)
SELECT 
    p.property_id,
    ROUND(AVG(l.monthly_rent / p.units_total), 2) AS avg_rent_per_unit
FROM leases l
JOIN properties p ON l.property_id = p.property_id
GROUP BY p.property_id;



-- STEP 15: Lease payment method trends
SELECT 
    payment_method,
    COUNT(*) AS total_leases
FROM leases
GROUP BY payment_method;
