# Configuration.ps1

# Define the path for the configuration file
$configFilePath = "configuration.txt"

# Function to read configuration from the configuration file
function readConfiguration ($FilePath) {
    # Check if the file exists
    if (-not (Test-Path $FilePath)) {
        Write-Error "The specified file does not exist: $FilePath"
        return
    }
    
    # Read the contents of the file
    $fileContents = Get-Content $FilePath 

    # Ensure the file contains 2 lines
    if ($fileContents.Count -ne 2) {
        Write-Error "The file must contain 2 lines."
        return
    }
    
    $configObject = [PSCustomObject]@{
        Days = [int]$fileContents[0]
        ExecutionTime = $fileContents[1]
    }

    return $configObject
}

# Function to change configuration
function changeConfiguration {
    $days = ''
    $executionTime = ''
    
    # Input validation for Days
    while ($true) {
        $days = Read-Host "Enter new Days (only digits)"
        if ($days -match '^\d+$') {
            break
        } else {
            Write-Host "Invalid input. Please enter only digits."
        }
    }

    # Input validation for Execution Time
    while ($true) {
        $executionTime = Read-Host "Enter new Execution Time (format: 12-hour time AM/PM)"
        if ($executionTime -match '^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM)$') {
            break
        } else {
            Write-Host "Invalid input. Please enter in the format 12-hour time AM/PM."
        }
    }

    # Save the new configuration to the file
    $newConfig = "$days`n$executionTime"
    Set-Content -Path $configFilePath -Value $newConfig
    Write-Host "Configuration updated successfully."
}

# Function to show the configuration menu
function configurationMenu {
    $exitMenu = $false  # Flag to control the menu exit

    while (-not $exitMenu) {
        Write-Host "`nConfiguration Menu:"
        Write-Host "1. Show Configuration"
        Write-Host "2. Change Configuration"
        Write-Host "3. Exit"

        $choice = Read-Host "Select an option (1-3)"

        switch ($choice) {
            '1' {
                $config = readConfiguration $configFilePath
                if ($config -ne $null) {
                     $config | Format-Table -Property Days, ExecutionTime
                }
            }
            '2' {
                changeConfiguration
            }
            '3' {
                Write-Host "Exiting the menu. Goodbye!"
                $exitMenu = $true  # Set the flag to exit the loop
            }
            default {
                Write-Host "Invalid selection. Please choose 1, 2, or 3."
            }
        }
    }
}

# Run the configuration menu
#configurationMenu
