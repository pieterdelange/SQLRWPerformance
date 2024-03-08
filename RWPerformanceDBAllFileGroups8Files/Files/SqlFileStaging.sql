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
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStaging03],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStaging03.ndf'
	) TO FILEGROUP [FileGroupStaging]
GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStaging04],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStaging04.ndf'
	) TO FILEGROUP [FileGroupStaging]
GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStaging05],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStaging05.ndf'
	) TO FILEGROUP [FileGroupStaging]
GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStaging06],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStaging06.ndf'
	) TO FILEGROUP [FileGroupStaging]
GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStaging07],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStaging07.ndf'
	) TO FILEGROUP [FileGroupStaging]
GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStaging08],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStaging08.ndf'
	) TO FILEGROUP [FileGroupStaging]
GO
	
