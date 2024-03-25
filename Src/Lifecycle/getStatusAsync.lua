--[[
	Connect to the Twitch Observer server
]]
local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Enums = require(LibraryRoot.Enums)


return function(managers)
	local lm = managers:get("LoggingManager")
	local nm = managers:get("NetworkingManager")

	return function()
		return nm:requestAppStatus():andThen(function(response)
			lm:trace(response)
			local isAuthenticated = response.authenticated == true
			if (not isAuthenticated) then
				return Promise.reject(Enums.Errors.NotAuthenticated)
			end

			local isConnected = response.connected == true
			if (not isConnected) then
				return Promise.reject(Enums.Errors.NotConnected)
			end

			return true, "GOOD TO GO!"
			
		end, function(err)
			-- TODO : HANDLE LOCALHOST NOT RUNNING
			lm:error(err)
			return Promise.reject(Enums.Errors.NoLocalhostAvailable)
		end)
	end
end