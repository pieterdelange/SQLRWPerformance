CREATE PROCEDURE [dbo].[Performance]
	
AS
	SELECT 
	R.[Scenario]
	, R.[BufferSize]
	, R.[source]
	, AVG(R.[Throughputtime]*1.0)  AS [AverageThroughputtime]
	, STDEV(R.[Throughputtime]*1.0)  AS [StandardDeviationThroughputtime]
  FROM [dbo].[Results] R
  WHERE R.[source] = 'DFT - Extract'
  GROUP BY 
  	R.[Scenario]
	, R.[BufferSize]
	, R.[source]
ORDER BY source
	, AVG(R.[Throughputtime]*1.0) 
	, STDEV(R.[Throughputtime]*1.0)
;
WITH
SQL_Load AS (
SELECT 
	 R.[Scenario]
	,R.[BufferSize]
	,R.[event]
	,R.[source]
	,R.[StartTime]
	,R.[Iteration]
	,R.[FinishTime]
	,R.[Throughputtime]
  FROM [dbo].[Results] R
  WHERE R.[source] = 'SQL - Load'
)
,
SQL_Create_IX_Staging AS (
SELECT 
	 R.[Scenario]
	,R.[BufferSize]
	,R.[event]
	,R.[source]
	,R.[StartTime]
	,R.[Iteration]
	,R.[FinishTime]
	,R.[Throughputtime]
  FROM [dbo].[Results] R
  WHERE R.[source] = 'SQL - Create IX_Staging'
)

SELECT 
	  RIGHT(AL.[Scenario], 30) AS [Scenario]
	, AVG(AL.[Throughputtime]*1.0) AS Average_SQLLoad_Throughputtime
	, AVG(IX.[Throughputtime]*1.0) AS Average_CreateIX_Staging_Throughputtime
	, AVG(AL.[Throughputtime]*1.0 + IX.[Throughputtime]*1.0) AS Average_Throughputtime
	, STDEV(AL.[Throughputtime]*1.0) AS StandardDeviation_SQLLoad_Throughputtime
	, STDEV(IX.[Throughputtime]*1.0) AS StandardDeviation_CreateIX_Staging_Throughputtime
	, STDEV(AL.[Throughputtime]*1.0 + IX.[Throughputtime]*1.0) AS StandardDeviation_Throughputtime
	, COUNT(*) AS NumberOfMeasurements
FROM SQL_Load AL
INNER JOIN SQL_Create_IX_Staging IX
	ON AL.[BufferSize] = IX.[BufferSize]
	AND AL.[Iteration] = IX.[Iteration]
	AND AL.[Scenario] = IX.[Scenario]
GROUP BY RIGHT(AL.[Scenario], 30)
ORDER BY AVG(AL.[Throughputtime]*1.0 + IX.[Throughputtime]*1.0) 
RETURN 0
