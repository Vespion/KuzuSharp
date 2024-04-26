#!/bin/ash

function create_symlinks {
    # Directory to create symlinks in
    local dir_path="$1"

    # Iterate over all files in the directory
    for file in "$dir_path"/*; do
        # Get the base name of the file
        local base_name=$(basename "$file")

        # Capitalize the first letter of each word in the filename
        local capitalized_name=$(echo "$base_name" | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

        # Create a symbolic link with the capitalized name
        ln -s "$file" "$dir_path/$capitalized_name"
    done
}

# Call the function with the directory path as an argument
create_symlinks "/usr/lib/zig/libc/include/any-windows-any"