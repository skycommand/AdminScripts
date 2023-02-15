#Requires -Version 5.1

function PublicStaticVoidMain {
  param ()
  Clear-Host

  # Compatible with PowerShell 5.1
  [Char]$ESC = [Char]27

  Write-Output -InputObject @"
This script helps you find out whether your terminal emulator supports ANSI escape sequences.

$ESC[42;30m Writing styles                                        $ESC[0m
<ESC>[0m$ESC[0m Reset formatting (plain)
<ESC>[1m$ESC[1m Bold            $ESC[22m<ESC>[22m                 Bold
<ESC>[2m$ESC[2m Dim             $ESC[22m<ESC>[22m                  Dim
<ESC>[3m$ESC[3m Italic          $ESC[23m<ESC>[23m               Italic
<ESC>[4m$ESC[4m Underline       $ESC[24m<ESC>[24m            Underline
<ESC>[5m$ESC[5m Blink           $ESC[25m<ESC>[25m                Blink
<ESC>[7m$ESC[7m Inverse         $ESC[27m<ESC>[27m              Inverse
<ESC>[8m$ESC[8m Hidden          $ESC[28m<ESC>[28m               Hidden
<ESC>[9m$ESC[9m Strikethrough   $ESC[29m<ESC>[29m        Strikethrough
$ESC[0m
$ESC[43;30m Normal foreground colors $ESC[0m   $ESC[103;30m Bright foreground colors $ESC[0m
<ESC>[30m $ESC[30m@#%&%#@$ESC[0m    Black   <ESC>[90m  $ESC[90m@#%&%#@$ESC[0m   Black
<ESC>[31m $ESC[31m@#%&%#@$ESC[0m      Red   <ESC>[91m  $ESC[91m@#%&%#@$ESC[0m     Red
<ESC>[32m $ESC[32m@#%&%#@$ESC[0m    Green   <ESC>[92m  $ESC[92m@#%&%#@$ESC[0m   Green
<ESC>[33m $ESC[33m@#%&%#@$ESC[0m   Yellow   <ESC>[93m  $ESC[93m@#%&%#@$ESC[0m  Yellow
<ESC>[34m $ESC[34m@#%&%#@$ESC[0m     Blue   <ESC>[94m  $ESC[94m@#%&%#@$ESC[0m    Blue
<ESC>[35m $ESC[35m@#%&%#@$ESC[0m  Magenta   <ESC>[95m  $ESC[95m@#%&%#@$ESC[0m Magenta
<ESC>[36m $ESC[36m@#%&%#@$ESC[0m     Cyan   <ESC>[96m  $ESC[96m@#%&%#@$ESC[0m    Cyan
<ESC>[37m $ESC[37m@#%&%#@$ESC[0m    White   <ESC>[97m  $ESC[97m@#%&%#@$ESC[0m   White

$ESC[43;30m Normal background colors $ESC[0m   $ESC[103;30m Bright background colors $ESC[0m
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
