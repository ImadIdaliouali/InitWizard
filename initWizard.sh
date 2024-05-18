#!/bin/bash

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0m'           # White
Grey='\e[0;90m'         # Grey

# Bold
BBlue='\e[1;34m'        # Blue

choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift 2
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
    trap 'echo -e "${Red}✖${White} Operation cancelled";echo -en "${esc}[?25h"; exit 1' INT

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
    echo -e "${Green}✔ ${White}${prompt} ${Grey}› ${Purple}${options[$cur]}${White}"
    # Clear the rest of the screen
    tput ed
}

initialize_project() {
    local project_name="$1"
    local language="${2,,}"
    local git="$3"
    ./languages/"$language".sh "$project_name" "$git" 
    create_readme "$project_name"
    if [ "$git" = "Yes" ]; then
        initialize_git_repo "$project_name"
    fi
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

# Function to log messages
log_message() {
    local type="$1"
    local message="$2"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local username=$(whoami)
    echo "$timestamp : $username : $type : $message" | sudo tee -a /var/log/initWizard/history.log
}

# Function to execute the program in a subshell
execute_in_subshell() {
    local script="$1"
    local args=("$@")  # Store all arguments in an array
    # Execute the script in a subshell
    (
        source "$script" "${args[@]}"
    )
}

# Function to display help message
display_help() {
    echo -e "${White}Usage:${White} $0 [options]\n"
    echo -e "${White}Options:"
    echo -e "  ${BBlue}-h${White}, ${BBlue}--help${White}          Display this help message"
    echo -e "  ${BBlue}-f${White}, ${BBlue}--fork${White}          Enable fork execution"
    echo -e "  ${BBlue}-t${White}, ${BBlue}--thread${White}        Enable thread execution"
    echo -e "  ${BBlue}-s${White}, ${BBlue}--subshell${White}      Execute program in a subshell"
    echo -e "  ${BBlue}-l${White}, ${BBlue}--log${White}           Specify a directory for log file storage"
    echo -e "  ${BBlue}-r${White}, ${BBlue}--restore${White}       Reset to default settings (admin only)"
    echo -e "\n${White}Example:${White} $0 --log"
}

# Function to initialize a git repository
initialize_git_repo() {
    local project_name="$1"
    cd "$project_name" || exit
    git init
    git add .
    git commit -m "Initial commit"
}

# Function to create README.md
create_readme() {
    local project_name="$1"
    echo "# $project_name" > "$project_name/README.md"
}

# Function to display the banner
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

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Check if log directory exists, if not, create it
log_dir="/var/log/InitWizard"
if ! directory_exists "$log_dir"; then
    sudo mkdir -p "$log_dir"
fi

# Check if log file exists, if not, create it
log_file="$log_dir/history.log"
if [ ! -f "$log_file" ]; then
    sudo touch "$log_file"
fi

# Parse command-line options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            display_help
            exit 0
            ;;
        -l|--log)
            # Enable logging
            LOG_ENABLED=true
            shift
            ;;
        -s|--subshell)
            # Execute the program in a subshell
            execute_in_subshell "$0" "$@"
            exit 0
            ;;
        *)
            echo "Invalid option: $1" >&2
            display_help
            exit 1
            ;;
    esac
done

display_banner

# Trap SIGINT (Ctrl+C) and show a message before exiting
trap 'echo -e "\n${Red}✖${White} Operation cancelled"; exit 1' INT

echo -en "${Blue}? ${White}Project name: ${Grey}›${White} "
read project_name

# if user presses enter without entering a project name
if [ -z "$project_name" ]; then
    # Clear the line where the project name prompt was displayed
    echo -en "\033[1A"  # Move cursor up one line
    echo -en "\r\033[K"  # Clear the line

    echo -e "${Red}✖${White} Project name cannot be empty"
    echo -e "${Red}✖${White} Operation cancelled"
    exit 1
fi

# Check if the project folder already exists
m=true
while $m ; do
    if [ -d "$project_name" ]; then
        # Clear the line where the project name prompt was displayed
        echo -en "\033[1A"  # Move cursor up one line
        echo -en "\r\033[K"  # Clear the line

        echo -e "${Red}✖${White} Project folder ${Yellow}'$project_name'${White} already exists."
        echo -en "Do you want to replace it (${Cyan}r${White}) or make a new one with a different name (${Green}n${White})? "
        read choice

        # Clear the two lines where the options were displayed
        echo -en "\033[1A"   # Move cursor up one line
        echo -en "\r\033[K"  # Clear the line
        echo -en "\033[1A"   # Move cursor up one line
        echo -en "\r\033[K"  # Clear the line

        case "$choice" in
            [Rr]* ) rm -rf "$project_name"
                    echo ""
                    ;;
            [Nn]* ) echo -en "${Blue}? ${White}Project name: ${Grey}›${White} "
                    read project_name
                    ;;
            * ) echo -e "${Red}✖${White} Invalid option"
                ;;
        esac
    else
        m=false
    fi
done

# Remove the SIGINT trap
trap - INT

# Clear the line where the project name prompt was displayed
echo -en "\033[1A"   # Move cursor up one line
echo -en "\r\033[K"  # Clear the line

# Display the selected project name with a ✔
echo -e "${Green}✔ ${White}Project name: ${Grey}› ${Purple}${project_name}"

# Display the language selection menu
languages=("C" "Cpp" "Node" "Vite")
choose_from_menu "Select a language:" language "${languages[@]}"

# Display the git repository creation menu
selections=("Yes" "No")
choose_from_menu "Do you want to create a git repository?" git "${selections[@]}"

if [ "$LOG_ENABLED" = true ]; then
    log_message "INFOS" "Logging enabled"
fi

initialize_project "$project_name" "$language" "$git"
