local KV = {}
KV.__index = KV

function KV.new(label)
    local self = setmetatable({}, KV)
    self.label = label
    self.store = {}
    return self
end

function KV:get(keyString)
    return self.store[keyString]
end

function KV:set(keyString, value)
    self.store[keyString] = value
end

function KV:len()
    local count = 0
    for _ in pairs(self.store) do
        count = count + 1
    end
    return count
end

function KV:keys()
    local keys = {}
    for k, _ in pairs(self.store) do
        table.insert(keys, k)
    end
    return keys
end

local function filter_store(store, fn)
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

function KV:getPrefix(prefix)
    return filter_store(self.store, function(k, _)
        return starts_with(k, prefix)
    end)
end

return KV







