SET timezone = 'UTC';
SHOW  timezone;

-- Show the population per continent
SELECT DISTINCT continent, sum(population) OVER (PARTITION BY continent)
FROM "public"."country";


-- add on the ability to calculate the percentage of the world population
SELECT
  DISTINCT continent,
  SUM(population) OVER w1 AS"continent population",
  CONCAT( 
      ROUND( 
          ( 
            SUM( population::float4 ) OVER w1 / 
            SUM( population::float4 ) OVER() 
          ) * 100    
      ),'%' ) AS "percentage of population"
FROM country 
WINDOW w1 AS( PARTITION BY continent );