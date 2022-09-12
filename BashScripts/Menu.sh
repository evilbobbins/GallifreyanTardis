#!/bin/bash
#title:         menu.sh
#description:   Update Menu which allows multiple items to be selected
#author:        Dave Edwards
#               Based on script from MestreLion
#created:       September 10 2022
#updated:       N/A
#version:       1.0 (v3 of update Script new code base)
#usage:         ./menu.sh
#==============================================================================

# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
clear='\033[0m' # Clear the color

#Menu options
options[0]="Main (Nala)"
options[1]="Main (Apt)"
options[2]="Snap"
options[3]="Flatpak"

function LOG {
log=/home/bobbins/Documents/Scripts/log_file.txt
# create log file or overrite if already present
printf "Log File - " > $log
# append date to log file
date >> $log
}

function LOGEND {
    printf "End of log\n\n\n" >> $log
}

#Actions to take based on selection
function ACTIONS {
    if [[ ${choices[0]} ]]; then
        #Option 1 selected
        echo "Main Updates Using Nala"
        upmainnala="true"
    fi
    if [[ ${choices[1]} ]]; then
        #Option 2 selected
        echo "Main Updates Using APT"
        upmainapt="true"
    fi
    if [[ ${choices[2]} ]]; then
        #Option 3 selected
        echo "Updating Snap"
        upsnap="true"
    fi
    if [[ ${choices[3]} ]]; then
        #Option 4 selected
        echo "Updating Flatpak"
        upflatp="true"
    fi
}

#Variables
ERROR=" "

#Clear screen for menu
clear

#Menu function
function MENU {
    echo -e "Welcome to the update menu\n\n"
    echo -e "Update Options\n"
    for NUM in ${!options[@]}; do
        echo "[""${choices[NUM]:- }""]" $(( NUM+1 ))") ${options[NUM]}"
    done
    echo "$ERROR"
}

#Menu loop

while MENU && read -e -p "Select the desired options using their number (again to uncheck, ENTER when done): " -n1 SELECTION && [[ -n "$SELECTION" ]]; do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done

ACTIONS
if [ "$upmainnala" == "true" ]
then
    pman="nala"
    sudo $pman update
    sudo $pman upgrade -y
    sudo $pman autoremove -y
fi

if [ "$upmainapt" == "true" ]
then
    pman="apt"
    sudo $pman Update
    sudo $pman upgrade -y
    sudo $pman autoremove -y
fi

if [ "$upsnap" == "true" ]
then
LOG
    sudo snap refresh |& tee $log
LOGEND 
fi

if [ "$upflatp" == "true" ]
then
LOG
    sudo flatpak update -y >> $log
    echo -e "Removing Unused Flatpaks"
    sudo flatpak uninstall --unused >> $log
LOGEND 
fi

echo -e "\n#================================================================#"
echo -e "#                           ${green}Script Finished!${clear}                     #"
echo -e "#================================================================#"
echo -e "#                           ${green}Have A Nice Day!${clear}                     #"
echo -e "#================================================================#"
