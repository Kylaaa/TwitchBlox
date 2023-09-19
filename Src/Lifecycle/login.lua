return function(managers) : ()->()
	local nm = managers:get("NetworkingManager")
	local sm = managers:get("StateManager")
	local lm = managers:get("LogManager")

	return function()
		-- check that we have connected to any events
		local currentState = sm.storeRef:getState()
		local subscriptions = currentState.TwitchUser.subscriptions
		local hasAtLeastOneSubscription = next(subscriptions)
		if hasAtLeastOneSubscription then
			nm:authenticateWithTwitch()
		else
			lm:error("Cannot login without subscribing to at least one event.")
		end
	end
end