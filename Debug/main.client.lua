local TwitchBlox = require(script.Parent.TwitchBlox)

-- Generic Callback
TwitchBlox.OnEventReceived:Connect(function(eventName, id, eventData, receivedDate)
	print(string.format("%s - Received %s with id (%s)", receivedDate, eventName, id), eventData)
end)

-- Specialized Callbacks
local function simpleEventLogger(...)
	print(...)
end
TwitchBlox.Events.OnChannelCheer:Connect(simpleEventLogger)
TwitchBlox.Events.OnChannelFollow:Connect(simpleEventLogger)
TwitchBlox.Events.OnChannelHypeTrainBegin:Connect(simpleEventLogger)
TwitchBlox.Events.OnChannelHypeTrainProgress:Connect(simpleEventLogger)
TwitchBlox.Events.OnChannelHypeTrainEnd:Connect(simpleEventLogger)
TwitchBlox.Events.OnChannelPointRedemptionAdd:Connect(simpleEventLogger)
TwitchBlox.Events.OnChannelRaid:Connect(simpleEventLogger)
TwitchBlox.Events.OnChannelSubscribe:Connect(simpleEventLogger)
TwitchBlox.Events.OnChannelSubscriptionGift:Connect(simpleEventLogger)
TwitchBlox.Events.OnChannelSubscriptionMessage:Connect(simpleEventLogger)


-- Begin initializing
TwitchBlox.Lifecycle:getStatusAync():andThen(function()
	-- All Good!
	TwitchBlox.startPollingForEvents()

	local rs = game:GetService("RunService")
	if not rs:IsStudio() then
		game:BindToClose(function()
			TwitchBlox.stopPollingForEvents()
		end)
	end

end, function(errCode, message)
	print(message)
	if errCode == TwitchBlox.Enums.Errors.NoLocalhostAvailable then
		warn("Localhost Server Not Running")
	elseif errCode == TwitchBlox.Enums.Errors.NotAuthenticated then
		warn("User Isn't Authenticated")
		TwitchBlox.Lifecycle.login()
	elseif errCode == TwitchBlox.Enums.Errors.NotConnected then
		warn("Localhost Server Not Connected To Twitch")
	end
end)