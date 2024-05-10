#!/bin/bash

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
Grey='\e[0;90m'         # Grey

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White
BGrey='\e[1;90m'        # Grey

choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    local max_length=0

    # Calculate the maximum length of the options for proper alignment
    for opt in "${options[@]}"; do
        if [ ${#opt} -gt $max_length ]; then
            max_length=${#opt}
        fi
    done

    # Hide cursor
    echo -en "${esc}[?25l"

    # Trap SIGINT (Ctrl+C) and show cursor before exiting
    trap 'echo -en "${esc}[?25h"; exit 1' INT

    while true; do
        # Display the menu prompt
        echo -en "${Blue}? ${White}${prompt} ${Grey}› - Use arrow-keys. Return to submit.\n"

        # Display the options
        for ((i=0; i<$count; i++)); do
            if [ "$i" == "$cur" ]; then
                echo -e "${Green}❯ ${esc}[4m${options[$i]}${esc}[0m"
            else
                echo -e "  ${White}${options[$i]}"
            fi
        done
        
        # Read user input
        read -s -n3 key

        # Move cursor up after displaying the options
        echo -en "\033[$(($count + 1))A"

        # Clear the line where the menu was displayed
        echo -en "\r\033[K"

        if [[ $key == $esc[A ]]; then # up arrow
            cur=$(( ($cur - 1 + $count) % $count ))
        elif [[ $key == $esc[B ]]; then # down arrow
            cur=$(( ($cur + 1) % $count ))
        elif [[ $key == "" ]]; then # Enter key
            break
        fi
    done

    # Export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"

    # Show cursor
    echo -en "${esc}[?25h"

    # Remove the SIGINT trap
    trap - INT

    # Display the selected option with a ✔
    echo -e "${Green}✔ ${White}${prompt} ${Grey}› ${Purple}${options[$cur]}"
}

initialize_project() {
    local project_name="$1"
    local language="$2"
    local git="$3"
    ./languages/"$language".sh "$project_name" "$git"
}

# Function to check if a directory exists
directory_exists() {
    local directory="$1"
    if [ -d "$directory" ]; then
        return 0 # Directory exists
    else
        return 1 # Directory does not exist
    fi
}

display_banner() {
    echo ""
    sleep 0.1
    echo -e "   ${Green}██╗███╗   ██╗██╗████████╗    ${Red}██${Grey}╗    ${Red}██${Grey}╗${Red}██${Grey}╗${Red}███████${Grey}╗ ${Red}█████${Grey}╗ ${Red}██████${Grey}╗ ${Red}██████${Grey}╗"
    sleep 0.1
    echo -e "   ${Green}██║████╗  ██║██║╚══██╔══╝    ${Red}██${Grey}║    ${Red}██${Grey}║${Red}██${Grey}║╚══${Red}███${Grey}╔╝${Red}██${Grey}╔══${Red}██${Grey}╗${Red}██${Grey}╔══${Red}██${Grey}╗${Red}██${Grey}╔══${Red}██${Grey}╗"
    sleep 0.1
    echo -e "   ${Green}██║██╔██╗ ██║██║   ██║       ${Red}██${Grey}║ ${Red}█${Grey}╗ ${Red}██${Grey}║${Red}██${Grey}║  ${Red}███${Grey}╔╝ ${Red}███████${Grey}║${Red}██████${Grey}╔╝${Red}██${Grey}║  ${Red}██${Grey}║"
    sleep 0.1
    echo -e "   ${Green}██║██║╚██╗██║██║   ██║       ${Red}██${Grey}║${Red}███${Grey}╗${Red}██${Grey}║${Red}██${Grey}║ ${Red}███${Grey}╔╝  ${Red}██${Grey}╔══${Red}██${Grey}║${Red}██${Grey}╔══${Red}██${Grey}╗${Red}██${Grey}║  ${Red}██${Grey}║"
    sleep 0.1
    echo -e "   ${Green}██║██║ ╚████║██║   ██║       ${Grey}╚${Red}███${Grey}╔${Red}███${Grey}╔╝${Red}██${Grey}║${Red}███████${Grey}╗${Red}██${Grey}║  ${Red}██${Grey}║${Red}██${Grey}║  ${Red}██${Grey}║${Red}██████${Grey}╔╝"
    sleep 0.1
    echo -e "   ${Green}╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝        ${Grey}╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝"
    echo -e "${White}"
}

display_banner

echo -en "${Blue}? ${White}Project name: "
read project_name

# Check if the project folder already exists
m=true
while $m ; do
    if [ -d "$project_name" ]; then
        echo -e "${Red}Error:${White} Project folder '$project_name' already exists."
        read -p "Do you want to replace it (r) or make a new one with a different name (n)? " choice
        case "$choice" in
            [Rr]* ) rm -rf "$project_name";;
            [Nn]* ) read -p "Enter a new project name: " project_name;;
            * ) echo "Invalid option. Exiting."; exit 1;;
        esac
    else
        m=false
    fi
done

languages=("c" "cpp" "node" "vite")
choose_from_menu "Select a framework:" language "${languages[@]}"

selections=("Yes" "No")
choose_from_menu "Do you want to create a git repository?" git "${selections[@]}"

initialize_project "$project_name" "$language" "$git"
