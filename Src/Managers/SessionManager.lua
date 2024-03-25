local SessionManager = {}
SessionManager.__index = SessionManager

function SessionManager.new(dependencies : {})
	local sm = {
		pollingToken = nil,
	}

	return setmetatable(sm, SessionManager)
end

return SessionManager