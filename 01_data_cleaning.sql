-- Data Cleaning
-- 1.Duplicate the raw Data
-- 2.Removing Dublicate
-- 3.Standardize the data
-- 4.remove the useless numm values or blank  values
-- 5.Remove useless column


select *
from world_layoffs.layoffs;

create table world_layoffs.layoffs_staging
like world_layoffs.layoffs;

SELECT *
FROM world_layoffs.layoffs_staging;

insert into layoffs_staging
select * 
from world_layoffs.layoffs;

with cte1 as
(Select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM world_layoffs.layoffs_staging)
select * from cte1
where row_num >1;

CREATE TABLE `layoffs_Editing` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
	`row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into world_layoffs.layoffs_editing
Select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM world_layoffs.layoffs_staging;


SELECT *
FROM world_layoffs.layoffs_editing;

select *
from world_layoffs.layoffs_editing
where row_num > 1;

DELETE from world_layoffs.layoffs_editing
where row_num > 1;

SELECT *
FROM world_layoffs.layoffs_editing;

SELECT distinct (company)
from world_layoffs.layoffs_editing
order by 1;

Select company, TRIM(company)
from world_layoffs.layoffs_editing;

update world_layoffs.layoffs_editing
set company = TRIM(company);

SELECT *
FROM world_layoffs.layoffs_editing;

SELECT distinct(location)
from world_layoffs.layoffs_editing
order by 1;

SELECT DISTINCT location
FROM world_layoffs.layoffs_editing
WHERE location LIKE BINARY '%Ã%'
ORDER BY location;

SELECT location,
       CONVERT(CAST(CONVERT(location USING latin1) AS BINARY) USING utf8mb4) AS fixed_location
FROM world_layoffs.layoffs_editing
WHERE location LIKE BINARY '%Ã%';

UPDATE world_layoffs.layoffs_editing
SET location = CONVERT(CAST(CONVERT(location USING latin1) AS BINARY) USING utf8mb4)
WHERE location LIKE BINARY '%Ã%';



select industry
from world_layoffs.layoffs_editing
where industry like 'Crypto%';

Update world_layoffs.layoffs_editing
SET industry = 'Crypto'
where industry like 'Crypto%';


SET SQL_SAFE_UPDATES = 1;


select *
from world_layoffs.layoffs_editing;

select `date`,
str_to_date(`date`, '%m/%d/%Y') as DATE
From layoffs_editing;

Update world_layoffs.layoffs_editing
Set Date = str_to_date(`date` , '%m/%d/%Y');


SET SQL_SAFE_UPDATES = 0;

Update world_layoffs.layoffs_editing
Set Date = str_to_date(`date` , '%m/%d/%Y');

select `date`,
str_to_date(`date`, '%m/%d/%Y') as DATE
From layoffs_editing;

ALTER TABLE world_layoffs.layoffs_editing
Modify COLUMN `date` date;

select *
from world_layoffs.layoffs_editing;


select  industry
from world_layoffs.layoffs_editing
order by industry;

Update world_layoffs.layoffs_editing
SET industry = null
where industry = '';

select  industry
from world_layoffs.layoffs_editing
order by industry;

select *
from world_layoffs.layoffs_editing as T1
join world_layoffs.layoffs_editing as t2
	ON T1.company = t2.company
    where T1.industry is null
    AND t2.industry is not null
union
select *
from world_layoffs.layoffs_editing as T1
join world_layoffs.layoffs_editing as t2
	ON T1.company = t2.company
    where T1.industry is not null
    AND t2.industry is null;
    
Update layoffs_editing as T1
join layoffs_editing as T2
	on t1.company = t2.company
set T1.industry = T2.industry
where T1.industry is null
and T2.industry is not null;
    

select *
from world_layoffs.layoffs_editing;

select *
from world_layoffs.layoffs_editing
where company = 'Airbnb';

select  company , industry , location ,country
from world_layoffs.layoffs_editing
order by company;


CREATE TABLE `layoffs_final` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date DEFAULT NULL,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_final
select * from world_layoffs.layoffs_editing;


select * 
from world_layoffs.layoffs_final;

select *
from world_layoffs.layoffs_final
where total_laid_off is null
and percentage_laid_off is null;

DELETE
from world_layoffs.layoffs_final
where total_laid_off is null
and percentage_laid_off is null;

ALTER TABLE world_layoffs.layoffs_final
DROP column row_num;

select *
from world_layoffs.layoffs_final;

