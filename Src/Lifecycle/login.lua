return function(managers) : ()->()
	local nm = managers:get("NetworkingManager")

	return function()
		nm:requestAppConnect()
	end
end