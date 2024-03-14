local TwitchBlox = require(script.Parent.Library)

-- Generic Callback
TwitchBlox.OnEvent:Connect(function(eventName, id, eventData, receivedDate)
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


-- 
local success, message = TwitchBlox.Lifecycle:CheckConnection()
if not success then
	print(message)
	TwitchBlox.Lifecycle:ReqestLogin()
end