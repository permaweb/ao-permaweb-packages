local ListPlugin = {}

function ListPlugin.new()
    local plugin = {}

    function plugin.register(kv)
        kv:registerPlugin("listInit", function()
            return plugin.createList(kv)
        end)
    end

    function plugin.createList(kv)
        local list = {}
        list.operations = {}

        function list:add(keyString, value)
            table.insert(self.operations, { op = "add", key = keyString, value = value })
        end

        function list:remove(keyString, value)
            table.insert(self.operations, { op = "remove", key = keyString, value = value })
        end

        function list:sort(keyString, comparator)
            table.insert(self.operations, { op = "sort", key = keyString, comparator = comparator })
        end

        function list:execute()
            for _, operation in ipairs(self.operations) do
                local currentList = kv:get(operation.key) or {}

                if operation.op == "add" then
                    table.insert(currentList, operation.value)
                elseif operation.op == "remove" then
                    for i, v in ipairs(currentList) do
                        if v == operation.value then
                            table.remove(currentList, i)
                            break
                        end
                    end
                elseif operation.op == "sort" then
                    table.sort(currentList, operation.comparator)
                end

                kv:set(operation.key, currentList)
            end

            self:clear()
        end

        function list:clear()
            self.operations = {}
        end

        return list
    end

    return plugin
end

return ListPlugin
