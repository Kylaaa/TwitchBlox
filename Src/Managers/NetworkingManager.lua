local LibraryRoot = script:FindFirstAncestor("TwitchBlox")

local Packages = LibraryRoot.Packages
local Roact = require(Packages.Roact)
local Http = require(Packages.Http)

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local UtilFolder = plugin.Util
local getSubscribedTwitchEvents = require(UtilFolder.getSubscribedTwitchEvents)


local NetworkingManager = {}
NetworkingManager.__index = NetworkingManager

function NetworkingManager.new(dependencies : {})
	local cm = dependencies.ConfigurationManager

	local nm = {
		dependencies = dependencies,
		protocol = if cm:getValue("HTTP_USE_HTTPS") then "https" else "http",
		host = cm:getValue("HTTP_HOST"),
		port = cm:getValue("HTTP_PORT"),
		interval = cm:getValue("HTTP_POLLING_INTERVAL"),
		timeout = cm:getValue("HTTP_POLLING_TIMEOUT"),
		httpImpl = Http.new({
			DEBUG = cm:getValue("HTTP_DEBUG"),
		}),
		connections = {},
	}
	setmetatable(nm, NetworkingManager)

	return nm
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

function NetworkingManager:authenticateWithTwitch(onResponse : ()->())
	local sm = self.dependencies.StateManager
	local events = getSubscribedTwitchEvents()
	local scopes = {}
	for eventName, eventData in pairs(events) do
		table.insert(scopes, eventData.scope)
	end
	local args = { 
		scopes = table.concat(scopes, "+"),
	}
	local targetUrl = self:constructLocalhostUrl("requestLogin", args)
	self.httpImpl:GET(targetUrl):andThen(function(response)
		-- hopefully returns a broadcasterId
		print(response)
		onResponse(response)
	end)
end


--[[
	Due to the nature of the Edit / Play datamodel lifecycle, it's important to check if the local server has connected to Twitch yet.
]]
function NetworkingManager:checkIfConnectedToTwitch(onResponse : (bool, string)->())
	local targetUrl = self:constructLocalhostUrl("checkConnection")
	local fetchPromise = self.httpImpl:GET(targetUrl)
	self.httpImpl:parseJSON(fetchPromise):andThen(function(responseJSON)
		-- check if we are actually connected
		local isConnected = responseJSON.Body == "true"
		onResponse(isConnected, "")
	end, function(errorMessage)
		onResponse(false, "Failed to connect with message : " .. (errorMessage or ""))
	end)
end

--[[
	The local server will not connect to Twitch until Studio signals that it is ready.
]]
function NetworkingManager:connectToTwitch(onResponse : (bool, string)->())
	local targetUrl = self:constructLocalhostUrl("connectToTwitch")
	local fetchPromise = self.httpImpl:POST(targetUrl, ""):andThen(function()
		onResponse(true, "")
	end)
end

--[[

]]
function NetworkingManager:subscribeToEvents(topics : {}, onResponse : (bool)->())
	local targetUrl = self:constructLocalhostUrl("subscribe")
	local body = HttpService:JSONEncode(topics)
	self.httpImpl:POST(targetUrl, body):andThen(function()
		onResponse(true)
	end, function()
		onResponse(false)
	end)
end

function NetworkingManager:unsubscribeFromTopics(topics : {}, onResponse : ()->())
	local targetUrl = self:constructLocalhostUrl("unsubscribe")
end

function NetworkingManager:startPollingForChanges(onResponse : ({}) -> ())
	local targetUrl = self:constructLocalhostUrl("changes")

	-- don't dispatch a new request until the old one finishes
	local requestDebounce = false
	local timeSinceLastPoll = self.interval

	table.insert(self.connections, RunService.Heartbeat:Connect(function(deltaTimeS)
		if requestDebounce then
			return
		end

		timeSinceLastPoll -= (deltaTimeS * 1000)
		if timeSinceLastPoll > 0 then
			return
		end

		requestDebounce = true
		local requestPromise = self.httpImpl:GET(targetUrl)
		self.httpImpl:parseJSON(requestPromise):andThen(function(responseJSON)
			print("Changes since last request : ", responseJSON.Body)
			onResponse(responseJSON.Body)
			requestDebounce = false
			timeSinceLastPoll = self.interval
		end, function(parseError)
			warn("failed to parse JSON with error : " .. (parseError or ""))
			requestDebounce = false
			timeSinceLastPoll = self.interval
		end)
	end))
end

function NetworkingManager:stopPolling()
	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end
end

function NetworkingManager:getBroadcasterId(channelUrl : string)
	
end

return NetworkingManager