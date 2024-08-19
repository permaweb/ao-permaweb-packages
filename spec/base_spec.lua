local KV = require('kv')

local nameKey = "@x:Name"
describe("Should set and get simple strings", function()
    it("should set and get", function()
        local aStore = KV.new("aStore")
        aStore:set(nameKey, "BobbaBouey")
        local result = aStore:get("@x:Name")
        assert.are.same(result, "BobbaBouey")
        local keys = aStore:keys()
        assert.are.same(keys[1], nameKey )
    end)
end)

describe("Should set and get by prefix", function()
    it("should set multiple and get by prefix key", function()
        local bStore = KV.new("bStore")
        bStore:set("@x:Fruit:1:", "apple")
        bStore:set("@x:Fruit:2", "peach")
        local results = bStore:getPrefix("@x:Fruit")
        assert.are.same(bStore:len(results), 2)
    end)
end)

