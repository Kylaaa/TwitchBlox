local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Packages = LibraryRoot.Packages

local Signal = require(Packages.Signal)

local TwitchEvent = require(script.TwitchEvent)

--[[
	Each event is configured with fields to allow the library to know how to subscribe to and parse each event.
	- Name = the specific name of event
	- Version = the version of the event to subscribe to
	- Scope = the required permissions that need to be requested upon login in order to subscribe to this event
	- Condition = a list of additional information to provide when subscribing.

	See specific details at : https://dev.twitch.tv/docs/eventsub/eventsub-subscription-types/
]]
type GUID = string -- ex : 1b0AsbInCHZW2SQFQkCzqN07Ib2
type ISO8601DateTime = string -- ex : YYYY-MM-DDThh:mm:ss.sssZ
type ParsableNumber = string -- ex : "1234"

type UserParams = {
	user_id : ParsableNumber,
	user_login : string,
	user_name : string,
}
type BroadcasterParams = {
	broadcaster_user_id : ParsableNumber,
	broadcaster_user_login : string,
	broadcaster_user_name : string,
}
type FromBroadcasterParams = {
	from_broadcaster_user_id : ParsableNumber,
	from_broadcaster_user_login : string,
	from_broadcaster_user_name : string,
}
type ToBroadcasterParams = {
	to_broadcaster_user_id : ParsableNumber,
	to_broadcaster_user_login : string,
	to_broadcaster_user_name : string,
}
type TierParams = { 
	tier : string,
}
type AnonymousParams = {
	is_anonymous : boolean,
}
type TwitchEmote = {
	begin : number,
	["end"] : number,
	id : ParsableNumber,
}
type ChannelMessage = {
	text : string,
	emotes : { TwitchEmote },
}
type Contributor = UserParams & {
	["type"] : string,
	total : number,
}
type HypeTrain = UserParams & {
	id : GUID,
	total : number,
	level : number,
	top_contributors : { Contributor },
	last_contribution : Contributor,
	started_at : ISO8601DateTime,
}
type HypeTrainWithProgress = HypeTrain & {
	progress : number,
	goal : number,
	expires_at : ISO8601DateTime,
}
type ChannelPointReward = {
	id : GUID,
	title : string,
	cost : number,
	prompt : string,
}

export type ChannelFollowDetails = UserParams & BroadcasterParams & {
	followed_at : ISO8601DateTime,
}
export type ChannelSubscribeDetails = UserParams & BroadcasterParams & TierParams & {
	is_gift : boolean,
}
export type ChannelSubscriptionGiftDetails = UserParams & BroadcasterParams & TierParams & {
	total : number,
	cumulative_total : number?, -- nil if anonymous or not shared by the user
	is_anonymous : boolean,
}
export type ChannelSubscriptionMessageDetails = UserParams & BroadcasterParams & TierParams & {
	message : ChannelMessage,
	cumulative_months : number,
	streak_months : number?, -- nil if not shared
	duration_months : number,
}
export type ChannelCheerDetails = UserParams & BroadcasterParams & TierParams & AnonymousParams & {
	message : ChannelMessage,
	bits : number,
}
export type ChannelRaidDetails = FromBroadcasterParams & ToBroadcasterParams & {
	viewers : number,
}
export type ChannelHypeTrainBeginDetails = HypeTrainWithProgress
export type ChannelHypeTrainProgressDetails = HypeTrainWithProgress
export type ChannelHypeTrainEndedDetails = HypeTrain & {
	ended_at : ISO8601DateTime,
	cooldown_ends_at : ISO8601DateTime,
}
export type ChannelChannelPointsCustomRewardRedeptionAddDetails = BroadcasterParams & UserParams & {
	id : GUID,
	user_input : string,
	status : string,
	reward : ChannelPointReward,
	redeemed_at : ISO8601DateTime,
}

export type AllTwitchEvents = {
	["channel.follow"] : TwitchEvent.TwitchEvent<ChannelFollowDetails>,
	["channel.subscribe"] : TwitchEvent.TwitchEvent<ChannelSubscribeDetails>,
	["channel.subscription.gift"] : TwitchEvent.TwitchEvent<ChannelSubscriptionGiftDetails>,
	["channel.subscription.message"] : TwitchEvent.TwitchEvent<ChannelSubscriptionMessageDetails>,
	["channel.cheer"] = TwitchEvent.TwitchEvent<ChannelCheerDetails>,
	["channel.raid"] = TwitchEvent.TwitchEvent<ChannelRaidDetails>,
	["channel.hype_train.begin"] = TwitchEvent.TwitchEvent<ChannelHypeTrainBeginDetails>,
	["channel.hype_train.progress"] = TwitchEvent.TwitchEvent<ChannelHypeTrainProgressDetails>,
	["channel.hype_train.end"] = TwitchEvent.TwitchEvent<ChannelHypeTrainEndedDetails>,
	["channel.channel_points_custom_reward_redemption.add"] = TwitchEvent.TwitchEvent<ChannelChannelPointsCustomRewardRedeptionAddDetails>,
}

local events : { TwitchEvent.InitializationDetails } = {
	{
		name = "channel.follow",
		description = "",
		version = 1,
		scope = "",
		condition = { "broadcaster_user_id", },
	},
	{
		name = "channel.subscribe",
		description = "",
		version = 1,
		scope = "channel:read:subscriptions",
		condition = { "broadcaster_user_id", },
	},
	{
		name = "channel.subscription.gift",
		description = "",
		version = 1,
		scope = "channel:read:subscriptions",
		condition = { "broadcaster_user_id", },
	},
	{
		name = "channel.subscription.message",
		description = "",
		version = 1,
		scope = "channel:read:subscriptions",
		condition = { "broadcaster_user_id", },
	},
	{
		name = "channel.cheer",
		description = "",
		version = 1,
		scope = "bits:read",
		condition = { "broadcaster_user_id", },
	},
	{
		name = "channel.raid",
		description = "",
		version = 1,
		scope = "",
		condition = { "to_broadcaster_user_id", },
	},
	{
		name = "channel.hype_train.begin",
		description = "",
		version = 1,
		scope = "channel:read:hype_train",
		condition = { "broadcaster_user_id", },
	},
	{
		name = "channel.hype_train.progress",
		description = "",
		version = 1,
		scope = "channel:read:hype_train",
		condition = { "broadcaster_user_id", },
	},
	{
		name = "channel.hype_train.end",
		description = "",
		version = 1,
		scope = "channel:read:hype_train",
		condition = { "broadcaster_user_id", },
	},
	{
		name = "channel.channel_points_custom_reward_redemption.add",
		description = "",
		version = 1,
		scope = "channel:read:redemptions",
		condition = { "broadcaster_user_id", },
	},
}

function(managers) : AllTwitchEvents
	local allEvents : AllTwitchEvents = {}
	for _, details : TwitchEvent.InitializationDetails in ipairs(events) do
		allEvents[details.name] = TwitchEvent.new(details, managers)
	end

	return allEvents
end