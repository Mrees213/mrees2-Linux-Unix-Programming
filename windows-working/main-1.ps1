# Load required modules/scripts
. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Log.ps1)
. (Join-Path $PSScriptRoot String-Helper.ps1)

clear

# Prompt for menu options
$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - List at Risk Users`n"
$Prompt += "10 - Exit`n"

$operation = $true

# Function to check if user exists
function checkUser {
    param (
        [string]$username
    )
    return (Get-LocalUser | Where-Object { $_.Name -eq $username }) -ne $null
}

# Function to create a user
function createAUser {
    param (
        [string]$name,
        [SecureString]$password
    )
    New-LocalUser -Name $name -Password $password
}

# Function to remove a user
function removeAUser {
    param (
        [string]$name
    )
    Remove-LocalUser -Name $name
}

# Function to enable a user
function enableAUser {
    param (
        [string]$name
    )
    Enable-LocalUser -Name $name
}

# Function to disable a user
function disableAUser {
    param (
        [string]$name
    )
    Disable-LocalUser -Name $name
}

# Function to check password strength
function checkPassword {
    param (
        [string]$password
    )
    if ($password.Length -lt 6 -or 
        -not ($password -match '[A-Za-z]') -or 
        -not ($password -match '[0-9]') -or 
        -not ($password -match '[!@#$%^&*(),.?":{}|<>]')) {
        return $false
    }
    return $true
}

# Function to get at-risk users
function getRiskUsers {
    param (
        [int]$days
    )
    $failedLogins = getFailedLogins $days
    $groupedLogins = $failedLogins | Group-Object User
    $atRiskUsers = $groupedLogins | Where-Object { $_.Count -gt 10 }
    return $atRiskUsers | Select-Object Name, Count
}

while ($operation) {
    Write-Host $Prompt | Out-String
    $choice = Read-Host 

    switch ($choice) {
        "1" {
            $enabledUsers = Get-LocalUser | Where-Object { $_.Enabled }
            Write-Host ($enabledUsers | Format-Table | Out-String)
        }
        "2" {
            $disabledUsers = Get-LocalUser | Where-Object { -not $_.Enabled }
            Write-Host ($disabledUsers | Format-Table | Out-String)
        }
        "3" {
            $name = Read-Host -Prompt "Please enter the username for the new user"
            if (checkUser $name) {
                Write-Host "User $name already exists." | Out-String
                continue
            }
            $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"
            if (-not (checkPassword (ConvertFrom-SecureString $password))) {
                Write-Host "Password must be at least 6 characters long and include at least one letter, one number, and one special character." | Out-String
                continue
            }
            createAUser $name $password
            Write-Host "User: $name is created." | Out-String
        }
        "4" {
            $name = Read-Host -Prompt "Please enter the username for the user to be removed"
            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist." | Out-String
                continue
            }
            removeAUser $name
            Write-Host "User: $name removed." | Out-String
        }
        "5" {
            $name = Read-Host -Prompt "Please enter the username for the user to be enabled"
            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist." | Out-String
                continue
            }
            enableAUser $name
            Write-Host "User: $name enabled." | Out-String
        }
        "6" {
            $name = Read-Host -Prompt "Please enter the username for the user to be disabled"
            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist." | Out-String
                continue
            }
            disableAUser $name
            Write-Host "User: $name disabled." | Out-String
        }
        "7" {
            $name = Read-Host -Prompt "Please enter the username for the user logs"
            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist." | Out-String
                continue
            }
            $days = Read-Host -Prompt "Enter the number of days for logs"
            $userLogins = getLogInAndOffs $days
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }
        "8" {
            $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"
            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist." | Out-String
                continue
            }
            $days = Read-Host -Prompt "Enter the number of days for logs"
            $userLogins = getFailedLogins $days
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }
        "9" {
            $days = Read-Host -Prompt "Enter the number of days to check for at-risk users"
            $atRiskUsers = getRiskUsers $days
            Write-Host ($atRiskUsers | Format-Table | Out-String)
        }
        "10" {
            Write-Host "Goodbye" | Out-String
            $operation = $false
        }
        default {
            Write-Host "Invalid choice. Please enter a number between 1 and 10." | Out-String
        }
    }
}
