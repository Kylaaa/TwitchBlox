local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Packages = if LibraryRoot:FindFirstChild("Packages") then LibraryRoot.Packages else LibraryRoot.Parent
local Signal = require(Packages.Signal)

--[[
{
    "id": "17fa2df1-ad76-4804-bfa5-a40ef63efe63",
    "broadcaster_user_id": "1337",
    "broadcaster_user_login": "cool_user",
    "broadcaster_user_name": "Cool_User",
    "user_id": "9001",
    "user_login": "cooler_user",
    "user_name": "Cooler_User",
    "user_input": "pogchamp",
    "status": "unfulfilled",
    "reward": {
        "id": "92af127c-7326-4483-a52b-b0da0be61c01",
        "title": "title",
        "cost": 100,
        "prompt": "reward prompt"
    },
    "redeemed_at": "2020-07-15T17:16:03.17106713Z"
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
	local rewardInfo = {
		id = eventData["reward"]["id"],
		status = eventData["status"],
		title = eventData["reward"]["title"],
		cost = eventData["reward"]["cost"],
		prompt = eventData["reward"]["prompt"],
		redeemed = eventData["redeemed_at"],
	}
	eventSignal:Fire(id, time, sender, rewardInfo)
end

return { "channel.channel_points_custom_reward_redemption.add", eventSignal, parseEvent }