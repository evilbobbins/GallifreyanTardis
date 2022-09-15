#title:         CreatComputer.ps1
#description:   Edit object Description
#logo site      https://texteditor.com/multiline-text-art/
#author:        Dave Edwards
#created:       September 15 2022
#updated:       
#version:       1.0
#usage:         ./createcomputer.ps1
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
$global:adserver = "SDCBFISLTC21" # AD server to lockon to
$global:BHX = "OU=UK-Birmingham,OU=EMEA,OU=Workstations,OU=FIS,DC=FNFIS,DC=com"
$global:CBD = "OU=UK-Cumbernauld,OU=EMEA,OU=Workstations,OU=FIS,DC=FNFIS,DC=com"
$global:LON = "OU=UK-Canary Wharf,OU=EMEA,OU=Workstations,OU=FIS,DC=FNFIS,DC=com"



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
 
        Write-Host -Verbose "$pcname Not Found!`n" -ForegroundColor Red
        Start-Sleep -Seconds 2
        Createcompmenu
        
}
else {
        Write-Host -Verbose "$pcname Found!`n" -ForegroundColor Green
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
                    write-host "A - Create BHX"
                    write-host "B - Create CBD"
                    write-host "C - Create LON"
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
                        CreateBHX
                        
                    }
                    
                    "B"
                    {
                        CreateCBD
                    }
            
                    "C"
                    {
                        CreateLON
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
write-host "BHX"
exit
}

Function CreateCBD {
write-host "CBD"
exit
}

Function CreateLON {
write-host "LON"
exit
}

Function RemoveComp {
write-host "REMOVE"
exit
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
