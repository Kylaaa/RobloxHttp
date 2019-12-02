--[[
	This library provides a Promise based implementation
	for executing HTTP requests.

	Usage :
	local packages = script.Parent.Parent.Parent.packages
	local Http = require(packages.Http)
	local Networking = Http.Networking.new()

	local request = Networking.GET("https://www.someDomain.com/json")
	request:andThen(function(response)
		-- handle the successful request's response
		print(tostring(response))
		
	end, function(err)
		-- handle the failed reuest's error

	end)
]]

-- check dependencies
local Packages = script.Parent
assert(require(Packages.Promise) ~= nil, "This Http library requires a Promise library as a sibling.")
assert(require(Packages.Util)) ~= nil, "This Http library requires a Util library as a sibling")

return {
	-- constants and configuration
	Config = {
		DEBUG_HTTP = false
	},

	-- fields
	Error = require(script.HttpError),
	Response = require(script.HttpResponse),
	Networking = require(script.Networking),
}