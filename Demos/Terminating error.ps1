#Requires -Version 5.1

<#
.SYNOPSIS
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
  Inputs (if any)
.OUTPUTS
  Output (if any)
.NOTES
  General notes
#>

using namespace System.Management.Automation

[CmdletBinding()]
param()

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

function IntermediateFunction {
  Write-Information -MessageData "You should be seeing an error message after this line." -InformationAction "Continue"
  Exit-BecauseOsIsNotSupported
  Write-Information -MessageData "You mustn't be seeing this line (instance 1)." -InformationAction "Continue"
}

IntermediateFunction
Write-Information -MessageData "You mustn't be seeing this line (instance 2)." -InformationAction "Continue"