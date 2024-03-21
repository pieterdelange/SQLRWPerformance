CREATE TABLE [dbo].[Results]
(
	[Scenario] NVARCHAR(100),
	[BufferSize] INT NOT NULL, 
    [event] NVARCHAR(20) NOT NULL,
	[source] NVARCHAR(30) NOT NULL,
	[StartTime] DATETIME2(0) NOT NULL,
	[Iteration] SMALLINT NOT NULL,
	[FinishTime] DATETIME2(0) NOT NULL,
	[Throughputtime] SMALLINT NOT NULL

)
