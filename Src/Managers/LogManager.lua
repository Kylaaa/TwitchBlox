local LibraryRoot = script:FindFirstAncestor("TwitchBlox")

local Packages = LibraryRoot.Packages
local Signal = require(Packages.Signal)


local LogManager = {}
LogManager.__index = LogManager

LogManager.LogLevel = {
	None = 0,
	Error = 1,
	Warning = 2,
	Message = 3,
	Trace = 4,
}

function LogManager.new(dependencies : {})
	local cm = dependencies.ConfigurationManager

	local lm = {
		logLevel = cm:getValue("LOGGING_LEVEL"),
		NewMessage = Signal.new(), -- (logLevel : number, ... : any) -> ()
	}
	setmetatable(lm, LogManager)

	cm.Updated:Connect(function()
		lm.LogLevel = cm:getValue("LOGGING_LEVEL")
	end)

	return lm
end

function LogManager:log(level : number, ...)
	assert(level ~= LogManager.LogLevel.None, "level cannot be `None`")

	if level <= self.LogLevel then
		self.NewMessage:fire(level, ...)
	end
end

function LogManager:error(...)
	self:log(LogManager.Error, ...)
end

function LogManager:warn(...)
	self:log(LogManager.Warning, ...)
end

function LogManager:message(...)
	self:log(LogManager.Message, ...)
end

function LogManager:trace(...)
	self:log(LogManager.Trace, ...)
end

return LogManager