SELECT * FROM Covid_Project.coviddeaths;

-- Select/check data that need to be frequently used
SELECT 
	location, 
    date, 
    total_cases,
    new_cases,
    total_deaths,
    new_deaths,
    population 
FROM covid_project.coviddeaths
WHERE continent = ''
ORDER BY 1, 2;

-- Total cases of one location and total death (in percentage)
-- Shows the likelihood of dying if attracting COVID in one country
SELECT 
	location,
    date,
    total_cases,
    total_deaths,
    (total_deaths/total_cases)*100 AS Death_Percenrage
FROM covid_project.coviddeaths
WHERE location like 'canada'
ORDER BY 1, 2;

-- Total cases vs population
-- shows the percentage of population got covid
SELECT 
	location,
    date,
    total_cases,
    population,
    (total_cases/population)*100 AS Case_Percenrage
FROM covid_project.coviddeaths
WHERE location like 'canada'
ORDER BY 1, 2;

-- countries with highest infection rate compare to population
SELECT 
	location,
    population, 
    MAX(total_cases) AS HighestInfectionCount,
    MAX(total_cases/population)*100 AS PopulationInfected_Percentage
FROM covid_project.coviddeaths
WHERE continent = ''
GROUP BY location, population
ORDER BY PopulationInfected_Percentage DESC;

-- countries with highest death count and death rate compare to population
SELECT 
	location, 
    MAX(CAST(total_deaths AS DECIMAL)) AS TotalDeathCount,
    MAX(total_deaths/population)*100 AS PopulationDeath_Percentage
FROM covid_project.coviddeaths
WHERE continent <> ''
GROUP BY location
-- ORDER BY totaldeathcount DESC;
ORDER BY PopulationDeath_Percentage DESC;

-- Death Count Analysis by Continent
-- The raw data summarized the continent number 
-- (continent name in the location column and the corresponding continent column is an empty string)
SELECT 
	Continent,
    location, 
    MAX(CAST(total_deaths AS DECIMAL)) AS TotalDeathCount,
    MAX(total_deaths/population)*100 AS PopulationDeath_Percentage
FROM covid_project.coviddeaths
WHERE continent = ''
GROUP BY continent, location
ORDER BY totaldeathcount DESC;
-- ORDER BY PopulationDeath_Percentage DESC;

-- Cases and Death Count from a Global Perspective
SELECT 
	-- Date, 
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS DECIMAL)) AS TotalDeathCount, 
    SUM(new_deaths)/sum(new_cases)*100 AS DeathPercentage
FROM covid_project.coviddeaths
WHERE continent <> ''
-- GROUP BY date
ORDER BY 1,2;
