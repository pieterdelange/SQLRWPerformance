#This script helps you update the ETL packages so that they can find the configuration file.
#Get configuration
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
}

Write-Host "Directory for testfile: $($FullPathToFolderToCreate)"

#Loop through all etl packages and set configuration file location
$XPathQueryDTSX = '/dts:Executable/dts:Configurations/dts:Configuration'
Get-ChildItem $ETLProjectfolderLocation -Filter '*.dtsx' | % {
    $Package = $_.FullName
    Write-Host "Package to update: $($Package)."

    [xml]$ETLPackageXML = Get-Content -Encoding UTF8 -Path $Package
    $NameSpaceManager = [System.Xml.XmlNamespacemanager]::new($ETLPackageXML.NameTable)
    $NameSpaceManager.AddNameSpace('dts', 'www.microsoft.com/SqlServer/Dts')
    $ETLPackageXML.SelectNodes($XPathQueryDTSX, $NameSpaceManager) | % {
        $Element = $_
        $Element.SetAttribute('DTS:ConfigurationString', $ETLConfigurationFilelocation)
        $ETLPackageXML.Save($Package)
    }
    Write-Host "Package : $($Package) updated."
}
