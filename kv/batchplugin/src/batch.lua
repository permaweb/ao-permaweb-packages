local BatchPlugin = {}

function BatchPlugin.new()
    local self = {}
    self.operations = {}

    -- Register the plugin methods to a KV instance
    function self.register(kv)

        kv:registerPlugin("batchInit", function()
            return self.createBatch(kv)
            -- return a new batch container
        end)
        --
        --kv:registerPlugin("batchSet", function(_, keyString, value)
        --    table.insert(self.operations, { op = "set", key = keyString, value = value })
        --end)
        --
        --kv:registerPlugin("batchDel", function(_, keyString, value)
        --    table.insert(self.operations, { op = "del", key = keyString })
        --end)
        --
        --kv:registerPlugin("batchGet", function(_, keyString)
        --    table.insert(self.operations, { op = "get", key = keyString })
        --end)
        --
        --kv:registerPlugin("batchExecute", function(_)
        --    self.execute(kv)
        --end)
        --
        --kv:registerPlugin("batchClear", function(_)
        --    self.clear()
        --end)
    end

    function self.createBatch(kv)
        local batch = {}
        batch.operations = {}

        function batch:set(keyString, value)
            table.insert(self.operations, { op = "set", key = keyString, value = value })
        end

        -- Execute all batched operations
        function batch:execute()
            for _, operation in ipairs(self.operations) do
                if operation.op == "set" then
                    kv:set(operation.key, operation.value)
                elseif operation.op == "get" then
                    local value = kv:get(operation.key)
                    print("Get: " .. operation.key .. " = " .. tostring(value))
                end
            end
            self:clear()  -- Optionally clear the batch after execution
        end

        -- Clear all batched operations
        function batch:clear()
            self.operations = {}
        end

        return batch
    end

    return self
end

return BatchPlugin
