USE Covid_Project;

-- JOIN COVIDDEATHS TABLE WITH COVIDVACCINE TABLE
-- Using CTE to create a table for Rolling Vaccination by Location


WITH 
PopvsVac AS (
SELECT 
	CD.continent,
    CD.location, 
    CD.date,
    CD.population,
    CV.new_vaccinations,
    SUM(CONVERT(CV.new_vaccinations, SIGNED)) 
		OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) 
        AS RollingVaccinated
FROM CovidDeaths CD
JOIN CovidVaccinations CV ON CD.date = CV.date
	AND CD.location = CV.location
WHERE CD.continent <> ''
-- GROUP BY cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
-- ORDER BY 2,3
)

SELECT *, (Rollingvaccinated/Population)*100
FROM PopvsVac;


-- TEMP TABLE 

DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
continent				VARCHAR(50),
Location				VARCHAR(255),
date					DATETIME,
Population				BIGINT,
New_vaccinations		INT,
RollingVaccinated		BIGINT
);

INSERT IGNORE INTO PercentPopulationVaccinated
SELECT
	CD.continent,
    CD.location, 
    CD.date,
    CD.population,
    CV.new_vaccinations,
    SUM(CAST(CV.new_vaccinations AS signed))
		OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) 
        AS RollingVaccinated
FROM CovidDeaths CD
JOIN CovidVaccinations CV ON CD.date = CV.date
	AND CD.location = CV.location
WHERE CD.continent <> '';



-- CREATE VIEW TO STORE DATA FOR LATER VISUALIZATION

 CREATE OR REPLACE VIEW NA_VaccinatedPopulation AS
 SELECT
	CD.continent,
    CD.location, 
    CD.date,
    CD.population,
    CV.new_vaccinations,
    SUM(CAST(CV.new_vaccinations AS signed))
		OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) 
        AS RollingVaccinated
FROM CovidDeaths CD
JOIN CovidVaccinations CV ON CD.date = CV.date
	AND CD.location = CV.location
WHERE CD.continent = 'North America';

SELECT* 
FROM Covid_Project.na_vaccinatedpopulation;
