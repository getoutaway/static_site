#!/bin/bash

BASE_DIRECTORY="/usr/share/nginx/html/protected"

generate_index() {
    local directory=$1
    local index_file="$directory/index.html"

    echo "<html><body><h1>Content of $(basename "$directory")</h1><ul>" > "$index_file"
    for file in "$directory"/*; do
        if [ "$(basename "$file")" != "index.html" ]; then
            if [ -f "$file" ]; then
                echo "<li><a href=\"$(basename "$file")\">$(basename "$file")</a></li>" >> "$index_file"
            elif [ -d "$file" ]; then
                echo "<li><a href=\"$(basename "$file")/\">$(basename "$file")</a></li>" >> "$index_file"
            fi
        fi
    done
    echo "</ul></body></html>" >> "$index_file"
}

while true; do
    for dir in "$BASE_DIRECTORY" "$BASE_DIRECTORY"/*/; do
        if [ -d "$dir" ]; then
            generate_index "$dir"
        fi
    done
    sleep 10
done
