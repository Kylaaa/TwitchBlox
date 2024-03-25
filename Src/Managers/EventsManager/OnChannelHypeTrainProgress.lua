local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Signal = require(LibraryRoot.Packages.Signal)

--[[
{
    "id": "1b0AsbInCHZW2SQFQkCzqN07Ib2",
    "broadcaster_user_id": "1337",
    "broadcaster_user_login": "cool_user",
    "broadcaster_user_name": "Cool_User",
    "level": 2,
    "total": 700,
    "progress": 200,
    "goal": 1000,
    "top_contributions": [
        { "user_id": "123", "user_login": "pogchamp", "user_name": "PogChamp", "type": "bits", "total": 50 },
        { "user_id": "456", "user_login": "kappa", "user_name": "Kappa", "type": "subscription", "total": 45 }
    ],
    "last_contribution": { "user_id": "123", "user_login": "pogchamp", "user_name": "PogChamp", "type": "bits", "total": 50 },
    "started_at": "2020-07-15T17:16:03.17106713Z",
    "expires_at": "2020-07-15T17:16:11.17106713Z"
}
]]

local eventSignal = Signal.new()

local function parseEvent(id, time, eventData)
	local receiver = {
		userId = eventData["broadcaster_user_id"],
		userName = eventData["broadcaster_user_name"],
	}
	local trainInfo = {
		id = eventData["id"], -- string
		total = eventData["total"], -- number
		progress = eventData["progress"], -- number
		goal = eventData["goal"], -- number
		level = eventData["level"], -- number
		started = eventData["started_at"], -- ISO datetime
		expires = eventData["expires_at"], -- ISO datetime
	}
	local contributors = {
		top = eventData["top_contributions"],
		latest = eventData["last_contribution"],
	}

	eventSignal.fire(id, time, receiver, trainInfo, contributors)
end

return { "channel.hype_train.progress", eventSignal, parseEvent }