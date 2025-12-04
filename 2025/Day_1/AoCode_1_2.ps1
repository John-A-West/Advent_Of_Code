<#
This is the solution for Advent of Code 2025 Day 1, Part 2
#>
function Count-Zero {
    [CmdletBinding()]
    param (
        $Start,
        [ValidateSet('L','R')]
        $Direction,
        $Clicks
    )
    $Result = 0
    $Position = $Start
    for ( $i=0; $i -lt $Clicks; $i++ ) {
        if ( $Direction -eq 'R' ) {
            $Position += 1
        } else {
            $Position -= 1
        }
        if ( ($Position % 100) -eq 0 ) {
            $Result++
        }
    }
    $Result
}
function Move-Dial {
    [CmdletBinding()]
    param (
        $Start,
        [ValidateSet('L','R')]
        $Direction,
        $Clicks,
        $Min = 0,
        $Max = 99
    )
    if ( $Direction -eq 'R' ) {
        # turn to the right
        if ( ($Start + $Clicks) -le $Max ) {
            $Start + $Clicks
        } else {
            $ClicksToMin = $Max - $Start + 1 # how many clicks does it take to get to Min
            $MoveParams = @{
                Start = $Min
                Direction = $Direction
                Clicks = ($Clicks - $ClicksToMin)
            }
            Move-Dial @MoveParams
        }
    } else {
        # turn to the left
        if ( ($Start - $Clicks) -ge $Min ) {
            $Start - $Clicks
        } else {
            $ClicksToMax = $Start + 1 # how many clicks does it take to get to Max
            $MoveParams = @{
                Start = $Max
                Direction = $Direction
                Clicks = ($Clicks - $ClicksToMax)
            }
            Move-Dial @MoveParams
        }
    }
}

$AocData = Import-PowerShellDataFile -Path "$PSScriptRoot\Day1_Details.psd1"
[string]$InputFilePath = "$PSScriptRoot\$($AocData.InputFile)"
if ( -not (Test-Path $InputFilePath) ) {
    Write-Warning "Cannot find input file: $InputFilePath"
    return
}
$InputData = Get-Content $InputFilePath
$Start = $AocData.Start
$ZeroCount = 0
$SafeData = @{
    Min = $AocData.Min
    Max = $AocData.Max
}
foreach ( $Turn in $InputData ) {
    $Direction = $Turn.ToCharArray()[0]
    $Clicks = [int]($Turn.TrimStart($Direction))

    $ClickParams = @{
        Start = $Start
        Direction = $Direction
        Clicks = $Clicks
    }
    # figure out the next position
    $NewPos = Move-Dial @ClickParams @SafeData

    # count how many times we end at zero or pass zero
    $ZeroHits = Count-Zero @ClickParams
    $ZeroCount += $ZeroHits

    $Start = $NewPos
}
Write-Host "Moves ending at 0: $ZeroCount"