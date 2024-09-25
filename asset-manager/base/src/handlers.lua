local function load_asset_manager()
    local AssetManager = {}

    AssetManager.__index = AssetManager

    local AssetManagerPackageName = '@permaweb/asset-manager'

    function AssetManager.new()
        local self = setmetatable({}, AssetManager)
        self.uploads = {}
        return self
    end

    function AssetManager.get_uploads()
        print('Get uploads')
    end

    package.loaded[AssetManagerPackageName] = AssetManager

    return AssetManager
end

package.loaded['@permaweb/asset-manager'] = load_asset_manager()

local AssetManager = require('@permaweb/asset-manager')
if not AssetManager then
    error('AssetManager not found, install it')
end

Handlers.add('Zone-Uploads', Handlers.utils.hasMatchingTag('Action', 'Zone-Uploads'),
    function(msg)
        print('Zone-Uploads123')
        AssetManager.get_uploads()
    end
)
