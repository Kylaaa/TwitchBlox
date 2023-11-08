<h1 align="center">TwitchBlox</h1>
<div align="center">
	A library that exposes Twitch stream events to Roblox.<br/>
    <sub>Requires use of the <a href="#">KidsInASandBlox application and Twitch integration</a>.</sub>
</div>
<br/><br/>

## Installation
Option 1) Wally

Option 2) Direct import
<br/><br/>

## Usage

```lua
-- load the library
local TwitchBlox = require(game.ReplicatedStorage.TwitchBlox)

-- configure some metadata
TwitchBlox.Lifecycle:SetChannelName("Kylaaa_tv")

-- subscribe to the Twitch Events
for k, evt in pairs(TwitchBlox.Events) do
	evt:Connect(function(eventArgs)
		print(k, eventArgs)
	end)
end

-- check whether the KidsInASandblox application is running
local isConnected, errMessage = TwitchBlox.Lifecycle:CheckConnection()
if not success then
	warn(errMessage)
	TwitchBlox.Lifecycle:ReqestLogin()
end
```
