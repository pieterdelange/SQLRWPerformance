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
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStore03],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStore03.ndf'
	) TO FILEGROUP [FileGroupStore]
	GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStore04],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStore04.ndf'
	) TO FILEGROUP [FileGroupStore]
	GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStore05],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStore05.ndf'
	) TO FILEGROUP [FileGroupStore]
	GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStore06],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStore06.ndf'
	) TO FILEGROUP [FileGroupStore]
	GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStore07],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStore07.ndf'
	) TO FILEGROUP [FileGroupStore]
	GO
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [SqlFileStore08],
		FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_SqlFileStore08.ndf'
	) TO FILEGROUP [FileGroupStore]
	GO
	
	
