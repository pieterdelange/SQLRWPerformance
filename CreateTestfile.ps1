#Delete existing testfiles directory and create a new one
$FoldernameToCreate = 'Testfiles'
$Root = 'C:'
$FullPathToFolderToCreate = Join-Path -Path $Root -ChildPath $FoldernameToCreate
Write-Host "Directory to create: $($FullPathToFolderToCreate)"

if(Test-Path -path  $FullPathToFolderToCreate) {
    Remove-Item $FullPathToFolderToCreate
}

New-Item -ItemType Directory -Path $FullPathToFolderToCreate 

#Let's write some content to a file in our new directory. 
$FileNameToWriteTo = "Test.csv"
#Let's create the full path
$PathToWriteTo = Join-Path -path $FullPathToFolderToCreate -ChildPath $FileNameToWriteTo
Write-Host "Path to write to: $($PathToWriteTo)"

#Determine nr of lines to write
[bigint]$counter = 0
[bigint]$NrOfLinesToWrite = 10000000

#$sw = [io.file]::AppendText($PathToWriteTo);
$sw =[System.IO.StreamWriter] $PathToWriteTo;

$StopWatch = new-object system.diagnostics.stopwatch
$StopWatch.Start()

#Kudos to PowerShell administrator blog
#https://powershelladministrator.com/2015/11/15/speed-of-loops-and-different-ways-of-writing-to-files-which-is-the-quickest/
do
{
    $sw.WriteLine("$($counter);textcolumn1XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX${$counter};textcolumn2XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX${$counter};textcolumn3XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX${$counter};textcolumn4XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX${$counter}")
    if ($counter%($NrOfLinesToWrite / 100) -eq 0) {
        Write-Host "Completed writing $($counter) rows"
    }
    $counter = $counter + 1
}
while ($counter -lt $NrOfLinesToWrite)

$sw.Close()
$sw.Dispose()

$StopWatch.Stop()
$Minutes = $StopWatch.Elapsed.TotalMinutes

$StopWatch.Elapsed.Seconds