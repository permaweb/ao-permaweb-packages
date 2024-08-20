local KV = require('kv')

local nameKey = "@x:Name"

local function get_len(results)
    local printed = ""
    local len = 0
    for _, v in pairs(results) do
        printed = printed .. v
        len = len + 1
    end
    return len
end

describe("Should set and get simple strings", function()
    it("should set and get", function()
        local aStore = KV.new("aStore")
        aStore:set(nameKey, "BobbaBouey")
        local result = aStore:get(nameKey)
        assert.are.same(result, "BobbaBouey")
        local keys = aStore:keys()
        assert.are.same(keys[1], nameKey )
    end)
end)

describe("By prefix", function()
    it("should set multiple and get by prefix key", function()
        local bStore = KV.new("bStore")
        bStore:set("@x:Fruit:1:", "apple")
        bStore:set("@x:Fruit:2", "peach")
        bStore:set("@x:Meat:1", "bacon")
        local results = bStore:getPrefix("@x:Fruit")
        assert.are.same(get_len(results), 2)
        local allResults = bStore:getPrefix("")
        assert.are.same(get_len(allResults), 3)
    end)
end)

describe("Batch", function()
    it("should create and write a batch", function()
        local cStore = KV.new("cStore")
        cStore:set("initialItem", "apple")
        local initialItems = cStore:getPrefix("")
        assert.are.same(get_len(initialItems), 1)

        -- add two items
        local batch = cStore:start_batch()
        batch:set("item1", "dog")
        batch:set("item2", "cat")
        batch:print()
        cStore:write(batch)
        local batchedItems = cStore:getPrefix("item")
        assert.are.same(get_len(batchedItems), 2)
        assert.are.same(batchedItems["item1"], "dog")
        assert.are.same(batchedItems["item2"], "cat")

        -- move "cat" to item1, delete cat and initialItem,
        local batch = cStore:start_batch()
        batch:set("item1", "cat")
        batch:delete("initialItem")
        batch:delete("item2")
        batch:print()
        cStore:write(batch)
        local batchedItems = cStore:getPrefix("item")
        assert.are.same(get_len(batchedItems), 1)
        assert.are.same(batchedItems["item1"], "cat")
    end)
end)

