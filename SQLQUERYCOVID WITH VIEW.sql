--SELECT DATA WE'RE USING

SELECT *
FROM [portfolio project]. .CovidDeaths$
WHERE CONTINENT IS NOT NULL
ORDER BY 3,4 

--SELECT *
--FROM [portfolio project]. .Covidvaccination$
--ORDER BY 3,4

SELECT location, date, total_cases, total_deaths, new_cases, population
FROM [portfolio project]. .CovidDeaths$
WHERE location='india'
ORDER BY 3,4 

--LOOKING AT TOTAL CASES VS TOTAL DEATHS
--SHOWS LIKELIHOOD OF YOU DYING IF YOU CONTRACT COVID IN YOUR COUNTRY
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DEATHPERCENTAGE
FROM [portfolio project]. .CovidDeaths$
WHERE location='india'
ORDER BY 3,4 

-- LOOKING AT TOTAL CASES VS TOTAL POPULATION
--SHOWS WHAT PERCENTAGE OF PEOPLE GOT COVID
SELECT location, date, total_cases, POPULATION,(total_cases/POPULATION)*100 AS PERCENTPOPULATIONINFECTED
FROM [portfolio project]. .CovidDeaths$
--WHERE location='india'
ORDER BY 1,2


--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATES COMPARED TO POPULATION
SELECT location, POPULATION, MAX(total_cases) AS HIGHESTINFECTIONCOUNT, MAX(total_cases/POPULATION)*100 AS PERCENTPOPULATIONINFECTED
FROM [portfolio project]. .CovidDeaths$
--WHERE location='india'
GROUP BY LOCATION, POPULATION
ORDER BY  PERCENTPOPULATIONINFECTED DESC

--showing countries with highest death count per population
SELECT location, MAX(CAST(total_deaths AS INT)) AS TOTALDEATHCOUNT
FROM [portfolio project]. .CovidDeaths$
--WHERE location='india'
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION
ORDER BY  TOTALDEATHCOUNT DESC


--LETS BREAK IT DOWN BY CONTINENT 

--SHOWING THE CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION
SELECT continent,  MAX(CAST(total_deaths AS INT)) AS TOTALDEATHCOUNT
FROM [portfolio project]. .CovidDeaths$
WHERE CONTINENT IS NOT NULL
GROUP BY continent
ORDER BY  TOTALDEATHCOUNT DESC


--GLOBAL NUMBERS
SELECT DATE, SUM(NEW_CASES) AS TOTALCASES, SUM(CAST(NEW_DEATHS AS INT)) AS TOTALDEATHS,  SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES)*100 AS DEATHPERCENTAGE
FROM [portfolio project]. .CovidDeaths$
WHERE CONTINENT IS NOT NULL
GROUP BY DATE
ORDER BY 1,2 

SELECT SUM(NEW_CASES) AS TOTALCASES, SUM(CAST(NEW_DEATHS AS INT)) AS TOTALDEATHS,  SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES)*100 AS DEATHPERCENTAGE
FROM [portfolio project]. .CovidDeaths$
WHERE CONTINENT IS NOT NULL



 SELECT *
  FROM [portfolio project]..CovidDeaths$ DEA
 JOIN [portfolio project]..Covidvaccination$ VAC
  ON DEA.LOCATION=VAC.LOCATION
  AND DEA.DATE=VAC.DATE
  ORDER BY 2,3


  --LOOKING AT TOTAL POPULATION VS VACCINATIONS
  --Shows Percentage of Population that has recieved at least one Covid Vaccine


  SELECT DEA.continent,DEA.location, DEA.population, DEA.date, VAC.new_vaccinations, 
  SUM(CONVERT(INT,VAC.NEW_VACCINATIONS)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE) as Rollingpeoplevaccinated
  --(RollingPeopleVaccinated/population)*100
 FROM [portfolio project]..CovidDeaths$ DEA
 JOIN [portfolio project]..Covidvaccination$ VAC
  ON DEA.LOCATION=VAC.LOCATION
  AND DEA.DATE=VAC.DATE
  WHERE DEA.continent IS NOT NULL
  ORDER BY 2,3

  -- Using CTE to perform Calculation on Partition By in previous query

  WITH POPVSVAC (CONTINENT, LOCATION, POPULATION, DATE,NEW_VACCINATIONS,ROLLINGPEOPLEVACCINATED) AS
  (
  SELECT DEA.continent,DEA.location, DEA.population, DEA.date, VAC.new_vaccinations, 
  SUM(CONVERT(INT,VAC.NEW_VACCINATIONS)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE) as Rollingpeoplevaccinated
FROM [portfolio project]..CovidDeaths$ DEA
 JOIN [portfolio project]..Covidvaccination$ VAC
  ON DEA.LOCATION=VAC.LOCATION
  AND DEA.DATE=VAC.DATE
  WHERE DEA.continent IS NOT NULL
  )

  SELECT*, (ROLLINGPEOPLEVACCINATED/POPULATION)*100
  FROM POPVSVAC

  -- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS #PERCENTPOPULATIONVACCINATED
  CREATE TABLE #PERCENTPOPULATIONVACCINATED
  (
  CONTINENT NVARCHAR(255),
  LOCATION NVARCHAR(255),
  POPULATION NUMERIC,
  DATE DATETIME,
  NEW_VACCINATIONS NUMERIC,
  ROLLINGPEOPLEVACCINATED NUMERIC
  )



  INSERT INTO #PERCENTPOPULATIONVACCINATED
  SELECT DEA.continent,DEA.location, DEA.population, DEA.date, VAC.new_vaccinations, 
  SUM(CONVERT(INT,VAC.NEW_VACCINATIONS)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE) as Rollingpeoplevaccinated
  --(RollingPeopleVaccinated/population)*100
 FROM [portfolio project]..CovidDeaths$ DEA
 JOIN [portfolio project]..Covidvaccination$ VAC
  ON DEA.LOCATION=VAC.LOCATION
  AND DEA.DATE=VAC.DATE
  WHERE DEA.continent IS NOT NULL
  --ORDER BY 2,3

  SELECT*,(ROLLINGPEOPLEVACCINATED/POPULATION)*100 
  FROM #PERCENTPOPULATIONVACCINATED



  -- Creating View to store data for later visualizations


  CREATE VIEW PERCENTPOPULATIONVACCINATED AS
  SELECT DEA.continent,DEA.location, DEA.population, DEA.date, VAC.new_vaccinations, 
  SUM(CONVERT(INT,VAC.NEW_VACCINATIONS)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,DEA.DATE) as Rollingpeoplevaccinated
  --(RollingPeopleVaccinated/population)*100
 FROM [portfolio project]..CovidDeaths$ DEA
 JOIN [portfolio project]..Covidvaccination$ VAC
  ON DEA.LOCATION=VAC.LOCATION
  AND DEA.DATE=VAC.DATE
  WHERE DEA.continent IS NOT NULL
  
 

  

  
  

   


