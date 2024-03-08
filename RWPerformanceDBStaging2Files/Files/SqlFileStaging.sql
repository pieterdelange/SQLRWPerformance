/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStaging01],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStaging01.ndf'
	) TO FILEGROUP [FileGroupStaging]
GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStaging02],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStaging02.ndf'
	) TO FILEGROUP [FileGroupStaging]
GO
