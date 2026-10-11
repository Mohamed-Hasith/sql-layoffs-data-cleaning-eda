# Layoffs Data Cleaning & Exploratory Analysis (MySQL)

## Overview
Cleaned and analyzed a global layoffs dataset using MySQL.

## Tools
MySQL, Window Functions, CTEs, Self Joins

## Data Cleaning Steps
1. Created a staging table to preserve the raw data
2. Removed duplicates using ROW_NUMBER()
3. Standardized text, industry labels and dates
4. Repaired character-encoding errors in location names
5. Filled missing industry values using self joins
6. Removed rows with no layoff figures

## Questions Explored
- Which companies had the most layoffs?
- Which countries were hit hardest?
- How did layoffs change by year and month?
- Who were the top 3 companies per year?
- Which companies shut down completely?

## Key Findings
- Country Most affected - United States - 254874(Total Laid Offs)
- Which month most Peoples Laid off - January - 92037(Total Laid Offs)
- How Many Company Totaly Shut down - 116

## Files
- 01_data_cleaning.sql
- 02_exploratory_analysis.sql
