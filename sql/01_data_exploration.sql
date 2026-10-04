-- Swiggy Restaurant Analysis
-- Day 1: Getting familiar with the data
-- Database: MySQL

USE swiggy_analysis;


-- 1. First, let's see what columns and data types we have
DESCRIBE swiggy_raw;


-- 2. Take a quick look at the actual restaurant data
-- This helps us understand what the values look like before cleaning anything
SELECT *
FROM swiggy_raw
LIMIT 10;


-- 3. Find out how many restaurant records are in the dataset
SELECT
    COUNT(*) AS total_records
FROM swiggy_raw;


-- 4. Find out how many different cities are in the dataset
SELECT
    COUNT(DISTINCT city) AS total_cities
FROM swiggy_raw;


-- 5. Check which important columns have missing values
-- We are checking this before cleaning the data
SELECT
    SUM(CASE WHEN restaurant_name IS NULL THEN 1 ELSE 0 END) AS null_restaurant_names,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_cities,
    SUM(CASE WHEN cuisine IS NULL THEN 1 ELSE 0 END) AS null_cuisines,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_ratings,
    SUM(CASE WHEN rating_count IS NULL THEN 1 ELSE 0 END) AS null_rating_counts,
    SUM(CASE WHEN cost IS NULL THEN 1 ELSE 0 END) AS null_costs
FROM swiggy_raw;


-- 6. Check all the different rating values
-- We want to find values like 'NEW' or '--' before working with ratings
SELECT
    rating,
    COUNT(*) AS total
FROM swiggy_raw
GROUP BY rating
ORDER BY total DESC;


-- 7. Check how the cost values are stored
-- This helps us see if values contain commas or other characters
SELECT
    cost,
    COUNT(*) AS total
FROM swiggy_raw
GROUP BY cost
ORDER BY total DESC
LIMIT 20;


-- 8. Check how rating counts are stored
-- We need to know whether values contain '+' or ',' before converting them to numbers
SELECT
    rating_count,
    COUNT(*) AS total
FROM swiggy_raw
GROUP BY rating_count
ORDER BY total DESC
LIMIT 20;


-- 9. Check whether the same restaurant appears more than once in a city
-- We are only investigating duplicates here, not deleting anything yet
SELECT
    restaurant_name,
    city,
    COUNT(*) AS duplicate_count
FROM swiggy_raw
GROUP BY restaurant_name, city
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;