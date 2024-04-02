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
    } elseif ($Element.Path -eq '\Package.Variables[User::ServerName].Properties[Value]') {
        $ServerName = = $Element.ConfiguredValue
    }
}

Write-Host "Directory for testfile: $($FullPathToFolderToCreate)"
Write-Host "Servername: $($ServerName)"

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

#Loop through all database publish files and set correct connectionstring
$XPathQueryPublishXML = 'Project/PropertyGroup'
$PublishConnectionString = "Data Source=$($ServerName);Integrated Security=True;Persist Security Info=False;Pooling=False;Multiple Active Result Sets=False;Connect Timeout=60;Encrypt=False;Trust Server Certificate=False;Command Timeout=0"
Get-ChildItem $PSScriptRoot -Recurse -Filter '*.publish.xml' | % {
    $PublishFile = $_.FullName
    Write-Host "Publish file to update: $($PublishFile)."

    [xml]$PublishFileXML = Get-Content -Encoding UTF8 -Path $Package
    $NameSpaceManager = [System.Xml.XmlNamespacemanager]::new($PublishFileXML.NameTable)
    $PublishFileXML.SelectNodes($XPathQueryPublishXML, $NameSpaceManager) | % {
        $Element = $_
        $Element.SetAttribute('TargetConnectionString', $PublishConnectionString)
        $PublishFileXML.Save($Package)
    }
    Write-Host "Publish file : $($PublishFile) updated."
}

