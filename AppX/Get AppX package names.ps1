[CmdletBinding()]

<#
C# code to expose SHLoadIndirectString(), derived from:
  Title:    Expand-IndirectString.ps1
  Author:   Jason Fossen, Enclave Consulting LLC (www.sans.org/sec505)
  Date:     20 September 2016
  URL:      https://github.com/SamuelArnold/StarKill3r/blob/master/Star%20Killer/Star%20Killer/bin/Debug/Scripts/SANS-SEC505-master/scripts/Day1-PowerShell/Expand-IndirectString.ps1
  License: "Public domain, no rights reserved, no warranties or guarantees."
#>
$CSharpSHLoadIndirectString = @'
using System;
using System.Text;
using System.Runtime.InteropServices;

public class IndirectStrings
{
  [DllImport("shlwapi.dll", BestFitMapping = false, CharSet = CharSet.Unicode, ExactSpelling = true, SetLastError = false, ThrowOnUnmappableChar = true)]
  internal static extern int SHLoadIndirectString(string pszSource, StringBuilder pszOutBuf, uint cchOutBuf, IntPtr ppvReserved);

  public static string GetIndirectString(string indirectString)
  {
    StringBuilder lptStr = new StringBuilder(1024);
    int returnValue = SHLoadIndirectString(indirectString, lptStr, (uint)lptStr.Capacity, IntPtr.Zero);

    return returnValue == 0 ? lptStr.ToString() : null;
  }
}
'@

# Add the IndirectStrings type to PowerShell
Add-Type -TypeDefinition $CSharpSHLoadIndirectString -Language CSharp

<#
Usage examples:

  $instr1 = '@%SystemRoot%\system32\shell32.dll,-21801'
  $instr2 = '@{This.is.deliberately.invalid}'
  $instr3 = '@{c5e2524a-ea46-4f67-841f-6a9465d9d515_10.0.18362.267_neutral_neutral_cw5n1h2txyewy?ms-resource://FileExplorer/Resources/AppxManifest_DisplayName}'

  [IndirectStrings]::GetIndirectString( $instr1 )
  [IndirectStrings]::GetIndirectString( $instr2 )
  [IndirectStrings]::GetIndirectString( $instr3 )
#>

# Get a list of Appx packages
$AppxPackages = Get-AppxPackage @args
$AppxSum = $AppxPackages.Count

# Create an array to store Appx identities
Class AppxIdentity {
  [ValidateNotNullOrEmpty()][string]$Name
  [string]$DisplayNameResolved
  [string]$DisplayNameRaw
}
[AppxIdentity[]]$AppxIdentities = [AppxIdentity[]]::New($AppxSum)

# Access the AppX repository in the Registry
Push-Location "Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Packages"

for ($i = 0; $i -lt $AppxSum; $i++) {
  # These variables help make the code more compact
  # AXN, AXF and AXI respectively mean AppX Name, AppX Fullname and AppX Identity
  $AXN = $AppxPackages[$i].Name
  $AXF = $AppxPackages[$i].PackageFullName
  $AXI = New-Object -TypeName AppxIdentity

  # The first property is easy to acquire
  $AXI.Name = $AXN

  #The display name is stored in the Registry
  If (Test-Path $AXF) {
    try {
      $AXI.DisplayNameRaw = (Get-ItemProperty -Path $AXF -Name DisplayName).DisplayName
      if ($AXI.DisplayNameRaw -match '^@') {
        $AXI.DisplayNameResolved = [IndirectStrings]::GetIndirectString( $AXI.DisplayNameRaw )
        if ($AXI.DisplayNameResolved -eq '') {
          Write-Warning "Could not resolve the display name for $($AXN)."
        }
      } else {
        $AXI.DisplayNameResolved = $AXI.DisplayNameRaw
        if ($AXI.DisplayNameRaw -match '^ms-resource\:') {
          Write-Verbose "For the want of an `@, a kingdom is lost. $($AXN) has a bad display name."
        }
      }
    } catch {
      Write-Verbose "There are no display names associated with $($AXN)."
    }
  }

  #Hand over the info
  $AppxIdentities[$i] = $AXI
}

Pop-Location

$AppxIdentities
