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
  $MyId=[System.Security.Principal.WindowsIdentity]::GetCurrent()
  $WindowsPrincipal=New-Object System.Security.Principal.WindowsPrincipal( $MyId )
  return $WindowsPrincipal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
}
