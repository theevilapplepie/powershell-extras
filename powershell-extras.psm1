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

Function ConvertFrom-Newline {
    <#
    .SYNOPSIS
     A simple function which converts a string into an array delimited by newlines
    #>
    [cmdletbinding()]
    param(
        [parameter(
            ValueFromPipeline = $true
        )]
        [AllowNull()]
        $pipelineInput,
        [switch]$CarefulSplit,
        [switch]$RemoveBlank
    )

    Begin {

        # Are we part of an input pipeline?
        if ($PSCmdlet.MyInvocation.ExpectingInput -or ( $PSCmdlet.MyInvocation.PipelineLength -gt 1 -and $PSCmdlet.MyInvocation.PipelinePosition -gt 1 )) {
            $inputPipelined = $true
        } else {
            $inputPipelined = $false
            $outputBufferArray = [System.Collections.ArrayList]@()
        }
        
        # Check if we're executed without defined input or output
        if ( !$inputPipelined -and $PSCmdlet.MyInvocation.PipelineLength -eq 1 -and $PSCmdlet.MyInvocation.Line -match "^\s*" + $PSCmdlet.MyInvocation.InvocationName ) {
            throw "`r`nThis function is not meant to be ran directly!`r`nPlease pipe input into this function or use the output for interaction`r`n"
        }

        if ($RemoveBlank) {
            $splitOption = [StringSplitOptions]::RemoveEmptyEntries
        } else {
            $splitOption = [StringSplitOptions]::None
        }
        
    }

    Process {
        # Are we being pipelined?
        if ( $inputPipelined ) {
            if ($CarefulSplit -or $RemoveBlank) {
                # This is our slow split
                $pipelineInput.Split(
                    @("`r`n", "`r", "`n"),
                    $splitOption
                )
            } else {
                # This is our fast split
                $pipelineInput -split "`r`n"
            }
            return
        }

        # We are not, lets read in our stuff
        write-host "ConvertFrom-Newline`r`n== Type or Paste your string, Finish by sending two newlines =="
        $last = "bogon"
        $input = "bogon"
        while ( $last -ne "" -or $input -ne "" ) {
            $last = [string]$input
            $input = read-host -prompt "> "
            
            # Remove blanks
            if ( $input -eq '' ) {
                continue
            }
            
            # Add to Output
            $null = $outputBufferArray.Add($input)

        }
    }

    End {
        # Batch output our provided data
        if ( !$inputPipelined ) {
            $outputBufferArray
        }
    }
}
New-Alias -Name cnl -value ConvertFrom-NewLine -Description "A simple function which converts a string into an array delimited by newlines"

# Export Everything ;)
Export-ModuleMember -alias * -function *
