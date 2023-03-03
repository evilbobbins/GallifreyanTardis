#title:         CreateComputer.ps1
#description:   Edit object Description
#logo site      https://texteditor.com/multiline-text-art/
#author:        Dave Edwards
#created:       September 15 2022
#updated:       
#version:       1.0
#usage:         ./description_v2.ps1
#===================================================

#Preload
Remove-Variable * -ErrorAction SilentlyContinue
Clear-Host
$ErrorActionPreference = 'SilentlyContinue'

#Variables
$global:logo = @"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━┏━━━┓━━━━━━━━━━━━━┏┓━━━━━━━━━┏━━━┓━━━━━━━━━━━━━━━━━┏┓━━━━━━━━━━━━┏━━━┓━━━━━━━━━━━━━━━━━━━━━┏┓━━━
━━┃┏━┓┃━━━━━━━━━━━━┏┛┗┓━━━━━━━━┃┏━┓┃━━━━━━━━━━━━━━━━┏┛┗┓━━━━━━━━━━━┃┏━┓┃━━━━━━━━━━━━━━━━━━━━┏┛┗┓━━
━━┃┃━┗┛┏━┓┏━━┓┏━━┓━┗┓┏┛┏━━┓━━━━┃┃━┗┛┏━━┓┏┓┏┓┏━━┓┏┓┏┓┗┓┏┛┏━━┓┏━┓━━━━┃┃━┃┃┏━━┓┏━━┓┏━━┓┏┓┏┓┏━┓━┗┓┏┛━━
━━┃┃━┏┓┃┏┛┃┏┓┃┗━┓┃━━┃┃━┃┏┓┃━━━━┃┃━┏┓┃┏┓┃┃┗┛┃┃┏┓┃┃┃┃┃━┃┃━┃┏┓┃┃┏┛━━━━┃┗━┛┃┃┏━┛┃┏━┛┃┏┓┃┃┃┃┃┃┏┓┓━┃┃━━━
━━┃┗━┛┃┃┃━┃┃━┫┃┗┛┗┓━┃┗┓┃┃━┫━━━━┃┗━┛┃┃┗┛┃┃┃┃┃┃┗┛┃┃┗┛┃━┃┗┓┃┃━┫┃┃━━━━━┃┏━┓┃┃┗━┓┃┗━┓┃┗┛┃┃┗┛┃┃┃┃┃━┃┗┓━━
━━┗━━━┛┗┛━┗━━┛┗━━━┛━┗━┛┗━━┛━━━━┗━━━┛┗━━┛┗┻┻┛┃┏━┛┗━━┛━┗━┛┗━━┛┗┛━━━━━┗┛━┗┛┗━━┛┗━━┛┗━━┛┗━━┛┗┛┗┛━┗━┛━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┗┛━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

"@
$global:adserver = "Working server name" # AD server to lockon to
$global:AD1 = "OU LOCATION"
$global:AD2= "OU LOCATION"
$global:AD3 = "OU LOCATION"



#Functions
Function logo {
Clear-Host
write-host $logo
}

Function ADCheck {
#pre Check AD server is Up
Write-Host -Verbose "Preforming Pre Checks`n" -ForegroundColor Green
Write-Host -Verbose "Checking AD Server $adserver `n" -ForegroundColor Green
$adserverup = Get-AdComputer -Identity $adserver -Properties *

if(!$adserverup) {
 
        Write-Host -Verbose "WARNING! Ad server $adserver Not Found!`n" -ForegroundColor Red
        Write-Host -Verbose "Check Network and server settings`n" -ForegroundColor Red
        Write-Host "Exiting Script" -ForegroundColor Red
        Start-Sleep -Seconds 2
        Exit
}
else {
       Write-Host -Verbose "Ad server $adserver Found!`n" -ForegroundColor Green

}
}

Function Compname {
#setup computer name and current description

$global:pcname = Read-Host -Prompt "Enter PC Name"
$global:objComputer = Get-AdComputer -Identity $pcname -Properties * -Server $adserver
Start-Sleep -Seconds 2

if(!$objComputer) {
 
        Write-Host -Verbose "$pcname Not Found!`n" -ForegroundColor Green
        Start-Sleep -Seconds 2
        Createcompmenu
        
}
else {
        Write-Host -Verbose "$pcname Found!`n" -ForegroundColor Red
        $global:objComputercur = Get-AdComputer -Identity $pcname -Properties * -Server $adserver
        $global:compnamecur = $objComputercur | Select-Object -Property @{Name = 'Name'; Expression = {$_.Name}}
        $global:compdeccur = $objComputercur | Select-Object -Property @{Name = 'Description'; Expression = {$_.'Description'}}
        Removecompmenu
}
}

