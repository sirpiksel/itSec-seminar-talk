#!/bin/sh

echo "Choose a directory where the script is located:"

# Get the directory where the script is located
script_dir=$(dirname "$0")

# Get the list of directories in the script's location, excluding "tex" directory
directories=$(ls -d "$script_dir"/*/ 2>/dev/null | grep -v "$script_dir/tex/")

# Display the menu
PS3="Enter the number of your choice: "
IFS='
'
selected_directory=""
index=1
for directory in $directories; do
    echo "$index) $directory"
    index=$((index + 1))
done

while true; do
    printf "Select a directory: "
    read -r choice
    if [ "$choice" -ge 1 ] && [ "$choice" -le "$(echo "$directories" | wc -l)" ]; then
        selected_directory=$(echo "$directories" | sed -n "${choice}p")
        docker run --rm -it -v "$(pwd):/workspace" -w "/workspace/$(basename "$selected_directory")" nixos/nix:latest nix develop --extra-experimental-features "flakes nix-command"
        break
    else
        echo "Invalid choice. Please enter a valid number."
    fi
done
