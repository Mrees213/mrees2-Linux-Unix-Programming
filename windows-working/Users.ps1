

<# ******************************
# Create a function that returns a list of NAMEs AND SIDs only for enabled users
****************************** #>
function getEnabledUsers(){

  $enabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "True" } | Select-Object Name, SID
  return $enabledUsers

}

<# ******************************
# Create a function that returns a list of NAMEs AND SIDs only for not enabled users
****************************** #>
function Get-NotEnabledUsers {
    $notEnabledUsers = Get-LocalUser | Where-Object { $_.Enabled -eq $false } | Select-Object Name, SID
    return $notEnabledUsers
}

<# ******************************
# Create a function that adds a user
****************************** #>
#function createAUser($Name, $Password) {
function createAUser {
    param (
        [string]$Name,
        [SecureString]$Password
    )
  
     New-LocalUser -Name $Name -Password $Password -Disabled 
    # ***** Policies ******
    # User should be forced to change password
    # First-time created users should be disabled
    }

function removeAUser($Name) {
    
    $userToBeDeleted = Get-LocalUser | Where-Object { $_.Name -eq $Name }
    if ($userToBeDeleted) {
        Remove-LocalUser -Name $userToBeDeleted.Name
    } else {
        Write-Error "User '$Name' not found."
    }
}

function disableAUser($Name) {
    $userToBeDisabled = Get-LocalUser | Where-Object { $_.Name -eq $Name }
    if ($userToBeDisabled) {
        Disable-LocalUser -Name $userToBeDisabled.Name
    } else {
        Write-Error "User '$Name' not found."
    }
}

function enableAUser($Name) {
    $userToBeEnabled = Get-LocalUser | Where-Object { $_.Name -eq $Name }
    if ($userToBeEnabled) {
        Enable-LocalUser -Name $userToBeEnabled.Name
    } else {
        Write-Error "User '$Name' not found."
    }
}

#define a function that checks the user to see if the user name already exists
function checkUser($username){
    $user = Get-LocalUser | Where-Object { $_.Name -eq $username }
    if ($user) {
        return $true
    } else {
        return $false
    }
}