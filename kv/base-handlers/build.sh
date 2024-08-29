#!/bin/bash
if [[ "$(uname)" == "Linux" ]]; then
    BIN_PATH="$HOME/.luarocks/bin"
else
    BIN_PATH="/opt/homebrew/bin"
fi

if [ ! -d "dist" ]; then
    mkdir dist
fi

$BIN_PATH/amalg.lua -o dist/main.lua -s src/handlers.lua
$BIN_PATH/luacheck dist/main.lua