#requires -Version 5.1
using namespace System.Management.Automation
<#
Functions are sorted alphabetically
#>

function ConvertTo-NativeDigits {
  <#
  .SYNOPSIS
    Converts the digits in a string from one language to another. It supports English, Arabic, and
    Persian.
  .DESCRIPTION
    World language may have different alphabets and digits. Therefore, their scripts have different
    Unicode representations. The .NET calls these distinctions "cultures". This function converts
    the input script's digits of one culture to another. It supports English, Arabic, and Persian.
    Unicode represents English digits in U+0030 through U+0039. Arabic digits are U+06F0 through
    U+06F9 (Arabic-Indic Digits). Persian, Dari, Pashto, and Urdu digits are U+0660 through U+0669
    (Extended Arabic-Indic Digits), although script-sensitive fonts render it differently for Urdu.
    Arial is one of the rare script-sensitive fonts that also converts Extended Arabic-Indic Digits
    to Arabic-Indic Digits and vice versa.
  .NOTES

  Digit | Unicode
    ----- | -------
    0     | U+0030
    1     | U+0031
    2     | U+0032
    3     | U+0033
    4     | U+0034
    5     | U+0035
    6     | U+0036
    7     | U+0037
    8     | U+0038
    9     | U+0039

    Digit | Unicode
    ----- | -------
    ۰     | U+06F0
    ۱     | U+06F1
    ۲     | U+06F2
    ۳     | U+06F3
    ۴     | U+06F4
    ۵     | U+06F5
    ۶     | U+06F6
    ۷     | U+06F7
    ۸     | U+06F8
    ۹     | U+06F9

    Digit | Unicode
    ----- | -------
    ٠     | U+0660
    ١     | U+0661
    ٢     | U+0662
    ٣     | U+0663
    ٤     | U+0664
    ٥     | U+0665
    ٦     | U+0666
    ٧     | U+0667
    ٨     | U+0668
    ٩     | U+0669

  .EXAMPLE
    PS C:\> ConvertTo-NativeDigits -InputString "1a12b23c34d45e56f67g78h89i90j0" -TargetCulture "ar"
    ١a١٢b٢٣c٣٤d٤٥e٥٦f٦٧g٧٨h٨٩i٩٠j٠

    Converts "1a12b23c34d45e56f67g78h89i90j0" to "١a١٢b٢٣c٣٤d٤٥e٥٦f٦٧g٧٨h٨٩i٩٠j٠".
  #>
  param (
    # Input string subject to digit conversion
    [Parameter(Mandatory)]
    [string]
    $InputString,

    # Input culture
    [Parameter()]
    [ValidateSet("ar", "en", "fa")]
    [string]
    $InputCulture = "en",

    # Target culture
    [Parameter()]
    [ValidateSet("ar", "en", "fa")]
    [string]
    $TargetCulture = "fa"
  )
  if ($InputCulture -eq $TargetCulture) { return $InputString }

  $SrcN = [System.Globalization.CultureInfo]::new($InputCulture).NumberFormat.NativeDigits
  $TgtN = [System.Globalization.CultureInfo]::new($TargetCulture).NumberFormat.NativeDigits

  $OutputStringBuilder = [System.Text.StringBuilder]::new($InputString)

  for ($i = 0; $i -lt $SrcN.Count; $i++) {
    $OutputStringBuilder.Replace($SrcN[$i], $TgtN[$i]) | Out-Null
  }

  return $OutputStringBuilder.ToString()
}

function Exit-BecauseFileIsMissing {
  param (
    # Specify one or two words that says what's missing; use lowercase for indefinite nouns
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

function Exit-BecauseFolderIsMissing {
  param (
    # Specify one or two words that says what's missing; use lowercase for indefinite nouns
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

function New-TemporaryFileName {
  <#
  .SYNOPSIS
    Generates a string to use as your temporary file's name.
  .DESCRIPTION
    Generates a string whose general form is "tmp####.tmp", where #### is a hexadecimal number. This style simulates the output of the built-in New-TemporaryFile.
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
    Generates a string whose general form is "tmp####", where #### is a hexadecimal number. This style simulates the output of the built-in New-TemporaryFile.
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

function Reset-PSEnvPath {
  <#
  .SYNOPSIS
    Reverts the PATH and PSModulePath environment variables to the logon-time values from Registry.
  .DESCRIPTION
    Reverts the PATH and PSModulePath environment variables to the logon-time values from Registry,
    discarding any changes that the parent process has made in them. For the details in the impact
    of these variables, see:
    <https://github.com/PowerShell/PowerShell/issues/8635>
  #>
  $env:PATH         = $([Environment]::GetEnvironmentVariable('PATH', 'Machine')) +';'+$([Environment]::GetEnvironmentVariable('PATH', 'User'))
  $env:PSModulePath =   [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')
}

function Test-ProcessAdminRight {
  <#
  .SYNOPSIS
    Returns $True when the process running this script has administrative privileges
  .DESCRIPTION
    Starting with PowerShell 4.0, the "Requires -RunAsAdministrator" directive prevents the execution of the script when administrative privileges are absent. However, there are still times that you'd like to just check the privilege (or lack thereof), e.g., to announce it to the user or downgrade script functionality gracefully.
  .NOTES
    For the Requires directive, see the "about_Requires" help page.
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_requires
  #>
  $MyId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal( $MyId )
  return $WindowsPrincipal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
}

function Test-UserAdminMembershipDirect {
  <#
  .SYNOPSIS
    Returns $True when the user account running this script is a **direct** member of the local Administrators group.
  .DESCRIPTION
    This function checks whether the current user account is a **direct** member of the local Administrators group. However, even when this function returns $False, the user account may still be a nested member of said group.

    This function has several use cases, but it is not a reliable test as to whether the script running it has administrative privileges. (For that purpose, use Test-ProcessAdminRight.)
  #>
  $MyId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  return $MyId.Name -in $(Get-LocalGroupMember -Name Administrators).Name
}

function Test-UserAdminMembershipRecursive {
  <#
  .SYNOPSIS
    Returns $True when the user account running this script is a member (direct or nested) of the local Administrators group.
  .DESCRIPTION
    This function checks whether the current user account is a member of the local Administrators group or one of its subgroups.

    This function is not a reliable test as to whether the script running it has administrative privileges. (For that purpose, use Test-ProcessAdminRight.) However, it has several use cases, one of which is knowing whether the current user can request elevated access through the User Account Control.
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
    Extremely dangerous. Use with caution.
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