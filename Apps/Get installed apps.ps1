#Requires -Version 5.1

<#
.SYNOPSIS
  Queries Windows Registry for a list of installed apps
.DESCRIPTION  
  This script queries Windows Registry for a list of apps that have registered uninstallers, and
  displays their target CPU architecture (Arch), friendly name, and their registered uninstaller. 
  In Windows PowerShell 5.1, you could accomplish the same via the `Get-Package` cmdlet because
  Windows comes bundled with a "Programs" package provider. This provider is not available in
  PowerShell 7.0 and later.
.EXAMPLE  
  PS C:\> & '.\Get installed apps.ps1' | Format-Table

  Arch  Scope Name                                   Display name                                         Uninstall string
  ----  ----- ----                                   ------------                                         ----------------
  x64   HKLM  {B59E8D78-7A0F-4246-ACB8-9867B22FDBD3} Microsoft .NET 8.0 Templates 8.0.300 (x64)           MsiExec.exe /I{B59E8D78-7A0F-4246-ACB8-9867B22FDBD3}
  x64   HKLM  {6F2714E0-EFB0-40D1-AD1D-6BFA5900312C} Microsoft .NET AppHost Pack - 8.0.5 (x64_arm64)      MsiExec.exe /X{6F2714E0-EFB0-40D1-AD1D-6BFA5900312C}
  x64   HKLM  {340DA01F-6675-4679-B779-691CA048D9B0} Microsoft .NET AppHost Pack - 8.0.5 (x64_x86)        MsiExec.exe /X{340DA01F-6675-4679-B779-691CA048D9B0}
  x64   HKLM  {F904B9A8-A0A9-42FA-8132-2E1EEC523722} Microsoft .NET AppHost Pack - 8.0.5 (x64)            MsiExec.exe /X{F904B9A8-A0A9-42FA-8132-2E1EEC523722}
  x64   HKLM  {59ED1DC1-E3E4-4BC0-B43F-143CCC38FF17} Microsoft .NET Host - 6.0.31 (x64)                   MsiExec.exe /X{59ED1DC1-E3E4-4BC0-B43F-143CCC38FF17}
  x64   HKLM  {8FB40332-CD49-4E77-A40D-E2D09368632D} Microsoft .NET Host - 8.0.5 (x64)                    MsiExec.exe /X{8FB40332-CD49-4E77-A40D-E2D09368632D}
  x64   HKLM  {9992D04E-553E-4BC2-B0EC-4A394DD19986} Microsoft .NET Host FX Resolver - 6.0.31 (x64)       MsiExec.exe /X{9992D04E-553E-4BC2-B0EC-4A394DD19986}
  x64   HKLM  {25F6351D-21A3-4E92-964E-01E864A21AB1} Microsoft .NET Host FX Resolver - 8.0.5 (x64)        MsiExec.exe /X{25F6351D-21A3-4E92-964E-01E864A21AB1}
  x64   HKLM  {0950F07D-F1C4-47A5-AC88-C5FAA5DC564D} Microsoft .NET Runtime - 6.0.31 (x64)                MsiExec.exe /X{0950F07D-F1C4-47A5-AC88-C5FAA5DC564D}
  x64   HKLM  {26037618-FB6D-47BC-9F99-4C4323C4CEC6} Microsoft .NET Runtime - 8.0.5 (x64)                 MsiExec.exe /X{26037618-FB6D-47BC-9F99-4C4323C4CEC6}
  x64   HKLM  {13521D8E-D3F7-4EC0-9C01-9BE446A061DC} Microsoft .NET SDK 8.0.300 (x64) from Visual Studio  MsiExec.exe /X{13521D8E-D3F7-4EC0-9C01-9BE446A061DC}
  x64   HKLM  {A7036CFB-B403-4598-85FF-D397ABB88173} Microsoft .NET Standard Targeting Pack - 2.1.0 (x64) MsiExec.exe /X{A7036CFB-B403-4598-85FF-D397ABB88173}
  x64   HKLM  {A8A2D7E9-E01C-477D-8706-204B85010D87} Microsoft .NET Targeting Pack - 8.0.5 (x64)          MsiExec.exe /X{A8A2D7E9-E01C-477D-8706-204B85010D87}
  x64   HKLM  {C6661EB8-C8EC-447C-8BD6-6439592AF0D8} Microsoft .NET Toolset 8.0.300 (x64)                 MsiExec.exe /X{C6661EB8-C8EC-447C-8BD6-6439592AF0D8}
  x64   HKLM  {A1AA40D8-C0B3-3620-A12D-CC4E43CFEBAD} Microsoft ASP.NET Core 8.0.5 Shared Framework (x64)  MsiExec.exe /X{A1AA40D8-C0B3-3620-A12D-CC4E43CFEBAD}
  x64   HKLM  {34F17197-6239-3B55-851C-B21B1F6C926D} Microsoft ASP.NET Core 8.0.5 Targeting Pack (x64)    MsiExec.exe /X{34F17197-6239-3B55-851C-B21B1F6C926D}
  x64   HKLM  OneDriveSetup.exe                      Microsoft OneDrive                                   "C:\Program Files\Microsoft OneDrive\24.108.0528....
  x64   HKLM  {5BC7E9EB-13E8-45DB-8A60-F2481FEB4595} Microsoft System CLR Types for SQL Server 2019       MsiExec.exe /I{5BC7E9EB-13E8-45DB-8A60-F2481FEB4595}
  x64   HKLM  {1FC1A6C2-576E-489A-9B4A-92D21F542136} Microsoft Update Health Tools                        MsiExec.exe /X{1FC1A6C2-576E-489A-9B4A-92D21F542136}
  x64   HKLM  {6F320B93-EE3C-4826-85E0-ADF79F8D4C61} Microsoft Visual Studio Installer                   "C:\Program Files (x86)\Microsoft Visual Studio\In...
  x64   HKLM  {EFE53353-800E-4987-B965-1C968D0F23A4} Microsoft Windows Desktop Runtime - 6.0.31 (x64)     MsiExec.exe /X{EFE53353-800E-4987-B965-1C968D0F23A4}
  x64   HKLM  {CE4D0B17-4E11-41F9-8C3B-73F61DFE0797} Microsoft Windows Desktop Runtime - 8.0.5 (x64)      MsiExec.exe /X{CE4D0B17-4E11-41F9-8C3B-73F61DFE0797}
  IA-32 HKLM  {A18D4C2A-07A8-40E4-9797-DD324E6EA4FC} Microsoft .NET Framework 4.6.2 Targeting Pack        MsiExec.exe /X{A18D4C2A-07A8-40E4-9797-DD324E6EA4FC}
  IA-32 HKLM  {C80951BD-6904-474F-BBC5-03A6C777F37C} Microsoft .NET Framework 4.6.2 Targeting Pack (ENU)  MsiExec.exe /X{C80951BD-6904-474F-BBC5-03A6C777F37C}
  IA-32 HKLM  {EC073C7E-990D-4BB1-BFA9-45C6704E3571} Microsoft .NET Framework 4.7 Targeting Pack          MsiExec.exe /X{EC073C7E-990D-4BB1-BFA9-45C6704E3571}
  IA-32 HKLM  {829CB0F4-AB51-4DB7-8CA2-1C93CCC36D5E} Microsoft .NET Framework 4.7 Targeting Pack (ENU)    MsiExec.exe /X{829CB0F4-AB51-4DB7-8CA2-1C93CCC36D5E}
  IA-32 HKLM  {5686C5E9-A3B3-451E-A2EA-4C246CDE5CC9} Microsoft .NET Framework 4.7.1 Targeting Pack        MsiExec.exe /X{5686C5E9-A3B3-451E-A2EA-4C246CDE5CC9}
  IA-32 HKLM  {1784A8CD-F7FE-47E2-A87D-1F31E7242D0D} Microsoft .NET Framework 4.7.2 Targeting Pack        MsiExec.exe /X{1784A8CD-F7FE-47E2-A87D-1F31E7242D0D}
  IA-32 HKLM  {B517DBD3-B542-4FC8-9957-FFB2C3E65D1D} Microsoft .NET Framework 4.7.2 Targeting Pack (ENU)  MsiExec.exe /X{B517DBD3-B542-4FC8-9957-FFB2C3E65D1D}
  IA-32 HKLM  {949C0535-171C-480F-9CF4-D25C9E60FE88} Microsoft .NET Framework 4.8 SDK                     MsiExec.exe /X{949C0535-171C-480F-9CF4-D25C9E60FE88}
  IA-32 HKLM  {BAAF5851-0759-422D-A1E9-90061B597188} Microsoft .NET Framework 4.8 Targeting Pack          MsiExec.exe /X{BAAF5851-0759-422D-A1E9-90061B597188}
  IA-32 HKLM  {A4EA9EE5-7CFF-4C5F-B159-B9B4E5D2BDE2} Microsoft .NET Framework 4.8 Targeting Pack (ENU)    MsiExec.exe /X{A4EA9EE5-7CFF-4C5F-B159-B9B4E5D2BDE2}
  IA-32 HKLM  {81EF376F-C9A1-42A3-8997-22A1DE4687F0} Microsoft .NET Framework 4.8.1 SDK                   MsiExec.exe /X{81EF376F-C9A1-42A3-8997-22A1DE4687F0}
  IA-32 HKLM  {8DD67B10-D676-4CCF-B141-E17A6B135016} Microsoft .NET Framework 4.8.1 Targeting Pack        MsiExec.exe /X{8DD67B10-D676-4CCF-B141-E17A6B135016}
  IA-32 HKLM  {A304E528-86BF-476D-AEED-72B7D88CA4BC} Microsoft .NET Framework 4.8.1 Targeting Pack (ENU)  MsiExec.exe /X{A304E528-86BF-476D-AEED-72B7D88CA4BC}
  IA-32 HKLM  {20FDF22E-7C46-4CBC-A18A-ABCFAFD00B95} Microsoft .NET Host - 8.0.5 (x86)                    MsiExec.exe /X{20FDF22E-7C46-4CBC-A18A-ABCFAFD00B95}
  IA-32 HKLM  {DC28E145-98EF-4FE6-9471-E76DBA992DB8} Microsoft .NET Host FX Resolver - 8.0.5 (x86)        MsiExec.exe /X{DC28E145-98EF-4FE6-9471-E76DBA992DB8}
  IA-32 HKLM  {D0F3B510-89D0-4076-BC4B-7900CDF01AF1} Microsoft .NET Runtime - 8.0.5 (x86)                 MsiExec.exe /X{D0F3B510-89D0-4076-BC4B-7900CDF01AF1}
  IA-32 HKLM  {DFC52ACE-2374-4116-A93D-219BDE6DAF77} Microsoft .NET Targeting Pack - 8.0.5 (x86)          MsiExec.exe /X{DFC52ACE-2374-4116-A93D-219BDE6DAF77}
  IA-32 HKLM  {72AB5E0C-58AE-3E4A-9F7E-61FCE4375548} Microsoft ASP.NET Core 8.0.5 Shared Framework (x86)  MsiExec.exe /X{72AB5E0C-58AE-3E4A-9F7E-61FCE4375548}
  IA-32 HKLM  {ADBE87B0-4456-310E-B5CD-212CA8526876} Microsoft ASP.NET Core 8.0.5 Targeting Pack (x86)    MsiExec.exe /X{ADBE87B0-4456-310E-B5CD-212CA8526876}
  IA-32 HKLM  {FBB6A96E-0222-3F1F-BC09-D6B07B8911C9} Microsoft Edge                                       MsiExec.exe /X{FBB6A96E-0222-3F1F-BC09-D6B07B8911C9}
  IA-32 HKLM  {737FDDA7-B944-4CB5-92D9-3D56373BD301} Microsoft NetStandard SDK                            MsiExec.exe /I{737FDDA7-B944-4CB5-92D9-3D56373BD301}
  IA-32 HKLM  {7F86DEBA-AF7D-43F2-8312-DBCB65F116A9} Microsoft TestPlatform SDK Local Feed                MsiExec.exe /I{7F86DEBA-AF7D-43F2-8312-DBCB65F116A9}
  IA-32 HKLM  {6E7D95E1-DA2A-4DED-A8C6-3FBA1714DB62} Microsoft Visual Studio Setup Configuration          MsiExec.exe /I{6E7D95E1-DA2A-4DED-A8C6-3FBA1714DB62}
  IA-32 HKLM  {0AC39B1B-4AFC-4684-B22C-625848E16C92} Microsoft Visual Studio Setup WMI Provider           MsiExec.exe /I{0AC39B1B-4AFC-4684-B22C-625848E16C92}
  IA-32 HKLM  {1a7abdc5-639b-4af0-87c6-dbc511750c6e} Microsoft Windows Desktop Runtime - 6.0.31 (x64)     "C:\ProgramData\Package Cache\{1a7abdc5-639b-4af0...
  IA-32 HKLM  {9FF5D2D9-C74D-47A0-807B-AA2EC7A12F9D} Microsoft Windows Desktop Runtime - 8.0.5 (x86)      MsiExec.exe /X{9FF5D2D9-C74D-47A0-807B-AA2EC7A12F9D}

