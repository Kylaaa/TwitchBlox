return function(nm)
	--[[
		Returns : nothing, opens a webview to log the user in
	]]
	local targetUrl = nm:constructLocalhostUrl("app/connect")
	return nm:request("GET", targetUrl)
end