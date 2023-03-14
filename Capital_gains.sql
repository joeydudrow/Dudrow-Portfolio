SELECT * FROM adult_training

-- Sample Numbers per Country
SELECT COUNT(salary_range), Country
FROM adult_training
GROUP BY Country
ORDER BY COUNT(salary_range) DESC

-- Average Gains by Country
SELECT AVG(capital_gains-capital_loss) AS Avg_pay, Country
FROM adult_training
GROUP BY Country
ORDER BY Avg_pay DESC

--Total Gains by Country
SELECT SUM(capital_gains-capital_loss) AS Total_pay, Country
FROM adult_training
GROUP BY Country
ORDER BY Total_pay DESC

-- Compare Gains by Gender and Country
SELECT AVG(capital_gains-capital_loss) AS Avg_pay, Gender, Country
FROM adult_training
GROUP BY Country, Gender
ORDER BY Country

--Gains By Marital Status
SELECT AVG(capital_gains-capital_loss) AS Avg_pay, marital_status
FROM adult_training
GROUP BY marital_status
ORDER BY Avg_pay DESC

-- Gains By Education Level
SELECT AVG(capital_gains-capital_loss) AS Avg_pay, Education
FROM adult_training
GROUP BY Education
ORDER BY Avg_pay DESC

--Gains by Occupation
SELECT AVG(capital_gains-capital_loss) AS Avg_pay, Occupation
FROM adult_training
GROUP BY Occupation
ORDER BY Avg_pay DESC

-- Average Work Time by Country
SELECT AVG(hours_per_week) AS Avg_time, Country
FROM adult_training
GROUP BY Country
ORDER BY Avg_time DESC

--Number of people making under 50K by country
SELECT COUNT(Salary_range) AS num_under_50k, Country 
FROM adult_training
WHERE Salary_range = '<=50K'
GROUP BY Country 
ORDER BY COUNT(salary_range) DESC

--Number of people making over 50K by country
SELECT COUNT(Salary_range) AS num_over_50k, Country
FROM adult_training
WHERE Salary_range = '>50K'
Group BY Country
ORDER BY COUNT(salary_range) DESC
