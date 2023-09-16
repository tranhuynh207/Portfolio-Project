-- Black Friday Sales Data Exploration 

-- Select data
Select * 
from PortfolioProject.blackfridaysale;

-- Show the number of customers by genders
select Gender, count(*) as count_gender from PortfolioProject.blackfridaysale
group by Gender;

-- Which user has the maximum purchase?
select User_ID, Purchase
from PortfolioProject.blackfridaysale
where Purchase in (select max(Purchase) from PortfolioProject.blackfridaysale);

/*CONCEPTS USED: WINDOW FUNCTIONS, AGGREGATE FUNCTIONS, virtual tables,joins
*/

select * from PortfolioProject.blackfridaysale
;

-- Number of customers from both genders

select Gender, count(*) as count_genders 
from PortfolioProject.blackfridaysale
group by Gender
;

-- Number of purchases from each city
select City_Category , count(*) as no_of_purchases 
from PortfolioProject.blackfridaysale
group by City_Category
;
-- Top 3 age groups with large purchases
select *
from
	(select Age,sum(purchase) as Total_purchase
	from PortfolioProject.blackfridaysale
	group by Age) c
order by c.Total_purchase Desc
limit 3
;

-- Details of Top 10 male customers having large purchases
with cte_rep as
 (select USER_ID,sum(purchase) as Total_purchase 
 from PortfolioProject.blackfridaysale
        where Gender ='M' 
		group by USER_ID
		)
	select distinct s.User_ID, s.Age, r.Total_purchase from cte_rep r
	join PortfolioProject.blackfridaysale s on  s.User_ID= r.User_ID
	order by Total_purchase DESC
    limit 10

;
-- List of users that have stayed the maximum in the current city
select max(Stay_In_Current_City_Years)
from `PortfolioProject`.blackfridaysale
;
select distinct USER_ID, Gender, Age, Stay_In_Current_City_Years
from `PortfolioProject`.blackfridaysale
where Stay_In_Current_City_Years = "4+"
order by Age
;

-- number of married people wrt age who haven not stayed at a particular city
with cte_count as (select distinct USER_ID, gender, age, Stay_In_Current_City_Years
from `PortfolioProject`.blackfridaysale
where Stay_In_Current_City_Years=0 and Marital_Status=1 
)
select Age , count(*) as no_of_married from cte_count
group by Age
order by Age
;
-- Lowest 5 purchases by female with occupation > 16 and city category either a or b

with cte_user as (select User_ID,sum(purchase) as Total_purchase,max(Occupation) as occ
from `PortfolioProject`.blackfridaysale
where  City_Category ='A' or City_Category='B'
group by User_ID)

select distinct s.User_ID,s.City_Category,c.Total_purchase from `PortfolioProject`.blackfridaysale s
join cte_user c on c.USER_ID=s.User_ID
where c.occ>16 and s.gender='F'
order by c.Total_purchase asc
limit 5
;
-- The most purchased product of every city

with cte_number as (select Product_ID ,count(Product_ID) as purchase_frequency,City_Category
from `PortfolioProject`.blackfridaysale
group by Product_ID,City_Category
)

select Product_id,city_category,purchase_frequency from(
select *, ROW_NUMBER() over ( partition by city_category order by purchase_frequency Desc) as rank_num
from cte_number)a
where rank_num=1
;

-- User ID of Married and non married users that did minimum purchase

select USER_ID,marital_status,purchase from(
select USER_ID, purchase, marital_status,ROW_NUMBER() over(partition by Marital_Status order by purchase) as row_num
from `PortfolioProject`.blackfridaysale)a
where row_num=1
;

-- Percentage of people living in each city

select City_Category, people_living, round((people_living/tot_people)*100, 2) as percentage_over_total
from 
	(select *, sum(people_living) over () as tot_people
	from (select count(distinct USER_ID) as people_living , City_Category 
			from `PortfolioProject`.blackfridaysale
			group by City_Category) a
	group by City_Category ) b
order by City_Category
;
-- Users from each age group that stayed the minimum in a particular city but has the maximum purchase

with cte_min as (select distinct USER_ID, gender, age, Stay_In_Current_CIty_Years
from `PortfolioProject`.blackfridaysale
where Stay_In_Current_City_Years =0 )
select USER_ID, gender,age, purchase
from 
(select c.USER_ID, c.gender,c.age,s.purchase, ROW_NUMBER() over(partition by c.age order by s.purchase desc) as rnk 
from `PortfolioProject`.blackfridaysale s
join cte_min c on c.User_ID=s.User_ID
)a
where rnk=1








