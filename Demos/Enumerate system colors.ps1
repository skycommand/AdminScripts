#Requires -Version 5.1

using namespace System.Drawing

function PublicStaticVoidMain {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification = "This script targets terminal emulators to diagnose their use of ANSI escape sequences. There is no point in running it headless. In addition, as of PowerShell 5.1, the PSAvoidUsingWriteHost warning is entirely meaningless because Write-Host has become a wrapper for Write-Information.")]
  param ()

  [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Out-Null

  [Char]$ESC = [Char]27
  $FullBlock = "$ESC[48;2;{0};{1};{2}m`u{20}`u{20}`u{20}`u{20}`u{20}$ESC[0m"

  [Type]$SystemColorsType = 'SystemColors'
  $SystemColorsProperties = $SystemColorsType.GetProperties()

  foreach ($SystemColorsProperty in $SystemColorsProperties) {
    $ColorName = $SystemColorsProperty.Name
    $ColorValue =  $SystemColorsProperty.GetValue($SystemColorsType, $null)
    $ColorHexNotation = "0x{0:X2}{1:X2}{2:X2}" -f $ColorValue.R, $ColorValue.G, $ColorValue.B
    $ColorRendering = $FullBlock -f $ColorValue.R, $ColorValue.G, $ColorValue.B

    Write-Host -Object $('{0} {1,23} {2}' -f $ColorRendering, $ColorName, $ColorHexNotation)
  }
}

PublicStaticVoidMain