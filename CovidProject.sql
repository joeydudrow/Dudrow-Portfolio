SELECT *
FROM CovidDeaths
WHERE continent is not null

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location like '%state%'
ORDER BY 1,2

-- Total Cases vs Population
SELECT location, date, total_cases, population, (total_cases/population)*100 AS ContractionPercentage
FROM CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- Countries with Highest Infection Rate
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS HighestInfectionPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY HighestInfectionPercentage DESC

-- Countries with Highest Death Rate
SELECT location, MAX(total_deaths) AS HighestDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY HighestDeathCount DESC



-- Continent with Highest Death Rate
SELECT [location], MAX(total_deaths) AS HighestDeathCount
FROM CovidDeaths
WHERE continent is null
GROUP BY [location]
ORDER BY HighestDeathCount DESC

-- Continent with Highest Infection Rate
SELECT location, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS HighestInfectionPercentage
FROM CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY HighestInfectionPercentage DESC


-- Global Calculations
SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- Global Calculations By Day
SELECT date, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY [date]
ORDER BY 1,2


-- Joining Data Tables
SELECT * 
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
ON dea.location = vac.location AND dea.date = vac.date

-- Population vs Vaccinations
SELECT dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not NULL
ORDER BY 2,3

-- Creating a CTE
WITH PopVsVac (Continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
AS 
(SELECT dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not NULL)
SELECT *, (RollingPeopleVaccinated/population)*100 AS PercentVaccinated
FROM PopVsVac

-- Creating View for Visiualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.[location], dea.[date], dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac 
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not NULL

CREATE VIEW TotalCasesVsPopulation AS
SELECT location, date, total_cases, population, (total_cases/population)*100 AS ContractionPercentage
FROM CovidDeaths
WHERE continent is not null

CREATE VIEW InfectionRateByCountry AS
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS HighestInfectionPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY location, population

CREATE VIEW InfectionRateByContinent AS
SELECT location, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS HighestInfectionPercentage
FROM CovidDeaths
WHERE continent is null
GROUP BY location

CREATE VIEW DeathRateByCountry AS
SELECT location, MAX(total_deaths) AS HighestDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY location

CREATE VIEW DeathRateByContinent AS
SELECT [location], MAX(total_deaths) AS HighestDeathCount
FROM CovidDeaths
WHERE continent is null
GROUP BY [location]
