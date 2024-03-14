return function(nm)
	--[[
		Returns :
		{
			success: true/false,
			events: [
				{
					"id": "f1c2a387-161a-49f9-a165-0f21d7a4e1c4",
					"name": "channel.update",
					"data": {
						"broadcaster_user_id": "1337",
						"broadcaster_user_login": "cool_user",
						"broadcaster_user_name": "Cool_User",
						"title": "Best Stream Ever",
						"language": "en",
						"category_id": "12453",
						"category_name": "Grand Theft Auto",
						"content_classification_labels": [
							"MatureGame"
						]
					}
					"received_date": "2023-06-29T17:20:33.860897266Z"
				}, {...}, ...
			]
		}
	]]

	-- note, the "data" field of each table is unique for each event
	local targetUrl = nm:constructLocalhostUrl("events/all")
	return nm:request("GET", targetUrl)
end