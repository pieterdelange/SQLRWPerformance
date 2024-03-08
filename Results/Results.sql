CREATE TABLE [dbo].[Results]
(
	[Scenario] VARCHAR(50),
	[BufferSize] INT NOT NULL, 
    [event] VARCHAR(15) NOT NULL,
	[source] VARCHAR(15) NOT NULL,
	[StartTime] DATETIME2(0) NOT NULL,
	[Iteration] SMALLINT NOT NULL,
	[FinishTime] DATETIME2(0) NOT NULL,
	[Throughputtime] SMALLINT NOT NULL

)
