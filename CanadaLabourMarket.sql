USE CanadaLabourMarket
GO

-- Explore Canada Labour Force
SELECT *
FROM LabourForceCharacteristics_Jan2024;

-- Explore Employment by Industry
SELECT *
FROM EmploymentByNAICS_Jan2024;

-- Join all labour force data
-- Select only the necessary fields
WITH
labour_force AS (
	SELECT * FROM LabourForceCharacteristics_Jan2024
	UNION ALL
	SELECT * FROM LabourForceCharacteristics_Feb2024
	UNION ALL
	SELECT * FROM LabourForceCharacteristics_Mar2024
	UNION ALL
	SELECT * FROM LabourForceCharacteristics_Apr2024
	UNION ALL
	SELECT * FROM LabourForceCharacteristics_May2024
)

SELECT
	lf.REF_DATE as date_month,
	lf.GEO as location,
	lf.Labour_force_characteristics as labour_class,
	lf.Age_group as age_group,
	lf.Sex as sex,
	lf.VALUE as total_count
FROM labour_force as lf;

-- Join all employment data
-- Select only the necessary fields
WITH
employment_industry AS (
	SELECT * FROM EmploymentByNAICS_Jan2024
	UNION ALL
	SELECT * FROM EmploymentByNAICS_Feb2024
	UNION ALL
	SELECT * FROM EmploymentByNAICS_Mar2024
	UNION ALL
	SELECT * FROM EmploymentByNAICS_Apr2024
	UNION ALL
	SELECT * FROM EmploymentByNAICS_May2024
)

SELECT
	ei.REF_DATE as date_month,
	ei.GEO as location,
	CASE
		WHEN ei.North_American_Industry_Classification_System_NAICS LIKE '%[[]%'
		THEN
			RTRIM(
				LEFT(
					ei.North_American_Industry_Classification_System_NAICS,
					CHARINDEX(' [',ei.North_American_Industry_Classification_System_NAICS, -1)
				)
			)
		ELSE ei.North_American_Industry_Classification_System_NAICS
	END as industry,
	ei.VALUE as total_count
FROM employment_industry as ei;