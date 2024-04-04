local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Packages = if LibraryRoot:FindFirstChild("Packages") then LibraryRoot.Packages else LibraryRoot.Parent
local Signal = require(Packages.Signal)


-- The configuration table is externally mutatable, we just need to grab the underlying table for now
local createConfigTable = require(LibraryRoot.Config)

local ConfigurationManager = {}
ConfigurationManager.__index = ConfigurationManager

function ConfigurationManager.new(dependencies : {})
	local cm = {
		-- if the configuration changes at runtime, alert all observers that they need to refetch their values
		Updated = Signal.new(),

		_config = {},
	}

	local configTable = createConfigTable(function(key, value)
		cm:setValue(key, value)
	end) 

	-- copy the contents of the configuration file to break any connections
	for k, v in pairs(configTable:_get()) do
		cm._config[k] = v
	end

	setmetatable(cm, ConfigurationManager)
	return cm
end

function ConfigurationManager:getValue(key : string)
	if self._config[key] == nil then
		error(string.format("No value loaded for key, %s", key), 1)
		return nil
	end

	return self._config[key]
end

function ConfigurationManager:_updateOrThrow(key, value) 
	if self._config[key] == nil then
		error(string.format("Could not set value for non-existent key, %s", key), 1)
		return
	end

	self._config[key] = value
end

function ConfigurationManager:setValue(key : string, value : any)
	self:_updateOrThrow(key, value)

	-- alert any observers that configuration has changed at runtime
	self.Updated:Fire()
end

function ConfigurationManager:setValues(newValues : {})
	-- when setting multiple values, use this batch updater to reduce the number of times observers must re-initialize
	for key, value in pairs(newValues) do
		self:_updateOrThrow(key, value)
	end

	-- alert any observers that configuration has changed at runtime
	self.Updated:Fire()
end

return ConfigurationManager