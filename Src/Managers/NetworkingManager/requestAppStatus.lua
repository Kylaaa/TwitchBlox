return function(nm)
	--[[
		Returns :
		{
			authenticated : true/false,
			connected : true/false
		}
	]]
	local targetUrl = nm:constructLocalhostUrl("app/status")
	return nm:request("GET", targetUrl)
end