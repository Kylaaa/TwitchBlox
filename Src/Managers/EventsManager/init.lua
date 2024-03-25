local LibraryRoot = script:FindFirstAncestor("TwitchBlox")

local RunService = game:GetService("RunService")

local Packages = LibraryRoot.Packages
local Signal = require(Packages.Signal)

local EventsManager = {}
EventsManager.__index = EventsManager

function EventsManager.new(dependencies : {})
	local em = {
		handlers = {},
		events = {},

		OnEventReceived = Signal.new(),
	}

	for _, eventModule in ipairs(script:GetChildren()) do
		local eventName, signal, parseEvent = unpack(require(eventModule))
		em.handlers[eventName] = parseEvent
		em.events[eventModule.Name] = signal
	end

	return setmetatable(em, EventsManager)
end

function EventsManager:getCurrentISOTimestamp()
	--ex) 2024-01-01T00:01:00Z
	return os.date("%Y-%m-%dT%H:%M:%SZ")
end

function EventsManager:callOnInterval(interval, callback, ...)
	local args = { ... }
	local secondsSinceLastCall = 0.0
	local disconnectToken = RunService:Heartbeat(function(deltaTime : number)
		secondsSinceLastCall -= deltaTime
		if secondsSinceLastCall <= 0.0 then
			callback(unpack(args))
			secondsSinceLastCall = interval
		end
	end)
	return disconnectToken
end

function EventsManager:parseEvent(event)
	local id = event.id
	local name = event.name
	local data = event.data
	local time = event.received_date

	-- specific event handler
	self.handlers[name](id, time, data)

	-- generic handler
	self.OnEventReceived:Fire(name, id, time, data)
end

return EventsManager