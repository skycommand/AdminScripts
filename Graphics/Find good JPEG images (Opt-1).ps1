#Requires -Version 7.2

using namespace System.Management.Automation
using namespace System.Drawing

[CmdletBinding()]
param(
  # Specifies a path to one or more locations.
  [Parameter(Mandatory, Position = 0)]
  [ValidateNotNullOrEmpty()]
  [String]
  $LiteralPath,

  # Specifies whether to search the path given recursively
  [switch] $Recurse
)

function Exit-BecauseFolderIsMissing {
  param (
    # Specify the path of the missing folder
    [Parameter(Mandatory, Position = 0)][String]$Path
  )
  $PSCmdlet.ThrowTerminatingError(
    [ErrorRecord]::new(
      [System.IO.DirectoryNotFoundException]::new("Could not find '$Path'"),
      'FolderNotFound',
      [ErrorCategory]::ObjectNotFound,
      $Path
    )
  )
}
function PublicStaticVoidMain {

  $JpegFilesFilter = '*.jpg', '*.jpeg'

  class JpegImageSpec {
    [String]$FullName
    [int]$Width
    [int]$Height
    JpegImageSpec ( [String]$fn, [int]$w, [int]$h ) {
      $this.FullName = $fn
      $this.Width = $w
      $this.Height = $h
    }
  }

  function Get-JpegFileSpec {
    param(
      [ValidateNotNullOrEmpty()]
      [String]
      $LiteralPath
    )
    $NumBytesToRead = 32kb
    [Byte[]] $Buffer = [Byte[]]::new($NumBytesToRead)
    $ReturnObject = $null

    try {
      [IO.FileStream] $FileStream = [IO.File]::OpenRead($LiteralPath)
      $ActualBytesRead = $FileStream.Read($Buffer, 0, $NumBytesToRead)
    }
    finally {
      [Void]${FileStream}?.Dispose()
    }
    try {

      [IO.MemoryStream] $MemoryStream = [IO.MemoryStream]::new($Buffer, 0, $ActualBytesRead)
      [Bitmap] $JpegImage = [Bitmap]::FromStream($MemoryStream)
      $ReturnObject = [JpegImageSpec]::new($LiteralPath, $JpegImage.Width, $JpegImage.Height)

    } catch [System.ArgumentException] {

      # This exception occurs if $NumBytesToRead is too low for GDI+ to interpret the partial read as a partial image
      Write-Error -Message "Argument exception (insufficient read buffer?) on ""$LiteralPath""" -Exception $_.Exception -Category OpenError -ErrorId ReadBufferError -TargetObject $LiteralPath

    } catch [System.Runtime.InteropServices.ExternalException] {

      # This exception occurs when GDI+ cannot understand the image format.
      # In this case, the error code must be 0x80004005.
      if (0x80004005 -ne $_.Exception.ErrorCode) {
        Write-Error -Message "Decoder exception on ""$LiteralPath""" -Exception $_.Exception -Category OperationStopped -ErrorId DecoderError -TargetObject $LiteralPath
      }

    } finally {

      [Void]${MemoryStream}?.Dispose()
      [Void]${JpegImage}?.Dispose()

    }
    return $ReturnObject
  }

  function Test-JpegFolder {
    param(
      [ValidateNotNullOrEmpty()]
      [String]
      $LiteralPath,

      # Specifies whether to search the path given recursively
      [switch] $Recurse
    )
    $BadImageCount = 0

    $a=Get-ChildItem -LiteralPath $LiteralPath -Include $JpegFilesFilter -Recurse:$Recurse
    $a | ForEach-Object {
      $tempVal = Get-JpegFileSpec -LiteralPath $_.FullName
      if ($null -eq $tempVal) {
        $BadImageCount++
      } else {
        $tempVal
        Remove-Variable tempVal
      }
    }
    Write-Verbose "Bad images: $BadImageCount"
  }

  if (Test-Path -LiteralPath $LiteralPath -PathType Container) {
    Test-JpegFolder -LiteralPath $LiteralPath -Recurse:$Recurse
  } else {
    Exit-BecauseFolderIsMissing -Path $LiteralPath
  }
}
PublicStaticVoidMain @args
