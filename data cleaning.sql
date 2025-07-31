# data cleaning

###### standarzied 108
###### NULLS 172

# 1--remove dups
# 2--standardize data --- trim , str_to_date
# 3--Null values/blank values
# 4--Remove any colums

# FIRST DUPLICATE THE DATA TO EVADE ANY ERRORS 
create table layoffs_staging
like layoffs;

insert layoffs_staging
select * from layoffs
;
# CODE END -------------------


select *
from layoffs_staging
;

select *,
row_number () over(partition by company,industry,total_laid_off,percentage_laid_off,`date`) as row_num
from layoffs_staging;

with duplicate_cte as 
(
select *,
row_number () over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
select * from duplicate_cte
where row_num > 1
;

select * from
layoffs_staging
where company = 'Cazoo'
;

with duplicate_cte as 
(
select *,
row_number () over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
select * from duplicate_cte
where row_num > 1
;

#Create another table to remove dups
create table layoffs_staging2
like layoffs_staging
;

insert layoffs_staging2
select * from layoffs_staging
;
#Create another table to remove dups

# how to add a new colum
ALTER TABLE layoffs_staging2
ADD COLUMN `row_num` INT;
# how to add a new colum

with duplicate_cte2 as 
(
select *,
row_number () over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging2
)
select * from duplicate_cte2
where row_num > 1
;
select * from layoffs_staging2
;

insert into layoffs_staging2
select *,
row_number () over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging;
#--------------------------------------------------------------

CREATE TABLE `layoffs_staging2` (
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


insert into layoffs_staging2
select *,
row_number () over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging;

select * from layoffs_staging2
where row_num > 1
;
delete from layoffs_staging2
where row_num > 1
;

###### standarzied
select * from
layoffs_staging2
;
select company, trim(company)
from layoffs_staging2
;

update layoffs_staging2
set company= trim(company);

select distinct industry
 from layoffs_staging2
 order by 1;
 
 select * from layoffs_staging2
 where industry like 'crypto%'
 ;
 
 update layoffs_staging2
 set industry = 'Crypto'
 where industry like 'crypto%'
 ;
 
  select * from layoffs_staging2
 where industry like 'crypto%'
 ;
 
 select distinct country 
 from layoffs_staging2
 ;
 
 select distinct trim(country)
 from layoffs_staging2
 order by 1
 ;
 
 update layoffs_staging2
 set country = trim(trailing '.' from country)
 where country like 'United States%'
 ;
 
 
 select `date`,
 str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2
;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y')
;

select *
from layoffs_staging2
;

alter table layoffs_staging2
modify column `date` date
;

# NULLS


select * from layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

select  *
from layoffs_staging2
where industry IS null 
OR industry = ''
;

select * from layoffs_staging2
where company like 'Bally%'
;

select t1.industry,t2.industry from layoffs_staging2 t1
JOIN layoffs_staging2 t2
on t1.company = t2.company
AND t1.location = t2.location
where t1.industry is NULL
AND t2.industry is NOT null
;

update layoffs_staging2
set industry = null 
where industry = ''
;

update layoffs_staging2 t1
JOIN layoffs_staging2 t2
on t1.company = t2.company
AND t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is NULL
AND t2.industry is NOT null
;

#remove columns and rows

select * from layoffs_staging2
where total_laid_off IS null
and percentage_laid_off is null
;


Delete  from layoffs_staging2
where total_laid_off IS null
and percentage_laid_off is null
;

select * from layoffs_staging2
;

alter table layoffs_staging2
drop column row_num
;


select * from layoffs_staging2
order by company 
;
