

select * 
from layoffs;

-- 1. remove duplicates
-- 2. standardize the data
-- 3. null values or blank values
-- 4. remove any columns


create table layoffs_staging
like layoffs;


select * 
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;


select *,
row_number() over(
partition by  company, industry, total_laid_off, percentage_laid_off, 'date') as row_num
from layoffs_staging
;

with duplicate_cte as 
(
select *,
row_number() over(
partition by  company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num >1;

select * 
from layoffs_staging
where company = 'Casper'
;


with duplicate_cte as 
(
select *,
row_number() over(
partition by  company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
delete
from duplicate_cte
where row_num >1;





create table `layoffs_staging2`  (
`company` text,
`locaion` text,
`industry` text,
`total_laid_off` int DEFAULT NULL,
`percentage_laid_off` text,
`date` text,
`stage` text,
`country` text,
`funds_raised_millions` int DEFAULT NULL,
`row_num` int
) ENGINE= InnoDB DEFAULT CHARSET= utf8mb4 COLLATE = utf8mb4_0900_ai_ci;


select * 
from layoffs_staging2;

insert into layoffs_staging2
select *,
row_number() over(
partition by  company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging;



delete
from layoffs_staging2
where row_num >1;



select *
from layoffs_staging2
where row_num >1;




select *
from layoffs_staging2;




-- standardizing data

select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);


select *
from layoffs_staging2
where industry like 'crypto%';



update layoffs_staging2
set industry = 'crypto'
where industry like  'crypto%';

select distinct country , trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'united states%';

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');


select `date`
from layoffs_staging2;


alter table layoffs_staging2
modify column  `date` DATE; 



SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
and percentage_laid_off is NULL;


update layoffs_staging2
set industry= NULL 
where industry = '';


SELECT *
FROM layoffs_staging2
WHERE industry is NULL
or industry = '';


SELECT *
FROM layoffs_staging2
where company= 'Airbnb';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company= t2.company
    and t1.locaion= t2.locaion
where t1.industry is NULL 
and t2.industry is NOT NULL;

 
update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company= t2.company
set t1.industry= t2.industry
where t1.industry is NULL 
and t2.industry is NOT NULL;

SELECT *
FROM layoffs_staging2
where company like 'bally%';


SELECT *
FROM layoffs_staging2;





SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
and percentage_laid_off is NULL;


delete 
FROM layoffs_staging2
WHERE total_laid_off is NULL
and percentage_laid_off is NULL;



SELECT *
FROM layoffs_staging2;


alter table layoffs_staging2
drop column row_num;
















