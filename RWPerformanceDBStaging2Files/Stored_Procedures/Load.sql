CREATE PROCEDURE [dbo].[Load]
AS

	INSERT INTO [dbo].[Store] WITH (TABLOCK) 
	SELECT
	 [Id], 
     [TextColumn1],
	 [TextColumn2],
	 [TextColumn3],
	 [TextColumn4]
	FROM [dbo].[Staging]

RETURN 0
