function AmIAdmin {
  $MyId=[System.Security.Principal.WindowsIdentity]::GetCurrent()
  $WindowsPrincipal=New-Object System.Security.Principal.WindowsPrincipal( $MyId )
  return $WindowsPrincipal.IsInRole( [System.Security.Principal.WindowsBuiltInRole]::Administrator )
}
