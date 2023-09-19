local LibraryRoot = script:FindFirstAncestor("TwitchBlox")

local Packages = LibraryRoot.Packages
local Signal = require(Packages.Signal)

local RunService = game:GetService("RunService")


local EnvironmentManager = {}
EnvironmentManager.__index = EnvironmentManager



function EnvironmentManager.new(dependencies : {})
	local em = {
		isPlugin = script:FindFirstAncestorOfClass("Plugin") ~= nil,
		isEditDM = RunService:IsEdit(),
		
	}
	setmetatable(em, EnvironmentManager)

	return em
end

return EnviromentManager