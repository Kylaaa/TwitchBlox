local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Signal = require(LibraryRoot.Packages.Signal)

local eventSignal = Signal.new()
local function parseEvent(eventData)
	eventSignal.fire(eventData)
end

return "channel.channel_points_custom_reward_redemption.add", eventSignal, parseEvent