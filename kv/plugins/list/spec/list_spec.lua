local KV = require('kv')
local ListPlugin = require('list')

describe("Should manage list operations", function()
    it("should add, remove, and sort list entries", function()

        local listPlugin = ListPlugin.new()
        local myKV = KV.new({listPlugin})
        local list = myKV:listInit()

        list:add("fruits", "Apple")
        list:add("fruits", "Banana")
        list:add("fruits", "Cherry")

        list:execute()
        assert.are.same(myKV:get("fruits"), {"Apple", "Banana", "Cherry"})

        list:remove("fruits", "Banana")
        list:execute()
        assert.are.same(myKV:get("fruits"), {"Apple", "Cherry"})

        list:sort("fruits", function(a, b) return a > b end)
        list:execute()
        assert.are.same(myKV:get("fruits"), {"Cherry", "Apple"})
    end)
end)
