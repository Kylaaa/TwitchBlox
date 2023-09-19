local plugin = script:FindFirstAncestorOfClass("Plugin").TwitchBloxPlugin
local Libs = plugin.Libs
local Rodux = require(Libs.Rodux)

local ReducersFolder = plugin.Reducers

local MainReducer = Rodux.combineReducers({
	Messages = require(ReducersFolder.Messages),
	PluginData = require(ReducersFolder.PluginData),
	TwitchUser = require(ReducersFolder.TwitchUser),
})

return MainReducer