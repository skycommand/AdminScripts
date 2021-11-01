#Requires -Version 5.1

using namespace System.Text

function TestSorting {
  # Define our code range
  [Byte[]]$CodePoints = 32..126

  # Fill the $Chars1 array
  [ASCIIEncoding]$Ascii = New-Object -TypeName ASCIIEncoding #Not to be confused with extended ASCII, a.k.a. codepage 437 or OEM-US
  [Char[]]$Chars1 = [Char[]]::new($CodePoints.Count)
  [Void]$Ascii.GetChars($CodePoints, 0, $CodePoints.Count, $Chars1, 0)
  
  # Fill the $Chars2 array
  [String[]]$Chars2 = $Chars1
  
  # Sort them
  $Chars1Sorted = ($Chars1 | Sort-Object -CaseSensitive) -join ''
  $Chars2Sorted = ($Chars2 | Sort-Object -CaseSensitive) -join ''
  
  # Print the result
  Write-Output "Sorted Char[] array:   $Chars1Sorted"
  Write-Output "Sorted String[] array: $Chars2Sorted"
}

Clear-Host

Write-Output @'
This demonstrative script compares how .NET Framework sorts a Char[] array versus a String[] array, when both have the same contents. In this sample script, we fill two arrays, $Char1 and $Char2 with printable ASCII characters (not to be confused with extended ASCII, a.k.a. codepage 437 or OEM-US.) These characters bear ASCII codes 32 through 126. (1 through 31, as well as 127, are non-printable.) More specifically, these characters:

!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~

'@
TestSorting
