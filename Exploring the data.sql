# explore data


select * from layoffs_staging2
;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2
;

# 1 in max percentage indicates 100% of the company was laid off

select * from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc
;

select * from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc
;


select company , SUM(total_laid_off),`date`
from layoffs_staging2
group by company,`date`
order by SUM(total_laid_off) desc
;


select min(`date`),max(`date`)
from layoffs_staging2
;


select industry , SUM(total_laid_off),`date`
from layoffs_staging2
group by industry,`date`
order by 2 desc 
;

select * from 
layoffs_staging2
;

select year(`date`) , SUM(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc
;


select stage, SUM(total_laid_off) 
from layoffs_staging2
group by stage
order by stage desc
;


select * from layoffs_staging2
;

select substring(`date`,1,7) as `Month`,sum(total_laid_off) 
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1
;


with Rolling_total_cte as
(
select substring(`date`,1,7) as `Month`,sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1
)
select `Month`,total_off, sum(total_off) over(order by `Month`) as rolling_total
from Rolling_total_cte
;


with null_cte as
(
select company , sum(total_laid_off) as total_poff
from layoffs_staging2
group by company
)
select * from
null_cte 
where total_poff is not null
;


select company, sum(total_laid_off) as total_poff
from layoffs_staging2
group by company
having sum(total_laid_off) is not null;


select company ,Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,Year(`date`)
order by 3 desc
;


#---renaming
with company_year (Company,Years,Total_Laid_Off)  as 
(
select company ,Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,Year(`date`)
), company_year_rank as
(
select *, dense_rank() over(partition by Years order by Total_Laid_Off desc) as Ranking
from company_year
where Years is not null
 )
 select * from
 company_year_rank
 where Ranking <= 5
;


SELECT stage, ROUND(AVG(percentage_laid_off),2)

FROM layoffs_staging2

GROUP BY stage

ORDER BY 2 DESC;




