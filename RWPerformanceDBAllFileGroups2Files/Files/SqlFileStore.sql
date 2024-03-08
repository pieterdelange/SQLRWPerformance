/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStore01],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStore01.ndf'
	) TO FILEGROUP [FileGroupStore]
	GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStore02],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStore02.ndf'
	) TO FILEGROUP [FileGroupStore]
	GO
