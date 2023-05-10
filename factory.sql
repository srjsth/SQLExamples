select count(*), 'Suraaj Shrestha' AS Name, CURRENT_DATE AS Date from manufacture_fact 



select factory_dim.factory_label, sum(manufacture_fact.qty_passed) as Total_Units_produced, sum(manufacture_fact.qty_failed) as Total_Units_failed 
from manufacture_fact 
join factory_dim 
ON manufacture_fact.factory_key = factory_dim.factory_key
group by(factory_dim.factory_key)

select calendar_manufacture_dim.manufacture_year
from manufacture_fact 
join calendar_manufacture_dim 
ON calendar_manufacture_dim.manufacture_cal_key = manufacture_fact.manufacture_cal_key
group by(calendar_manufacture_dim.manufacture_year)



select py.* from(
select calendar_manufacture_dim.manufacture_year, 
factory_dim.factory_label, 
sum(manufacture_fact.qty_passed) as Total_Units_produced, 
sum(manufacture_fact.qty_failed) as Total_Units_failed,
RANK() OVER (PARTITION BY (calendar_manufacture_dim.manufacture_year, 4) ORDER BY sum(manufacture_fact.qty_passed) DESC) AS Factory_name_rank 
from manufacture_fact 
join calendar_manufacture_dim 
ON calendar_manufacture_dim.manufacture_cal_key = manufacture_fact.manufacture_cal_key
join factory_dim 
ON manufacture_fact.factory_key = factory_dim.factory_key
group by(calendar_manufacture_dim.manufacture_year, factory_dim.factory_key)
order by(calendar_manufacture_dim.manufacture_year, sum(manufacture_fact.qty_passed)) desc   
) as py where py.Factory_name_rank <=3




WITH topthree AS (
select factory_dim.factory_label,
CASE  
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202201' THEN '01-January'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202202' THEN '02-February'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202203' THEN '03-March'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202204' THEN '04-April'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202205' THEN '05-May'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202206' THEN '06-June'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202207' THEN '07-July'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202208' THEN '08-August'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202209' THEN '09-September'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202210' THEN '10-October'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202211' THEN '11-November'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202212' THEN '12-December'
	ELSE 'NOT MATCHED'
END AS Month,
manufacture_fact.qty_passed,
 ROW_NUMBER() 
    over (
        PARTITION BY (factory_dim.factory_label,calendar_manufacture_dim.manufacture_yearmonth)
        order by (manufacture_fact.qty_passed)DESC
    ) AS RowNo
from manufacture_fact 
join factory_dim 
ON manufacture_fact.factory_key = factory_dim.factory_key
join calendar_manufacture_dim 
ON calendar_manufacture_dim.manufacture_cal_key = manufacture_fact.manufacture_cal_key
WHERE calendar_manufacture_dim.manufacture_year = 'mY2022'
group by(factory_dim.factory_label, calendar_manufacture_dim.manufacture_yearmonth), ROLLUP (manufacture_fact.qty_passed)
order by(factory_dim.factory_label,calendar_manufacture_dim.manufacture_yearmonth,manufacture_fact.qty_passed) desc)
SELECT * FROM topthree WHERE RowNo <= 3






select factory_dim.factory_label,
CASE
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202201' THEN '01-January'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202202' THEN '02-February'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202203' THEN '03-March'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202204' THEN '04-April'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202205' THEN '05-May'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202206' THEN '06-June'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202207' THEN '07-July'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202208' THEN '08-August'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202209' THEN '09-September'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202210' THEN '10-October'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202211' THEN '11-November'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202212' THEN '12-December'
	ELSE 'SUB-TOTAL'
END AS Month,
sum(manufacture_fact.qty_passed) as Total_Units_produced, 
sum(manufacture_fact.qty_failed) as Total_Units_failed
from manufacture_fact 
join factory_dim 
ON manufacture_fact.factory_key = factory_dim.factory_key
join calendar_manufacture_dim 
ON calendar_manufacture_dim.manufacture_cal_key = manufacture_fact.manufacture_cal_key
WHERE calendar_manufacture_dim.manufacture_year = 'mY2022'
group by ROLLUP (factory_dim.factory_label, calendar_manufacture_dim.manufacture_yearmonth) 
order by(factory_dim.factory_label,calendar_manufacture_dim.manufacture_yearmonth)







select factory_dim.factory_label,
CASE
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202201' THEN '01-January'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202202' THEN '02-February'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202203' THEN '03-March'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202204' THEN '04-April'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202205' THEN '05-May'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202206' THEN '06-June'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202207' THEN '07-July'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202208' THEN '08-August'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202209' THEN '09-September'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202210' THEN '10-October'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202211' THEN '11-November'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202212' THEN '12-December'
	ELSE 'SUB-TOTAL'
