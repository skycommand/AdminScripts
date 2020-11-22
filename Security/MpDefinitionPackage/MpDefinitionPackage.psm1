#Requires -Version 5.1
using namespace System.Management.Automation

Set-StrictMode -Version Latest

enum MpDefinitionPackageTarget {
    Defender = 1
    MSE = 2
    MSAM = 2
    All = 255
}

function Exit-BecauseOsIsNotSupported {
    $PSCmdlet.ThrowTerminatingError(
        [ErrorRecord]::new(
            [PSInvalidOperationException]::new('This operating system is not supported.'),
            'OSNotSupported',
            [ErrorCategory]::InvalidOperation,
            [System.Environment]::OSVersion
        )
    )
}

function Exit-BecauseFolderIsMissing {
    param (
        # Specify one or two words that says what's missing; use lowcase for indefinite nouns
        [Parameter(Mandatory, Position = 0)][String]$Title,
        # Specify the path of the missing folder
        [Parameter(Mandatory, Position = 1)][String]$Path
    )
    $PSCmdlet.ThrowTerminatingError(
        [ErrorRecord]::new(
            [System.IO.DirectoryNotFoundException]::new("Could not find the $Title at '$Path'"),
            'FolderNotFound',
            [ErrorCategory]::ObjectNotFound,
            $Path
        )
    )
}

function Exit-BecauseFileIsMissing {
    param (
        # Specify one or two words that says what's missing; use lowcase for indefinite nouns
        [Parameter(Mandatory, Position = 0)][String]$Title,
        # Specify the path of the missing file
        [Parameter(Mandatory, Position = 1)][String]$Path
    )
    $PSCmdlet.ThrowTerminatingError(
        [ErrorRecord]::new(
            [System.IO.FileNotFoundException]::new("Could not find the $Title at '$Path'"),
            'FileNotFound',
            [ErrorCategory]::ObjectNotFound,
            $Path
        )
    )
}

function Build-SFX {
    param (
        [Parameter(Mandatory)][String]$MyPathWinRarExe,
        [Parameter(Mandatory)][String]$MyTitle,
        [Parameter(Mandatory)][String]$MySfxName,
        [Parameter(Mandatory)][String]$MySfxTemplate,
        [Parameter(Mandatory)][string]$MySfxContent
    )
    $MyWinRarArgs = $('a -ep1 -s -t -sfx -zSfx1.txt -iadm "{0}" "{1}"' -f $MySfxName, $MySfxContent)

    Write-Verbose "Packaging definitions for $MyTitle"

    $a=Copy-Item -Path $MySfxTemplate -Destination '.\Sfx1.txt' -PassThru -ErrorAction Stop
    $a.Attributes = "Normal"

    # If a SFX with this name exists, delete it.
    Remove-Item -Path * -Include $MySfxName -ErrorAction Stop

    $CompressionProcess = Start-Process -FilePath $MyPathWinRarExe -ArgumentList $MyWinRarArgs -Wait -PassThru
    if ($CompressionProcess.ExitCode -eq 0) {
        Write-Verbose "$MyTitle package is ready."
    } elseif ($CompressionProcess.ExitCode -eq 255) {
        Write-Warning "The user has cancelled the $MyTitle package."
    } else {
        Write-Warning "WinRAR failed to create the $MyTitle package. Error code: $($CompressionProcess.ExitCode)"
    }

    Remove-Item '.\Sfx1.txt'
}

