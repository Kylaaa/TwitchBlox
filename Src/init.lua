local LibraryRoot = script
local Packages = LibraryRoot.Packages
local Karen = require(Packages.Karen)

local Managers = LibraryRoot.Managers

local k = Karen.new("TwitchBlox")
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
	Managers.PersistenceManager,
	Managers.LogManager,
	Managers.NetworkingManager,
	Managers.NPCManager,
	Managers.StateManager,
})
sm:initialize()

-- DEBUG
local lm = sm:get("LogManager")
lm.NewMessage:Connect(function(message)
	print(message)
end)

return {
	Enums = require(script.Enums),
	Configuration = require(script.Config)(sm),
	Events = require(script.Events)(sm),

	-- 
	Lifecycle = require(script.Lifecycle)(sm),
}