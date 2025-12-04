<#
This is the solution for Advent of Code 2025 Day 1, Part 1
#>
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
[string]$InputFilePath = "$PSScriptRoot\AoCode_1_Input.txt"
if ( -not (Test-Path $InputFilePath) ) {
    Write-Warning "Cannot find input file: $InputFilePath"
    return
}
$InputData = Get-Content $InputFilePath
$Start = 50
$Max = 99
$Min = 0
$Positions = @($Min..$Max)
$ZeroCount = 0
foreach ( $Turn in $InputData ) {
    $Direction = $Turn.ToCharArray()[0]
    $Clicks = [int]($Turn.TrimStart($Direction))
    $NewPos = Move-Dial -Start $Start -Direction $Direction -Clicks $Clicks
    if ( $NewPos -eq 0 ) { $ZeroCount++ }
    $Start = $NewPos
}
Write-Host "Moves ending at 0: $ZeroCount"