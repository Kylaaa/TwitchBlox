<h1 align="center">TwitchBlox</h1>
<div align="center">
	A library that exposes Twitch stream events to Roblox.<br/>
    <sub>Requires use of the <a href="#">KidsInASandBlox application and Twitch integration</a>.</sub>
</div>
<br/><br/>

## Installation
Option 1) Wally

Add TwitchBlox to your `wally.toml` dependencies.

```toml
[dependencies]
TwitchBlox = "kylaaa/twitchblox@0.3.0"
```

Option 2) Direct import

- Go to the Releases section of this GitHub repo.
- Download `TwitchBlox.rbxm`
- Drag and drop it into Roblox Studio.


<br/><br/>

## Usage

```lua
-- load the library
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
TwitchBlox.Lifecycle.getStatusAsync():andThen(function()
	-- All Good!
	TwitchBlox.Lifecycle.startPollingForEvents()

	local rs = game:GetService("RunService")
	if not rs:IsStudio() then
		game:BindToClose(function()
			TwitchBlox.stopPollingForEvents()
		end)
	end

end, function(errCode, message)
	if errCode == TwitchBlox.Enums.Errors.NoLocalhostAvailable then
		warn("Localhost Server Not Running")
	elseif errCode == TwitchBlox.Enums.Errors.NotAuthenticated then
		warn("User Isn't Authenticated")
		TwitchBlox.Lifecycle.login()
	elseif errCode == TwitchBlox.Enums.Errors.NotConnected then
		warn("Localhost Server Not Connected To Twitch")
	end
end)
```
