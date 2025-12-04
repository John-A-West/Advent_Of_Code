<#
I got off on a tangent with exploring the speeds of different kinds of loops...
#>

# import helper functions
$HelperFolder = Join-Path -Path (Split-Path $PSScriptRoot) -ChildPath "Helpers\Day_1"
Get-ChildItem -Path $HelperFolder -Recurse -Filter "*.ps1" | ForEach-Object { Import-Module $_.FullName }

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
# this part will display the speed of different kinds of loops

'fe-o','fe','for','while' | ForEach-Object {
    $LoopData = @{
        Loop = $PSItem
        Start = $AocData.Start
        InputData = $InputData
        SafeData = $SafeData
    }
    $Time = Measure-Command -InputObject $LoopData -Expression {
        $ZeroCount = 0
        $Start = $_.Start
        $InputData = $_.InputData
        $SafeData = $_.SafeData
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
            $ZeroHits = Count-Zero @ClickParams -Loop $_.Loop
            $ZeroCount += $ZeroHits

            $Start = $NewPos
        }
    }
    [PSCustomObject]@{
        Loop = $PSItem
        Time = (Format-TimeSpan $Time) # Format-TimeSpan is one of my custom functions
    }
} | Format-Table -AutoSize

Write-Host "Moves ending at 0: $ZeroCount"