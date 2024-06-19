#Requires -Version 5.1

<#
.SYNOPSIS
  Returns the package identities and display names of all installed packaged apps (AppX)
.DESCRIPTION
  Get-AppxPackage returns a list of all installed packaged apps, along with their "Name",
  "PackageFullName", and "PackageFamilyName" properties. None of these are human-consumable. For
  example, what is "58027.265370AB8DB33_fjemmk5ta3a5g"? This script reveals the display name of all
  installed packaged apps.
.NOTES
  DEPRECATED

  This script depends on Get-AppxPackage and its Appx module. As such, it won't work in PowerShell
  6 and later.

  Instead of this script, consider using WinGet.exe.
.LINK
  None
.EXAMPLE
  PS > & 'Get AppX package names.ps1'

  WARNING: Could not resolve the display name for 1527c705-839a-4832-9118-54d4Bd6a0c89.

  Name                                             DisplayName
  ----                                             -----------
  1527c705-839a-4832-9118-54d4Bd6a0c89
  40459File-New-Project.EarTrumpet                 EarTrumpet
  48548MarcinOtorowski.MSIXHero                    MSIX Hero
  58027.265370AB8DB33                              Character Map UWP
  64360VelerSoftware.DevToys                       DevToys
  c5e2524a-ea46-4f67-841f-6a9465d9d515             File Explorer
  E2A4F912-2574-4A75-9BB0-0D023378592B             App Resolver
  F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE             Add Folder Suggestions dialog
  Microsoft.136853439117B                          Ink Journal
  Microsoft.AAD.BrokerPlugin                       Work or school account
  Microsoft.AccountsControl                        Email and accounts
  Microsoft.BioEnrollment                          Windows Hello Setup
  Microsoft.ECApp                                  Eye Control
  Microsoft.Win32WebViewHost                       Desktop App Web Viewer
  Microsoft.Windows.Apprep.ChxApp                  Windows Defender SmartScreen
  Microsoft.Windows.CloudExperienceHost            Your account
  Microsoft.Windows.ContentDeliveryManager         Microsoft Content
  Microsoft.Windows.PeopleExperienceHost           Windows Shell Experience
  Microsoft.Windows.SecHealthUI                    Windows Security
  Microsoft.Windows.SecureAssessmentBrowser        Take a Test
  Microsoft.Windows.ShellExperienceHost            Windows Shell Experience
  Microsoft.Windows.StartMenuExperienceHost        Start
  Microsoft.Windows.XGpuEjectDialog                Safely Remove Device
  microsoft.windowscommunicationsapps              Mail and Calendar
  Microsoft.XboxGamingOverlay                      Game Bar
  windows.immersivecontrolpanel                    Settings
#>

[CmdletBinding()]
param ()

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
  [string]$DisplayName
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
      $EncodedName = (Get-ItemProperty -Path $AXF -Name DisplayName).DisplayName
      if ($EncodedName -match '^@') {
        $AXI.DisplayName = [IndirectStrings]::GetIndirectString( $EncodedName )
        if ($AXI.DisplayName -eq '') {
          Write-Warning "Could not resolve the display name for $AXN."
       }
      } else {
        $AXI.DisplayName = $EncodedName
        if ($EncodedName -match '^ms-resource\:') {
          Write-Verbose "For the want of an `@, a kingdom is lost. $AXN has a bad display name."
        }
      }
    } catch {
      Write-Verbose "There are no display names associated with $AXN."
    }
  }

  #Hand over the info
  $AppxIdentities[$i] = $AXI
}

Pop-Location

$AppxIdentities
