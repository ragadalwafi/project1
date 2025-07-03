# EXploreing 

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

# its shows the total of layoffs employee from the large SUM 
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
order by 2 DESC;

# beging from 2020 - 2023 
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT country , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
order by 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by YEAR (`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
group by stage
ORDER BY SUM(total_laid_off) DESC;

SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


WITH Rolling_off AS 
(
SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_off
FROM Rolling_off;

SELECT country ,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country ,YEAR(`date`)
ORDER BY 3 desc;

SELECT company ,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company ,YEAR(`date`)
ORDER BY 3 desc;

WITH Company_year (Company, Years, Total_laid_off) AS 
(
SELECT company ,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company ,YEAR(`date`)
), Company_year_ranK AS 
(
SELECT *, dense_rank() OVER (PARTITION BY Years ORDER BY Total_laid_off DESC) AS RanKing 
FROM  Company_year
WHERE Years IS NOT NULL
)
SELECT *
FROM Company_year_ranK
WHERE Ranking <= 5;


