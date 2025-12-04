function Count-Zero {
    [CmdletBinding()]
    param (
        [int]$Start,

        [ValidateSet('L','R')]
        [char]$Direction,

        [int]$Clicks,

        [ValidateSet('while','fe-o','fe','for')]
        [string]$Loop = 'while'
    )
    $Result = 0
    $Position = $Start
    # added this to test which loop is the fastest - while, foreach, and for were all about the same, while foreach-object was the slowest
    switch ( $Loop ) {
        'while' {
            $i = 0
            while ( $i -lt $Clicks ) {
                if ( $Direction -eq 'R' ) {
                    $Position += 1
                } else {
                    $Position -= 1
                }
                if ( ($Position % 100) -eq 0 ) {
                    $Result++
                }
                $i++
            }
        }
        'fe-o' {
            (1..$Clicks) | ForEach-Object {
                if ( $Direction -eq 'R' ) {
                    $Position += 1
                } else {
                    $Position -= 1
                }
                if ( ($Position % 100) -eq 0 ) {
                    $Result++
                }
            }
        }
        'fe' {
            foreach ( $i in (1..$Clicks) ) {
                if ( $Direction -eq 'R' ) {
                    $Position += 1
                } else {
                    $Position -= 1
                }
                if ( ($Position % 100) -eq 0 ) {
                    $Result++
                }
            }
        }
        'for' {
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
        }
    }
    $Result
}