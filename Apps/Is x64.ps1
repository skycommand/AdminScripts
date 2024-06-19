<#
.SYNOPSIS
  Determines whether an EXE file is marked as x64.
.DESCRIPTION
  Determines whether an EXE file is marked as x64.
.EXAMPLE
  PS C:\> & "Is x64.ps1" -LiteralPath C:\Windows\Notepad.exe
  True
.INPUTS
  None
.OUTPUTS
  Boolean
.NOTES
  None
#>

#Requires -Version 5.1

using namespace System.Management.Automation

[CmdletBinding()]
param (
  <#
  Specifies a path to an executable file. Unlike the Path parameter, the value of the LiteralPath
  parameter is used exactly as it is typed. No characters are interpreted as wildcards. If the path
  includes escape characters, enclose it in single quotation marks. Single quotation marks tell
  Windows PowerShell not to interpret any characters as escape sequences.
  #>
  [Parameter(
    Mandatory,
    Position = 0,
    ParameterSetName = "LiteralPath",
    ValueFromPipelineByPropertyName,
    HelpMessage = "Literal path to an executable file.")]
  [Alias("PSPath", "Path")]
  [ValidateNotNullOrEmpty()]
  [string]
  $LiteralPath
)

[UInt16]$MZIdentifier = 0x5A4D # MZ
[UInt16]$PEIdentifier = 0x4550 # PE
[UInt16]$64Identifier = 0x8664
$PeOffset = 60
$MachineOffset = 4
$MemoryStreamSize = 2kB

function MachineUIntToString {
  [OutputType([String])]
  param (
    [UInt16]$InputObject
  )
  switch ($InputObject) {
    0x0000 { return "Unknown machine type" }
    0x014c { return "Intel 386 or later family processors" }
    0x0166 { return "MIPS little endian" }
    0x0169 { return "MIPS little-endian WCE v2" }
    0x01a2 { return "Hitachi SH3" }
    0x01a3 { return "Hitachi SH3 DSP" }
    0x01a6 { return "Hitachi SH4" }
    0x01a8 { return "Hitachi SH5" }
    0x01c0 { return "ARM little endian" }
    0x01c2 { return "ARM or Thumb (`“interworking`”)" }
    0x01c4 { return "ARMv7 (or higher) Thumb mode only" }
    0x01d3 { return "Matsushita AM33" }
    0x01f0 { return "Power PC little endian" }
    0x01f1 { return "Power PC with floating point support" }
    0x0200 { return "Intel Itanium processor family" }
    0x0266 { return "MIPS16" }
    0x0366 { return "MIPS with FPU" }
    0x0466 { return "MIPS16 with FPU" }
    0x0ebc { return "EFI byte code" }
    0x8664 { return "x64" }
    0x9041 { return "Mitsubishi M32R little endian" }
    0xaa64 { return "ARMv8 in 64-bit mode" }
  }
}

function TerminateBadEXE {
  $PSCmdlet.ThrowTerminatingError(
    [ErrorRecord]::new(
      [IO.FileFormatException]::new('The specified file is not a valid Windows EXE.'),
      'BadFileFormat',
      [ErrorCategory]::MetadataError,
      $LiteralPath
    )
  )
}

if (-not (Test-Path -Path $LiteralPath -PathType Leaf)) {
  $PSCmdlet.ThrowTerminatingError(
    [ErrorRecord]::new(
      [IO.FileNotFoundException]::new(),
      'ObjectNotFound',
      [ErrorCategory]::ObjectNotFound,
      $LiteralPath
    )
  )
}

try {
  [Byte[]]$Data = [Byte[]]::new($MemoryStreamSize)
  $MyFileStream = [IO.FileStream]::new($LiteralPath, 'Open', 'Read')
  $MyFileStream.Read($Data, 0, $MemoryStreamSize) | Out-Null
} catch {
  throw
}
finally {
  if ($null -ne $MyFileStream) { $MyFileStream.Close() }
}

if ($MZIdentifier -ne [BitConverter]::ToUInt16($Data, 0)) {
  TerminateBadEXE
}

$PeHeaderAddress = [BitConverter]::ToInt32($Data, $PeOffset)
if ($PEIdentifier -ne [BitConverter]::ToUInt16($Data, $PeHeaderAddress)) {
  TerminateBadEXE
}

$MachineUInt = [BitConverter]::ToUInt16($data, $PeHeaderAddress + $MachineOffset)
Write-Verbose -Message $(MachineUIntToString -InputObject $MachineUInt)
return ($64Identifier -eq $MachineUInt)