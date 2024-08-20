local KV = {}
KV.__index = KV

local Batch = {}
Batch.__index = Batch

function Batch.new()
    local self = setmetatable({}, Batch)
    self.operations = {}
    return self
end

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

function KV:write(batch)
    batch:execute(self)
    batch:destroy()
end

function KV:start_batch()
    return Batch.new()
end

function Batch:set(keyString, value)
    table.insert(self.operations, { op = "set", key = keyString, value = value })
end

function Batch:delete(keyString)
    table.insert(self.operations, { op = "delete", key = keyString })
end

function Batch:execute(kv)
    for _, operation in ipairs(self.operations) do
        if operation.op == "set" then
            kv:set(operation.key, operation.value)
        elseif operation.op == "delete" then
            kv:del(operation.key)
        end
    end
end

function Batch:clear()
    self.operations = {}
end

function Batch:destroy()
    self:clear()
    setmetatable(self, nil)
end

function Batch:print()
    local result = "PRINTED: "
    for _, operation in ipairs(self.operations) do
        result = result .. operation.op
    end
    print(result)
end

return KV







