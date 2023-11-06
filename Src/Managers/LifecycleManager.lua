local LibraryRoot = script:FindFirstAncestor("TwitchBlox")

local Packages = LibraryRoot.Packages
local Signal = require(Packages.Signal)

local RunService = game:GetService("RunService")


local LifecycleManager = {}
LifecycleManager.__index = LifecycleManager


function LifecycleManager.new(dependencies : {})
	local lm = {
		Heartbeat = Signal.new(),
		Connected = Signal.new(),
		ConnectedToLocalHost = Signal.new(),
		Authenticated = Signal.new(),
		Closing = Signal.new(), -- () -> ()

		_connections = {},
	}
	setmetatable(lm, LifecycleManager)

	return lm
end

return LifecycleManager