local LibraryRoot = script
local Packages = LibraryRoot.Packages
local Karen = require(Packages.Karen)

local Managers = LibraryRoot.Managers

local sm = Karen.new("TwitchBlox")
sm:registerSingleton(Managers.ConfigurationManager, {})
sm:registerSingleton(Managers.LifecycleManager, {})
sm:registerSingleton(Managers.LogManager, {
	Managers.ConfigurationManager,
})
sm:registerSingleton(Managers.NetworkingManager, {
	Managers.ConfigurationManager,
	Managers.LogManager,
})
sm:registerSingleton(Managers.PersistenceManager, {})
sm:registerSingleton(Managers.StateManager, {
	Managers.LogManager,
	Managers.PersistenceManager,
})
sm:registerSingleton(Managers.TwitchBloxManager, {
	Managers.ConfigurationManager,
	Managers.LogManager,
	Managers.NetworkingManager,
	Managers.StateManager,
})
sm:initialize()

-- If any messages come from the libary, log them through this event.
-- Change the log level in the configuration file to log messages
sm:get("LogManager").NewMessage:Connect(function(level, ...)
	if sm:get("ConfigurationManager"):getValue("LOG_TO_OUTPUT") then
		local outFunc = {
			[lm.LogLevel.Error] = error,
			[lm.LogLevel.Warning] = warn,
			[lm.LogLevel.Message] = print,
			[lm.LogLevel.Trace] = print,
		}
		outFunc[level](...)
	end
end)

return {
	Configuration = require(script.Config)(sm),
	Enums = require(script.Enums),
	Events = require(script.Events)(sm),
	Lifecycle = require(script.Lifecycle)(sm),
}