﻿CREATE TABLE [dbo].[Store]
(
	[Id] BIGINT NOT NULL PRIMARY KEY, 
    [TextColumn1] VARCHAR(500) NOT NULL,
	[TextColumn2] VARCHAR(500) NOT NULL,
	[TextColumn3] VARCHAR(500) NOT NULL,
	[TextColumn4] VARCHAR(500) NOT NULL
) ON FileGroupRW