function Build-MpDefinitionPackage {
    [CmdletBinding()]
    param (
        # Specifies the output folder's path, where the definitions packages are written
        [Parameter(
            Mandatory = $true,
            Position = 0,
            HelpMessage = "Specify the output folder's path, where the definitions packages are written")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        # Whether to create definitions package for Windows Defender, Security Essentials, or both
        [Parameter(Mandatory = $false)]
        [MpDefinitionPackageTarget]
        $Target = [MpDefinitionPackageTarget]::Defender,

        # Path to WinRAR.exe. Normally not required, as WinRAR registers itself with Windows.
        [Parameter(Mandatory = $false)]
        [String]
        $PathWinRarExe = 'WinRAR.exe' #WinRAR registers its executable file in Windows Registry
    )

    <#
    Constants
    #>
    # For this OS
    New-Variable -Option Constant -Name PathTempFolder     -Value ".\Temp"
    New-Variable -Option Constant -Name PathTempFiles      -Value "$PathTempFolder\*"
    New-Variable -Option Constant -Name PathDefMASM        -Value "$env:ProgramData\Microsoft\Microsoft Antimalware\Definition Updates\`{*`}"
    New-Variable -Option Constant -Name PathDefDefender    -Value "$env:ProgramData\Microsoft\Windows Defender\Definition Updates\`{*`}"
    # For the target OS
    New-Variable -Option Constant -Name SfxMSAM            -Value "MsamDefPack.exe"
    New-Variable -Option Constant -Name SfxDefender        -Value "DefenderDefPack.exe"
    New-Variable -Option Constant -Name TemplateMSAM       -Value "$PSScriptRoot\res\SFX-commands-MASM.txt"
    New-Variable -Option Constant -Name TemplateDefender   -Value "$PSScriptRoot\res\SFX-commands-Defender.txt"

    <#
    Check OS version
    #>
    # Are we running on Windows?
    $os = [System.Environment]::OSVersion
    if ($os.Platform -ne 'Win32NT') {
        Exit-BecauseOsIsNotSupported
    }

    # Are we running the correct version of Windows?
    $vers = $os.Version.Major * 100 + $os.Version.Minor
    switch ($vers) {
        # Windows Vista or Windows Server 2008
        600 { $PathDefFolders = $PathDefMASM }
        # Windows 7 or Windows Server 2008 R2
        601 { $PathDefFolders = $PathDefMASM }
        602 { $PathDefFolders = $PathDefDefender }
        603 { $PathDefFolders = $PathDefDefender }
        1000 { $PathDefFolders = $PathDefDefender }
        Default {
            Exit-BecauseOsIsNotSupported
        }
    }

    #Are antimalware definitions present?
    $PathDefFiles = Get-ChildItem $PathDefFolders -Recurse -Depth 1 -Name -ErrorAction SilentlyContinue
    If ($null -eq $PathDefFiles) {
        Exit-BecauseFileIsMissing 'antimalware definitions' $(Split-Path -Path $PathDefFolders -Parent)
    }

    # Navigate to the work folder
    If (Test-Path -Path $Path -PathType Container) {
        Push-Location $Path -ErrorAction Stop
    } else {
        Exit-BecauseFolderIsMissing 'output folder' $Path
    }

    try {
        # Is there an object (file or folder) whose path is the same as the temp folder? If yes, Delete it.
        # We need to delete the object and (re)create a folder instead. We can't risk weird NTFS permissions impeding us.
        if (Test-Path -Path $PathTempFolder) {
            Write-Verbose "Deleting the temporary folder at '$PathTempFolder' (probable left-over)"
            Remove-Item $PathTempFolder -Recurse -ErrorAction Stop
        }

        # Create the temp folder
        New-Item -Path $PathTempFolder -ItemType Directory -ErrorAction Stop | Out-Null

        # Collect definitions
        Resolve-Path $PathDefFolders | ForEach-Object {
            $SourcePath1 = Join-Path $_ '*'
            Write-Verbose "Copying $SourcePath1"
            Copy-Item -Path $SourcePath1 -Destination $PathTempFolder -Force
        }

        # Build the MSAM package, if applicable
        if (($Target -eq [MpDefinitionPackageTarget]::MSAM) -or ($Target -eq [MpDefinitionPackageTarget]::All)) {
            Build-SFX `
                -MyPathWinRarExe $PathWinRarExe `
                -MyTitle         'Microsoft Security Essentials' `
                -MySfxName       $SfxMSAM `
                -MySfxTemplate   $TemplateMSAM `
                -MySfxContent    $PathTempFiles
        }

        # Build the Defender package, if applicable
        if (($Target -eq [MpDefinitionPackageTarget]::Defender) -or ($Target -eq [MpDefinitionPackageTarget]::All)) {
            Build-SFX `
                -MyPathWinRarExe $PathWinRarExe `
                -MyTitle         'Microsoft Defender Antivirus' `
                -MySfxName       $SfxDefender `
                -MySfxTemplate   $TemplateDefender `
                -MySfxContent    $PathTempFiles
        }

        #Cleaning up
        Write-Verbose 'Cleaning up'
        Remove-Item $PathTempFolder -Recurse
    } finally {
        #Return to whence you came
        Pop-Location
    }
}