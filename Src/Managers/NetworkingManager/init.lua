local LibraryRoot = script:FindFirstAncestor("TwitchBlox")

local Packages = LibraryRoot.Packages
local Http = require(Packages.Http)

local HttpService = game:GetService("HttpService")


local NetworkingManager = {}
NetworkingManager.__index = NetworkingManager

function NetworkingManager.new(dependencies : {})
	local cm = dependencies.ConfigurationManager

	local nm = {
		dependencies = dependencies,
		protocol = cm:getValue("HTTP_USE_HTTPS") and "https" or "http",
		host = cm:getValue("HTTP_HOST"),
		port = cm:getValue("HTTP_PORT"),
		interval = cm:getValue("HTTP_POLLING_INTERVAL"),
		timeout = cm:getValue("HTTP_POLLING_TIMEOUT"),
		httpImpl = Http.new({
			DEBUG = cm:getValue("HTTP_DEBUG"),
		}),
		connections = {},
	}
	
	cm.Updated:Connect(function()
		nm.protocol = cm:getValue("HTTP_USE_HTTPS") and "https" or "http"
		nm.host = cm:getValue("HTTP_HOST")
		nm.port = cm:getValue("HTTP_PORT")
		nm.interval = cm:getValue("HTTP_POLLING_INTERVAL")
		nm.timeout = cm:getValue("HTTP_POLLING_TIMEOUT")
		nm.httpImpl = Http.new({
			DEBUG = cm:getValue("HTTP_DEBUG"),
		})
	end)

	local children = script:GetChildren()
	for _, requestFunction in ipairs(children) do
		nm[requestFunction.Name] = function(...)
			requestFunction(nm, ...)
		end
	end

	return setmetatable(nm, NetworkingManager)
end

function NetworkingManager:constructLocalhostUrl(path : string, args : {}?) : string
	local argString = ""
	if args and next(args) ~= nil then
		local argList = {}
		for k, v in pairs(args) do
			table.insert(argList, string.format("%s=%s", k, HttpService:UrlEncode(v)))
		end
		argString = "?" .. table.concat(argList, "&")
	end

	return string.format("%s://%s:%s/%s%s", self.protocol, self.host, self.port, path, argString)
end

function NetworkingManager:request(method, url, body)
	local fetchPromise = self.httpImpl[method](self.httpImpl, url, body)
	return self.httpImpl:parseJSON(fetchPromise)
end


return NetworkingManager