.INPUTS  
  None
.OUTPUTS  
  PSCustomObject[]
.NOTES  
  None
#>  

using namespace System.Management.Automation

[CmdletBinding()]
param()

function GetInstallAppsFragment {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory,Position=0)]
      [string]
      $Arch,

      [Parameter(Mandatory,Position=1)]
      [string[]]
      $GetChildItemLiteralPath,

      [Parameter(Mandatory,Position=2)]
      [string[]]
      $GetChildItemExclude
  )

  $gci = Get-ChildItem -LiteralPath $GetChildItemLiteralPath -Exclude $GetChildItemExclude -ErrorAction 'SilentlyContinue'
  return $gci | Select-Object -Property @(
    @{n = "Arch"; e = { $Arch } }
    @{n = "Scope"; e = { $_.PSDrive.Name } }
    @{n = "Name"; e = { $_.PSChildName } }
    @{n = "Display name"; e = { $_.GetValue("DisplayName") } }
    @{n = "Uninstall string"; e = { $_.GetValue("UninstallString") } }
  )

}

$x64QueryParameters = @{
  Arch = "x64"
  GetChildItemLiteralPath = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
  )
  GetChildItemExclude = @(
    '7-Zip'
    'AddressBook'
    'Connection Manager'
    'DirectDrawEx'
    'Fontcore'
    'IE40'
    'IE4Data'
    'IE5BAKEX'
    'IEData'
    'MobileOptionPack'
    'SchedulingAgent'
    'WIC'
  )
}
GetInstallAppsFragment @x64QueryParameters

$IA32QueryParameters = @{
  Arch = "IA-32"
  GetChildItemLiteralPath = @(
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    'HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
  )
  GetChildItemExclude = @(
    'AddressBook'
    'Connection Manager'
    'DirectDrawEx'
    'Fontcore'
    'IE40'
    'IE4Data'
    'IE5BAKEX'
    'IEData'
    'MobileOptionPack'
    'SchedulingAgent'
    'WIC'
  )
}
GetInstallAppsFragment @IA32QueryParameters