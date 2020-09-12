Function Measure-Count {
    <#
    .SYNOPSIS
      A simple function to return the count of objects and arrays
    .EXAMPLE
     PS C:\Users\user> (1..5) | Measure-Count
     5

     PS C:\Users\user> @() | Measure-Count
     0

     This command will return a int32
    #>
    [cmdletbinding()]
    param(
        [parameter(
            Mandatory         = $true,
            ValueFromPipeline = $true
        )]
        [AllowNull()]
        $pipelineInput
    )
    Begin {
        [int32]$count = 0
    }
    Process {
        $count++
    }
    End {
        $count
    }
}
New-Alias -Name mc -value Measure-Count -Description "A simple function to return the count of objects and arrays"
