function Test-ProcessAdminRight {
  <#
  .SYNOPSIS
    Returns $True when the process running this script has administrative privileges
  .DESCRIPTION
    Starting with PowerShell 4.0, the "Requires -RunAsAdministrator" directive prevents the execution of the script when administrative privileges are absent. However, there are still times that you'd like to just check the privilege (or lack thereof), e.g., to announce it to the user or downgrade script functionality gracefully.
  .NOTES
    For the Requires directive, see the "about_Requires" help page.
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_requires?view=powershell-7
  #>
  $MyId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal( $MyId )
  return $WindowsPrincipal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
}

function Test-UserAdminMembership {
  <#
  .SYNOPSIS
    Returns $True when the user account running this script is a member of the local Administrators group.
  .DESCRIPTION
    This function checks whether the current user account is a member of the local Administrators group. If the answer is positive, depending on the User Account Control configuration on this machine, this script may either be running with administrative privileges or may request it.
  #>
  $MyId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  return $MyId.Claims.Value.Contains('S-1-5-32-544')
}

function Unregister-ScheduledTaskEx {
  <#
  .SYNOPSIS
    Unregisters several scheduled tasks whose names matches a wildcard pattern (not regex)
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
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # The set of wildcard patterns based on which to search the scheduled tasks.  The task gets unregistered if its name matches one member of this set.
    [Parameter(Mandatory)]
    [SupportsWildcards()]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $TaskNameEx
  )
  $MatchingTasks = Get-ScheduledTask | Where-Object -FilterScript { foreach ($item in $TaskNameEx) { if ($_.TaskName -like $item) { return $true } } }
  if ($null -ne $MatchingTasks) {
    # This command does not seem to respect the $VerbosePreference and asks for confirmation anyway
    # Add -Confirm:$false to make it stop
    Unregister-ScheduledTask -TaskName $MatchingTasks.TaskName -WhatIf:$WhatIfPreference
  } else {
    Write-Verbose "Found no scheduled tasks matching the requested criteria: $TaskNameEx"
  }
}

function Remove-RegistryValue {
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
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, Position = 0)] [String] $Path,
    [Parameter(Mandatory, Position = 1)] [String[]] $Name
  )
  if (Test-Path -Path $Path) {
    Remove-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue -ErrorVariable ee -WhatIf:$WhatIfPreference
    foreach ($e in $ee) {
      if (-not ($e.Exception -is [System.ArgumentException])) { Write-Warning $e }
    }
  } else {
    Write-Verbose "Could not find '$Path'"
  }
}

function New-TemporaryFileName {
  <#
  .SYNOPSIS
    Generates a string to use as your temporary file's name.
  .DESCRIPTION
    Generates a string whose general form is "tmp####.tmp", where #### is a hexadecimal number. This style mimicks the output of the built-in New-TemporaryFile.
  .EXAMPLE
    PS C:\> New-TemporaryFileName
    tmp5B7F.tmp
  .INPUTS
    None
  .OUTPUTS
    System.String
  .NOTES
    Version 1.0
  #>
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
  param ()
  return "tmp$((Get-Random -Maximum 0xFFFF).ToString('X4')).tmp"
}

function New-TemporaryFolderName {
  <#
  .SYNOPSIS
    Generates a string to use as your temporary folder's name.
  .DESCRIPTION
    Generates a string whose general form is "tmp####", where #### is a hexadecimal number. This style mimicks the output of the built-in New-TemporaryFile.
  .EXAMPLE
    PS C:\> New-TemporaryFolderName
    tmp5B7F.tmp
  .INPUTS
    None
  .OUTPUTS
    System.String
  .NOTES
    None
  #>
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
  param ()
  return "tmp$((Get-Random -Maximum 0xFFFF).ToString('X4'))"
}

function Get-AlphabetUpper {
  <#
  .SYNOPSIS
    Returns an array of Char containing 'A' through 'Z'.
  .DESCRIPTION
    Returns an array of Char  with 26 members. The array contains the uppercase alphabet letters 'A' through 'Z'.
  .EXAMPLE
    PS C:\> (Get-AlphabetUpper) -join ', '
    A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
  .INPUTS
    None
  .OUTPUTS
    System.Char[]
  #>

  return [Char[]](65..90)
}

function Get-AlphabetLower {
  <#
  .SYNOPSIS
    Returns an array of Char containing 'a' through 'a'.
  .DESCRIPTION
    Returns an array of Char  with 26 members. The array contains the lowercase alphabet letters 'a' through 'z'.
  .EXAMPLE
    PS C:\> (Get-AlphabetLower) -join ', '
    a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
  .INPUTS
    None
  .OUTPUTS
    System.Char[]
  #>

  return [Char[]](97..122)
}

function Exit-BecauseOsIsNotSupported {
  $PSCmdlet.ThrowTerminatingError(
    [ErrorRecord]::new(
      [PSInvalidOperationException]::new('This operating system is not supported.'),
      'OSNotSupported',
      [ErrorCategory]::InvalidOperation,
      [System.Environment]::OSVersion
    )
  )
}

function Exit-BecauseFolderIsMissing {
  param (
    # Specify one or two words that says what's missing; use lowcase for indefinite nouns
    [Parameter(Mandatory, Position = 0)][String]$Title,
    # Specify the path of the missing folder
    [Parameter(Mandatory, Position = 1)][String]$Path
  )
  $PSCmdlet.ThrowTerminatingError(
    [ErrorRecord]::new(
      [System.IO.DirectoryNotFoundException]::new("Could not find the $Title at '$Path'"),
      'FolderNotFound',
      [ErrorCategory]::ObjectNotFound,
      $Path
    )
  )
}

function Exit-BecauseFileIsMissing {
  param (
    # Specify one or two words that says what's missing; use lowcase for indefinite nouns
    [Parameter(Mandatory, Position = 0)][String]$Title,
    # Specify the path of the missing file
    [Parameter(Mandatory, Position = 1)][String]$Path
  )
  $PSCmdlet.ThrowTerminatingError(
    [ErrorRecord]::new(
      [System.IO.FileNotFoundException]::new("Could not find the $Title at '$Path'"),
      'FileNotFound',
      [ErrorCategory]::ObjectNotFound,
      $Path
    )
  )
}
