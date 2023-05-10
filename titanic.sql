drop view additional_person_info

--question 1
create view additional_person_info as
select 
states.us_state_terr,
employment_categories.category_description,
education_codes.education_level_achieved,
person_economic_info.*
from person_economic_info 
join states on person_economic_info.address_state=states.numeric_id
join education_codes on person_economic_info.education=education_codes.code
join employment_categories on person_economic_info.employment_category=employment_categories.employment_category

select* from additional_person_info

--question 2
select * from 
(
select us_state_terr, sum(own_computer) as number_of_people_who_own_computer
from additional_person_info 
group by us_state_terr)ss
where number_of_people_who_own_computer = 0 

--question 3
select us_state_terr, education_level_achieved, 
count(us_state_terr) as number_of_people_reported
from additional_person_info 
group by cube(us_state_terr, education_level_achieved)
order by us_state_terr, education_level_achieved

--question 4
select us_state_terr, sum(own_computer),
RANK() OVER (ORDER BY SUM(own_computer) desc) as rank_own_computer
from additional_person_info
group by us_state_terr
order by rank_own_computer

--question 5
select *, 
cast(number_of_people_who_use_the_internet * 100 as decimal)/ cast(number_of_people_who_own_a_personal_computer as decimal) as percentage_of_people_who_have_a_dedicated_internet_connection
from(
select us_state_terr, 
count(us_state_terr) as number_of_people_reported,
sum(case when internet !=0 then 1 else 0end) as number_of_people_who_use_the_internet,
sum(case when own_computer != 0 then 1 else 0 end) as number_of_people_who_own_a_personal_computer,
cast(max(income) as money) as highest_income,
cast(avg(income) as money) as average_income
from additional_person_info
group by us_state_terr
order by us_state_terr) ss
where number_of_people_who_own_a_personal_computer >= 1





--question 6
select *, 
cast(number_of_people_who_use_the_internet * 100 as decimal)/ cast(number_of_people_who_own_a_personal_computer as decimal) as percentage_of_people_who_have_a_dedicated_internet_connection
from(
select us_state_terr, education_level_achieved,
count(us_state_terr) as number_of_people_reported,
sum(case when internet !=0 then 1 else 0end) as number_of_people_who_use_the_internet,
sum(case when own_computer != 0 then 1 else 0 end) as number_of_people_who_own_a_personal_computer,
cast(max(income) as money) as highest_income,
cast(avg(income) as money) as average_income
from additional_person_info
group by us_state_terr, education_level_achieved
order by us_state_terr, education_level_achieved) ss
where number_of_people_who_own_a_personal_computer >= 1



-- question 7
select
us_state_terr,category_description,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY income) as MedianIncome,
LEAD(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY income)) OVER (PARTITION BY us_state_terr ORDER BY category_description desc) as NextMedianIncome,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY car_price) as MedianCarPrice,
LAG(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY car_price)) OVER (PARTITION BY us_state_terr ORDER BY category_description desc) as PreviousMedianCarPrice
from additional_person_info
group by us_state_terr, category_description

