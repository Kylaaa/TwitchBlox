--!strict
local LibraryRoot = script
local Packages = if LibraryRoot:FindFirstChild("Packages") then LibraryRoot.Packages else LibraryRoot.Parent
local Karen = require(Packages.Karen)

local Managers = LibraryRoot.Managers

local sm = Karen.new("TwitchBloxLibrary")
sm:registerSingleton(Managers.ConfigurationManager, {})
sm:registerSingleton(Managers.LogManager, {
	Managers.ConfigurationManager,
})
sm:registerSingleton(Managers.NetworkingManager, {
	Managers.ConfigurationManager,
	Managers.LogManager,
})
sm:registerSingleton(Managers.SessionManager, {})
sm:registerSingleton(Managers.EventsManager, {
	Managers.SessionManager,
})

sm:initialize()

-- If any messages come from the libary, log them through this event.
-- Change the log level in the configuration file to log messages
sm:get("LogManager").NewMessage:Connect(function(level, ...)
	if sm:get("ConfigurationManager"):getValue("LOG_TO_OUTPUT") then
		local lm = sm:get("LogManager")
		local outFunc : {[number] : (any?)->(any?)} = {
			[lm.LogLevel.Error] = error,
			[lm.LogLevel.Warning] = warn,
			[lm.LogLevel.Message] = print,
			[lm.LogLevel.Trace] = print,
		}
		outFunc[level](...)
	end
end)

local em = sm:get("EventsManager")
local library = {
	Configuration = require(script.Config)(sm),
	Enums = require(script.Enums),
	
	-- Actions
	Lifecycle = require(script.Lifecycle)(sm),

	-- Events for subscribing
	OnEventReceived = em.OnEventReceived,
	Events = em.events,
}
return library