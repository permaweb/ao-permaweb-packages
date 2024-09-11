local PackageName = "@permaweb/profile"
local KV = require("@permaweb/kv-base")
if not KV then
    error("KV Not found, install it")
end

local BatchPlugin = require("@permaweb/kv-batch")
if not BatchPlugin then
    error("BatchPlugin not found, install it")
end

if package.loaded[PackageName] then
    return package.loaded[PackageName]
end

if not Profile then Profile = {} end
if not Profile.profileKV then Profile.profileKV = KV.new({BatchPlugin}) end

Profile.PROFILE_SET = "Profile-Set"
Profile.PROFILE_GET = "Profile-Get"
Profile.PROFILE_ERROR = "Profile-Error"
Profile.PROFILE_SUCCESS = "Profile-Success"

function Profile.decodeMessageData(data)
    local status, decodedData = pcall(json.decode, data)
    if not status or type(decodedData) ~= 'table' then
        return false, nil
    end

    return true, decodedData
end


function Profile.hello()
    print("Hello profile")
end

function Profile.profileSet(msg)
    local decodeCheck, data = Profile.decodeMessageData(msg.Data)
    if not decodeCheck then
        ao.send({
            Target = msg.From,
            Action = Profile.PROFILE_ERROR,
            Tags = {
                Status = 'Error',
                Message =
                'Invalid Data'
            }
        })
        return
    end

    local entries = data.entries

    local testkeys = {}

    if #entries then
        for _, entry in ipairs(entries) do
            if entry.key and entry.value then
                table.insert(testkeys, entry.key)
                Profile.profileKV:set(entry.key, entry.value)
            end
        end
        ao.send({
            Target = msg.From,
            Action = Profile.PROFILE_SUCCESS,
            Tags =  {
                Value1 = Profile.profileKV:get(testkeys[1]),
                Key1 = testkeys[1]
            },
            Data = json.encode({ First = Profile.profileKV:get(testkeys[1]) })
        })
        return
    end
    --if #entries > 1 then
    --    local batch = Profile.profileKV.batchInit()
    --    for k, v in pairs(entries) do
    --        table.insert(testkeys, k)
    --
    --        batch:set(k, v)
    --    end
    --    batch:execute()
    --end
    --
    --ao.send({
    --    Target = msg.From,
    --    Action = Profile.PROFILE_SUCCESS,
    --    Tags =  {
    --        First = Profile.profileKV:get(testkeys[1]),
    --    },
    --    Data = json.encode({ Test = "2", First = Profile.profileKV:get(testkeys[1]) })
    --})
end

function Profile.profileGet(msg)

    local decodeCheck, data = Profile.decodeMessageData(msg.Data)
    if not decodeCheck then
        ao.send({
            Target = msg.From,
            Action = Profile.PROFILE_ERROR,
            Tags = {
                Status = 'Error',
                Message =
                'Invalid Data'
            }
        })
        return
    end

    local keys = data.keys

    if not keys then
        error("no keys")
    end

    if keys then
        local results = {}
        for _, k in ipairs(keys) do
            results[k] = Profile.profileKV:get(k)
        end
        ao.send({
            Target = msg.From,
            Action = Profile.PROFILE_SUCCESS,
            Data = json.encode({Results = results} )
        })
    end
end

Handlers.remove(Profile.PROFILE_SET)
Handlers.add(
        Profile.PROFILE_SET,
        Handlers.utils.hasMatchingTag("Action", Profile.PROFILE_SET),
        Profile.profileSet
)
Handlers.remove(Profile.PROFILE_GET)
Handlers.add(
        Profile.PROFILE_GET,
        Handlers.utils.hasMatchingTag("Action", Profile.PROFILE_GET),
        Profile.profileGet
)

return Profile

