<#
This is the solution for Advent of Code 2025 Day 1, Part 1
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
    $NewPos = Move-Dial @ClickParams @SafeData
    if ( $NewPos -eq 0 ) { $ZeroCount++ }
    $Start = $NewPos
}
Write-Host "Moves ending at 0: $ZeroCount"