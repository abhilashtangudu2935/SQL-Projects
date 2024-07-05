select * from accident_data.uk_data limit 4;

-- Year of the Accidents which we are going to Analyze
select distinct year from accident_data.uk_data;



-- Total No.of Accidents occured in 2015
select count(1) from accident_data.uk_data;



-- No of Accidents based on severity of accidents
select Accident_Severity, count(1) as count from accident_data.uk_data group by Accident_Severity order by count;




-- What are all the weather conditions due to which accidents occured
select distinct Weather_Conditions from accident_data.uk_data;




-- What are all the conditions in which the count of accidents is greater than 500 (GROUP BY, HAVING ,ORDERY BY CALUSES)
select distinct Weather_Conditions, count(1) as count from accident_data.uk_data group by Weather_conditions having count > 500 order by count desc;




-- What are all the cases where number of vehicles involed (DISTINCT)
select distinct Number_of_Vehicles from accident_data.uk_data order by Number_of_Vehicles;





-- No of accidents took pace with 1 and 2 vehicles (IN OPERATOR)
select Count(1) from accident_data.uk_data where Number_of_Vehicles in (1,2);





-- Max No of vehicles involved Accidents (AGGREGATE FUNCTIONS)
select max(Number_of_Vehicles) from accident_data.uk_data;




-- Total Number of people died in 2005 due to Accidents
select sum(Number_of_Casualties) from accident_data.uk_data;




-- Max no  of deaths accident in 2005
select max(Number_of_Casualties) from accident_data.uk_data;




-- Avg no of deaths for single vehicle
select avg(Number_of_Casualties) from accident_data.uk_data where Number_of_vehicles=1;




-- Avg no of deaths for each Number of vehicles involved
select Number_of_vehicles,avg(Number_of_Casualties) from accident_data.uk_data group by Number_of_vehicles;




-- No of accidents occured on each road type
select count(1),Road_Type from accident_data.uk_data group by Road_Type;
-- No of accidents occured based on Light Conditions
select count(1),Light_Conditions from accident_data.uk_data group by Light_Conditions;




-- No of accidents occured in single road and daylight (LOGICAL AND OPERATOR)
select count(1) from accident_data.uk_data where Road_Type="Single carriageway" and Light_Conditions="Daylight: Street light present";




-- No of accidents occured between durations (BETWEEN OPERATOR)
select count(1) from accident_data.uk_data where Time between 1 and 6;
select count(1) from accident_data.uk_data where Time between 6 and 12;
select count(1) from accident_data.uk_data where Time between 12 and 18;
select count(1) from accident_data.uk_data where Time between 18 and 24;




-- No of accidents occured based on the Time ZONE (CASE STATEMENT WITH SUBQUERY)
select count(1), period from (
select *, case when Time between 1 and 6 Then "Mid-night" 
               when Time between 6 and 12 then "Morning" 
               when Time between 12 and 18 then "afternoon" 
               else "evening" end as period from accident_data.uk_data 
)T group by T.period;




-- Road Number with no junction control and speed linit>30 (SUBQUERIES)
select distinct Speed_limit from accident_data.uk_data;
select 1st_Road_Number from accident_data.uk_data where Junction_Control="None" and 1st_Road_Number not in ( select 1st_Road_Number from accident_data.uk_data where Speed_limit>30 );





-- Accidents occured in particular location ( LIKE CLAUSE WITH WILCARD OPERATORS )
select * from accident_data.uk_data where Location_Easting_OSGR like '522%'and Location_Northing_OSGR like '177%';




-- Police un attended cases
select * from accident_data.uk_data where Did_Police_Officer_Attend_Scene_of_Accident="No";




-- More than one accident occured in same location (ROW NUMBER WITH CTE)
with CTE as (
select *, row_number()over(partition by Location_Easting_OSGR,Location_Northing_OSGR,Longitude,Latitude order by id) as rn from accident_data.uk_data
)
select * from CTE where rn>1;




-- 7th highest deaths accident details in single vehicle (DENSE RANK WITH CTE)
select * from (
select *, dense_rank()over(partition by Number_of_Vehicles order by Number_of_Casualties asc) as dr from accident_data.uk_data
)T where dr=7;





-- More number of accidents which day of week (CASE STATEMENT WITH SUB-QUERY)
select max(count) from (select count(1) as count ,Week_Accident from 
(select *, case when Day_of_Week=1 then "Sunday"
                when Day_of_Week=2 then "Monday"
                when Day_of_Week=3 then "Tuesday"
                when Day_of_Week=4 then "Wednesday"
                when Day_of_Week=5 then "Thursday"
                when Day_of_Week=6 then "Friday"
                else "saturday" end as Week_Accident from accident_data.uk_data)T
group by T.Week_Accident order by count desc)D;




-- Accidents that occured on Dry road but not on morning light (SET OPERATORS)
select * from accident_data.uk_data where Road_Surface_Conditions="Dry"
except
select * from accident_data.uk_data where Light_Conditions="Daylight: Street light present";




-- Accidents based on each MONTH
update accident_data.uk_data
set Accident_Date=replace(Accident_date, "/", "-")
;

alter table accident_data.uk_data rename column Date to Accident_Date;
alter table accident_data.uk_data modify column Accident_Date varchar(20);

-- select extract(month from Trim(Accident_Date)) from accident_data.uk_data;
-- select date_format(cast(Trim(Accident_Date) as date), 'YYYY-MM_DD') from accident_data.uk_data;