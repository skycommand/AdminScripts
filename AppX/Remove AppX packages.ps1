#Requires -RunAsAdministrator
Import-Module -Name Appx -ErrorAction Stop

$applist = @(
  "Microsoft.3DBuilder",                             # 3D Builder
  "Microsoft.DesktopAppInstaller",                   # App Installer
  "Microsoft.GetHelp",                               # Get Help
  "Microsoft.Getstarted",                            # Tips
  "Microsoft.Messaging",                             # Messaging
  "Microsoft.Microsoft3DViewer",                     # 3D Viewer (formerly Mixed Reality Viewer, View 3D)
  "Microsoft.MicrosoftOfficeHub",                    # My Office
  "Microsoft.MicrosoftSolitaireCollection",          # Solitaire Collection
  "Microsoft.MixedReality.Portal",                   # Mixed Reality Portal
  "Microsoft.MSPaint",                               # Paint 3D
  "Microsoft.Office.OneNote",                        # OneNote (the pathetic remake, not the original)
  "Microsoft.OneConnect",                            # Paid Wi-Fi & Cellular
  "Microsoft.Print3D",                               # Print 3D
  "Windows.Print3D",                                 # Print 3D backend
  "Microsoft.StorePurchaseApp",                      # Store Purchase App
  "Microsoft.Wallet",                                # Pay
  "Microsoft.WindowsFeedbackHub",                    # Feedback Hub
  "Microsoft.WindowsSoundRecorder",                  # Voice Recorder
  "Microsoft.Xbox.TCUI",                             # Xbox Live in-game experience
  "Microsoft.XboxApp",                               # Xbox Console Companion (formerly Xbox)
  "Microsoft.XboxGameOverlay",                       # Xbox Game Bar Plug-in
  "Microsoft.XboxGamingOverlay",                     # Xbox Game Bar
  "Microsoft.XboxIdentityProvider",                  # Xbox Identity Provider
  "Microsoft.XboxSpeechToTextOverlay",               # ???
  "Microsoft.YourPhone",                             # Your Phone
  "Microsoft.ZuneMusic",                             # Groove
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
  Write-Output $("Looking for {0}" -f $app)
  $APPXs = Get-AppxPackage $app -AllUsers
  if ($null -ne $APPXs )
  {
    foreach ($APPX in $APPXs) {
      Write-Output $("Removing {0}" -f $APPX.ToString())
      Remove-AppxPackage -AllUsers -Package $APPX
    }
    Remove-Variable APPX
  } else {
    Write-Output $("{0} is not installed." -f $app)
  }
  Write-Output ""
}
