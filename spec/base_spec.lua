local KV = require('kv')

local nameKey = "@x:Name"
describe("Should set and get simple strings", function()
    it("should set and get", function()

        KV.set(nameKey, "BobbaBouey")
        local result = KV.get("@x:Name")
        assert.are.same(result, "BobbaBouey")
        local keys = KV.keys(KV.store)
        assert.are.same(keys[1], nameKey )
    end)
end)

describe("Should set and get by prefix", function()
    it("should set multiple and get by prefix key", function()
        KV.set("@x:Fruit:1:", "apple")
        KV.set("@x:Fruit:2", "peach")
        local results = KV.getPrefix("@x:Fruit")
        assert.are.same(KV.len(results), 2)
    end)
end)

