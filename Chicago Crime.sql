Use ChicagoCrime

-- Chapter 1: Overall Crime Frequence by Date
-- By Date

SELECT CONVERT(date, date) AS Date,
       COUNT(*) AS CrimeFreq
FROM crimes
GROUP BY CONVERT(date, date)
ORDER BY CrimeFreq DESC


-- By Year
SELECT DATEPART(yy, date) AS Year,
       COUNT(*) AS CrimeFreq
FROM crimes
GROUP BY DATEPART(yy, date)
ORDER BY CrimeFreq DESC

-- By Month
SELECT DATEPART(mm, date) AS Month,
       COUNT(*) AS CrimeFreq
FROM crimes
GROUP BY DATEPART(mm, date)
ORDER BY CrimeFreq DESC

-- By day
SELECT DATEPART(dd, date) AS Day,
       COUNT(*) AS CrimeFreq
FROM crimes
GROUP BY DATEPART(dd, date)
ORDER BY CrimeFreq DESC

SELECT *
FROM crimes
WHERE DATEPART(yy, date) = 2012
      AND DATEPART(mm, date) = 07


-- Chapter 2: Demographic of the neighborhood
-- Racial
SELECT w.ward,
       COUNT(c.id) AS Num_of_Crime,
       FORMAT(AVG(percentWhite), 'P2') AS White,
       FORMAT(AVG(percentBlack), 'P2') AS Black,
       FORMAT(AVG(percentAsian), 'P2') AS Asian,
       FORMAT(AVG(percentHispanic), 'P2') AS Hispanic
FROM wards w
INNER JOIN crimes c
ON w.ward = c.ward
GROUP BY w.ward
ORDER BY COUNT(c.id) DESC

SELECT c.district,
       c.ward,
       COUNT(c.id) AS Num_of_Crime,
       FORMAT(AVG(percentWhite), 'P2') AS White,
       FORMAT(AVG(percentBlack), 'P2') AS Black,
       FORMAT(AVG(percentAsian), 'P2') AS Asian,
       FORMAT(AVG(percentHispanic), 'P2') AS Hispanic
FROM wards w
INNER JOIN crimes c
ON w.ward = c.ward
GROUP BY ROLLUP(c.district, c.ward)
ORDER BY c.district, c.ward DESC

-- Income
SELECT w.ward,
       COUNT(c.id) AS Num_of_Crime,
       FORMAT(AVG(percentIncomeUnder25K), 'P2') AS IncomeUnder25K,
       FORMAT(AVG(percentIncome25_50K), 'P2') AS Income25_50K,
       FORMAT(AVG(percentIncome50_100K), 'P2') AS Income50_100K,
       FORMAT(AVG(percentIncome100_150K), 'P2') AS Income100_150K,
       FORMAT(AVG(percentIncomeOver150K), 'P2') AS IncomeOver150K
FROM wards w
INNER JOIN crimes c
ON w.ward = c.ward
GROUP BY w.ward
ORDER BY COUNT(c.id) DESC

SELECT c.district,
       COUNT(c.id) AS Num_of_Crime,
       FORMAT(AVG(percentIncomeUnder25K), 'P2') AS IncomeUnder25K,
       FORMAT(AVG(percentIncome25_50K), 'P2') AS Income25_50K,
       FORMAT(AVG(percentIncome50_100K), 'P2') AS Income50_100K,
       FORMAT(AVG(percentIncome100_150K), 'P2') AS Income100_150K,
       FORMAT(AVG(percentIncomeOver150K), 'P2') AS IncomeOver150K
FROM wards w
INNER JOIN crimes c
ON w.ward = c.ward
GROUP BY c.district
ORDER BY COUNT(c.id) DESC

-- IUCR
SELECT *
FROM IUCR