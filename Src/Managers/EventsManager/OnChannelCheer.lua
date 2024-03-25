local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Signal = require(LibraryRoot.Packages.Signal)

--[[
{
    "is_anonymous": false,
    "user_id": "1234",          // null if is_anonymous=true
    "user_login": "cool_user",  // null if is_anonymous=true
    "user_name": "Cool_User",   // null if is_anonymous=true
    "broadcaster_user_id": "1337",
    "broadcaster_user_login": "cooler_user",
    "broadcaster_user_name": "Cooler_User",
    "message": "pogchamp",
    "bits": 1000
}
]]

local eventSignal = Signal.new() -- <string, ISO datetime, {}, {}, string, number>

local function parseEvent(id, time, eventData)
	local sender = {
		isAnonymous = eventData["is_anonymous"],
		userId = eventData["user_id"],
		userName = eventData["userName"],
	}
	local receiver = {
		userId = eventData["broadcaster_user_id"],
		userName = eventData["broadcaster_user_name"],
	}
	local message = eventData["message"]
	local bits = eventData["bits"]

	eventSignal.fire(id, time, sender, receiver, message, bits)
end

return { "channel.cheer", eventSignal, parseEvent }