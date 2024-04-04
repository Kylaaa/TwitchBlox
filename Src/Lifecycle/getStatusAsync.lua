--[[
	Connect to the Twitch Observer server
]]
local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Packages = if LibraryRoot:FindFirstChild("Packages") then LibraryRoot.Packages else LibraryRoot.Parent
local Enums = require(LibraryRoot.Enums)
local Promise = require(Packages.Promise)


return function(managers)
	local lm = managers:get("LogManager")
	local nm = managers:get("NetworkingManager")

	return function()
		return nm:requestAppStatus():andThen(function(response)
			lm:trace(response)
			local body = response.Body
			local isAuthenticated = body.authenticated == true
			if (not isAuthenticated) then
				return Promise.reject(Enums.Errors.NotAuthenticated)
			end

			local isConnected = body.connected == true
			if (not isConnected) then
				return Promise.reject(Enums.Errors.NotConnected)
			end

			return true, "GOOD TO GO!"
			
		end, function(err)
			-- TODO : HANDLE LOCALHOST NOT RUNNING
			--if (err.Code == 500) then
			lm:error(err)
			return Promise.reject(Enums.Errors.NoLocalhostAvailable)
		end)
	end
end