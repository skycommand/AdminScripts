function Write-Something {
  [CmdletBinding()]
  param (
    # Try altering the type of this parameter between [Object] and [String[]] to see how they differ
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
  [String[]]$a="A","B","C","D","E"

  Write-Output "Testing inline array input directly"
  Write-Something "1","2","3","4","5"

  Write-Output "`n`n"

  Write-Output "Testing inline array input via pipeline"
  "6","7","8","9","0" | Write-Something

  Write-Output "`n`n"

  Write-Output "Testing array object input directly"
  Write-Something $a

  Write-Output "`n`n"

  Write-Output "Testing array object input via pipeline"
  $a | Write-Something
}

Public~Static~Void~Main
