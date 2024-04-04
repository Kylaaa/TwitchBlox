local LibraryRoot = script:FindFirstAncestor("TwitchBlox")

local RunService = game:GetService("RunService")

local Packages = if LibraryRoot:FindFirstChild("Packages") then LibraryRoot.Packages else LibraryRoot.Parent
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
	-- Don't us os.date(), as it returns a time based on the current locale, not the current UTC timestamp
	return DateTime.now():ToIsoDate()
	
end

function EventsManager:callOnInterval(interval, callback, ...)
	local args = { ... }
	local secondsSinceLastCall = 0.0
	local disconnectToken = RunService.Heartbeat:Connect(function(deltaTime : number)
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
	local handler = self.handlers[name]
	if handler then
		handler(id, time, data)
	end

	-- generic handler
	self.OnEventReceived:Fire(name, id, time, data)
end

return EventsManager