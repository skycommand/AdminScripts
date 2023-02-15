#Requires -Version 5.1

using namespace System.Drawing

function PublicStaticVoidMain {
  param ()

  Add-Type -AssemblyName 'System.Drawing'

  [Char]$ESC = [Char]27
  $PowerShell5CompatibleTemplate = "$ESC[48;2;{0};{1};{2}m    $ESC[0m {3,23} 0x{0:X2}{1:X2}{2:X2}"


  [Type]$SystemColorsType = 'SystemColors'
  $SystemColorsProperties = $SystemColorsType.GetProperties()

  foreach ($SystemColorsProperty in $SystemColorsProperties) {
    $ColorName = $SystemColorsProperty.Name
    $ColorValue =  $SystemColorsProperty.GetValue($SystemColorsType, $null)

    $FullLine = $PowerShell5CompatibleTemplate -f $ColorValue.R, $ColorValue.G, $ColorValue.B, $ColorName
    Write-Output -InputObject $FullLine
  }
}

PublicStaticVoidMain