-- these are the values that are consumers of the library may change
local configuration = {
	-- library
	LIBRARY_NAME = "TwitchBlox",
	LIBRARY_VERSION = "0.0.1",

	-- networking
	HTTP_DEBUG = false,
	HTTP_USE_HTTPS = false,
	HTTP_HOST = "localhost",
	HTTP_PORT = 3000,
	HTTP_POLLING_INTERVAL_MS = 1500, -- ms
	HTTP_POLLING_TIMEOUT_MS = 2000, -- ms

	-- logging
	LOGGING_LEVEL = 0, -- trace
	LOG_TO_OUTPUT = false,
}


return function(onValueChanged : (any, any)->())
	-- create a proxy table so that any run-time accesses and mutations may be tracked
	return setmetatable({
		-- create a simple accessor for the ConfigurationManager
		_get = function()
			return configuration
		end,
	}, {
		__index = function(_, key)
			local v = configuration[key]
			if v then
				return v
			end

			error(string.format("Attempt to get a non-existent field in the configuration : %s", tostring(key)))
			return nil
		end,

		__newindex = function(_, key, value)
			if configuration[key] then
				configuration[key] = value
				
				-- the Configuration Manager is the source of truth once it's loaded, so send any changes there as well
				onValueChanged(key, value)
			else
				error(string.format("Attempt to set a non-existent field in the configuration : %s with value %s", tostring(key), tostring(value)), 2)
			end
		end,
	})
end