local KV = require('kv')
local BatchPlugin = require('batch')

describe("Should set and get simple strings", function()
    it("should set and get", function()

        -- Create a batch plugin instance
        local batchPlugin = BatchPlugin.new()

        -- Create a KV instance with the batch plugin
        local myKV = KV.new({batchPlugin})
        myKV:set("president", "Steve")
        local president = myKV:get("president")
        assert.are.same(president, "Steve")
        -- Use the batch methods via the KV instance
        local b = myKV:batchInit()
        b:set("count", 1)
        b:set("vice-president", "John")

        -- Execute batch operations
        b:execute()
        local president = myKV:get("vice-president")
        assert.are.same(president, "John")
    end)
end)
