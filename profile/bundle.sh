#!/bin/bash

# Define the target file
TARGET_FILE="bundle/bundle.lua"

# Clear the target file if it exists
> $TARGET_FILE

# List of files to append
FILES=(
    "./src/apm_client.lua"
    "../kv/base/src/kv.lua"
    "../kv/batchplugin/src/batch.lua"
    "./src/profile.lua"

    # Add other files as needed
)

# Append each file's content to the target file
print_header() {
    local header="$1"
    local length=80
    local border=$(printf '%*s' "$length" '' | tr ' ' '=')

    echo ""
    echo ""
    echo "-- $border"
    echo "-- $border"
    echo "-- $header"
    echo "-- $border"
    echo "-- $border"
}
# Append each file's content to the target file
for FILE in "${FILES[@]}"; do
    if [[ "$FILE" == *"apm"* ]]; then
        cat "$FILE" >> $TARGET_FILE
        continue
    fi
    if [ -f "$FILE" ]; then
        FILE_NAME=$(basename "$FILE" .lua)
        FUNCTION_NAME="load_${FILE_NAME//-/_}"
        print_header $FILE_NAME >> $TARGET_FILE

        echo "local function $FUNCTION_NAME()" >> $TARGET_FILE
        cat "$FILE" >> $TARGET_FILE
        echo "end" >> $TARGET_FILE
        echo "if not package.loaded['$FILE_NAME'] then package.loaded['$FILE_NAME'] = $FUNCTION_NAME() end" >> $TARGET_FILE
        echo -e "\n" >> $TARGET_FILE  # Add a newline for separation
    else
        echo "File $FILE does not exist."
    fi
done
echo "Bundling complete. Output written to $TARGET_FILE."