Function Createcompmenu {

        do {
                do {
                    write-host ""
                    write-host "A - Create AD1"
                    write-host "B - Create AD2"
                    write-host "C - Create AD3"
                    write-host ""
                    write-host "R - Restart"
                    write-host ""
                    write-host "X - Exit"
                    write-host ""
                    write-host -nonewline "Type your choice and press Enter: "
                    
                    $choice = read-host
                    
                    write-host ""
                    
                    $ok = $choice -match '^[abcrx]+$'
                    
                    if ( -not $ok) { write-host "Invalid selection" }
                } until ( $ok )
                
                switch -Regex ( $choice ) {
                    "A"
                    {
                        CreateAD1
                        
                    }
                    
                    "B"
                    {
                        CreateAD2
                    }
            
                    "C"
                    {
                        CreateAD3
                    }

                    "R"
                    {
                        Reload
                    }
                }
            } until ( $choice -match "X" )
              exit
            
}

Function Removecompmenu {

        do {
                do {
                if($objComputer) {
                    Write-Host -Verbose "WARNING! $pcname Already Exists!" -ForegroundColor Red
                    #write-host ad location command here
                    $compnamecur, $compdeccur | Format-List
                    }
                    write-host ""
                    write-host "A - Remove Computer"
                    write-host ""
                    write-host "R - Restart"
                    write-host ""
                    write-host "X - Exit"
                    write-host ""
                    write-host -nonewline "Type your choice and press Enter: "
                    
                    $choice = read-host
                    
                    write-host ""
                    
                    $ok = $choice -match '^[arx]+$'
                    
                    if ( -not $ok) { write-host "Invalid selection" }
                } until ( $ok )
                
                switch -Regex ( $choice ) {
                    "A"
                    {
                        RemoveComp
                        
                    }
                    
                    "R"
                    {
                        Reload
                    }

                }
            } until ( $choice -match "X" )
              exit
            
}


Function CreateBHX {
    Write-Host "`nCreate $pcname In`n$AD1`n" -ForegroundColor Green
    $confirmation = Read-Host "Create Computer Object in AD1? (y)"
    if ($confirmation -eq 'y') {
New-ADComputer -Name "$pcname" -SamAccountName "$pcname" -PATH "$BHX"
Start-Sleep -Seconds 10
Reload
else {
    Createcompmenu
}
}
}

Function CreateCBD {
    Write-Host "`nCreate $pcname In`n$AD2`n" -ForegroundColor Green
    $confirmation = Read-Host "Create Computer Object in AD2? (y)"
    if ($confirmation -eq 'y') {
New-ADComputer -Name "$pcname" -SamAccountName "$pcname" -PATH "$CBD"
Start-Sleep -Seconds 10
Reload
else {
    Createcompmenu
}
}
}

Function CreateLON {
    Write-Host "`nCreate $pcname In`n$AD3`n" -ForegroundColor Green
    $confirmation = Read-Host "Create Computer Object in AD3? (y)"
    if ($confirmation -eq 'y') {
New-ADComputer -Name "$pcname" -SamAccountName "$pcname" -PATH "$LON"
Start-Sleep -Seconds 10
Reload
else {
    Createcompmenu
}
}
}

Function RemoveComp {
        Write-Host -Verbose "Remove $pcname" -ForegroundColor Red
        $confirmation = Read-Host "Do you want to delete $pcname? (y)"
        if ($confirmation -eq 'y') {
        Remove-ADComputer -Identity "$objComputer" -Server $adserver
        Write-Host -Verbose "Removing $pcname" -ForegroundColor Red
        Start-Sleep -Seconds 8
        Reload
        else {
        Removecompmenu
        }
}
}

Function Reload {
Remove-Variable objComputer* -Scope Global
logo
Compname
}

#Action list
logo
ADCheck
Compname
