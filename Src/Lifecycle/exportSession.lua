-- Exports the existing state of the plugin to allow for quick re-initialization the next time
return function(managers)
	return function()
		return managers:get("PersistenceManager"):getCurrentState()
	end
end