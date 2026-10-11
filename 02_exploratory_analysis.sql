-- Data exploratory

Select `date`,company
from world_layoffs.layoffs_final
where `date` is null;

select * 
from world_layoffs.layoffs_final;

select max(total_laid_off), max(percentage_laid_off)
from world_layoffs.layoffs_final;

-- to filter by company having higher total laid off

select company , sum(total_laid_off) as Total_off
from world_layoffs.layoffs_final
group by company
having sum(total_laid_off) is not null
order by Total_off DESC;


-- Filtered by company who laid off more than 100 people

SELECT company, SUM(total_laid_off) as total_offf
FROM layoffs_final
GROUP BY company
having total_offf > 100
order by total_offf DESC;


-- Filtered by company who laid off more than 1000 people


SELECT company, SUM(total_laid_off) AS Total_off
FROM layoffs_final
GROUP BY company
HAVING SUM(total_laid_off) > 1000
order by total_off DESC;


-- Filter by which year higher people laid off

Select year(`date`),Sum(total_laid_off)
from world_layoffs.layoffs_final
where `date` is not null
group by year(`date`);


-- Filter by which day higher people laid off

SELECT `date`,sum(total_laid_off)
FROM world_layoffs.layoffs_final
GROUP BY `date`
order by sum(total_laid_off) DESC;

-- Filtering data for which month more people laid_off

Select substr(`date`,6,2) as `month` ,sum(total_laid_off) as Total_laid_off
from world_layoffs.layoffs_final
group by `month`
having `month` is not null
order by Total_laid_off DESC;


-- to find which  country has more no-of-people laid_off

select country , sum(total_laid_off) as Total_laid_offf
from world_layoffs.layoffs_final
group by country
order by Total_laid_offf DESC;


-- IT Looks like united states have higher Laid off
-- NOW we have check which year US have higher Laid off

with US_lay_off as
	(select year(`date`) as Years,country,sum(total_laid_off) as Totals
	from world_layoffs.layoffs_final
	group by Years,country
	Having country = "United States" AND Years is not null
	order by Totals DESC
	)
select * from US_lay_off;

-- I know in the above data CTE is not needed but i just practiced

-- The Company That Totaly Shut Down

select *
from world_layoffs.layoffs_final
where percentage_laid_off = 1
order by Total_laid_off DESC;


-- Rolling (running) total by month


WITH monthly AS (
  SELECT substr(`date`, 6,2) AS month,
         SUM(total_laid_off) AS total
  FROM world_layoffs.layoffs_final
  WHERE `date` IS NOT NULL
  GROUP BY substr(`date`, 6,2)
)
SELECT month, total,
       SUM(total) OVER (ORDER BY month) AS rolling_total
FROM monthly
ORDER BY month;


-- to find layoff every month and rolling data

WITH monthly AS (
  SELECT SUBSTRING(`date`,1,7) AS month,
         SUM(total_laid_off) AS total
  FROM world_layoffs.layoffs_final
  WHERE `date` IS NOT NULL
  GROUP BY SUBSTRING(`date`,1,7)
)
SELECT month, total,
       SUM(total) OVER (ORDER BY month) AS rolling_total
FROM monthly
ORDER BY month;

-- Top 3 companies that has highest laid off per year
WITH layoff_per_year AS (
	SELECT YEAR(`date`) AS years,
	company,
	SUM(total_laid_off) AS total_off,
	DENSE_RANK() OVER (PARTITION BY YEAR(`date`)
	ORDER BY SUM(total_laid_off) DESC) AS ranking
	FROM layoffs_final
	WHERE `date` IS NOT NULL
	AND total_laid_off IS NOT NULL
	GROUP BY YEAR(`date`), company
	)
SELECT *
FROM layoff_per_year
WHERE ranking <= 3
ORDER BY years, ranking;

-- Company That Laid off more than  once 

SELECT company, `date`, total_laid_off, total_count 
FROM (
  SELECT company, `date`, total_laid_off,
         COUNT(*) OVER (PARTITION BY company) AS total_count
  FROM world_layoffs.layoffs_final
) AS counted
WHERE total_count > 1
ORDER BY  total_count DESC;


-- filter number of layoffs and how many times of layoffs per day of week

SELECT DAYNAME(`date`) AS weekday, COUNT(*) AS LAYOFFS, SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_editing
WHERE `date` IS NOT NULL
GROUP BY DAYNAME(`date`), DAYOFWEEK(`date`)
ORDER BY DAYOFWEEK(`date`);


