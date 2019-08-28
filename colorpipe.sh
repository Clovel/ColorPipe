#!/usr/local/bin/bash

# Using /usr/local/bin/bash, from brew on macOS
# because the built-in bash is v3.2.57 in Mojave
# but v4 is required for associative arrays

# This script take an input from a pipe and colors it
# The goal is to color different keyword 
# when compiling or running a program

MYDIR=$(dirname $(readlink -f $0))

# Checking dependencies -----------------------------------

# Color definitions ---------------------------------------
NC='\033[1m\033[0m' # No color

declare -A keyword
# upper case
keyword["ERROR"]="BRED"
keyword["WARN"]="BYELLOW"
keyword["WARNING"]="BYELLOW"
keyword["NOTE"]="BCYAN"
keyword["FAIL"]="BRED"
keyword["FAILURE"]="BRED"
keyword["PASS"]="BGREEN"
keyword["PASSED"]="BGREEN"
keyword["START"]="BCYAN"
keyword["STARTED"]="BCYAN"
keyword["STARTING"]="BCYAN"
keyword["INFO"]="BCYAN"
keyword["OK"]="BGREEN"
keyword["KO"]="BRED"
keyword["SUCCESS"]="BGREEN"
# lower case
keyword["error"]="BRED"
keyword["warn"]="BYELLOW"
keyword["warning"]="BYELLOW"
keyword["note"]="BCYAN"
keyword["fail"]="BRED"
keyword["failure"]="BRED"
keyword["pass"]="BGREEN"
keyword["passed"]="BGREEN"
keyword["start"]="BCYAN"
keyword["started"]="BCYAN"
keyword["starting"]="BCYAN"
keyword["info"]="BCYAN"
keyword["ok"]="BGREEN"
keyword["ko"]="BRED"
keyword["success"]="BGREEN"
# Normal case
keyword["Error"]="BRED"
keyword["Warn"]="BYELLOW"
keyword["Warning"]="BYELLOW"
keyword["Note"]="BCYAN"
keyword["Fail"]="BRED"
keyword["Failure"]="BRED"
keyword["Pass"]="BGREEN"
keyword["Passed"]="BGREEN"
keyword["Start"]="BCYAN"
keyword["Started"]="BCYAN"
keyword["Starting"]="BCYAN"
keyword["Info"]="BCYAN"
keyword["Ok"]="BGREEN"
keyword["Ko"]="BRED"
keyword["Success"]="BGREEN"


declare -A colors
# Regular
colors["BLACK"]="\033[0;30m"
colors["RED"]="\033[0;31m"
colors["GREEN"]="\033[0;32m"
colors["YELLOW"]="\033[0;33m"
colors["BLUE"]="\033[0;34m"
colors["PURPLE"]="\033[0;35m"
colors["CYAN"]="\033[0;36m"
colors["WHITE"]="\033[0;37m"
#Bold
colors["BBLACK"]="\033[1;30m"
colors["BRED"]="\033[1;31m"
colors["BGREEN"]="\033[1;32m"
colors["BYELLOW"]="\033[1;33m"
colors["BBLUE"]="\033[1;34m"
colors["BPURPLE"]="\033[1;35m"
colors["BCYAN"]="\033[1;36m"
colors["BWHITE"]="\033[1;37m"
# High Intensity
colors["IBLACK"]="\033[0;90m"
colors["IRED"]="\033[0;91m"
colors["IGREEN"]="\033[0;92m"
colors["IYELLOW"]="\033[0;93m"
colors["IBLUE"]="\033[0;94m"
colors["IPURPLE"]="\033[0;95m"
colors["ICYAN"]="\033[0;96m"
colors["IWHITE"]="\033[0;97m"
# Bold High Intensity
colors["BIBLACK"]="\033[1;90m"
colors["BIRED"]="\033[1;91m"
colors["BIGREEN"]="\033[1;92m"
colors["BIYELLOW"]="\033[1;93m"
colors["BIBLUE"]="\033[1;94m"
colors["BIPURPLE"]="\033[1;95m"
colors["BICYAN"]="\033[1;96m"
colors["BIWHITE"]="\033[1;97m"
# No color
colors["NC"]="\033[1m\033[0m"

# Color function ------------------------------------------
function color_word() {
    if [[ "$#" -ne 2 ]]; then
        echo "[ERROR] <color> Wrong number of arguments !"
    else
        local COLOR=$1
        local COLORCODE=${colors[${COLOR}]}
        local STRING=$2
        
        echo -e "${COLORCODE}$STRING${NC}"
    fi
}

function color_line() {
    # Argument is a line of characters
    if [[ "$#" -ne 1 ]]; then
        echo "[ERROR] <color> Wrong number of arguments !"
    else
        local line="$1"
        for word in $line; do
            #echo "[DEBUG] word = $word, keyword[$word] = ${keyword[$word]}"
            #echo "$(color_word "${keyword[$word]}" "$word")"
            if [[ -v keyword["$word"] ]]; then
                SELECTEDCOLOR=${keyword[$word]}
                if [[ -v colors["$SELECTEDCOLOR"] ]]; then
                    printf "%s" "$(color_word "$SELECTEDCOLOR" "$word") "
                else
                    printf "%s" "$word "
                fi
            else
                printf "%s" "$word "
            fi
        done
        printf "\n"
    fi
}

# Main script ---------------------------------------------
# check that we have a correct stdin
if [[ -p /dev/stdin ]]; then
    # We want to read the input line by line
    while IFS= read line; do
        echo "$(color_line "$line")"
    done
else
    echo "[ERROR] No input was found on stdin, skipping !"
fi