END AS Month,
sum(manufacture_fact.qty_passed) as Total_Units_produced, 
sum(manufacture_fact.qty_failed) as Total_Units_failed
from manufacture_fact 
join factory_dim 
ON manufacture_fact.factory_key = factory_dim.factory_key
join calendar_manufacture_dim 
ON calendar_manufacture_dim.manufacture_cal_key = manufacture_fact.manufacture_cal_key
WHERE calendar_manufacture_dim.manufacture_year = 'mY2022'
group by ROLLUP (factory_dim.factory_label, calendar_manufacture_dim.manufacture_yearmonth) 
order by(factory_dim.factory_label,calendar_manufacture_dim.manufacture_yearmonth) 




select * from calendar_manufacture_dim

$$select  py.year, py.factory_name, py.quantity_passed from(
select CASE
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2022' THEN 2022
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2021' THEN 2021
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2020' THEN 2020
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2019' THEN 2019
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2018' THEN 2018
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2017' THEN 2017
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2016' THEN 2016
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2015' THEN 2015
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2014' THEN 2014
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2013' THEN 2013
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2012' THEN 2012
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2011' THEN 2011
END AS Year, 
factory_dim.factory_label as factory_name, 
sum(manufacture_fact.qty_passed) as quantity_passed, 
RANK() OVER (PARTITION BY (calendar_manufacture_dim.manufacture_year, 4) ORDER BY sum(manufacture_fact.qty_passed) DESC) AS Factory_name_rank 
from manufacture_fact 
join calendar_manufacture_dim 
ON calendar_manufacture_dim.manufacture_cal_key = manufacture_fact.manufacture_cal_key
join factory_dim 
ON manufacture_fact.factory_key = factory_dim.factory_key
where calendar_manufacture_dim.manufacture_monthofyear = 'mMO02'
group by(calendar_manufacture_dim.manufacture_year, factory_dim.factory_key)
order by(calendar_manufacture_dim.manufacture_year, sum(manufacture_fact.qty_passed)) desc   
) as py where py.Factory_name_rank <=3 AND py.Year > 2022 - 5 $$)



drop table pivotcrosstable

create table pivotcrosstable as
select  py.year, py.factory_name, py.quantity_passed from(
select CASE
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2022' THEN 2022
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2021' THEN 2021
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2020' THEN 2020
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2019' THEN 2019
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2018' THEN 2018
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2017' THEN 2017
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2016' THEN 2016
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2015' THEN 2015
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2014' THEN 2014
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2013' THEN 2013
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2012' THEN 2012
    WHEN calendar_manufacture_dim.manufacture_year = 'mY2011' THEN 2011
END AS Year, 
factory_dim.factory_label as factory_name, 
sum(manufacture_fact.qty_passed) as quantity_passed
from manufacture_fact 
join calendar_manufacture_dim 
ON calendar_manufacture_dim.manufacture_cal_key = manufacture_fact.manufacture_cal_key
join factory_dim 
ON manufacture_fact.factory_key = factory_dim.factory_key
where calendar_manufacture_dim.manufacture_monthofyear = 'mMO02'
group by(calendar_manufacture_dim.manufacture_year, factory_dim.factory_key)
order by(calendar_manufacture_dim.manufacture_year, sum(manufacture_fact.qty_passed)) desc   
) as py where py.year > 2022 - 5

select * from crosstab(
$$ select factory_name::TEXT, year, sum(quantity_passed)::integer from pivotcrosstable group by 1,2 order by 1,2$$,
$$ select distinct year from pivotcrosstable order by 1 desc $$)
	AS ct
(factory_name text, "2022"  integer, "2021" integer, "2020" integer, "2019" integer, "2018" integer);









select factory_dim.factory_label,
CASE
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202201' THEN '01-January'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202202' THEN '02-February'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202203' THEN '03-March'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202204' THEN '04-April'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202205' THEN '05-May'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202206' THEN '06-June'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202207' THEN '07-July'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202208' THEN '08-August'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202209' THEN '09-September'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202210' THEN '10-October'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202211' THEN '11-November'
    WHEN calendar_manufacture_dim.manufacture_yearmonth = 'mYM202212' THEN '12-December'
	ELSE 'SUB-TOTAL'
END AS Month,
prod_dim.Brand_label AS Brand_name,
sum(manufacture_fact.qty_passed) as Total_Units_produced, 
sum(manufacture_fact.qty_failed) as Total_Units_failed
from manufacture_fact 
join factory_dim 
ON manufacture_fact.factory_key = factory_dim.factory_key
join calendar_manufacture_dim 
ON calendar_manufacture_dim.manufacture_cal_key = manufacture_fact.manufacture_cal_key
join product_dim as prod_dim 
ON manufacture_fact.product_key = prod_dim.product_key
WHERE calendar_manufacture_dim.manufacture_year = 'mY2022'
group by CUBE (factory_dim.factory_label, prod_dim.Brand_label,calendar_manufacture_dim.manufacture_yearmonth) 



