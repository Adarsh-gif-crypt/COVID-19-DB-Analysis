select * from Covid19Analysis..CovidDeaths
order by 3,4

select * from Covid19Analysis..CovidVaccinations
order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from Covid19Analysis..CovidDeaths
order by 1,2

-- Exploring the ratio of total cases to total deaths
-- Possibility of death in some countries where Covid cases went on a hike

select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases) as DeathRatio
from Covid19Analysis..CovidDeaths
order by 1,2

select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Covid19Analysis..CovidDeaths
order by 1,2

select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Covid19Analysis..CovidDeaths
where location='India'
order by 1,2

select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Covid19Analysis..CovidDeaths
where location='United States'
order by 1,2

-- Looking at total cases vs Population
-- Percentage of population which got Covid

select Location, date, total_cases, population, (total_cases/population)*100 as PercentageInfected 
from Covid19Analysis..CovidDeaths
order by 1,2

select Location, date, total_cases, population, round((total_cases/population)*100,5) as PercentageInfected 
from Covid19Analysis..CovidDeaths
order by 1,2

select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentageInfected 
from Covid19Analysis..CovidDeaths
group by location,population
order by PercentageInfected desc

-- Showing Highest Death Count per population

select Location, max(cast(total_deaths as int)) as TotalDeathCount 
from Covid19Analysis..CovidDeaths
where continent is not NULL
group by location
order by TotalDeathCount desc

select continent, max(cast(total_deaths as int)) as TotalDeathCountContinent 
from Covid19Analysis..CovidDeaths
where continent is not NULL
group by continent
order by TotalDeathCountContinent desc

-- Global Statistics 


select date, sum(new_cases) as SumofDeathsOnADay
from Covid19Analysis..CovidDeaths
where continent is not null
group by date
order by 1,2

select date, sum(new_cases) as SumofDeathsOnADay, sum(cast(new_deaths as int)) as SumofDeathsOnADay, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentageGolbal
from Covid19Analysis..CovidDeaths
where continent is not null
group by date
order by 1,2

-- Global Death Percentage

select sum(new_cases) as SumofDeaths, sum(cast(new_deaths as int)) as SumofDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentageGolbal
from Covid19Analysis..CovidDeaths
where continent is not null
order by 1,2

--======================================================--

select *
from Covid19Analysis..CovidDeaths Dea
Join Covid19Analysis..CovidVaccinations Vac
on dea.location=vac.location
and dea.date=vac.date

-- Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinations
from Covid19Analysis..CovidDeaths Dea
Join Covid19Analysis..CovidVaccinations Vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

-- Percentage Vaccinated using CTE

with PercVac (continent, location, date, population, new_vaccinations, SummingVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinations
from Covid19Analysis..CovidDeaths Dea
Join Covid19Analysis..CovidVaccinations Vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3
)
select *, (SummingVaccinated/population)*100 as PercentageVaccinated from PercVac

