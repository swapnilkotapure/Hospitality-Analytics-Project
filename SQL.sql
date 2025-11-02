use hospitality;
- -- 1.Total Revenue
SELECT 
    ROUND(SUM(revenue_realized), 2) AS total_revenue
FROM fact_bookings;

 -- 2.Occupancy
SELECT 
    ROUND((SUM(successful_bookings) / SUM(capacity)) * 100, 2) AS occupancy_rate
FROM fact_aggregated_bookings;

--- 3.cancellation rate
SELECT 
    ROUND(
        (SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS cancellation_rate
FROM fact_bookings;

--- 4.Totalbooking
SELECT 
    COUNT(DISTINCT booking_id) AS total_bookings
FROM fact_bookings;

--- 5.utilize capacity
SELECT 
    check_in_date,
    SUM(successful_bookings) AS utilized_rooms,
    SUM(capacity) AS total_capacity,
    ROUND((SUM(successful_bookings) / SUM(capacity)) * 100, 2) AS utilization_percent
FROM fact_aggregated_bookings
GROUP BY check_in_date
ORDER BY check_in_date;

-- 6.Trend Analysis
SELECT 
    check_in_date,
    SUM(revenue_realized) AS total_revenue
FROM fact_bookings
GROUP BY check_in_date
ORDER BY check_in_date;

-- 7.weekday,weekend,revenue and booking
SELECT 
    d.day_type,
    SUM(fb.revenue_realized) AS total_revenue,
    COUNT(fb.booking_id) AS total_bookings
FROM fact_bookings fb
JOIN dim_date d 
    ON fb.check_in_date = d.date_value
GROUP BY d.day_type;

-- 8.Revenue by state&hotel
SELECT 
    h.city,
    h.property_name,
    SUM(fb.revenue_realized) AS total_revenue
FROM fact_bookings fb
JOIN dim_hotels h ON fb.property_id = h.property_id
GROUP BY h.city, h.property_name
ORDER BY total_revenue DESC;

-- 9.class wise revenue
SELECT 
    r.room_class,
    SUM(fb.revenue_realized) AS total_revenue
FROM fact_bookings fb
JOIN dim_rooms r ON fb.room_category = r.room_id
GROUP BY r.room_class
ORDER BY total_revenue DESC;

-- 10.checked out cancel no show
SELECT 
    booking_status,
    COUNT(*) AS total_bookings
FROM fact_bookings
GROUP BY booking_status;

--- 11.weekly trend key trend (revenue,total booking,occupancy)
SELECT 
    d.week_no,
    SUM(fb.revenue_realized) AS total_revenue,
    COUNT(fb.booking_id) AS total_bookings,
    ROUND((SUM(fab.successful_bookings) / SUM(fab.capacity)) * 100, 2) AS occupancy_rate
FROM fact_bookings fb
JOIN dim_date d ON fb.check_in_date = d.date_value
JOIN fact_aggregated_bookings fab 
    ON fb.property_id = fab.property_id 
   AND fb.check_in_date = fab.check_in_date
GROUP BY d.week_no
ORDER BY d.week_no;
   












