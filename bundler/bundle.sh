#!/bin/bash
set -e
# Define the target file
TARGET_FILE="./dist/bundle-trusted.lua"

# Clear the target file if it exists
> "$TARGET_FILE"

FILES=(
    "./apm_client.lua"
    "./trusted.lua"
    "../kv/base/src/kv.lua"
    "../kv/batchplugin/src/batch.lua"
    "../zone/src/zone.lua"
)

declare -A FILE_MAP=(
    ["../kv/base/src/kv.lua"]="@permaweb/kv-base"
    ["../kv/batchplugin/src/batch.lua"]="@permaweb/kv-batch"
    ["../zone/src/zone.lua"]="@permaweb/zone"
)

print_header() {
    HEADER="$1"
    WIDTH=80
    BORDER=$(printf '%*s' "$WIDTH" '' | tr ' ' '=')

    echo ""
    echo ""
    echo "-- $BORDER"
    echo "-- $BORDER"
    echo "-- $HEADER"
    echo "-- $BORDER"
    echo "-- $BORDER"
}

# Append each file's content to the target file
for FILE in "${FILES[@]}"; do
    if [[ "$FILE" == *"apm"* ]] || [[ "$FILE" == *"trusted"* ]]; then
        cat "$FILE" >> "$TARGET_FILE"
        continue
    fi
    if [ -f "$FILE" ]; then
        FILE_NAME=$(basename "$FILE" .lua)
        FUNCTION_NAME="load_${FILE_NAME//-/_}"
        PACKAGE_NAME=${FILE_MAP["$FILE"]}
        print_header "$PACKAGE_NAME" >> "$TARGET_FILE"

        echo "local function $FUNCTION_NAME()" >> "$TARGET_FILE"
        cat "$FILE" >> "$TARGET_FILE"
        echo "end" >> "$TARGET_FILE"
        echo "package.loaded['$PACKAGE_NAME'] = $FUNCTION_NAME()" >> $TARGET_FILE
        echo "" >> "$TARGET_FILE"  # Add a newline for separation
    else
        echo "File $FILE does not exist."
    fi
done
echo "Bundling complete. Output written to $TARGET_FILE."