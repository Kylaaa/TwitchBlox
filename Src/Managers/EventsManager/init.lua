local LibraryRoot = script:FindFirstAncestor("TwitchBlox")

local Packages = LibraryRoot.Packages
local Signal = require(Packages.Signal)

local EventsManager = {}
EventsManager.__index = EventsManager

function EventsManager.new(dependencies : {})
	local em = {
		callbacks = {},
		events = {},
	}

	for _, eventModule in ipairs(script:GetChildren()) do
		local eventName, signal, callback = require(eventModule)
		em.callbacks[eventName] = callback
		em.events[eventModule.Name] = signal
	end

	return setmetatable(em, EventsManager)
end

return EventsManager