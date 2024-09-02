local KV = require('kv')

local Batch = {}
Batch.__index = Batch

function Batch.new(kv)
	local self = setmetatable({}, Batch)
	self.operations = {}
	return self
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

return Batch
