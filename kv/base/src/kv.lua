if not KV then KV = {} end
KV.__index = KV
if not KV.authFns then KV.authFns = {} end
if not KV.stores then KV.stores = {} end

function KV.new(label, authFn)
    function defaultAuthFn(msg)
        return msg.From == Owner
    end

    if type(label) ~= "string" then
        print("error invalid label")
        error("Invalid label")
    end

    if KV.stores[label] then
        print("error already exists")
        error("Store " .. label .. "  already exists")
    end

    local self = setmetatable({}, KV)
    self.label = label
    self.store = {}
    KV.stores[label] = self
    KV.authFns[label] = authFn or defaultAuthFn
    return true
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

function KV:del(keyString)
    self.store[keyString] = nil
end

function KV:keys()
    local keys = {}
    for k, _ in pairs(self.store) do
        table.insert(keys, k)
    end
    return keys
end

function KV.filter_store(store, fn)
    local results = {}
    for k, v in pairs(store) do
        if fn(k, v) then
            results[k] = v
        end
    end
    return results
end

function KV.starts_with(str, prefix)
    return str:sub(1, #prefix) == prefix
end

function KV:getPrefix(prefix)
    return KV.filter_store(self.store, function(k, _)
        return KV.starts_with(k, prefix)
    end)
end

return KV







