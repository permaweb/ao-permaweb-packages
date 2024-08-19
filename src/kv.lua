local json = require('json')
local KV = {}

if not KV.store then
    KV.store = {

    }
end

function KV.set (keyString, value)
    print('set')
    KV.store[keyString] = value
end

function KV.len(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

function KV.get (keyString)
    return KV.store[keyString]
end

function filter_store(store, fn)
    local results = {}
    for k, v in pairs(store) do
        if fn(k, v) then
            results[k] = v
        end
    end
    return results
end

local function starts_with(str, prefix)
    return str:sub(1, #prefix) == prefix
end

function KV.getPrefix(prefix)
    return filter_store(KV.store, function(k, _)
        return starts_with(k, prefix)
    end)
end

return KV







