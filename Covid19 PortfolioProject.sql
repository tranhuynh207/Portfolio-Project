-- Covid 19 Data Exploration 
-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types


-- Select data
Select *
from PorfolioProject.coviddeath
Where continent <> ""
order by 3,4;


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in Belgium

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PorfolioProject.coviddeath
Where location like '%Belgium%' 
order by 1,2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid (in Belgium)

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PorfolioProject.coviddeath
-- Where location like '%Belgium%'
where continent <> ""
order by 1,2

-- Countries with Highest Infection Rate compared to Population

Select location, population, max(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject.coviddeath
where continent <> ""
Group by location, population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count

Select location, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
From PorfolioProject.coviddeath
Where continent <> ""
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count

Select continent, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
From PorfolioProject.coviddeath
Where continent <> ""
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as unsigned)) as total_deaths, SUM(cast(new_deaths as unsigned))/SUM(New_Cases)*100 as DeathPercentage
From PorfolioProject.coviddeath
Where continent <> ""
-- Group By date
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PorfolioProject.coviddeath dea
Join PorfolioProject.covidvacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ""
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PorfolioProject.coviddeath dea
Join PorfolioProject.covidvacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ""
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedRate
From PopvsVac


-- Using a temp table 

DROP table if exists PorfolioProject.PercentPopulationVaccinated
Create Table PorfolioProject.PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated,
From PorfolioProject.coviddeath dea
Join PorfolioProject.covidvacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ""


-- Creating View to store data for later visualizations

DROP table if exists PorfolioProject.PercentPopulationVaccinated
Create View PorfolioProject.PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated,
From PorfolioProject.coviddeath dea
Join PorfolioProject.covidvacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ""

SELECT * FROM PorfolioProject.percentpopulationvaccinated;