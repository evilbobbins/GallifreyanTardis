#!/bin/bash
#title:         menu.sh
#description:   Update Menu which allows multiple items to be selected
#author:        Dave Edwards
#               Based on script from MestreLion
#created:       September 10 2022
#updated:       September 21 2022
#version:       1.1 (v3 of update Script new code base)
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
options[0]="Check (Nala)"
options[1]="Check (Apt)"
options[2]="Check and Update (Nala)"
options[3]="Check and Update (Apt)"
options[4]="Snap"
options[5]="Flatpak"
options[6]="Exit"

#Start log file
function LOG {
    log=/home/bobbins/Documents/Scripts/log_file.txt
    # create log file or overrite if already present
    printf "Log File - " > $log
    # append date to log file
    date >> $log
}

#End log file
function LOGEND {
    printf "End of log\n\n\n" >> $log
}

#Logo Display
function LOGO {
    cat logo.txt
}

#Actions to take based on selection
function ACTIONS {
    if [[ ${choices[0]} ]]; then
        #Option 1 selected
        echo "Check for Updates Using Nala"
        checknala="true"
    fi
    if [[ ${choices[1]} ]]; then
        #Option 2 selected
        echo "Check for Updates Using APT"
        checkapt="true"
    fi

    if [[ ${choices[2]} ]]; then
        #Option 1 selected
        echo "Check and update Using Nala"
        upmainnala="true"
    fi
    if [[ ${choices[3]} ]]; then
        #Option 2 selected
        echo "Check and update Using APT"
        upmainapt="true"
    fi
    if [[ ${choices[4]} ]]; then
        #Option 3 selected
        echo "Updating Snap"
        upsnap="true"
    fi
    if [[ ${choices[5]} ]]; then
        #Option 4 selected
        echo "Updating Flatpak"
        upflatp="true"
    fi

    if [[ ${choices[6]} ]]; then
        #Option 4 selected
        echo "Exiting"
        exit
    fi
}

#Variables
ERROR=" "

#Clear screen for menu
clear

#Menu function
function MENU {
    LOGO
    echo -e "\n\nWelcome to the update menu\n"
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

#Actions to process
ACTIONS
if [ "$checknala" == "true" ]
    then
        pman="nala"
       sudo $pman update
    fi

    if [ "$checkapt" == "true" ]
    then
        pman="apt"
        sudo $pman update
    fi
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
        sudo $pman update
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
