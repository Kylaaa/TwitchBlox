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
    "total": 2,
    "tier": "1000",
    "cumulative_total": 284, //null if anonymous or not shared by the user
    "is_anonymous": false
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
	local gift = {
		total = eventData["total"],
		tier = eventData["tier"],
		cumulativeTotal = eventData["cumulative_total"],
		isAnonymous = eventData["is_anonymous"],
	}
	eventSignal.fire(id, time, sender, receiver, gift)
end

return { "channel.subscription.gift", eventSignal, parseEvent }