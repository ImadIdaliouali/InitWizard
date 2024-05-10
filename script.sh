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

choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 m=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    local max_length=0
    for opt in "${options[@]}"; do
        if [ ${#opt} -gt $max_length ]; then
            max_length=${#opt}
        fi
    done
    while true; do
        # Clear screen
        tput clear
        # Display the menu prompt and options
        echo -e "${Blue}? $prompt${White} › - Use arrow-keys. Return to submit."
        for ((i=0; i<$m; i++)); do
            if [ "$i" == "$cur" ]; then
                echo -e "${Green}❯ ${esc}[4m${options[$i]}${esc}[0m"
            else
                echo -e "  ${options[$i]}"
            fi
        done
        # Read user input
        read -s -n3 key
        if [[ $key == $esc[A ]]; then # up arrow
            cur=$(( ($cur - 1 + $m) % $m ))
        elif [[ $key == $esc[B ]]; then # down arrow
            cur=$(( ($cur + 1) % $m ))
        elif [[ $key == "" ]]; then # Enter key
            break
        fi
    done
    # Export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
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

# Function to log messages
log_message() {
    local type="$1"
    local message="$2"
    local timestamp=$(date +"%Y-%m-%d  %H:%M:%S")
    local username=$(whoami)
   sudo echo "$timestamp : $username : $type : $message" | tee -a /var/log/initWizard/history.log
}

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Check if log directory exists, if not, create it
log_dir="/var/log/initWizard"
if ! directory_exists "$log_dir"; then
   sudo mkdir -p "$log_dir"
fi

# Check if log file exists, if not, create it
log_file="$log_dir/history.log"
if [ ! -f "$log_file" ]; then
    sudo touch "$log_file"
fi

# Parse command-line options
while getopts ":l" opt; do
    case ${opt} in
        l )
            # Enable logging
            LOG_ENABLED=true
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Clear screen
tput clear
read -p "? Enter project name: " project_name
# Check if the project folder already exists
m=0
while [ $m -ne 1 ]; do
    if [ -d "$project_name" ]; then
        echo -e "${Red}Error:${White} Project folder '$project_name' already exists."
        read -p "Do you want to replace it (r) or make a new one with a different name (n)? " choice
        case "$choice" in
            [Rr]* ) rm -rf "$project_name";;
            [Nn]* ) read -p "Enter a new project name: " project_name;;
            * ) echo "Invalid option. Exiting."; exit 1;;
        esac
    else
        m=1
    fi
done


languages=("c" "cpp" "node" "vite")
choose_from_menu "Enter language/framework: " language "${languages[@]}"

selections=("yes" "no")
choose_from_menu "Do you want to create a git repository? " git "${selections[@]}"

if [ "$LOG_ENABLED" = true ]; then
    log_message "INFOS" "Logging enabled"
fi

initialize_project "$project_name" "$language" "$git"
