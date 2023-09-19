--[[
	A TwitchEvent observes the events that are dispatched by the EventManager and relays them with details
]]
local LibraryRoot = script:FindFirstChild("TwitchBlox")
local Packages = LibraryRoot.Packages

local Signal = require(Packages.Signal)

local HttpService = game:GetService("HttpService")

export type InitializationDetails = {
	name : string,
	description : string,
	["version"] : number,
	scope : string,
	condition : { string },
}
export type TwitchEvent<T...> = {
	name : string,
	description : string,
	scope : string,
	getSubscriptionDetails : (self:TwitchEvent<T...>) -> (string),
	connect : (self:TwitchEvent<T...>, (T...)->nil) -> Signal.Connection,
	Connect : (self:TwitchEvent<T...>, (T...)->nil) -> Signal.Connection,
}

local TwitchEvent = {}
TwitchEvent.__index = TwitchEvent

function TwitchEvent.new<T...>(details : InitializationDetails, managers) : TwitchEvent<T...>
	local evt = setmetatable({
		name = details.name,
		description = details.description,
		["version"] = details.version,
		scope = details.scope,
		condition = details.condition,
		signal = Signal.new(),
		managerRefs = managers,
	}, TwitchEvent)
	
	return evt
end

function TwitchEvent:getSubscriptionDetails() : string
	-- TODO : UPDATE TO LOOKUP FROM STORED STATE

	-- TODO : this use of BROADCASTER_USER_ID and TO_BROADCASTER_USER_ID is opinionated for the logged in user.
	-- It should be updated to allow for the consumer of the library to specify the target ids
	local currentState = self.managerRefs:get("PersistenceManager"):getState()
	local lookups = {
		["broadcaster_user_id"] = function()
			return currentState.TwitchUser.broadcasterId
		end,
		["to_broadcaster_user_id"] = function()
			return currentState.TwitchUser.broadcasterId
		end,
		["session_id"] = function()
			return currentState.TwitchUser.sessionId
		end,
	}

	local conditions = {}
	for _, target in ipairs(conditions) do
		conditions[target] = lookups[target]
	end

	return HttpService:JSONEncode({
		type = self.name,
		["version"] = self.version,
		condition = conditions,
		transport = {
			method = "websocket",
			session_id = lookups["session_id"],
		},
	})
end

function TwitchEvent:connect(callback) : Signal.Connection
	return self.signal:Connect(callback)    
end
TwitchEvent.Connect = TwitchEvent.connect

return TwitchEvent