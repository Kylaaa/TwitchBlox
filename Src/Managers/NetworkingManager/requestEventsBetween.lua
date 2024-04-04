return function(nm, startTime, endTime)
	local targetUrl = nm:constructLocalhostUrl("events/between", {
		["start"] = startTime,
		["end"] = endTime,
	})
	return nm:request("GET", targetUrl)
end