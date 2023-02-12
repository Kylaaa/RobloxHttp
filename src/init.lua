--[[
	This library provides a Promise based implementation
	for executing HTTP requests.

	Usage :
	local packages = script.Parent.Parent.Parent.packages
	local Http = require(packages.Http).new()

	local request = HttpGET("https://www.someDomain.com/json")
	request:andThen(function(response)
		-- handle the successful request's response
		print(tostring(response))
		
	end, function(err)
		-- handle the failed reuest's error

	end)
]]

return require(script.Networking)