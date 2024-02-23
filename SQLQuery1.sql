create database HR

select * from hr_data


select termdate
from hr_data
order by termdate desc


update hr_data
set termdate=format(CONVERT(datetime,LEFT(termdate,19),120),'yyyy-MM-dd')

alter table hr_data
add new_termdate date


update hr_data
set new_termdate = case
when termdate is not null and isdate(termdate) = 1 
then cast(termdate as datetime)
else null
end



alter table hr_data
add age nvarchar(50)


update hr_data
set age = datediff(year,birthdate,getdate())



select min(age) as youngest,max(age) as oldest
from hr_data




select age_group ,count(*) as count
from
(select 
case 
 when age <= 22 and age <=30 then '21 to 30'
 when age <=31 and age <=40 then '31 to 40'
 when age <= 41 and age <=50 then '41 to 50'
 else '50+'
 end as age_group
 from hr_data
 where new_termdate is null
 )as subquery
 group by age_group
 order by age_group

 
select age_group ,gender,count(*) as count
from
(select 
case 
 when age <= 22 and age <=30 then '21 to 30'
 when age <=31 and age <=40 then '31 to 40'
 when age <= 41 and age <=50 then '41 to 50'
 else '50+'
 end as age_group
 ,gender
 from hr_data
 where new_termdate is null
 )as subquery
 group by age_group,gender
 order by age_group,gender




select gender,count(gender) as count
from hr_data
where new_termdate is null
group by gender
order by gender



select department,gender,count(gender) as count
from hr_data
where new_termdate is null
group by department,gender 
order by department, gender





select department,jobtitle,gender,count(gender) as count
from hr_data
where new_termdate is null
group by department,jobtitle,gender 
order by department,jobtitle, gender



select race,count(*) as count
from hr_data
where new_termdate is null
group by race
order by count desc


select avg(datediff(year,hire_date,new_termdate))as tenure
from hr_data
where new_termdate is not null and new_termdate <= getdate()







select *,round((cast(terminated_count as float)/total_count ),2) *100 as turnover_rate
from
	(select 
	department,
	count(*) as total_count,
	sum(case 
	when new_termdate is not null and new_termdate <= getdate() then 1 else 0
	end) as terminated_count
	from hr_data
	group by department
	)as subquery
	order by turnover_rate desc







select department, avg(datediff(year,hire_date,new_termdate))as tenure
from hr_data
where new_termdate is not null and new_termdate <= getdate()
group by department
order by tenure desc




select  location , count(*) as count
from hr_data
where new_termdate is null
group by location





select location_state,count(*) as count
from hr_data
where new_termdate is null
group by location_state
order by count desc




select jobtitle,count(*) as count
from hr_data
where new_termdate is null
group by jobtitle
order by count desc






select *,hires-terminations as net_change,
(round(cast(hires-terminations as float)/hires,2))*100 as percent_hire_changet 
from
	(select 
	year(hire_date) as hire_year,
	count(*) as hires,
	sum(case 
	when new_termdate is not null and new_termdate <= getdate() then 1 else 0
	end) as terminations
	from hr_data
	group by year(hire_date)
	)as subquery
	order by percent_hire_changet 



 
 