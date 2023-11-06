local LibraryRoot = script:FindFirstAncestor("TwitchBlox")
local Packages = LibraryRoot.Packages

export type LifecycleEvents = {
	importSession : ({}) -> (),
	checkConnection : () -> number,
}

return function(managers) : LifecycleEvents
	return {
		--0) Reload the previous session
		importSession = require(script.importSession)(managers),

		--1) Connect to all of the events

		--1) Set the Channel Name

		--2) Check for an existing connection
			--2a) Check for the localhost, fails if the local server isn't running
			--2b) Check for authentication, fails if the user isn't logged into Twitch
			--2c) Check that auth token scope matches the list of scopes for the connected events
		checkConnection = require(script.checkConnection)(managers),

		--3) Login to Twitch, -- returns broadcasterId
		login = require(script.login)(managers),


		-- closing) export the session to reload it later
		exportSession = require(script.exportSession),
	}
end