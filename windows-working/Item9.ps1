# Create foldier if it does exist
$folderpath = Join-Path -Path $env:PSScriptRoot -ChildPath "\outfolder"
Write-Host $filepath
if (Test-Path $folderpath){
 Write-Host "Folder Already Exists"
}
else{
 New-Item -Path $folderpath -ItemType Directory
   
} 