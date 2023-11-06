return function(managers)
	return function(previousState)
		managers:get("StateManager"):loadFromPreviousState(previousState)
	end
end