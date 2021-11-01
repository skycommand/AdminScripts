function Write-Something {
  [CmdletBinding()]
  param (
    # Try changing the type of this parameter to [Object] and [String[]]
    [Parameter(Mandatory, ValueFromPipeline)]
    [String[]]$Message
  )

  begin {
    Get-Date
  }

  process {
    $AnalysisResult = "I just received an object of {0} type." -f $Message.GetType().FullName
    if ($Message -is [System.Array]) {
      $AnalysisResult += " It has {0} sub-objects." -f $Message.Count
    }
    Write-Output $AnalysisResult
  }

  end {
    Get-Date
  }
}

function Public~Static~Void~Main {
  Write-Output "Testing direct array input"
  Write-Something "1","2","3","4","5"

  Write-Output "`n`n"

  Write-Output "Testing array input by pipeline"
  "6","7","8","9","0" | Write-Something

  Write-Output "`n`n"

  [String[]]$a="A","B","C","D","E"
  Write-Output "Testing direct array object input"
  Write-Something $a
  Write-Output "`n`n"
  Write-Output "Testing array object input by pipeline"
  $a | Write-Something
}

Public~Static~Void~Main
