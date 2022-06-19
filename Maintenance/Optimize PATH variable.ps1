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
  [HashSet[String]]$list = New-Object -TypeName 'HashSet[String]'

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

  foreach ($Element in $InputObject) {
    if (Test-Path -LiteralPath $Element -PathType Container) {
      if ($Element.Contains($PathSep)) { $Element = [String]::Concat($TextQualifier, $Element, $TextQualifier) }
      continue
    }
    Write-Verbose -Message "Not found: $Element"
    if ($InputObject.Remove($Element)) { continue }
    Write-Warning -Message "Assertion failure: Could not remove $Element"
  }
}

function Optimize-EnvPath {
  $UserEnvPathIn = [Environment]::GetEnvironmentVariable('Path', 'User')
  $MachineEnvPathIn = [Environment]::GetEnvironmentVariable('Path', 'Machine')

  [HashSet[String]]$UserEnvPathList = Convert-EnvPathToList -InputObject $UserEnvPathIn
  [HashSet[String]]$MachineEnvPathList = Convert-EnvPathToList -InputObject $MachineEnvPathIn

  $UserEnvPathList.ExceptWith($MachineEnvPathList)

  ValidatePathList -InputObject $UserEnvPathList
  ValidatePathList -InputObject $MachineEnvPathList

  $UserEnvPathOut = $UserEnvPathList -Join ';'
  $MachineEnvPathOut = $MachineEnvPathList -Join ';'

  Write-Output "`r`nInitial machine paths: `r`n$MachineEnvPathIn"
  Write-Output "`r`nOptimized machine paths: `r`n$MachineEnvPathOut"
  Write-Output "`r`nInitial user paths: `r`n$UserEnvPathIn"
  Write-Output "`r`nOptimized user paths: `r`n$UserEnvPathOut"
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
