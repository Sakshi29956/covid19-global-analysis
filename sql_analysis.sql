CREATE DATABASE covid_project;

CREATE TABLE covid_data(
location TEXT,
date DATE,
total_cases FLOAT,
new_cases FLOAT,
total_deaths FLOAT,	
new_deaths FLOAT,
total_vaccinations	FLOAT,
death_rate FLOAT
);

SELECT * FROM covid_data;

-- import data

-- COPY covid_data
-- FROM 'C:\Users\ankit\Downloads\cleaned_covid_data.csv'
-- DELIMITER ','
-- CSV HEADER;

-- 1. Top Countries by Cases

SELECT location, MAX(total_cases) AS total_cases
FROM covid_data
GROUP BY location
ORDER BY total_cases DESC
LIMIT 10;


-- 2. Highest Death Rate Countries

SELECT location, MAX(death_rate) AS death_rate
FROM covid_data
GROUP BY location
ORDER BY death_rate DESC
LIMIT 10;


-- 3. India Trend

SELECT date, new_cases
FROM covid_data
WHERE location = 'India'
ORDER BY date;


-- 4. Vaccination Leaders

SELECT location, MAX(total_vaccinations) as vaccinations
FROM covid_data
GROUP BY location
ORDER BY vaccinations DESC
LIMIT 10;

-- 5. Monthly Analysis

SELECT DATE_TRUNC('month', date) as month,
SUM(new_cases) AS total_cases
FROM covid_data
GROUP BY month
ORDER BY month;

-- 6. Peak Day Per Country

SELECT location, date, new_cases
FROM covid_data c1
WHERE new_cases = (
SELECT MAX(new_cases)
FROM covid_data c2
WHERE c1.location = c2.location
);








