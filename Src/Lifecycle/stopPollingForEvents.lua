return function(managers : {})
	local sm = managers:get("SessionManager")
	if sm.pollingToken then
		sm.pollingToken:Disconnect()
	end
end