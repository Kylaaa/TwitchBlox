local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Signal = require(LibraryRoot.Packages.Signal)

--[[
{
    "user_id": "1234",
    "user_login": "cool_user",
    "user_name": "Cool_User",
    "broadcaster_user_id": "1337",
    "broadcaster_user_login": "cooler_user",
    "broadcaster_user_name": "Cooler_User",
    "tier": "1000",
    "is_gift": false
}
]]

local eventSignal = Signal.new()

local function parseEvent(id, time, eventData)
	local sender = {
		userId = eventData["user_id"],
		userName = eventData["userName"],
	}
	local receiver = {
		userId = eventData["broadcaster_user_id"],
		userName = eventData["broadcaster_user_name"],
	}
	local tier = eventData["tier"]
	local isGift = eventData["is_gift"]

	eventSignal.fire(id, time, sender, receiver, tier, isGift)
end

return { "channel.subscribe", eventSignal, parseEvent }