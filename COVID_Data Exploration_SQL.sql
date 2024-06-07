Select *
From PortfolioProject. .CovidDeaths
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4 

Select location, date, total_cases, new_cases, total_cases, population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total cases vs Total Deaths
--showa likelihood of dying if you contract COVID in India

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From PortfolioProject..CovidDeaths
Where location like '%India%'
order by 1,2

--Looking at Tota cases vs Population

Select location, date, total_cases, population, (total_deaths/population)*100 as Deathpercentage
From PortfolioProject..CovidDeaths
Where location like '%India%'
order by 1,2

--Looking at country higest infection ratecompared to population

Select location, population, MAX(total_cases) as HighestInfectionCount , MAX((total_cases/population))*100 as percentagepopulationinfected
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Group by location, population
order by percentagepopulationinfected DESC

--showing Countries with highest Death Count per Population

Select location, MAX(cast (Total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
--Where location like '%India%'
where continent is not null
Group by location
order by TotalDeathCount DESC

--Let's Break thing down as continent

Select continent, MAX(cast (Total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
--Where location like '%India%'
where continent is not null
Group by continent
order by TotalDeathCount DESC

--Global numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
From PortfolioProject..CovidDeaths
--Where location like '%India%'
where continent is not null
Group by date
order by 1,2

-- Looking at totsl populstion vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleCount
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 1,2,3

  -- Use CTE

  with PopvsVac(continet, location, date, population, new_vaccination, RollingPeopleVaccinated)
  as
  (
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleCount
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  --order by 1,2,3
  )
  select*, (RollingPeopleVaccinated/Population)*100 
  From PopvsVac

  --Temp table

  DROP Table if exists #PercentPopulationVaccinated
  Create table #PercentPopulationVaccinated
  (
  continent nvarchar(300),
  location nvarchar(300),
  Date datetime,
  Population numeric,
  New_vaccinated numeric,
  RollingPeopleVaccinated numeric
  )

  insert into #PercentPopulationVaccinated
   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleCount
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  --order by 1,2,3
  
  Select*,(RollingPeopleVaccinated/Population)*100
  from #PercentPopulationVaccinated

  --Creating View to store data for later visualization

  Create view PercentPopulationVaccinated as
   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleCount
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  --order by 1,2
  

  select*
  from PercentPopulationVaccinated




