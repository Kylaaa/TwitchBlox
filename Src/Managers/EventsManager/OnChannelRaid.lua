local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Signal = require(LibraryRoot.Packages.Signal)

--[[
{
    "from_broadcaster_user_id": "1234",
    "from_broadcaster_user_login": "cool_user",
    "from_broadcaster_user_name": "Cool_User",
    "to_broadcaster_user_id": "1337",
    "to_broadcaster_user_login": "cooler_user",
    "to_broadcaster_user_name": "Cooler_User",
    "viewers": 9001
}
]]

local eventSignal = Signal.new() --<{}, {}, number>

local function parseEvent(id, time, eventData)
	local raider = {
		userId = eventData["from_broadcaster_user_id"],
		userName = eventData["from_broadcaster_user_name"],
	}
	local receiver = {
		userId = eventData["to_broadcaster_user_id"],
		userName = eventData["to_broadcaster_user_name"],
	}
	local viewers = eventData["viewers"]

	eventSignal.fire(id, time, sender, receiver, viewers)
end

return { "channel.raid", eventSignal, parseEvent }