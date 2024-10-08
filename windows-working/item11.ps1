$files = Get-ChildItem -Path . -Recurse -File -Filter *.csv
$files | Rename-Item -NewName { $_.Name -replace '\.csv$', '.log' }
Get-ChildItem -Path . -Recurse

