$TitleBar    = Split-Path -Path $PSCommandPath -Leaf

$Method1     = 'System.Windows.Forms.MessageBox'
$Method2     = 'Microsoft.VisualBasic.Interaction.MsgBox()'
$Method3     = 'WScript.Shell.Popup()'

$MessageBase = "This message box is brought to you by:`n{0}`nHere are some Unicode characters:`n😀 ā ی ± ≠ 👩"
$Message1    = $MessageBase -f $Method1
$Message2    = $MessageBase -f $Method2
$Message3    = $MessageBase -f $Method3

# Load System.Windows.Forms and enable visual styles
Write-Output 'Loading System.Windows.Forms'
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')

# Enable visual styles
# This command is required on Windows XP and later (yes, even on Windows 10)
# Without this, your message boxes look like something form Windows 95
Write-Output 'Enabling visual styles'
[System.Windows.Forms.Application]::EnableVisualStyles()

<# METHOD 1:

    System.Windows.Forms.MessageBox
    https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.messagebox

    Comforms with visual styles

    To get the details of parameter types:
        [enum]::GetValues([System.Windows.Forms.MessageBoxButtons])
        [enum]::GetValues([System.Windows.Forms.MessageBoxIcon])
    To get the details of the return type:
        [enum]::GetValues([System.Windows.Forms.DialogResult])
#>
Write-Output "Demonstrating method 1: $Method1"
$result = [System.Windows.Forms.MessageBox]::Show($Message1, $TitleBar  , 'OK', 'Asterisk');
Write-Output $result

<# METHOD 2:

    Microsoft.VisualBasic.Interaction.MsgBox()
    https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualbasic.interaction.msgbox

    Comforms with visual styles

    To get the details of parameter type:
        [enum]::GetValues([Microsoft.VisualBasic.MsgBoxStyle])
    To get the details of the return type:
        [enum]::GetValues([Microsoft.VisualBasic.MsgBoxResult])
#>
Write-Output "Demonstrating method 2: $Method2"
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 
$result = [Microsoft.VisualBasic.Interaction]::MsgBox($Message2, 'OKOnly,Information', $TitleBar  ) 
Write-Output $result

<# METHOD 3 (DEPRECATED):

    WScript.Shell.Popup()
    https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/scripting-articles/x83z1d9f(v=vs.84)

    Not affected by visual styles
    (Looks like something from Windows 95!)
#>
Write-Output "Demonstrating method 3: $Method3"
$MsgBox = New-Object -ComObject wscript.shell
$result = $MsgBox.Popup($Message3, 0, $TitleBar, 0 -bor 64)
Write-Output $result
