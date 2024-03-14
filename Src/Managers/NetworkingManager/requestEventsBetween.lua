return function(startTime, endTime)
	local targetUrl = nm:constructLocalhostUrl("app/connect")
	return nm:request("GET", targetUrl)
end