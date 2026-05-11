-- =====================================================
-- DATA CLEANING PROJECT (LAYOFFS DATASET)
-- Author: Niloofar
-- Purpose: Clean raw layoffs dataset for analysis
-- =====================================================

-- 1. Create staging table
CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- 2. Remove duplicates using row number
WITH duplicate_cte AS (
    SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off,
                     percentage_laid_off, date, stage, country,
                     funds_raised_millions
    ) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- NOTE: In real workflow, duplicates would be removed from a staging table after identification

-- 3. Standardize data

-- Trim company names
UPDATE layoffs_staging
SET company = TRIM(company);

-- Standardize industry values
UPDATE layoffs_staging
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

-- Clean country names
UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country);

-- Convert date column to proper DATE format
UPDATE layoffs_staging
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_staging
MODIFY COLUMN date DATE;

-- 4. Handle missing values

-- Convert blank industry values to NULL
UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

-- Fill missing industry using existing company data
UPDATE layoffs_staging t1
JOIN layoffs_staging t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- 5. Remove rows with no useful data
DELETE FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 6. Drop helper columns (if exist)
-- (Only if row_num exists in your table)
-- ALTER TABLE layoffs_staging DROP COLUMN row_num;
