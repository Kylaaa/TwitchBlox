return function(managers)
	return {
		--1) Check for an existing connection
			--a) Check for the localhost, fails if the local server isn't running
			--b) Check for authentication, fails if the user isn't logged into Twitch
			--c) Check that auth token scope matches the list of scopes for the connected events
		getStatusAsync = require(script.getStatusAsync)(managers),

		--3) Login to Twitch
		login = require(script.login)(managers),

		--4) Start listening for events
		startPollingForEvents = require(script.startPollingForEvents)(managers),
		stopPollingForEvents = require(script.stopPollingForEvents)(managers),
	}
end