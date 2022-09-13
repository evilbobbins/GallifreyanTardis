#title:         Descriptions_v2.ps1
#description:   Edit object Description
#logo site      https://texteditor.com/multiline-text-art/
#author:        Dave Edwards
#created:       September 13 2022
#updated:       September 13 2022
#version:       2.0
#usage:         ./description_v2.ps1
#===================================================

Remove-Variable * -ErrorAction SilentlyContinue
Clear-Host
$ErrorActionPreference = 'SilentlyContinue'

#logo site
#https://texteditor.com/multiline-text-art/


#Variables
$logo = @"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━┏━━━┓━━━━━━━━━━━━━━━━━┏┓━━━━━━━━━━━━┏━━━┓━━━━━━━━━━━━━━━━━━━━━━┏┓━━━━━━━━━━━━━
━━┃┏━┓┃━━━━━━━━━━━━━━━━┏┛┗┓━━━━━━━━━━━┗┓┏┓┃━━━━━━━━━━━━━━━━━━━━━┏┛┗┓━━━━━━━━━━━━
━━┃┃━┗┛┏━━┓┏┓┏┓┏━━┓┏┓┏┓┗┓┏┛┏━━┓┏━┓━━━━━┃┃┃┃┏━━┓┏━━┓┏━━┓┏━┓┏┓┏━━┓┗┓┏┛┏┓┏━━┓┏━━┓━━
━━┃┃━┏┓┃┏┓┃┃┗┛┃┃┏┓┃┃┃┃┃━┃┃━┃┏┓┃┃┏┛━━━━━┃┃┃┃┃┏┓┃┃━━┫┃┏━┛┃┏┛┣┫┃┏┓┃━┃┃━┣┫┃┏┓┃┃┏┓┓━━
━━┃┗━┛┃┃┗┛┃┃┃┃┃┃┗┛┃┃┗┛┃━┃┗┓┃┃━┫┃┃━━━━━┏┛┗┛┃┃┃━┫┣━━┃┃┗━┓┃┃━┃┃┃┗┛┃━┃┗┓┃┃┃┗┛┃┃┃┃┃━━
━━┗━━━┛┗━━┛┗┻┻┛┃┏━┛┗━━┛━┗━┛┗━━┛┗┛━━━━━┗━━━┛┗━━┛┗━━┛┗━━┛┗┛━┗┛┃┏━┛━┗━┛┗┛┗━━┛┗┛┗┛━━
━━━━━━━━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━┗┛━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┗┛━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

"@
$global:adserver = "SDCBFISLTC21" # AD server to lockon to 
$global:builddesk = "* On Build Desks" #Build desk name

#Functions

Function logo {
Clear-Host
write-host $logo
}

function menu {

        do {
                do {
                    write-host ""
                    write-host "A - For Build Desk"
                    write-host "B - Assisted Entry"
                    write-host "C - Full Manual"
                    write-host "D - Reload"
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
                        BuildDeskCheck
                    }
                    
                    "B"
                    {
                        AssistedEntry
                    }
            
                    "C"
                    {
                        ManualEntryCheck
                    }
            
                    "D"
                    {
                        write-host "Reload Description - not built yet"
                    }
                }
            } until ( $choice -match "X" )
            
}


Function menuheader {
logo
Write-Host -Verbose "Using $adserver Server`n"
#Write-Host -Verbose "Current $pcname Description"
$compnamecur, $compdeccur | Format-List
menu
}

Function NoChangesMade {
Write-Host "No Changes made`n" -ForegroundColor Green
Write-Host "Exiting Script" -ForegroundColor Green
Start-Sleep -Seconds 2
menuheader 
#Exit
}

Function ChangesMade {
Write-Host "Update of $pcname Compleate`n"
Write-Host "Exiting Script"
Start-Sleep -Seconds 2
#Exit
menuheader 
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

if(!$objComputer) {
 
        Write-Host -Verbose "WARNING! $pcname Not Found!`n" -ForegroundColor Red
        Write-Host "Exiting Script" -ForegroundColor Green
        Start-Sleep -Seconds 2
        Exit
}
else {
        Write-Host -Verbose "$pcname Found!`n" -ForegroundColor Green
        $global:objComputercur = Get-AdComputer -Identity $pcname -Properties * -Server $adserver
        $global:compnamecur = $objComputercur | Select-Object -Property @{Name = 'Name'; Expression = {$_.Name}}
        $global:compdeccur = $objComputercur | Select-Object -Property @{Name = 'Description'; Expression = {$_.'Description'}}
        Start-Sleep 2
}
}

