#!/bin/bash

customHooksPath="hooks_files"
hooksToRemove=("commit-msg" "post-commit" "pre-commit" "prepare-commit-msg")

updateCount=0

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

function removeHooks() {
    gitHooksPath="$1/.git/hooks"

    if [ -d "$gitHooksPath" ]; then
        foundGitProject=false

        for hookName in "${hooksToRemove[@]}"; do
            hookPath="$gitHooksPath/$hookName"
            if [ -f "$hookPath" ]; then
                if ! "$foundGitProject"; then
                    echo -e "\nFound git project: $currentPath/.git"
                    foundGitProject=true
                fi

                echo -e "${BLUE}Removed hook:${ENDCOLOR} $hookPath"
                rm "$hookPath"
            fi
        done
    fi
}

function copyCustomHooks() {
    gitHooksPath="$1/.git/hooks"

    if [ -d "$gitHooksPath" ]; then
        cp "$customHooksPath"/* "$gitHooksPath/"

        echo -e "${GREEN}Copied custom hooks to:${ENDCOLOR} $gitHooksPath"
        ((updatedCount++))
    fi
}

function findAndCopyHooks() {
    currentPath="$1"

    if [ -d "$currentPath/.git" ]; then
        removeHooks "$currentPath"
        copyCustomHooks "$currentPath"
    fi

    for item in "$currentPath"/*; do
        if [ -d "$item" ] && [ ! -L "$item" ]; then
            findAndCopyHooks "$item"
        fi
    done
}

echo "   __ __          __                       __     __"
echo "  / // /__  ___  / /__ ___   __ _____  ___/ /__ _/ /____ ____"
echo " / _  / _ \/ _ \/  '_/(_-<  / // / _ \/ _  / _ \`/ __/ -_) __/"
echo "/_//_/\___/\___/_/\_\/___/  \_,_/ .__/\_,_/\_,_/\__/\__/_/      /v1.0.0/"
echo "                               /_/"

if [ $EUID -ne 0 ]; then
    echo -e "\n----> Is user root : ${RED}no${ENDCOLOR}"
    echo -e "${RED}Please run this script as root.\n${ENDCOLOR}"
    exit
else
    echo -e "\n----> Is user root : ${GREEN}yes\n${ENDCOLOR}"
fi

read -p "Please provide the path in wich your projects are stored: " rootPath

if [ ! -d "$rootPath" ]; then
    echo -e "${RED}The path: <$rootPath> is not a directory${ENDCOLOR}"
    exit
else
    echo -e "${GREEN}The path: <$rootPath> is a directory${ENDCOLOR}"
    findAndCopyHooks "$rootPath"
fi

echo -e "\n----> A total of $updatedCount projects where found and updated with the latest hooks, happy coding !\n"