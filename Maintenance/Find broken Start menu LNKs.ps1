#requires -Version 7.4

try {
  [void][Reflection.Assembly]::LoadFrom("$PSScriptRoot\WindowsShortcutFactory.1.2.0\lib\netstandard2.0\WindowsShortcutFactory.dll")
} catch {
  throw
}

$BadLnkItems = [Collections.Generic.Dictionary[String,String]]::new()

function VerifyAllShortcuts {
  param (
    [Parameter(Mandatory, Position=0)]
    [ValidateNotNullOrEmpty()]
    [String]
    $LiteralPath
  )
  Get-ChildItem -LiteralPath $LiteralPath -Filter *.lnk -Recurse -File -Force | ForEach-Object {
    $LnkItem = [WindowsShortcutFactory.WindowsShortcut]::Load($PSItem.FullName)
    $LnkPath = [System.Environment]::ExpandEnvironmentVariables($LnkItem.Path)
    if (-not (Test-Path -LiteralPath $LnkPath)) {
      $BadLnkItems.Add($PSItem.FullName, $LnkPath)
    }
    $LnkItem.Dispose()
  }
}

$StartMenuPathGlobal = [Environment]::GetFolderPath('CommonStartMenu')
$StartMenuPathUser   = [Environment]::GetFolderPath('StartMenu')

VerifyAllShortcuts -LiteralPath $StartMenuPathGlobal
VerifyAllShortcuts -LiteralPath $StartMenuPathUser

return $BadLnkItems