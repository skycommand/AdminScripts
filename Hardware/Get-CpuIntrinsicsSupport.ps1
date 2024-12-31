<#
.SYNOPSIS
  Queries all supported CPU instruction-set extensions for x86 and x86-64 systems and reports their
  availability.
.DESCRIPTION
  Has a specific app ever required a CPU feature? Have you ever been uncertain whether your CPU has
  that feature? If the answers to both questions are "Yes," this script is for you. Run it, and it
  will report all CPU features that .NET 8.0 recognizes.
.INPUTS
  None
.OUTPUTS
  InstructionDetails[]
.NOTES
  This script requires PowerShell 7.4 because it uses .NET 8.0.
#>

#Requires -Version 7.4
# This script mustn't run on anything less than .NET 8.0.

using namespace System.Management.Automation
using namespace System.Runtime.Intrinsics.X86

[CmdletBinding()]
param()

Add-Type -TypeDefinition @'
using System;

public class InstructionDetails {
  public String Name { get; }
  public Boolean IsSupported { get; }
  public InstructionDetails(String name, Boolean isSupported) {
      this.Name = name;
      this.IsSupported = isSupported;
  }
}
'@

function PublicStaticVoidMain {

  return [InstructionDetails[]]@(
    [InstructionDetails]::new("X86BASE"         , [X86Base         ]::IsSupported)
    [InstructionDetails]::new("X86BASE x64"     , [X86Base+x64     ]::IsSupported)
    [InstructionDetails]::new("AES"             , [Aes             ]::IsSupported)
    [InstructionDetails]::new("AES x64"         , [Aes+x64         ]::IsSupported)
    [InstructionDetails]::new("AVX"             , [Avx             ]::IsSupported)
    [InstructionDetails]::new("AVX x64"         , [Avx+x64         ]::IsSupported)
    [InstructionDetails]::new("AVX2"            , [Avx2            ]::IsSupported)
    [InstructionDetails]::new("AVX2 x64"        , [Avx2+x64        ]::IsSupported)
    [InstructionDetails]::new("AVX512BW"        , [Avx512BW        ]::IsSupported)
    [InstructionDetails]::new("AVX512BW VL"     , [Avx512BW+VL     ]::IsSupported)
    [InstructionDetails]::new("AVX512BW X64"    , [Avx512BW+X64    ]::IsSupported)
    [InstructionDetails]::new("AVX512CD"        , [Avx512CD        ]::IsSupported)
    [InstructionDetails]::new("AVX512CD VL"     , [Avx512CD+VL     ]::IsSupported)
    [InstructionDetails]::new("AVX512CD X64"    , [Avx512CD+X64    ]::IsSupported)
    [InstructionDetails]::new("AVX512DQ"        , [Avx512DQ        ]::IsSupported)
    [InstructionDetails]::new("AVX512DQ VL"     , [Avx512DQ+VL     ]::IsSupported)
    [InstructionDetails]::new("AVX512DQ X64"    , [Avx512DQ+X64    ]::IsSupported)
    [InstructionDetails]::new("AVX512F"         , [Avx512F         ]::IsSupported)
    [InstructionDetails]::new("AVX512F VL"      , [Avx512F+VL      ]::IsSupported)
    [InstructionDetails]::new("AVX512F X64"     , [Avx512F+X64     ]::IsSupported)
    [InstructionDetails]::new("AVX512VBMI"      , [Avx512Vbmi      ]::IsSupported)
    [InstructionDetails]::new("AVX512VBMI VL"   , [Avx512Vbmi+VL   ]::IsSupported)
    [InstructionDetails]::new("AVX512VBMI X64"  , [Avx512Vbmi+X64  ]::IsSupported)
    [InstructionDetails]::new("AVXVNNI"         , [AvxVnni         ]::IsSupported)
    [InstructionDetails]::new("AVXVNNI X64"     , [AvxVnni+X64     ]::IsSupported)
    [InstructionDetails]::new("BMI1"            , [Bmi1            ]::IsSupported)
    [InstructionDetails]::new("BMI1 x64"        , [Bmi1+x64        ]::IsSupported)
    [InstructionDetails]::new("BMI2"            , [Bmi2            ]::IsSupported)
    [InstructionDetails]::new("BMI2 x64"        , [Bmi2+x64        ]::IsSupported)
    [InstructionDetails]::new("FMA"             , [Fma             ]::IsSupported)
    [InstructionDetails]::new("FMA x64"         , [Fma+x64         ]::IsSupported)
    [InstructionDetails]::new("LZCNT"           , [Lzcnt           ]::IsSupported)
    [InstructionDetails]::new("LZCNT x64"       , [Lzcnt+x64       ]::IsSupported)
    [InstructionDetails]::new("PCLMULQDQ"       , [Pclmulqdq       ]::IsSupported)
    [InstructionDetails]::new("PCLMULQDQ x64"   , [Pclmulqdq+x64   ]::IsSupported)
    [InstructionDetails]::new("POPCNT"          , [Popcnt          ]::IsSupported)
    [InstructionDetails]::new("POPCNT x64"      , [Popcnt+x64      ]::IsSupported)
    [InstructionDetails]::new("SSE"             , [Sse             ]::IsSupported)
    [InstructionDetails]::new("SSE x64"         , [Sse+x64         ]::IsSupported)
    [InstructionDetails]::new("SSE2"            , [Sse2            ]::IsSupported)
    [InstructionDetails]::new("SSE2 x64"        , [Sse2+x64        ]::IsSupported)
    [InstructionDetails]::new("SSE3"            , [Sse3            ]::IsSupported)
    [InstructionDetails]::new("SSE3 x64"        , [Sse3+x64        ]::IsSupported)
    [InstructionDetails]::new("SSE41"           , [Sse41           ]::IsSupported)
    [InstructionDetails]::new("SSE41 x64"       , [Sse41+x64       ]::IsSupported)
    [InstructionDetails]::new("SSE42"           , [Sse42           ]::IsSupported)
    [InstructionDetails]::new("SSE42 x64"       , [Sse42+x64       ]::IsSupported)
    [InstructionDetails]::new("SSSE3"           , [Ssse3           ]::IsSupported)
    [InstructionDetails]::new("SSSE3 x64"       , [Ssse3+x64       ]::IsSupported)
    [InstructionDetails]::new("X86SERIALIZE"    , [X86Serialize    ]::IsSupported)
    [InstructionDetails]::new("X86SERIALIZE X64", [X86Serialize+X64]::IsSupported)
  )
}

PublicStaticVoidMain @args