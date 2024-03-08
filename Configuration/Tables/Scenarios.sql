CREATE TABLE [dbo].[Scenarios]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [SSISPackage] VARCHAR(30) NOT NULL, 
    [DatabaseProject] VARCHAR(40) NOT NULL 
)
