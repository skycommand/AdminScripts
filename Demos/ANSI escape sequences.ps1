#Requires -Version 5.1

function PublicStaticVoidMain {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification = "This script targets terminal emulators to diagnose their use of ANSI escape sequences. There is no point in running it headless. In addition, as of PowerShell 5.1, the PSAvoidUsingWriteHost warning is entirely meaningless because Write-Host has become a wrapper for Write-Information.")]
  param ()
  Clear-Host

  # Compatible with PowerShell 5.1
  [Char]$ESC = [Char]27

  Write-Host @"
This script helps you find out whether your terminal emulator supports ANSI escape sequences.

$ESC[43;30m Styles $ESC[0m
<ESC>[0m $ESC[0mPlain$ESC[0m
<ESC>[1m $ESC[1mBold$ESC[0m
<ESC>[4m $ESC[4mUnderline$ESC[0m
<ESC>[7m $ESC[7mInverse$ESC[0m

$ESC[43;30m Normal foreground colors $ESC[0m   $ESC[43;30m Bright foreground colors $ESC[0m
<ESC>[30m $ESC[30m@#%&%#@$ESC[0m    Black   <ESC>[90m  $ESC[90m@#%&%#@$ESC[0m   Black
<ESC>[31m $ESC[31m@#%&%#@$ESC[0m      Red   <ESC>[91m  $ESC[91m@#%&%#@$ESC[0m     Red
<ESC>[32m $ESC[32m@#%&%#@$ESC[0m    Green   <ESC>[92m  $ESC[92m@#%&%#@$ESC[0m   Green
<ESC>[33m $ESC[33m@#%&%#@$ESC[0m   Yellow   <ESC>[93m  $ESC[93m@#%&%#@$ESC[0m  Yellow
<ESC>[34m $ESC[34m@#%&%#@$ESC[0m     Blue   <ESC>[94m  $ESC[94m@#%&%#@$ESC[0m    Blue
<ESC>[35m $ESC[35m@#%&%#@$ESC[0m  Magenta   <ESC>[95m  $ESC[95m@#%&%#@$ESC[0m Magenta
<ESC>[36m $ESC[36m@#%&%#@$ESC[0m     Cyan   <ESC>[96m  $ESC[96m@#%&%#@$ESC[0m    Cyan
<ESC>[37m $ESC[37m@#%&%#@$ESC[0m    White   <ESC>[97m  $ESC[97m@#%&%#@$ESC[0m   White

$ESC[43;30m Normal background colors $ESC[0m   $ESC[43;30m Bright background colors $ESC[0m
<ESC>[40m $ESC[40m       $ESC[0m    Black   <ESC>[100m $ESC[100m       $ESC[0m   Black
<ESC>[41m $ESC[41m       $ESC[0m      Red   <ESC>[101m $ESC[101m       $ESC[0m     Red
<ESC>[42m $ESC[42m       $ESC[0m    Green   <ESC>[102m $ESC[102m       $ESC[0m   Green
<ESC>[43m $ESC[43m       $ESC[0m   Yellow   <ESC>[103m $ESC[103m       $ESC[0m  Yellow
<ESC>[44m $ESC[44m       $ESC[0m     Blue   <ESC>[104m $ESC[104m       $ESC[0m    Blue
<ESC>[45m $ESC[45m       $ESC[0m  Magenta   <ESC>[105m $ESC[105m       $ESC[0m Magenta
<ESC>[46m $ESC[46m       $ESC[0m     Cyan   <ESC>[106m $ESC[106m       $ESC[0m    Cyan
<ESC>[47m $ESC[47m       $ESC[0m    White   <ESC>[107m $ESC[107m       $ESC[0m   White

"@
}

PublicStaticVoidMain @args
