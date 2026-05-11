-- =====================================================
-- 📊 Layoffs Data Analysis Project
-- Author: Niloofar
-- Tool: SQL
-- Dataset: layoffs_staging2
-- Purpose: Analyze global layoffs trends, patterns, and insights
-- =====================================================

-- =========================
-- 1. Explore dataset
-- =========================

SELECT *
FROM layoffs_staging2;

-- Check maximum layoffs
SELECT 
    MAX(total_laid_off) AS max_layoffs,
    MAX(percentage_laid_off) AS max_percentage
FROM layoffs_staging2;

-- Companies with 100% layoffs (shutdowns)
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- =========================
-- 2. Company-level analysis
-- =========================

-- Total layoffs per company
SELECT 
    company,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC;

-- Average layoff percentage per company
SELECT 
    company,
    AVG(percentage_laid_off) AS avg_percentage_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY avg_percentage_laid_off DESC;

-- =========================
-- 3. Industry & country analysis
-- =========================

-- Layoffs by industry
SELECT 
    industry,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_layoffs DESC;

-- Layoffs by country
SELECT 
    country,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY total_layoffs DESC;

-- =========================
-- 4. Time-based analysis
-- =========================

-- Date range
SELECT 
    MIN(`date`) AS start_date,
    MAX(`date`) AS end_date
FROM layoffs_staging2;

-- Layoffs per year
SELECT 
    YEAR(`date`) AS year,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY year;

-- Monthly layoffs trend
SELECT 
    SUBSTRING(`date`,1,7) AS month,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY month
ORDER BY month;

-- Rolling total layoffs
WITH rolling_total AS (
    SELECT 
        SUBSTRING(`date`,1,7) AS month,
        SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY month
)
SELECT 
    month,
    total_off,
    SUM(total_off) OVER (ORDER BY month) AS rolling_total
FROM rolling_total;

-- =========================
-- 5. Stage analysis
-- =========================

SELECT 
    stage,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_layoffs DESC;

-- =========================
-- 6. Top companies per year
-- =========================

WITH company_year AS (
    SELECT 
        company,
        YEAR(`date`) AS years,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
company_year_rank AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY years 
               ORDER BY total_laid_off DESC
           ) AS ranking
    FROM company_year
    WHERE years IS NOT NULL
)

SELECT *
FROM company_year_rank
WHERE ranking <= 5
ORDER BY years, ranking;
