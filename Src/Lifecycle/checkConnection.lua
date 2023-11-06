--[[
	Connect to the Twitch Observer server
]]
local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Enums = require(LibraryRoot.Enums)


return function(managers) : ()->(boolean, number)
	local nm = managers:get("NetworkingManager")
	local sm = managers:get("StateManager")

	return function() 
		local success = false
		nm
	end
end