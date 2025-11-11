CREATE DATABASE ENERGYDB2;
USE ENERGYDB2;

-- 1. country table
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);

SELECT * FROM COUNTRY;

-- 2. emission_3 table
CREATE TABLE emission_3 (
    country VARCHAR(100),
    energy_type VARCHAR(50),
    year INT,
    emission INT,
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM EMISSION_3;


-- 3. population table
CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (countries) REFERENCES country(Country)
);

SELECT * FROM POPULATION;

-- 4. production table
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);


SELECT * FROM PRODUCTION;

-- 5. gdp_3 table
CREATE TABLE gdp_3 (
    Country VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (Country) REFERENCES country(Country)
);

SELECT * FROM GDP_3;

-- 6. consumption table
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM CONSUMPTION;


SELECT MAX(year) AS most_recent_year
FROM emission_3;

SELECT country, SUM(emission) as total_emission
FROM emission_3
WHERE year = (SELECT MAX(year)FROM emission_3)
GROUP BY country;



select country
from gdp_3 where year = (select max(year) from gdp_3) order by year desc limit 5;


select prod.energy, prod.production, consum.consumption, prod.country, prod.year from production as prod
join consumption as consum
on prod.year=consum.year and prod.country=consum.country;




select energy_type, sum(emission) from emission_3 group by energy_type order by sum(emission) desc;


SELECT year, SUM(emission) AS global_emission FROM emission_3 GROUP BY year ORDER BY year;

SELECT country, year, Value AS gdp
FROM gdp_3
ORDER BY country, year;


SELECT
p.countries AS country,
p.year,
p.Value AS population,
SUM(e.emission) AS total_emission
FROM population p
JOIN emission_3 e ON p.countries = e.country AND p.year= e.year
GROUP BY p.countries, p.year, p.Value
ORDER BY p.countries, p.year;




SELECT country, year, SUM(consumption) AS total_consumption
FROM consumption
WHERE country IN ('United States', 'China', 'India', 'Germany', 'Japan')
GROUP BY country, year
ORDER BY country, year;


SELECT country, ROUND (AVG(per_capita_emission), 7) AS avg_yearly_per_capita_emission FROM emission_3
GROUP BY country;

SELECT
e.country,
e.year,
SUM(e.emission) / NULLIF(SUM(g.Value), 0) AS emission_to_gdp_ratio
FROM emission_3 e
JOIN gdp_3 g ON e.country = g.Country AND e.year = g.year
GROUP BY e.country, e.year;


SELECT
c.country,
c.year,
c.consumption / NULLIF(p.Value, 0) AS consumption_per_capita
FROM consumption c
JOIN population p ON c.country = p.countries AND c.year
WHERE c.year BETWEEN 2014 AND 2024
ORDER BY c.country, c.year;

SELECT
pr.country,
pr.year,
pr.production / NULLIF(p.Value, 0) AS production_per_capita
FROM production pr
JOIN population p ON pr.country = p.countries AND pr.year = p.year
ORDER BY pr.country, pr.year;


SELECT
c.country,
c.year,
round(SUM(c.consumption) / NULLIF (SUM(g.Value), 0),4) AS
consumption_to_gdp_ratio
FROM consumption c
JOIN gdp_3 g ON c.country = g. Country AND c.year = g.year
GROUP BY c.country, c.year



ORDER BY consumption_to_gdp_ratio DESC;


SELECT
p.countries AS country,
p.year,
p.Value AS population,
SUM(e.emission) AS total_emission
FROM population p
JOIN emission_3 e ON p.countries = e.country AND p.year = e.year
GROUP BY p.countries, p.year, p.Value
ORDER BY population DESC
LIMIT 10;

SELECT
e1.country,
e1.per_capita_emission AS emission_2022,
e2.per_capita_emission AS emission_2023,
(e1.per_capita_emission - e2.per_capita_emission) AS reduction
FROM emission_3 e1
JOIN emission_3 e2 ON e1.country = e2.country
WHERE e1.year = 2022 or e2.year = 2023
AND (e1.per_capita_emission - e2.per_capita_emission) > 0
ORDER BY reduction DESC LIMIT 10;

SELECT
e1.country,
e1.per_capita_emission AS emission_2022,
e2.per_capita_emission AS emission_2023,
(e1.per_capita_emission - e2.per_capita_emission) AS reduction
FROM emission_3 e1
JOIN emission_3 e2 ON e1.country = e2.country
WHERE e1.year = 2022 or e2.year = 2023
AND (e1.per_capita_emission - e2.per_capita_emission) > 0
ORDER BY reduction DESC LIMIT 10;

SELECT
country,
SUM(emission) * 100.0/ (SELECT SUM(emission) FROM emission_3) AS emission_share_percent
FROM emission_3
GROUP BY country
ORDER BY emission_share_percent
DESC;


SELECT
g.year,
AVG(g.Value) AS avg_gdp,
(SELECT AVG(emission) FROM emission_3 e WHERE e.year = g.year) AS avg_emission,
(SELECT round(AVG(Value), 3) FROM population p WHERE p.year = g.year) AS avg_population
FROM gdp_3 g
GROUP BY g.year
ORDER BY g.year;