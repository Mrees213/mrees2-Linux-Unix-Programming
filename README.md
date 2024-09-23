# mrees2-Linux-Unix-Programming

Couldn't submitted through powershell had to try this instead 
function Get-VisitedIPs {
    param (
        [string]$PageVisited,      # The page visited or referred from
        [int]$HttpCodeReturned,    # HTTP code returned
        [string]$BrowserName       # Name of the web browser
    )

    # Define the path to the Apache access log
    $logFilePath = "c:/xampp/apache/logs/access.log"

    # Check if the log file exists
    if (-Not (Test-Path $logFilePath)) {
        Write-Output "Log file not found: $logFilePath"
        return
    }

    # Read the log file and filter for the given criteria
    $matchingEntries = Get-Content $logFilePath | Where-Object {
        $_ -match [regex]::Escape($PageVisited) -and 
        $_ -match "\s$HttpCodeReturned\s" -and 
        $_ -match [regex]::Escape($BrowserName)
    }

    # Extract unique IP addresses from the matching entries
    $ipAddresses = $matchingEntries | ForEach-Object {
        # Assuming the IP is the first item in the log entry
        $_.Split(" ")[0]
    } | Sort-Object -Unique

    # Output the matching IP addresses
    if ($ipAddresses) {
        Write-Output "IP addresses that visited '$PageVisited' with HTTP code '$HttpCodeReturned' using '$BrowserName':"
        $ipAddresses
    } else {
        Write-Output "No matching entries found for the specified criteria."
    }
}
