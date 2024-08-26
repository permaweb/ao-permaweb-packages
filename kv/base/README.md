
# Installation
1. Make sure you have APM
    `load-blueprint apm`
2. Use APM to install
   `APM.install("@aopermawebpackages/kv-base")`

# Usage
1. Require
    `local KV = require("@aopermawebpackages/kv-base")`
2. Instantiate
    ```
    local storeName = "aStore"
    local status, result = pcall(KV.new, storeName)

    local store = KV.stores[storeName]
    ```
3. Set
    ```
   store:set(nameKey, "BobbaBouey")
   ```
4. Get
    ```
   local response = store:get(nameKey)
   ```

# Development

## Luarocks
`sudo apt install luarocks`
`luarocks install busted --local`
`export PATH=$PATH:/home/jessop/.luarocks/bin`
## Testing
`busted`

# APM Publish

1. Run build script
    `./build/sh`
2. Publish `main.lua` from `dist/`
