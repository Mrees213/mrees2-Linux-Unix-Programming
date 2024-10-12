# Load required modules/scripts
$PSScriptRoot = "C:\Users\Champuser\mrees2-Linux-Unix-Programming\windows-working"
$ConfigFile = "C:\Users\Champuser\mrees2-Linux-Unix-Programming\windows-working\configuration.txt"
. (Join-Path $PSScriptRoot -ChildPath "email.ps1")
. (Join-Path $PSScriptRoot -ChildPath "Scheduler.ps1")
. (Join-Path $PSScriptRoot -ChildPath "configuration.ps1")
. (Join-Path $PSScriptRoot -ChildPath "Event-Logs.ps1")

# Obtaining the configuration
$configuration = readConfiguration($ConfigFile)

# Obtaining at risk users by passing getRiskUsers 
$Failed = getRiskUsers $configuration.Days

#Sending at risk users as email
SendAlertEmail ($Failed | Format-Table | Out-String)

# Setting  the script to be run daily
ChooseTimeToRun ($configuration.ExecutionTime)