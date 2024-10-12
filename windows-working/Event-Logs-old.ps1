# Load the String-Helper script
$PSScriptRoot = "C:\Users\Champuser\mrees2-Linux-Unix-Programming\windows-working"
. (Join-Path $PSScriptRoot -ChildPath "String-Helper-working.ps1")

<# 
    Function Explanation: getLogInAndOffs
    This function retrieves logon and logoff events from the system event log
    for a specified number of days in the past.
#>
function getLogInAndOffs($Days) {

    $loginouts = Get-EventLog system -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$Days)
    
    $loginoutsTable = @()
    
    foreach ($event in $loginouts) {
        $type = switch ($event.InstanceID) {
            7001 { "Logon" }
            7002 { "Logoff" }
            default { "" }
        }

        # Check if user exists first
        $user = try {
            (New-Object System.Security.Principal.SecurityIdentifier $event.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
        } catch {
            "Unknown User"
        }

        $loginoutsTable += [pscustomobject]@{
            Time  = $event.TimeGenerated
            Id    = $event.InstanceId
            Event = $type
            User  = $user
        }
    }

    return $loginoutsTable
} # End of function getLogInAndOffs


<# 
    Function Explanation: getFailedLogins
    This function retrieves failed login events from the security event log
    for a specified number of days in the past.
#>
function getFailedLogins($days) {
    $failedLogins = Get-EventLog security -After (Get-Date).AddDays(-$days) | Where-Object { $_.InstanceID -eq 4625 }
    
    $failedLoginsTable = @()

    foreach ($event in $failedLogins) {
        $account = ""
        $domain = ""

        $usrlines = getMatchingLines $event.Message "*Account Name*"
        $usr = if ($usrlines.Count -gt 1) { $usrlines[1].Split(":")[1].Trim() } else { "Unknown User" }

        $dmnlines = getMatchingLines $event.Message "*Account Domain*"
        $dmn = if ($dmnlines.Count -gt 1) { $dmnlines[1].Split(":")[1].Trim() } else { "Unknown Domain" }

        $user = "$dmn\$usr"

        $failedLoginsTable += [pscustomobject]@{
            Time  = $event.TimeGenerated
            Id    = $event.InstanceId
            Event = "Failed"
            User  = $user
        }
    }

    return $failedLoginsTable
} # End of function getFailedLogins

function getRiskUsers($Days) {
    #The function will return a list of users who have had more than 10 failed login attempts in the last $Days days.
    #$Days: The number of days to look back for failed login attempts.
        ## Calculate the start date
        $startDate = (Get-Date).AddDays(-$Days)
    
        ## Get failed login events
        $failedLogins = Get-WinEvent -FilterHashtable @{
            LogName = 'Security'
            ID = 4625  # Event ID for failed logins
            StartTime = $startDate
        } -ErrorAction SilentlyContinue
    
        ## Group failed logins by username and count occurrences
        $userFailures = $failedLogins | 
            Group-Object { $_.Properties[5].Value } | 
            Where-Object { $_.Count -gt 10 } |
            Select-Object @{Name='Username';Expression={$_.Name}}, Count
    
        ## Return usernames
        return $userFailures | Select-Object -ExpandProperty Username
    }