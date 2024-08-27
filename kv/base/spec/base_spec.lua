local KV = require('kv')

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
    it("should create, set and get", function()
        local nameKey = "@x:Name"
        local storeName = "aStore"
        local status, result = pcall(KV.new, storeName)
        if not status then
            print(result)
            return result
        end
        assert.are.same(status, true)

        local store = KV.stores[storeName]

        KV.stores[storeName]:set(nameKey, "BobbaBouey")
        local response = store:get(nameKey)
        assert.are.same(response, "BobbaBouey")
        local keys = store:keys()
        assert.are.same(keys[1], nameKey )
    end)
    it("should error on bad create label", function()
        local storeName = 6
        local status, _ = pcall(KV.new, storeName)
        assert.are.same(status, false)
    end)
    it("should error on creating existing store", function()
        local storeName = "aStore"
        local status, _ = pcall(KV.new, storeName)
        assert.are.same(status, false)
    end)
end)

describe("By prefix", function()
    it("should set multiple and get by prefix key", function()
        local storeName = "bStore"
        local status, result = pcall(KV.new, storeName)
        assert.are.same(status, true)
        bStore = KV.stores[storeName]
        bStore:set("@x:Fruit:1:", "apple")
        bStore:set("@x:Fruit:2", "peach")
        bStore:set("@x:Meat:1", "bacon")
        local results = bStore:getPrefix("@x:Fruit")
        assert.are.same(get_len(results), 2)
        local allResults = bStore:getPrefix("")
        assert.are.same(get_len(allResults), 3)
    end)

end)

