function AmIAdmin {
  <#
  .SYNOPSIS
    Returns $True when the process running this script has administrative privileges
  .DESCRIPTION
    Starting with PowerShell 4.0, the "Requires -RunAsAdministrator" directive
    prevents the execution of the script when administrative privileges are
    absent. However, there are still times that you'd like to just check the
    privilege (or lack thereof), e.g., to announce it to the user or downgrade
    script functionality gracefully.
  .NOTES
    For the Requires directive, see the "about_Requires" help page.
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_requires?view=powershell-7
  #>
  $MyId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal( $MyId )
  return $WindowsPrincipal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
}

function Unregister-ScheduledTaskEx {
  <#
  .SYNOPSIS
    Unregisters several scheduled tasks whose names matches a wildcard patten (not regex)
  .DESCRIPTION
    Uses Get-ScheduledTask to get a list of all scheduled tasks, filters then via the -like operator, and runs Unregister-ScheduledTask against the resulting set.
    Extremly dangerous. Use with caution.
  .EXAMPLE
    PS C:\> Unregister-ScheduledTaskEx -TaskNameEx "AppThatIJustUninstalled_User.*"
    Removes scheduled tasks whose names begins with "AppThatIJustUninstalled_User."
  .INPUTS
    None
  .OUTPUTS
    None
  .NOTES
    Version 1.0
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [SupportsWildcards()]
    [String[]]
    $TaskNameEx
  )
  $MatchingTasks = Get-ScheduledTask | Where-Object -FilterScript { foreach ($item in $TaskNameEx) { if ($_.TaskName -like $item) { return $true } } }
  if ($null -ne $MatchingTasks) {
    # This command does not seem to respect the $VerbosePreference and asks for confirmation anyway
    # Add -Confirm:$false to make it stop
    Unregister-ScheduledTask -TaskName $MatchingTasks.TaskName
  } else {
    Write-Verbose "Found no scheduled tasks matching the requested criteria"
  }
}

function Remove-RegistryValues {
  <#
  .SYNOPSIS
    Attempts to remove one or more values from a given path in Windows Registry.
  .DESCRIPTION
    Removes one or more specified values from a given path in Windows Registry, if they exist. Remains silent if they don't exist. Generates a warning in the even of other problems.
  .EXAMPLE
    PS C:\> Remove-RegistryValues -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "AppThatIJustUninstalled-TrayIcon", "AppThatIJustUninstalled-Updater"
    Opens the "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" path of Windows Registry, looks for two values: "AppThatIJustUninstalled-TrayIcon", "AppThatIJustUninstalled-Updater". If they exist, deletes them.
  .INPUTS
    None
  .OUTPUTS
    None
  .NOTES
    Version 1.0
  #>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)] [String] $Path,
    [Parameter(Mandatory, Position = 1)] [String[]] $Name
  )
  if (Test-Path -Path $Path) {
    Remove-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue -ErrorVariable ee
    foreach ($e in $ee) {
      if (-not ($e.Exception -is [System.ArgumentException])) { Write-Warning $e }
    }
  } else {
    Write-Verbose "Could not find '$Path'"
  }
}
