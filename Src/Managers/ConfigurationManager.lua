local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Packages = LibraryRoot.Packages

-- The configuration table is externally mutatable, we just need to grab the underlying table for now
local config = require(LibraryRoot.Config)():_get()


local ConfigurationManager = {}
ConfigurationManager.__index = ConfigurationManager

function ConfigurationManager.new(dependencies : {})
	local cm = {}
	for k, v in pairs(config) do
		cm[k] = v
	end
	setmetatable(cm, ConfigurationManager)

	return cm
end

function ConfigurationManager:getValue(key : string)
	if self[key] == nil then
		error(string.format("No value loaded for key, %s", key), 1)
		return nil
	end

	return self[key]
end

function ConfigurationManager:setValue(key : string, value : any)
	if self[key] == nil then
		error(string.format("Could not set value for non-existent key, %s", key), 1)
		return
	end

	self[key] = value
end

return ConfigurationManager