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







