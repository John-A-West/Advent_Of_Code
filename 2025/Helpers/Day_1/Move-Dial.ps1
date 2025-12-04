function Move-Dial {
    [CmdletBinding()]
    param (
        [int]$Start,

        [ValidateSet('L','R')]
        [char]$Direction,

        [int]$Clicks,

        [int]$Min = 0,

        [int]$Max = 99
    )
    if ( $Direction -eq 'R' ) {
        # turn to the right
        if ( ($Start + $Clicks) -le $Max ) {
            $Start + $Clicks
        } else {
            $ClicksToMin = $Max - $Start + 1 # how many clicks does it take to get to $Min
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
            $ClicksToMax = $Start + 1 # how many clicks does it take to get to $Max
            $MoveParams = @{
                Start = $Max
                Direction = $Direction
                Clicks = ($Clicks - $ClicksToMax)
            }
            Move-Dial @MoveParams
        }
    }
}