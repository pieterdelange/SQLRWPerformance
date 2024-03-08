CREATE TABLE [dbo].[Store]
(
	[Id] BIGINT NOT NULL  , 
    [TextColumn1] NVARCHAR(500) NOT NULL,
	[TextColumn2] NVARCHAR(500) NOT NULL,
	[TextColumn3] NVARCHAR(500) NOT NULL,
	[TextColumn4] NVARCHAR(500) NOT NULL 
) ON FileGroupStaging
