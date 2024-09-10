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

if not myKV then myKV = KV.new({BatchPlugin}) end
local Profile = {}

function Profile.decodeMessageData(data)
    local status, decodedData = pcall(json.decode, data)
    if not status or type(decodedData) ~= 'table' then
        return false, nil
    end

    return true, decodedData
end

function Profile.profileSet(msg)
    local decodeCheck, data = Profile.decodeMessageData(msg.Data)
    if not decodeCheck then
        ao.send({
            Target = msg.From,
            Action = ACTIONS.PROFILE_ERROR,
            Tags = {
                Status = 'Error',
                Message =
                'Invalid Data'
            }
        })
        return
    end

    local entries = decodeCheck and data.entries

    if #entries > 1 then
        local batch = myKV.batchInit()
        for k, v in pairs(entries) do
            batch:set(k, v)
        end
        batch:execute()
    end

    ao.send({
        Target = msg.From,
        Action = ACTIONS.PROFILE_SUCCESS,
    })
end

function Profile.profileGet(msg)

    local decodeCheck, data = Profile.decodeMessageData(msg.Data)
    if not decodeCheck then
        ao.send({
            Target = msg.From,
            Action = ACTIONS.PROFILE_ERROR,
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

    if keys and #keys then
        local results = {}
        for k, v in pairs(keys) do
            results[k] = v

        end
        ao.send({
            Target = msg.From,
            Action = ACTIONS.PROFILE_SUCCESS,
            Data = json.encode(results)
        })
    end
end

local ACTIONS = {
    PROFILE_SET = "Profile-Set",
    PROFILE_GET = "Profile-Get",
    PROFILE_ERROR = "Profile-Error",
    PROFILE_SUCCESS = "Profile-Success"
}

Handlers.add(
        ACTIONS.PROFILE_SET,
        Handlers.utils.hasMatchingTag("Action", ACTIONS.PROFILE_SET),
        Profile.profileSet
)

Handlers.add(
        ACTIONS.PROFILE_GET,
        Handlers.utils.hasMatchingTag("Action", ACTIONS.PROFILE_GET),
        Profile.profileGet
)

package.loaded[PackageName] = Profile

