#!/bin/bash

customHooksPath="hooks_files"
hooksToRemove=("commit-msg" "post-commit" "pre-commit" "prepare-commit-msg")

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

function removeHooks() {
    gitHooksPath="$1/hooks"

    if [ -d "$gitHooksPath" ]; then
        for hookName in "${hooksToRemove[@]}"; do
            hookPath="$gitHooksPath/$hookName"
            if [ -f "$hookPath" ]; then
                rm "$hookPath"
                echo -e "${BLUE}Removed hook:${ENDCOLOR} $hookPath"
            fi
        done
    fi
}

function copyCustomHooks() {
    gitHooksPath="$1/hooks"

    if [ -d "$gitHooksPath" ]; then
        cp "$customHooksPath"/* "$gitHooksPath/"

        echo -e "${GREEN}Copied custom hooks to:${ENDCOLOR} $gitHooksPath\n"
    fi
}


echo "   __ __          __          _          __       ____"
echo "  / // /__  ___  / /__ ___   (_)__  ___ / /____ _/ / /__ ____"
echo " / _  / _ \/ _ \/  '_/(_-<  / / _ \(_-</ __/ _ \`/ / / -_) __/"
echo "/_//_/\___/\___/_/\_\/___/ /_/_//_/___/\__/\_,_/_/_/\__/_/      /v1.0.0/"

if [ $EUID -ne 0 ]; then
    echo -e "\n----> Is user root : ${RED}no${ENDCOLOR}"
    echo -e "${RED}Please run this script as root.\n${ENDCOLOR}"
    exit
else
    echo -e "\n----> Is user root : ${GREEN}yes\n${ENDCOLOR}"
fi

if [ -d "/usr/share/git-core/templates/hooks" ]; then
    removeHooks "/usr/share/git-core/templates"
    copyCustomHooks "/usr/share/git-core/templates"
fi

echo -e "\n----> Custom hooks installed succesfully !\n"

read -p "Do you want to update existing project hooks? (y/n): " updateExisting

if [ "$updateExisting" == "y" ]; then
    ./hooks_updater.sh
fi