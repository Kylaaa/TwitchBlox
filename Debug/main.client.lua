local TwitchBlox = require(script.Parent.Library)

TwitchBlox.Lifecycle:SetChannelName("Kylaaa_tv")

--[[local events = {
	"channel.cheer",
	"channel.cheer",
	"channel.follow",
	"channel.subscribe",
	"channel.subscription.gift",
	"channel.subscription.message",
	"channel.cheer",
	"channel.raid",
	"channel.hype_train.begin",
	"channel.hype_train.progress"
	"channel.hype_train.end",
	"channel.channel_points_custom_reward_redemption.add",
}]]

for k, evt in pairs(TwitchBlox.Events) do
	evt:Connect(function(eventArgs)
		print(k, eventArgs)
	end)
end

local success, message = TwitchBlox.Lifecycle:CheckConnection()
if not success then
	print(message)
	TwitchBlox.Lifecycle:ReqestLogin()
end