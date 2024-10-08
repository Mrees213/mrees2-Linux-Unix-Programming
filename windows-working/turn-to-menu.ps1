# Load required modules/scripts
$PSScriptRoot = "C:\Users\Champuser\mrees2-Linux-Unix-Programming\windows-working"
. (Join-Path $PSScriptRoot -ChildPath "Users.ps1")
. (Join-Path $PSScriptRoot -ChildPath "Event-Logs.ps1")
. (Join-Path $PSScriptRoot -ChildPath "String-Helper-working.ps1")
. (Join-Path $PSScriptRoot -ChildPath "Parsing-Apache-Logs.ps1")

#clear

# Prompt for menu options
$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - Display last 10 apache logs`n"
$Prompt += "2 - Display last 10 failed logins for all users`n"
$Prompt += "3 - Display at Risk Users`n"
$Prompt += "4 - Start Chrome web browser at champlain.edu if not running`n"
$Prompt += "5 - Exit`n"

$operation = $true

# Main loop
while ($operation) {
    Write-Host $Prompt | Out-String
    $choice = Read-Host "Please enter a number between 1 and 5"
    
    switch ($choice) {
        "1" {
            $lastEntries = ApacheLogs1 | Select-Object -Last 10
            Write-Host ($lastEntries | Format-Table | Out-String)
        }
        "4" {
            function Start-ChromeWithChamplain {
                $chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
                $champlainUrl = "https://www.champlain.edu"
            
                # Check if Chrome is already running
                $chromeProcess = Get-Process chrome -ErrorAction SilentlyContinue
            
                if (-not $chromeProcess) {
                    # Chrome is not running, start it with the Champlain URL
                    Start-Process $chromePath -ArgumentList $champlainUrl
                    Write-Host "Chrome started and opened Champlain.edu"
                } else {
                    Write-Host "Chrome is already running. No action taken."
                }
            }
            Start-ChromeWithChamplain
        }
        "2" {
            # Call the getFailedLogins function to get failed logins from the last 30 days
            $allFailedLogins = getFailedLogins(30)
            
            # Group the failed logins by user
            $groupedFailedLogins = $allFailedLogins | Group-Object -Property User
            
            # Output the last 10 failed logins for each user
            foreach ($group in $groupedFailedLogins) {
                Write-Host "Last 10 failed logins for user: $($group.Name)"
                Write-Host "----------------------------------------"
                $group.Group | Select-Object -Last 10 | Format-Table -Property Time, Id, Event, User -AutoSize
                Write-Host ""
            }
        }
        "3" {
            $atRiskUsers = getRiskUsers(30)
            Write-Host ($atRiskUsers | Format-Table | Out-String)
        }
        "5" {
            Write-Host "Goodbye" | Out-String
            $operation = $false
        }
        default {
            Write-Host "Invalid choice. Please enter a number between 1 and 5." | Out-String
        }
    }
}
