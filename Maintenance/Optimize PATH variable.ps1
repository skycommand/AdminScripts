<#
.SYNOPSIS
  Optimizes the PATH environment variable.

.DESCRIPTION
  In Microsoft Windows, the PATH environment variable contains a list of folder pathes. When a user
  asks the OS to run an executable file without specifying a fully qualified path, the OS searches
  folders listed in the PATH environment variable for the executable file. It is because of PATH
  that we can tell Windows to run "notepad" without knowing where Notepad.exe resides.

  This command removes duplicate and invalid entries from the PATH environment variable.

.EXAMPLE
  PS C:\> & .\Optimize-EnvPath.ps1
  Reads the PATH environment variable and returns an optimized version.
#>

#Requires -Version 5.1

using namespace System.Management.Automation
using namespace System.Collections.Generic

[CmdletBinding()]
param()

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

function Convert-EnvPathToList {
  param (
    # The string object containing a valid Path environment variable
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [String]
    $InputObject
  )

  [Char]$DirSep1 = [Io.Path]::DirectorySeparatorChar
  [Char]$DirSep2 = [Io.Path]::AltDirectorySeparatorChar
  [Char]$PathSep = [Io.Path]::PathSeparator
  [Char]$TextQualifier = '"'

  function CleanPath {
    param ([Parameter(Mandatory, Position = 0)][String]$InputObject)
    return $InputObject.Trim($TextQualifier, ' ').TrimEnd($DirSep1, $DirSep2)
  }

  $InputObjectLength = $InputObject.Length
  If ($InputObjectLength -lt 2) { return $InputObject }

  # Hash sets don't accept duplicates
  [HashSet[String]]$list = New-Object -TypeName 'HashSet[String]' -ArgumentList ([StringComparer]::CurrentCultureIgnoreCase)

  <#
  We can't use PowerShell's splitting operator (-split) because:
  
  - It doesn't support text qualifiers.
  - It doesn't discard zero-length strings.

  The following block of code implements a splitter.
  #>
  $StartPos = 0;
  $InhibitSearch = $false
  for ($i = 0; $i -lt $InputObjectLength; $i++) {
    $CurChar = $InputObject[$i]

    if ($CurChar -eq $TextQualifier) {
      $InhibitSearch = -not $InhibitSearch
      continue
    }

    if ($CurChar -eq $PathSep) {
      if ($InhibitSearch) { continue }
      if ($StartPos -eq $i) {
        $StartPos = $i + 1
        continue
      }

      $a = CleanPath $InputObject.Substring($StartPos, $i - $StartPos)
      if ('' -ne $a) { [Void]$list.Add($a) }
      $StartPos = $i + 1
      continue
    }

    if ($i + 1 -eq $InputObjectLength) {
      $a = CleanPath $InputObject.Substring($StartPos, $i - $StartPos + 1)
      if ('' -ne $a) { [Void]$list.Add($a) }
    }
  }

  return $list
}

function ValidatePathList {
  param(
    [Parameter(Mandatory, Position=0)]
    [ValidateNotNullOrEmpty()]
    [HashSet[String]] # HashSet data types are always sent to a function by reference
    $InputObject
  )

  [Char]$PathSep = [Io.Path]::PathSeparator
  [Char]$TextQualifier = '"'

  # The output object also needs to be a HashSet because after normalizing two seemingly different
  # paths, they may become duplicates.
  [HashSet[String]]$OutputObject = New-Object -TypeName 'HashSet[String]' -ArgumentList $InputObject.Count

  foreach ($Element in $InputObject) {
    if (-not (Test-Path -LiteralPath $Element -PathType Container)) {
      Write-Verbose -Message "Not found: $Element"
      continue
    }

    # Resolve convoluted paths
    # The cmdlet doesn't trim the trailing slahs or backslash
    $Element = (Resolve-Path -LiteralPath $Element).Path

    # Wrap the path in double quotation marks if it contains a $PathSep
    if ($Element.Contains($PathSep)) { $Element = [String]::Concat($TextQualifier, $Element, $TextQualifier) }

    # Write the new element to the hash set
    [Void]$OutputObject.Add($Element)
  }

  return $OutputObject
}

function Optimize-EnvPath {
  $SomethingChanged = $false

  $UserEnvPathIn = [Environment]::GetEnvironmentVariable('Path', 'User').TrimEnd(';')
  $MachineEnvPathIn = [Environment]::GetEnvironmentVariable('Path', 'Machine').TrimEnd(';')

  [HashSet[String]]$UserEnvPathListIn = Convert-EnvPathToList -InputObject $UserEnvPathIn
  [HashSet[String]]$MachineEnvPathListIn = Convert-EnvPathToList -InputObject $MachineEnvPathIn

  $UserEnvPathListIn.ExceptWith($MachineEnvPathListIn)

  $UserEnvPathListOut = ValidatePathList -InputObject $UserEnvPathListIn
  $MachineEnvPathListOut = ValidatePathList -InputObject $MachineEnvPathListIn

  $UserEnvPathOut = $UserEnvPathListOut -Join ';'
  $MachineEnvPathOut = $MachineEnvPathListOut -Join ';'

  if ($MachineEnvPathIn -ne $MachineEnvPathOut) {
    $SomethingChanged = $true
    Write-Output "`r`nInitial machine paths: `r`n$MachineEnvPathIn"
    Write-Output "`r`nOptimized machine paths: `r`n$MachineEnvPathOut"
    if (Test-ProcessAdminRight) {
      Write-Output "`r`nWe are now applying the optimized paths to the machine."
      [Environment]::SetEnvironmentVariable('Path', $MachineEnvPathOut, 'Machine')
    } else {
      Write-Output "`r`nWe could not apply the optimized path because of insufficient privileges."
    }
  }
  if ($UserEnvPathIn -ne $UserEnvPathOut) {
    $SomethingChanged = $true
    Write-Output "`r`nInitial user paths: `r`n$UserEnvPathIn"
    Write-Output "`r`nOptimized user paths: `r`n$UserEnvPathOut"
    Write-Output "`r`nWe are now applying the optimized paths to the user."
    [Environment]::SetEnvironmentVariable('Path', $UserEnvPathOut, 'User')
  }
  if (!$SomethingChanged) {
    Write-Output "No optimizations were needed."
  }
}

function ValidateOS {
  if (($PSVersionTable.PSVersion.Major -gt 5) -and ($PSVersionTable.Platform -ne 'Win32NT')) {
    $PSCmdlet.ThrowTerminatingError(
      [System.Management.Automation.ErrorRecord]::new(
        ([System.PlatformNotSupportedException]"This maintenance operation is only applicable to Microsoft Windows"),
        'PlatformCheck',
        [System.Management.Automation.ErrorCategory]::NotImplemented,
        $PSVersionTable.Platform
      )
    )
  }
}

ValidateOS
Optimize-EnvPath @args -Verbose
