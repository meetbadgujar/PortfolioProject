-- SELECT * FROM portfolioproject.covid19deaths;

/*
SELECT *
FROM covid19deaths
ORDER BY 3,4
*/

/*
SELECT country, date, total_cases_per_million, new_cases, total_deaths, population
From Covid19Deaths
ORDER BY 1,2
*/
/*
ALTER TABLE Covid19Deaths
CHANGE COLUMN new_cases total_cases VARCHAR(100);
*/
/*
SELECT country, total_cases, total_deaths
FROM Covid19Deaths
*/

/*
-- DeathPercentage
SELECT country, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
From Covid19Deaths
*/

/*
-- TOTALCASES VS POPULATION
SELECT country, date, total_cases, population, (total_cases/population) *100 as TotalCasesPercentage
FROM Covid19Deaths
*/ 
/*
-- Looking at country with highest Infection Rate compared to Polpulation
SELECT country, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population)) *100 as PercentagePopulationInfected
FROM Covid19Deaths
GROUP BY population, country
ORDER BY PercentagePopulationInfected desc
*/

/*
-- Coverting into 'int'
-- SELECT total_deaths + 0 AS converted_int
-- FROM covid19Deaths;
*/

/*
-- Showing the country with highest death count per poplution
SELECT country, population , MAX(total_deaths) as TotalDeathCount ,  MAX((total_deaths/population)) *100 as PercentagePopulationDead
FROM Covid19Deaths
GROUP BY country, population
ORDER by TotalDeathCount desc
*/

/*
-- Total cases and deaths on perticular day and DeathPercentage
SELECT date, SUM(total_cases) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/ SUM(total_cases) *100 as DeathPercentage
FROM Covid19Deaths
Group by date
*/

/*
-- Looking at total population vs total vaccination
SELECT * 
FROM Covid19Deaths dea
JOIN covid19vaccination vac
	ON 	dea.country = vac.country
    and dea.date = vac.date
*/

/*
-- People vaccinated rolling according to date
SELECT dea.country, dea.continent, dea.date, dea.population, vac.new_vaccinations 
, SUM(cast(vac.new_vaccinations as float)) OVER (PARTITION BY dea.country, dea.date) as RollingPeopleVaccinated
FROM Covid19Deaths dea
JOIN covid19vaccination vac
	ON 	dea.country = vac.country
    and dea.date = vac.date
*/


/*
-- Total people vaccinated
WITH PopvsVac(country, continent, date, population, new_vaccination, RollingPeopleVaccinated)
as
(
SELECT dea.country, dea.continent, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as float)) OVER (PARTITION BY dea.country, dea.date) as RollingPeopleVaccinated 
FROM Covid19Deaths dea
JOIN covid19vaccination vac
	ON 	dea.country = vac.country
    and dea.date = vac.date
)
SELECT *,(RollingPeopleVaccinated/population)*100
From PopvsVac
*/

/*
-- TEMP Table

-- DROP TABLE if exists PercentagePopulationVaccinated;
CREATE TEMPORARY TABLE PercentagePopulationVaccinated (
    country TEXT,
    continent TEXT,
    date TEXT,
    population INT,
    new_vaccination TEXT,
    RollingPeopleVaccinated TEXT
);

INSERT INTO PercentagePopulationVaccinated (country, continent, date, population, new_vaccination, RollingPeopleVaccinated)
SELECT 
    dea.country, 
    dea.continent, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.country ORDER BY dea.date) AS RollingPeopleVaccinated
FROM Covid19Deaths dea
JOIN covid19vaccination vac
    ON dea.country = vac.country
    AND dea.date = vac.date;


SELECT *, (RollingPeopleVaccinated/population)*100
From PercentagePopulationVaccinated
*/


/*
-- Creating view to store data for later visualization
CREATE VIEW PercentagePopulationVaccinated as 
SELECT 
    dea.country, 
    dea.continent, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.country ORDER BY dea.date) AS RollingPeopleVaccinated
FROM Covid19Deaths dea
JOIN covid19vaccination vac
    ON dea.country = vac.country
    AND dea.date = vac.date;
*/ 
