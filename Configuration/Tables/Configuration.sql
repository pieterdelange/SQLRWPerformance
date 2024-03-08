CREATE TABLE [dbo].[Configuration]
(
	[Id] INT NOT NULL  IDENTITY, 
    [Parameter] VARCHAR(50) NOT NULL, 
    [Value] VARCHAR(200) NOT NULL, 
    PRIMARY KEY ([Parameter])
)
