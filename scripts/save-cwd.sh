#/bin/bash

main_path="/home/$(whoami)/desktop/.cwd-saved.txt"

function show_args {
    echo -e "\nAvailable arguments:\n--save            Saves the current path\n--go            Moves to the saved path\n--see          Allow to see the saved path"
}

function get_path_from_file {
    echo $(head -n 1 $main_path)
}

if [[ $1 == "" ]]; then
    echo "ERROR: args not found!"
    show_args

elif [[ $1 == "--save" ]]; then
    echo $(pwd) > $main_path

elif [[ $1 == "--go" ]]; then;
    saved_path=$(get_path_from_file)
    cd $saved_path

elif [[ $1 == "--see" ]]; then
    saved_path=$(get_path_from_file)
    echo "Saved Path: $saved_path"
    
else
    echo "ERROR: command not found!"
    show_args
fi