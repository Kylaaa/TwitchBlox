local plugin = script:FindFirstAncestorOfClass("Plugin")
local pluginRoot = plugin.TwitchBloxPlugin
local UtilFolder = pluginRoot.Util
local getCurrentState = require(UtilFolder.getCurrentState)

return function()
	local state = getCurrentState()
	local TwitchEvents = state.TwitchUser.events

	local subscriptions = {}
	for name, eventData in pairs(TwitchEvents) do
		if eventData.enabled == true then
			subscriptions[name] = eventData.version
		end
	end

	return subscriptions
end