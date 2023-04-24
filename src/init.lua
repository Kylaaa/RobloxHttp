--[[
	This library provides a Promise based implementation
	for executing HTTP requests.

	Usage :
	local Packages = game.ReplicatedStorage.Packages
	local Http = require(Packages.Http).new()

	local request = Http.GET("https://www.someDomain.com/json")
	request:andThen(function(response)
		-- handle the successful request's response
		print(tostring(response))
		
	end, function(err)
		-- handle the failed reuest's error

	end)
]]

return require(script.Networking)