﻿/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileRW],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFile.ndf'
	) TO FILEGROUP [FileGroupStaging]
	
