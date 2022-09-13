function menu {


do {
    do {
        write-host ""
        write-host "A - Selection A"
        write-host "B - Selection B"
        write-host "C - Selection C"
        write-host "D - Selection D"
        write-host ""
        write-host "X - Exit"
        write-host ""
        write-host -nonewline "Type your choice and press Enter: "
        
        $choice = read-host
        
        write-host ""
        
        $ok = $choice -match '^[abcdx]+$'
        
        if ( -not $ok) { write-host "Invalid selection" }
    } until ( $ok )
    
    switch -Regex ( $choice ) {
        "A"
        {
            write-host "You entered 'A'"
        }
        
        "B"
        {
            write-host "You entered 'B'"
        }

        "C"
        {
            write-host "You entered 'C'"
        }

        "D"
        {
            write-host "You entered 'D'"
        }
    }
} until ( $choice -match "X" )

}

menu
