-- =========================================================
-- Swiggy Restaurant Analysis
-- Day 1: Data Exploration
-- Database: MySQL
-- =========================================================

USE swiggy_analysis;


-- =========================================================
-- 1. Check table structure
-- =========================================================

DESCRIBE swiggy_raw;


-- =========================================================
-- 2. Preview the data
-- =========================================================

SELECT *
FROM swiggy_raw
LIMIT 10;


-- =========================================================
-- 3. Total number of records
-- =========================================================

SELECT
    COUNT(*) AS total_records
FROM swiggy_raw;


-- =========================================================
-- 4. Total unique cities
-- =========================================================

SELECT
    COUNT(DISTINCT city) AS total_cities
FROM swiggy_raw;


-- =========================================================
-- 5. Check NULL values
-- =========================================================

SELECT
    SUM(CASE WHEN restaurant_name IS NULL THEN 1 ELSE 0 END) AS null_restaurant_names,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_cities,
    SUM(CASE WHEN cuisine IS NULL THEN 1 ELSE 0 END) AS null_cuisines,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_ratings,
    SUM(CASE WHEN rating_count IS NULL THEN 1 ELSE 0 END) AS null_rating_counts,
    SUM(CASE WHEN cost IS NULL THEN 1 ELSE 0 END) AS null_costs
FROM swiggy_raw;


-- =========================================================
-- 6. Investigate rating values
-- =========================================================

SELECT
    rating,
    COUNT(*) AS total
FROM swiggy_raw
GROUP BY rating
ORDER BY total DESC;


-- =========================================================
-- 7. Investigate cost values
-- =========================================================

SELECT
    cost,
    COUNT(*) AS total
FROM swiggy_raw
GROUP BY cost
ORDER BY total DESC
LIMIT 20;


-- =========================================================
-- 8. Investigate rating_count values
-- =========================================================

SELECT  rating_count, COUNT(*) AS total
FROM swiggy_raw
GROUP BY rating_count
ORDER BY total DESC
LIMIT 20;


-- =========================================================
-- 9. Check duplicate restaurant/city combinations
-- =========================================================

SELECT
    restaurant_name,
    city,
    COUNT(*) AS duplicate_count
FROM swiggy_raw
GROUP BY restaurant_name, city
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;