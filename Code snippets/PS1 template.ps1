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

#Requires -Version 5.1

using namespace System.Management.Automation

[CmdletBinding()]
param()

function PublicStaticVoidMain {
  # No [CmdletBinding()] or param() allowed here!
  # Define parameter is in the main param() block above.

  # Your code goes here.

}

PublicStaticVoidMain @args
