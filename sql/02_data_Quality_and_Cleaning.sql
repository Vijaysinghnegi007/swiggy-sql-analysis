-- Swiggy Restaurant Analysis
-- Day 2: Data Quality & Cleaning 
-- Database: MySQL

USE swiggy_analysis;

-- 1. Get familiar with the data

DESCRIBE swiggy_raw;

SELECT *
FROM swiggy_raw
LIMIT 10;

-- 2. How much data are we working with?

SELECT COUNT(*) AS total_records
FROM swiggy_raw;

-- See how many different restaurants and cities we have

SELECT
    COUNT(DISTINCT restaurant_name) AS unique_restaurants,
    COUNT(DISTINCT city) AS unique_cities
FROM swiggy_raw;

-- 3. Check for missing values

SELECT
    COUNT(*) AS total_records,
    COUNT(restaurant_name) AS restaurants_with_name,
    COUNT(city) AS records_with_city,
    COUNT(rating) AS records_with_rating
FROM swiggy_raw;

-- Find restaurants where important information is missing

SELECT *
FROM swiggy_raw
WHERE restaurant_name IS NULL
   OR city IS NULL
   OR rating IS NULL;

-- Count restaurants that don't have a rating

SELECT COUNT(*) AS missing_ratings
FROM swiggy_raw
WHERE rating IS NULL;

-- 4. Look at the rating data

SELECT
    MIN(rating) AS lowest_rating,
    MAX(rating) AS highest_rating
FROM swiggy_raw;

-- Ratings should normally stay within the 0 to 5 range.
-- Anything outside that range needs a closer look.

SELECT *
FROM swiggy_raw
WHERE rating < 0
   OR rating > 5;

-- How are the ratings distributed?

SELECT
    rating,
    COUNT(*) AS restaurant_count
FROM swiggy_raw
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY rating DESC;

-- 5. Check restaurant names

-- See whether the same restaurant name appears multiple times

SELECT
    restaurant_name,
    COUNT(*) AS total_records
FROM swiggy_raw
GROUP BY restaurant_name
HAVING COUNT(*) > 1
ORDER BY total_records DESC;

-- A repeated name isn't necessarily a duplicate.
-- Let's check the restaurant together with its city.

SELECT
    restaurant_name,
    city,
    COUNT(*) AS total_records
FROM swiggy_raw
GROUP BY restaurant_name, city
HAVING COUNT(*) > 1
ORDER BY total_records DESC;

-- 6. Check the city names

SELECT DISTINCT city
FROM swiggy_raw
ORDER BY city;

-- Remove accidental spaces and check again

SELECT DISTINCT
    TRIM(city) AS city
FROM swiggy_raw
ORDER BY city;

-- Convert everything to lowercase to spot
-- values that only differ because of capitalization.

SELECT DISTINCT
    LOWER(TRIM(city)) AS city
FROM swiggy_raw
ORDER BY city;

-- 7. Look at the most common cities

SELECT
    city,
    COUNT(*) AS restaurant_count
FROM swiggy_raw
GROUP BY city
ORDER BY restaurant_count DESC;

-- 8. Find restaurants with unusual names

-- Empty strings are different from NULL,
-- so check for them separately.

SELECT *
FROM swiggy_raw
WHERE restaurant_name = '';

-- Check for names that contain only spaces

SELECT *
FROM swiggy_raw
WHERE TRIM(restaurant_name) = '';

-- 9. Check the rating column more carefully

-- How many restaurants have each rating?

SELECT
    rating,
    COUNT(*) AS restaurant_count
FROM swiggy_raw
GROUP BY rating
ORDER BY rating DESC;

-- Find restaurants with no rating

SELECT
    restaurant_name,
    city
FROM swiggy_raw
WHERE rating IS NULL;

-- Find highly rated restaurants

SELECT
    restaurant_name,
    city,
    rating
FROM swiggy_raw
WHERE rating >= 4.5
ORDER BY rating DESC;

