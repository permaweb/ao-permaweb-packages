local KV = require('kv')
local json = require('json')
--local utils = require('utils')

local BH = {}

BH.ACTIONS = {
    KV_SET = "KvSet",
    KV_GET = "KvGet"
}

BH.TAGS = {
    KV_KEY = "KV_KEY",
    KV_VALUE = "KV_VALUE",
    KV_NAME = "KV_NAME"
}
function BH.decodeMessageData(data)
    local status, decodedData = pcall(json.decode, data)

    if not status or type(decodedData) ~= 'table' then
        return false, nil
    end

    return true, decodedData
end


local function kvSet(msg)
    local decodeCheck, data = BH.decodeMessageData(msg.Data)
    if not decodeCheck then
        ao.send({
            Target = msg.From,
            Action = 'Input-Error',
            Tags = {
                Status = 'Error',
                Message =
                'Invalid Data'
            }
        })
        return
    end

    local kv_key = msg.tags[BH.TAGS.KV_KEY] or data and data[BH.TAGS.KV_KEY]
    local kv_value = msg.tags[BH.TAGS.KV_VALUE] or data and data[BH.TAGS.KV_VALUE]
    local kv_name = msg.tags[BH.TAGS.KV_NAME] or data and data[BH.TAGS.KV_NAME]

    if not kv_key or not kv_value or not kv_name then
        ao.send({
            Target = msg.From,
            Action = 'Input-Error',
            Tags = {
                Status = 'Error',
                Message =
                'Invalid Data'
            }
        })
        return
    end

    if not KV.stores[kv_name] then
        local kvNewStatus, kvNewResult = pcall(KV.new, kv_name)
        if not kvNewStatus then
            ao.send({
                Target = msg.From,
                Action = 'Input-Error',
                Tags = {
                    Status = 'Error',
                    Message = kvNewResult
                }
            })
            return
        end
    end

    local store = KV.stores[kv_name]
    store:set(kv_key, kv_value)

    ao.send({
        Target = msg.From,
        Action = 'KV_SET_SUCCESS',
        Data = {
            KV_KEY = kv_key,
            KV_VALUE = kv_value,
            KV_NAME = kv_name
        }
    })
end

local function kvGet(msg)
    local decodeCheck, data = BH.decodeMessageData(msg.Data)
    if not decodeCheck then
        ao.send({
            Target = msg.From,
            Action = 'Input-Error',
            Tags = {
                Status = 'Error',
                Message =
                'Invalid Data'
            }
        })
        return
    end

    local kv_key = msg.tags[BH.TAGS.KV_KEY] or data and data[BH.TAGS.KV_KEY]
    local kv_name = msg.tags[BH.TAGS.KV_NAME] or data and data[BH.TAGS.KV_NAME]

    if not kv_key or not kv_name then
        ao.send({
            Target = msg.From,
            Action = 'Input-Error',
            Tags = {
                Status = 'Error',
                Message =
                'Invalid Data'
            }
        })
        return
    end

    if not KV.stores[kv_name] then
        ao.send({
            Target = msg.From,
            Action = 'Error',
            Tags = {
                Status = 'Error',
                Message =
                'KV_NAME not found'
            }
        })
        return
    end

    local store = KV.stores[kv_name]
    local kv_value = store:get(kv_key)
    if kv_value == nil then
        ao.send({
            Target = msg.From,
            Action = 'KV_GET_NOT_FOUND', -- what if null?
            Data = {
                KV_KEY = kv_key,
                KV_VALUE = nil,
                KV_NAME = kv_name
            }
        })
        return
    end
    ao.send({
        Target = msg.From,
        Action = 'KV_GET_SUCCESS',
        Data = {
            KV_KEY = kv_key,
            KV_VALUE = kv_value,
            KV_NAME = kv_name
        }
    })
end

function BH.install()
    Handlers.add(
            BH.ACTIONS.KV_SET,
            Handlers.utils.hasMatchingTag("Action", BH.ACTIONS.KV_SET),
            kvSet
    )

    Handlers.add(
            BH.ACTIONS.KV_GET,
            Handlers.utils.hasMatchingTag("Action", BH.ACTIONS.KV_GET),
            kvGet
    )
end

return BH