Function BuildDeskCheck {

$confirmation = Read-Host "For Build Desk? (y)"
if ($confirmation -eq 'y') {
Write-Host "`nCurrent $pcname Description" -ForegroundColor Green -NoNewline
$compnamecur, $compdeccur | Format-List

Write-Host "Update Description to`n$pcname - $builddesk`n" -ForegroundColor Red

$confirmation = Read-Host "Do you want to continue with update? (y)"
if ($confirmation -eq 'y') {

Write-Host "`nUpdating description Of $pcname to $builddesk`n" -ForegroundColor Green
Set-ADComputer $pcname -Description "$builddesk" -Server $adserver
Write-Host "Please wait updating" -ForegroundColor Green
Start-Sleep 10
$objComputerupdated = Get-AdComputer -Identity $pcname -Properties * -Server $adserver
$compname = $objComputerupdated | Select-Object -Property @{Name = 'Name'; Expression = {$_.Name}}
$compdec = $objComputerupdated | Select-Object -Property @{Name = 'Description'; Expression = {$_.'Description'}}
$compname, $compdec | Format-List
ChangesMade
}
else {
menuheader
NoChangesMade
}
}
}

Function ManualEntryCheck {
$confirmation = Read-Host "Full Manual Entry? (y)"
if ($confirmation -eq 'y') {

$manual = Read-Host -Prompt "`nEnter full name and description"

Write-Host "Update Description to`n$pcname - $manual`n" -ForegroundColor Red

$confirmation = Read-Host "Do you want to continue with update? (y)"
if ($confirmation -eq 'y') {

Write-Host "`nUpdating description Of $pcname to $manual`n" -ForegroundColor Green
Set-ADComputer $pcname -Description "$manual" -Server $adserver
Write-Host "Please wait updating" -ForegroundColor Green
Start-Sleep 10
$objComputerupdated = Get-AdComputer -Identity $pcname -Properties * -Server $adserver
$compname = $objComputerupdated | Select-Object -Property @{Name = 'Name'; Expression = {$_.Name}}
$compdec = $objComputerupdated | Select-Object -Property @{Name = 'Description'; Expression = {$_.'Description'}}
$compname, $compdec | Format-List
ChangesMade
}
else {
menuheader
NoChangesMade
}
}
}

Function LaptopType {

#$Computermodel = Read-Host -Prompt "`nEnter Computer Type"

write-output "Laptop type`n"
$type = Read-Host "1 = Latitude 2 = Precison"

switch ($type)

{

"1"

{ $global:type1 = "Latitude" }

"2"

{ $global:type1 = "Precision" }

default

{ Write-Host "You did not choose wisely! `nsetting type as empty!" -ForegroundColor Red }

}



if($type1 -match 'Latitude') {

#$Computermodel = Read-Host -Prompt "`nEnter Computer Model"

write-output "Laptop type`n"
$model = Read-Host "1 = 5400 2 = 7420 3 = 7430"

switch ($model)

{

"1"

{ $global:model1 = "5400" }

"2"

{ $global:model1 = "7420" }

"3"

{ $global:model1 = "7430" }

default

{ Write-Host "You did not choose wisely! `nsetting type as empty!" -ForegroundColor Red }

}
}

else {
#$Computermodel = Read-Host -Prompt "`nEnter Computer Model"

write-output "Laptop type`n"
$model = Read-Host "1 = 3571 2 = 5560 3 = 5570"

switch ($model)

{

"1"

{ $global:model1 = "3571" }

"2"

{ $global:model1 = "5560" }

"3"

{ $global:model1 = "5570" }

default

{ Write-Host "You did not choose wisely! `nsetting type as empty!" -ForegroundColor Red }

}

}
}

Function AssistedEntry {

$confirmation = Read-Host "Assisted Entry? (y)"
if ($confirmation -eq 'y') {

$User = Read-Host -Prompt "`nEnter Users name"
$Dep = Read-Host -Prompt "`nEnter Users Depatment"

LaptopType

$objComputercur = Get-AdComputer -Identity $pcname -Properties * -Server $adserver
$compnamecur = $objComputercur | Select-Object -Property @{Name = 'Name'; Expression = {$_.Name}}
$compdeccur = $objComputercur | Select-Object -Property @{Name = 'Description'; Expression = {$_.'Description'}}
#$objComputer = Get-AdComputer -Identity $pcname -Properties *
$description = "$User - $Dep - Dell $type1 $model1"

Write-Host "`nCurrent $pcname Description" -ForegroundColor Green
$compnamecur, $compdeccur | Format-List

Write-Host "Update $pcname Description to`n$description`n" -ForegroundColor Red

$confirmation = Read-Host "Do you want to continue with update? (y)"
if ($confirmation -eq 'y') {

Write-Host "`nUpdating description`n" -ForegroundColor Green
Set-ADComputer $pcname -Description "$description" -Server $adserver
Write-Host "Please wait updating" -ForegroundColor Green
Start-Sleep 10
$objComputerupdated = Get-AdComputer -Identity $pcname -Properties * -Server $adserver
$compname = $objComputerupdated | Select-Object -Property @{Name = 'Name'; Expression = {$_.Name}}
$compdec = $objComputerupdated | Select-Object -Property @{Name = 'Description'; Expression = {$_.'Description'}}
$compname, $compdec | Format-List
ChangesMade

}
}

else {
menuheader
NoChangesMade
}
}


#Action list

logo
ADCheck
Compname
menuheader
menu