-- 10. Create useful rating groups

SELECT
    restaurant_name,
    rating,
    CASE
        WHEN rating IS NULL THEN 'Not Rated'
        WHEN rating >= 4.5 THEN 'Excellent'
        WHEN rating >= 4.0 THEN 'Good'
        WHEN rating >= 3.0 THEN 'Average'
        ELSE 'Poor'
    END AS rating_category
FROM swiggy_raw;

-- Now count how many restaurants fall into each group

SELECT
    CASE
        WHEN rating IS NULL THEN 'Not Rated'
        WHEN rating >= 4.5 THEN 'Excellent'
        WHEN rating >= 4.0 THEN 'Good'
        WHEN rating >= 3.0 THEN 'Average'
        ELSE 'Poor'
    END AS rating_category,
    COUNT(*) AS restaurant_count
FROM swiggy_raw
GROUP BY rating_category
ORDER BY restaurant_count DESC;

-- 11. Find possible duplicate records

SELECT
    restaurant_name,
    city,
    rating,
    COUNT(*) AS duplicate_count
FROM swiggy_raw
GROUP BY
    restaurant_name,
    city,
    rating
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 12. Check price-related data
-- Run these only if your table contains a price column.

SELECT
    MIN(price) AS lowest_price,
    MAX(price) AS highest_price,
    AVG(price) AS average_price
FROM swiggy_raw;

-- Look for impossible negative prices

SELECT *
FROM swiggy_raw
WHERE price < 0;

-- 13. Look for unusual price values

SELECT
    price,
    COUNT(*) AS restaurant_count
FROM swiggy_raw
GROUP BY price
ORDER BY price;

-- 14. Basic restaurant analysis

-- Which cities have the most restaurants?

SELECT
    city,
    COUNT(*) AS restaurant_count
FROM swiggy_raw
GROUP BY city
ORDER BY restaurant_count DESC;

-- Which cities have the highest average rating?
-- We need to ignore restaurants that don't have a rating.

SELECT
    city,
    ROUND(AVG(rating), 2) AS average_rating
FROM swiggy_raw
WHERE rating IS NOT NULL
GROUP BY city
ORDER BY average_rating DESC;

-- 15. Find cities with enough restaurants to be useful

SELECT
    city,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(rating), 2) AS average_rating
FROM swiggy_raw
WHERE rating IS NOT NULL
GROUP BY city
HAVING COUNT(*) >= 10
ORDER BY average_rating DESC;

-- 16. Compare rated vs unrated restaurants

SELECT
    CASE
        WHEN rating IS NULL THEN 'Not Rated'
        ELSE 'Rated'
    END AS rating_status,
    COUNT(*) AS restaurant_count
FROM swiggy_raw
GROUP BY rating_status;

-- 17. Calculate the percentage of missing ratings

SELECT
    COUNT(*) AS total_records,
    COUNT(rating) AS rated_records,
    COUNT(*) - COUNT(rating) AS missing_ratings,

    ROUND(
        (COUNT(*) - COUNT(rating)) * 100.0 / COUNT(*),
        2
    ) AS missing_rating_percentage

FROM swiggy_raw;

-- 18. Final data quality summary

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT restaurant_name) AS unique_restaurants,
    COUNT(DISTINCT city) AS unique_cities,
    COUNT(rating) AS rated_restaurants,
    COUNT(*) - COUNT(rating) AS missing_ratings,
    COUNT(DISTINCT restaurant_name) AS restaurant_names

FROM swiggy_raw;

-- Day 2 notes
--
-- At this point we have checked:
--
-- - Total records
-- - Missing values
-- - Unique restaurants
-- - Unique cities
-- - Duplicate-looking records
-- - Rating range
-- - Rating distribution
-- - City consistency
-- - Empty values
-- - Price values
-- - Rating categories
-- - Basic city-level statistics
--
-- We haven't changed the raw table.
-- The next step is to decide what actually needs
-- to be cleaned before doing the main analysis.
