#Requires -Version 5.1

<#
.SYNOPSIS
  Uninstalls packaged apps bundled with Windows from the current user account.
.DESCRIPTION
  When Windows 10 was first published in 2015, it was bloated with marginally useful packaged apps.
  To their credit, they had no performance impact. Yet, their very existence was a violation of the
  principle of lean systems. This script uninstalls them all for the current user.
  .NOTES
  DEPRECATED. Please use WinGet instead.

  The script requires no administrative privileges.

  This script depends on Get-AppxPackage and its Appx module. As such, it won't work in PowerShell
  6 and later, and returns an error (System.PlatformNotSupportedException).
.LINK
  None
#>

Import-Module -Name Appx -ErrorAction "Stop"

$applist = @(
  "Microsoft.549981C3F5F10",                         # Cortana (2nd-Gen)
  "Microsoft.3DBuilder",                             # 3D Builder
  "Microsoft.BingWeather",                           # Weather
 #"Microsoft.DesktopAppInstaller",                   # App Installer and WinGet
  "Microsoft.GetHelp",                               # Get Help
  "Microsoft.Getstarted",                            # Tips, formerly Get Started
  "Microsoft.HEIFImageExtension",                    # HEIF Image Extensions
  "Microsoft.HEVCVideoExtension",                    # HEVC Video Extensions
  "Microsoft.Messaging",                             # Messaging
  "Microsoft.Microsoft3DViewer",                     # 3D Viewer (formerly Mixed Reality Viewer, View 3D)
  "Microsoft.MicrosoftOfficeHub",                    # Office
  "Microsoft.MicrosoftSolitaireCollection",          # Solitaire Collection
  "Microsoft.MicrosoftStickyNotes",                  # Sticky Notes
  "Microsoft.MixedReality.Portal",                   # Mixed Reality Portal
  "Microsoft.MSPaint",                               # Paint 3D
  "Microsoft.Office.OneNote",                        # OneNote (the pathetic remake, not the original)
  "Microsoft.OneConnect",                            # Mobile Plans, formerly Paid Wi-Fi & Cellular
  "Microsoft.Outlook.DesktopIntegrationServices",    # ???
  "Microsoft.People",                                # People
  "Microsoft.Print3D",                               # Print 3D
  "Windows.Print3D",                                 # Print 3D backend
  "Microsoft.ScreenSketch",                          # Snip & Sketch
  "Microsoft.SkypeApp",                              # Skype
  "Microsoft.StorePurchaseApp",                      # Store Purchase App
  "Microsoft.VP9VideoExtensions",                    # VP9 Video Extensions
  "Microsoft.Wallet",                                # Pay
  "Microsoft.WebMediaExtensions",                    # Web Media Extensions
  "Microsoft.Windows.Photos",                        # Photos
  "Microsoft.WindowsAlarms",                         # Clock, formerly Alarms & Clock
  "Microsoft.WindowsCalculator",                     # Calculator
  "Microsoft.WindowsCamera",                         # Camera
  "microsoft.windowscommunicationsapps",             # Mail and Calendar
  "Microsoft.WindowsFeedbackHub",                    # Feedback Hub
  "Microsoft.WindowsMaps",                           # Maps
  "Microsoft.WindowsSoundRecorder",                  # Voice Recorder
  "Microsoft.Xbox.TCUI",                             # Xbox Live in-game experience
  "Microsoft.XboxApp",                               # Xbox Console Companion (formerly Xbox)
  "Microsoft.XboxGameOverlay",                       # Xbox Game Bar Plug-in
  "Microsoft.XboxGamingOverlay",                     # Xbox Game Bar
  "Microsoft.XboxIdentityProvider",                  # Xbox Identity Provider
  "Microsoft.XboxSpeechToTextOverlay",               # Xbox Captioning
  "Microsoft.YourPhone",                             # Phone Link, formerly Your Phone
  "Microsoft.ZuneMusic",                             # Media Player, formerly Groove
  "Microsoft.ZuneVideo",                             # Movies & TV
  "Windows.ContactSupport",                          # Contact Support
  "ActiproSoftwareLLC.562882FEEB491",                # Code Writer
  "46928bounde.EclipseManager",                      # Eclipse Manager
  "PandoraMediaInc.29680B314EFC2",                   # Pandora
  "AdobeSystemsIncorporated.AdobePhotoshopExpress",  # Adobe Photoshop Express
  "D5EA27B7.Duolingo-LearnLanguagesforFree",         # Duolingo
  "Microsoft.NetworkSpeedTest",                      # Network Speed Test
  "Microsoft.BingNews",                              # Bing News
  "Microsoft.Office.Sway"                            # Office Sway
)

foreach ($app in $applist) {
  $APPXs = Get-AppxPackage $app
  if ($null -ne $APPXs )
  {
    foreach ($APPX in $APPXs) {
      Write-Output $("Removing {0}" -f $APPX.ToString())
      Remove-AppxPackage -Package $APPX
    }
    Remove-Variable APPX
  } else {
    Write-Verbose $("{0} is not installed." -f $app)
  }
}
