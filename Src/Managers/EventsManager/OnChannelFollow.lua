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
    "followed_at": "2020-07-15T18:16:11.17106713Z"
}
]]

local eventSignal = Signal.new() -- <string, ISO datetime, {}, {}>

local function parseEvent(id, time, eventData)
	local sender = {
		userId = eventData["user_id"],
		userName = eventData["userName"],
	}
	local receiver = {
		userId = eventData["broadcaster_user_id"],
		userName = eventData["broadcaster_user_name"],
	}
	eventSignal:Fire(id, time, sender, receiver)
end

return { "channel.follow", eventSignal, parseEvent }