local BatchPlugin = {}

function BatchPlugin.new()
    local plugin = {}

    -- Register the plugin methods to a KV instance
    function plugin.register(kv)
        kv:registerPlugin("batchInit", function()
            return plugin.createBatch(kv)
        end)
    end

    function plugin.createBatch(kv)
        local batch = {}
        batch.operations = {}

        function batch:set(keyString, value)
            table.insert(self.operations, { op = "set", key = keyString, value = value })
        end

        --function batch:set(keyString, value)
        --    table.insert(self.operations, { op = "set", key = keyString, value = value })
        --end

        -- Execute all batched operations
        function batch:execute()
            for _, operation in ipairs(self.operations) do
                if operation.op == "set" then
                    kv:set(operation.key, operation.value)
                --elseif operation.op == "del" then
                --    kv:del(operation.key)
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

    return plugin
end

return BatchPlugin
