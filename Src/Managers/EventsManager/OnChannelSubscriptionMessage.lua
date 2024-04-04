local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Packages = if LibraryRoot:FindFirstChild("Packages") then LibraryRoot.Packages else LibraryRoot.Parent
local Signal = require(Packages.Signal)
--[[
{
    "user_id": "1234",
    "user_login": "cool_user",
    "user_name": "Cool_User",
    "broadcaster_user_id": "1337",
    "broadcaster_user_login": "cooler_user",
    "broadcaster_user_name": "Cooler_User",
    "tier": "1000",
    "message": {
        "text": "Love the stream! FevziGG",
        "emotes": [
            {
                "begin": 23,
                "end": 30,
                "id": "302976485"
            }
        ]
    },
    "cumulative_months": 15,
    "streak_months": 1, // null if not shared
    "duration_months": 6
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
	local subscription = {
		tier = eventData["tier"],
		streak = eventData["streak_months"],
		duration = eventData["duration_months"],
		cumulative = eventData["cumulative_months"],
		message = eventData["message"],
	}
	
	eventSignal:Fire(id, time, sender, receiver, subscription)
end
return { "channel.subscription.message", eventSignal, parseEvent }