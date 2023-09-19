local Action = require(script.Parent.Action)

local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local TwitchEvent = require(LibraryRoot.Events.TwitchEvent)

return Action(script.Name, function(event : TwitchEvent.TwitchEvent)
	return {
		name = event.name,
		scope = event.scope,
	}
end)