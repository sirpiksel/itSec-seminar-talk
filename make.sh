#!/bin/sh

clear
echo "Choose a directory where the script is located:"

# Get the directory where the script is located
script_dir=$(realpath $(dirname "$0"))

# Get the list of directories in the script's location, excluding "acm-tex" & "rosen-tex" directories
directories=$(ls -d "$script_dir"/*/ 2>/dev/null | grep -vE "$script_dir/(acm-tex|rosen-tex)/" | awk -F/ '{print $(NF-1)}')

# Display the menu
selected_directory=""
index=1
for directory in $directories; do
  echo "$index) $directory"
  index=$((index + 1))
done

while true; do
  printf "\nSelect a directory: "
  read -r choice
  if [ "$choice" -ge 1 ] && [ "$choice" -le "$(echo "$directories" | wc -l)" ]; then
    selected_directory=$(echo "$directories" | sed -n "${choice}p")
    cd $selected_directory || exit
    sudo nix develop --extra-experimental-features "flakes nix-command"
    #docker run --rm -it -v "$script_dir:/workspace" -w "/workspace/$selected_directory" nixos/nix:latest nix develop --extra-experimental-features "flakes nix-command"
    cd .. || exit
    break
  else
    echo "Invalid choice. Please enter a valid number."
  fi
done
