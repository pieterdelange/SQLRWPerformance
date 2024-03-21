Import-Module Sqlps
function Delete-Database() {
<#
    .SYNOPSIS
        Checks if database exists and deletes

    .DESCRIPTION
        Checks if database exists and deletes if it exists.

    .PARAMETER SQLInstance
        SQL Server instance in which to look for the database to delete.

    .PARAMETER DatabaseName
        Name of database to delete.

#>
Param(
    [Parameter(Mandatory=$True)] [Microsoft.SQLServer.Management.SMO.Server]$SQLInstance
    , [Parameter(Mandatory=$True)] [String]$DatabaseName
    )

    $Database = $SQLInstance.Databases[$DatabaseName]
    if ($Database -eq $null) {
        Write-Host "Database $($DatabaseName) not found. No need to cleanup."
    } else {
        Write-Host "Database $($DatabaseName) found. Will delete the database now."
        $SQLInstance.KillDatabase($DatabaseName)
        Write-Host "Database $($DatabaseName) deleted from instance."
    }
}
#Begin script
$ErrorActionPreference = "STOP"

#Start 
#Environment variables.
$SQLPackageLocation = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\sqlpackage.exe"
$ETLProjectFoldername = 'RWPerformanceETL'
$ETLConfigurationFilename = 'Config.dtsConfig'
$ETLProjectfolderLocation = Join-Path -Path $PSScriptRoot -ChildPath $ETLProjectFoldername
$ETLConfigurationFilelocation = Join-Path $ETLProjectfolderLocation -ChildPath $ETLConfigurationFilename

#Load DtsConfigFile in memory
[xml]$ETLConfigurationFileXML = Get-Content -Encoding UTF8 -Path $ETLConfigurationFilelocation
$NameSpaceManager = [System.Xml.XmlNamespacemanager]::new($ETLConfigurationFileXML.NameTable)
$NameSpaceManager.AddNameSpace('dts', 'www.microsoft.com/SqlServer/Dts')

#Find filelocation
$XPathQuery = '/DTSConfiguration/Configuration'
$ETLConfigurationFileXML.SelectNodes($XPathQuery, $NameSpaceManager) | % {
    $Element = $_
    if ($Element.Path -eq '\Package.Variables[User::Folder].Properties[Value]') {
        $FullPathToFolderToCreate = $Element.ConfiguredValue
    }
    if ($Element.Path -eq '\Package.Variables[User::ServerName].Properties[Value]') {
        $SQLInstanceName = $Element.ConfiguredValue
    }
}

Write-Host "Directory for testfile: $($FullPathToFolderToCreate)"

$TestFileLocation = $FullPathToFolderToCreate
#Environment variables.
#End 

$ConfigurationDatabaseName = 'Configuration'
$PerformanceDatabaseName = 'RWPerformanceDB'
$DatabaseNames = @($ConfigurationDatabaseName, $PerformanceDatabaseName)

$SQLInstance = New-Object Microsoft.SQLServer.Management.SMO.Server($SQLInstanceName)

$ConfigurationDatabaseRepoLocation = Join-Path -Path $PSScriptRoot -ChildPath $ConfigurationDatabaseName
$ConfigurationDatabaseBuildLocation = Join-Path -Path $ConfigurationDatabaseRepoLocation -ChildPath "Bin\Debug"
$ConfigurationDatabaseDacPacLocation = Join-Path -Path $ConfigurationDatabaseBuildLocation -ChildPath "$($ConfigurationDatabaseName).dacpac"
$ConfigurationDatabasePublishXMLLocation = Join-Path -Path $ConfigurationDatabaseRepoLocation -ChildPath "$($ConfigurationDatabaseName).publish.xml"

$SSISLocation = Join-Path -Path $PSScriptRoot -ChildPath "RWPerformanceETL"

$PerformanceLogLocation = Join-Path -Path $TestFileLocation -ChildPath 'Performance.csv'

Write-Verbose "DatabaseNames: $($DatabaseNames)"
Write-Verbose "SQLInstance: $($SQLInstance)"
Write-Verbose "ConfigurationDatabaseName: $($ConfigurationDatabaseName)"
Write-Verbose "ConfigurationDatabaseRepoLocation: $($ConfigurationDatabaseRepoLocation)"
Write-Verbose "ConfigurationDatabaseBuildLocation: $($ConfigurationDatabaseBuildLocation)"
Write-Verbose "ConfigurationDatabaseDacPacLocation: $($ConfigurationDatabaseDacPacLocation)"
Write-Verbose "ConfigurationDatabasePublishXMLLocation: $($ConfigurationDatabasePublishXMLLocation)"

#Loop through databases and clean up if exist
$DatabaseNames | % {
    Delete-Database -SQLInstance $SQLInstance -DatabaseName $_
}

#Deploy configuration database
Write-Host "Deploying configuration database"
& $($SQLPackageLocation) /action:publish /SourceFile:"$($ConfigurationDatabaseDacPacLocation)" /Profile:"$($ConfigurationDatabasePublishXMLLocation)"

#Read the scenarios
$ScenariosResult = Invoke-Sqlcmd -Query "
SELECT  S.[Id]
      , S.[SSISPackage]
      , S.[DatabaseProject]
  FROM [Configuration].[dbo].[Scenarios] S
  WHERE S.[Id] > 11
" -ServerInstance $SQLInstanceName -Database $ConfigurationDatabaseName

#Run the scenarios
foreach($row in $ScenariosResult) {
    
    #First clean up
    Delete-Database -SQLInstance $SQLInstance -DatabaseName $PerformanceDatabaseName
    
    [string]$SSISPackage = $row.Item("SSISPackage")
    [string]$DatabaseProject = $row.Item("DatabaseProject")

    Write-Host "Now running scenario with package: $($SSISPackage) and databaseproject $($DatabaseProject)."

    $PerformanceDatabaseRepoLocation = Join-Path -Path $PSScriptRoot -ChildPath $DatabaseProject
    $PerformanceDatabaseBuildLocation = Join-Path -Path $PerformanceDatabaseRepoLocation -ChildPath "Bin\Debug"
    $PerformanceDatabaseDacPacLocation = Join-Path -Path $PerformanceDatabaseBuildLocation -ChildPath "$($DatabaseProject).dacpac"
    $PerformanceDatabasePublishXMLLocation = Join-Path -Path $PerformanceDatabaseRepoLocation -ChildPath "$($PerformanceDatabaseName).publish.xml"

    $SSISLocationPackageLocation = Join-Path -Path $SSISLocation -ChildPath $SSISPackage

    #Deploy performance database
    Write-Host "Deploying performance database"
    & $($SQLPackageLocation) /action:publish /SourceFile:"$($PerformanceDatabaseDacPacLocation)" /Profile:"$($PerformanceDatabasePublishXMLLocation)"

    #Run the package from the scenario
    & Dtexec /FILE $SSISLocationPackageLocation

    #Save the performance log
    $PerformanceLogDestionationFileName = "Performance-$($SSISPackage)-$($DatabaseProject).csv"
    Rename-Item -Path $PerformanceLogLocation -NewName $PerformanceLogDestionationFileName
}