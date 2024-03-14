local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Signal = require(LibraryRoot.Packages.Signal)

local eventSignal = Signal.new()
local function parseEvent(eventData)
	eventSignal.fire(eventData)
end

return "channel.hype_train.begin", eventSignal, parseEvent