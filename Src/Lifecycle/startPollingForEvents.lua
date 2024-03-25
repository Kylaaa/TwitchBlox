return function(managers : {})
	local cm = managers:get("ConfigurationManager")
	local em = managers:get("EventsManager")
	local lm = managers:get("LogManager")
	local nm = managers:get("NetworkingManager")
	local sm = managers:get("SessionManager")

	-- check if already polling for events
	if sm.pollingToken then
		--sm.pollingToken:Disconnect()
		return
	end

	return function()
		local POLLING_INTERVAL = cm:get("HTTP_POLLING_INTERVAL_MS") / 1000.0
		local startWindow = em:getCurrentISOTimestamp()

		local disconnectToken = em:callOnInterval(POLLING_INTERVAL, function()
			local endWindow = em:getCurrentISOTimestamp()
			nm:requestEventsBetween(startWindow, endWindow):andThen(function(response)
				for _, event in ipairs(response.events) do
					em:parseEvent(event)
				end
			end)

			-- shift the window
			startWindow = endWindow
		end)

		sm.pollingToken = disconnectToken
	end
end