<#

COPYRIGHT NOTCE
This script has been derived from:

  Title:       Drivers.ps1
  Author:      Dmitry Nefedov (also known as "farag2")
  Date:        22 May 2020
  URL:         https://github.com/farag2/Delete-old-drivers/blob/master/Drivers.ps1
  License:     MIT License
  License url: https://github.com/farag2/Delete-old-drivers/blob/master/LICENSE

Contents of the Drivers.ps1 license is as follows:

  MIT License

  Copyright (c) 2020 farag2

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

#>

#Requires -Version 5.1
#Requires -RunAsAdministrator

using namespace System.Management.Automation

[CmdletBinding()]
param (
)

function PublicStaticVoidMain {
  # Declare custom properties
  $OriginalFileName = @{ Name = "OriginalFileName"; Expression = { $_.OriginalFileName | Split-Path -Leaf } }
  $Date = @{ Name = "Date"; Expression = { "{0:yyyy-MM-dd}" -f $_.Date } }

  # Inventory all device drivers
  Write-Progress -Activity "Inspecting drivers..." -Id 1
  $AllDrivers = Get-WindowsDriver -Online -All | Where-Object -FilterScript { $_.Driver -like 'oem*inf' } | Select-Object -Property $OriginalFileName, Driver, ClassDescription, ProviderName, $Date, Version
  Write-Progress -Activity "Inspecting drivers..." -Id 1 -Completed

  # Print a list of all third-party device drivers to the verbose stream
  Write-Verbose $("All installed third-party drivers:`n" + ($AllDrivers | Sort-Object -Property ClassDescription | Format-Table -AutoSize -Wrap | Out-String))

  # Filter redundant device drivers
  $DriversToRemove = $AllDrivers | Group-Object -Property OriginalFileName | Where-Object -FilterScript { $_.Count -gt 1 } | ForEach-Object -Process { $_.Group | Sort-Object -Property Date -Descending | Select-Object -Skip 1 }

  # Give instructions to remove
  if ($null -ne $DriversToRemove) {
    Write-Output "Drivers to remove:"
    $DriversToRemove | Sort-Object -Property ClassDescription | Format-Table

    Write-Output "To remove them, issue the following commands:"
    foreach ($item in $DriversToRemove) {
      $Name = $($item.Driver).Trim()
      Write-Output $('    & pnputil.exe /delete-driver "{0}" /force' -f , $Name)
    }
  }
}

PublicStaticVoidMain @args