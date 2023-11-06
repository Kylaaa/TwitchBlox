local LibraryRoot = script:FindFirstAncestor("TwitchBlox")

local Packages = LibraryRoot.Packages
local Rodux = require(Packages.Rodux)

local ActionsFolder = LibraryRoot.Actions
local LoggedMessage = require(ActionsFolder.LoggedMessage)

local ReducersFolder = LibraryRoot.Reducers
local MainReducer = require(ReducersFolder.MainReducer)


local StateManager = {}
StateManager.__index = StateManager

function StateManager.new(dependencies : {})
	local cm = dependencies.ConfigurationManager
	local lm = dependencies.LogManager

	local store = Rodux.Store.new(MainReducer, nil, {
		--Rodux.thunkMiddleware,

		-- for debugging, enable the logger to observe all the events passing through and the state changes they enable
		--Rodux.loggerMiddleware,
	})
	local connection = lm.NewMessage:Connect(function(logLevel, message)
		store:dispatch(LoggedMessage(logLevel, message))
	end)

	local sm = {
		storeRef = store,
		connections = { connection },
	}
	setmetatable(sm, StateManager)

	return sm
end

function StateManager:getCurrentState()
	return self.storeRef:getState()
end

function StateManager:loadFromPreviousState(previousState)
	local success, newStore = pcall(function()
		return Rodux.Store.new(MainReducer, previousState)
	end)
	if success then
		self.storeRef
	end
end

return StateManager