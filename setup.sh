#!/bin/bash

function remove_args {
    selected_arg=$1
    local -n array=$2

    for args in "${init_argv[@]}"; do
        if [[ $args != $selected_arg ]]; then
            array+=("$args")
        fi
    done
}

init_argv=( "$@" )
argc=${#init_argv[@]}
default_folder="scripts/"
include=0

if [[ $argc -eq 0 ]]; then
    echo "No arguments were given!"
    echo -e "\nAvailable arguments:\n'<script-name> <symbolic-name>'\n\n--include                      [OPTIONAL] It tells the program that\n                                it'll gonna use the folder containing the default scripts"

    exit 1
fi

if [[ ${init_argv[0]} == "--include" ]]; then
    argv=()
    remove_args "--include" argv

    include=1

elif [[ ${init_argv[0]} == "--all" ]]; then
    argv=()
    remove_args "--all" argv

    scripts=$(find "./$default_folder"  -maxdepth 1 -name "*.sh" -type f)

    if [[ $? -eq 1 ]]; then
        exit 1
    fi

    if [[ ${#scripts[@]} -eq 0 ]]; then
        echo "No files were found!"
        exit 1
    fi

    for path_script in ${scripts[@]}; do
        mapfile -td "/" values <<<"$path_script"

        script=${values[-1]}
        symbolic_name=${script//".sh"/""}

        $(sudo ln -s ./$script /usr/bin/$symbolic_name)
    done

    echo "Setup ended successfully!"
    exit 0

else
    argv=("${init_argv[@]}")
fi

for args in "${argv[@]}"; do
    mapfile -td " " values <<<"$args" #split

    script=$(echo ${values[0]})
    symbolic_name=$(echo ${values[1]})

    if [[ $symbolic_name == "" ]]; then
        symbolic_name=$(echo ${script//.sh/''})
    fi

    if (( $include == 1 )); then
        script="$default_folder$script"
    fi

    $(sudo ln -s ./$script /usr/bin/$symbolic_name)

    if [[ $? -eq 1 ]]; then
        exit 1
    fi
done

echo "Setup ended successfully!"
