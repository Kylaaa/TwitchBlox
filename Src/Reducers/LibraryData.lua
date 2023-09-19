local plugin = script:FindFirstAncestorOfClass("Plugin").TwitchBloxPlugin
local Libs = plugin.Libs
local Rodux = require(Libs.Rodux)

local ActionsFolder = plugin.Actions
local SetPluginConnected = require(ActionsFolder.SetPluginConnected)
local SetPluginInitialized = require(ActionsFolder.SetPluginInitialized)

export type LibraryDataReducer = {
	isInitialized : boolean,
	isConnectedToServer : boolean,
}

--[[
	Holds onto information about the library
]]
local LibraryData = Rodux.createReducer({
	isInitialized = false,
	isConnectedToServer = false,
}, {
	[SetPluginInitialized.Name] = function(state, action)
		return Cryo.Dictionary.join(state, {
			isInitialized = true,
		})
	end,

	[SetPluginConnected.Name] = function(state, action)
		local isConnected = action.isConnected

		return Cryo.Dictionary.join(state, {
			isConnectedToServer = isConnected,
		})
	end,
})

return PluginData