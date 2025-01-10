#!/usr/bin/env bash
set -euo pipefail

# Script to weekly update all 'brew' and 'conda' packages.

LAST_RUN_FILE="$HOME/.last_command_run_date"
CURRENT_WEEK=$(date +%Y-%V) # current year and week number in YYYY-WW format

if [ -f "$LAST_RUN_FILE" ]; then
    # Read the last run week from the file
    LAST_RUN_WEEK=$(cat "$LAST_RUN_FILE")
else
    # If the file doesn't exist, assume it hasn't been run this week
    LAST_RUN_WEEK=""
fi

color_yellow='\033[33m'
color_green='\033[32m'
no_color='\033[0m'
color_section=$color_yellow

if [ "$CURRENT_WEEK" != "$LAST_RUN_WEEK" ]; then
    echo "Current week = $CURRENT_WEEK"
    echo
    echo -e "${color_section}Update all Homebrew packages"
    brew update
    brew upgrade
    brew cleanup -s
    echo -e "${color_green}Done${no_color}"
    echo
    if command -v conda >/dev/null; then
        echo -e "${color_section}Update all conda packages${no_color}"
        conda update -yn base conda
        conda update -yn base --all
        conda clean -y --all
        echo -e "${color_green}Done${no_color}"
    fi
    echo
    echo -e "${color_section}List of installed Homebrew casks and formulae that have an updated version available (update with 'brew upgrade --cask ...'):${no_color}"
    brew outdated --greedy

    # Update the last run week file
    echo "$CURRENT_WEEK" > "$LAST_RUN_FILE"
else
    # Commands have already been run this week
    :
fi
