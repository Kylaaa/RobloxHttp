--[[
	A promise based Http library
]]

-- services
local HttpService = game:GetService("HttpService")

-- helpers
local Http = script.Parent
local HttpResponse = require(Http.HttpResponse)
local HttpError = require(Http.HttpError)
local Promise = require(Http.Parent.Packages.Promise)


local Networking = {}
Networking.__index = Networking

-- args : (table, optional)
-- args.httpImpl : (table, optional) a service that implements RequestAsync
-- args.ALLOW_YIELDING : (boolean, optional) when false, resolves all requests syncronously, good for tests
-- args.DEBUG : (boolean, optional) logs messages when 
-- returns : (Promise<HttpResponse/HttpError>)
function Networking.new(args)
	local httpImpl = HttpService
	local DEBUG = false
	local ALLOW_YIELDING = true

	if args then
		if args.httpImpl then
			assert(args.httpImpl.RequestAsync ~= nil, "the Http implementation must define 'RequestAsync'")
			httpImpl = args.httpImpl
		end

		if args.ALLOW_YIELDING then
			assert(type(args.ALLOW_YIELDING) == "boolean", "expected 'ALLOW_YIELDING' to be a boolean")
			ALLOW_YIELDING = args.ALLOW_YIELDING
		end

		if args.DEBUG then
			assert(type(args.DEBUG) == "boolean", "expected 'DEBUG' to be a boolean")
			DEBUG = args.DEBUG
		end
	end

	local n = {
		-- some default headers
		_headers = {
			["Content-Type"] = "application/json",
		},

		-- the object that will fire the http requests
		_httpImpl = httpImpl,

		-- configuration variables
		_DEBUG = DEBUG,
		_ALLOW_YIELDING = ALLOW_YIELDING,
	}
	setmetatable(n, Networking)

	return n
end

-- urlResponseMap : (dictionary<string, jsonString>, optional)
function Networking.mock(urlResponseMap)
	if not urlResponseMap then
		urlResponseMap = {
			default = HttpService.JsonEncode({
				Body = "{}",
				Success = true,
				StatusCode = 200,
				StatusMessage = "OK",
			}),
		}
	end

	local mockHttpService = {}
	function mockHttpService:RequestAsync(requestOptions)
		local Url = requestOptions["Url"]
		--local Method = requestOptions["Method"]
		--local Headers = requestOptions["Headers"]
		--local Body = requestOptions["Body"]

		local responseString = urlResponseMap["default"]
		if urlResponseMap[Url] then
			responseString = urlResponseMap[Url]
		end

		return responseString
	end

	return Networking.new(mockHttpService)
end


-- options : (table) a map of arguments to pass to HttpService.RequestAsync
-- options.Url : (string)
-- options.Method : (string)
-- options.Headers : (table, optional)
-- options.Body : (string, optional, required when Method == "POST")
-- returns : (Promise<HttpResponse/HttpError>)
function Networking:request(options)
	assert(type(options) == "table", "expecte 'options' to be a table")
	assert(type(options["Url"]) == "string", "expected 'options.Url' to be a string")
	assert(type(options["Method"]) == "string", "expected 'options.Method' to be a string")

	local p = Promise.new(function(resolve, reject)
		local function createHttpPromise()
			local startTime = tick()
			local success, resultDict = pcall(self._httpImpl.RequestAsync, self._httpImpl, options)
			local endTime = tick()
			local deltaMs = (endTime - startTime) * 1000

			if self._DEBUG then
				local msg = table.concat(
				{
					"--------------------------",
					"Fetching Url :" .. url, "",
					"Success :" .. tostring(success), "",
					"Result :", tostring(resultDict),
					"--------------------------"
				}, "\n")
				print(msg)
			end

			if success then
				local body = resultDict["Body"]
				local requestSuccess = resultDict["Success"]
				local statusMsg = resultDict["StatusMessage"]
				local statusCode = resultDict["StatusCode"]

				if requestSuccess == true then
					resolve(HttpResponse.new(body, statusCode, deltaMs))
				else
					reject(HttpError.new(url, statusMsg, body, statusCode, deltaMs))
				end
			else
				-- the request timed out, or something went wrong
				reject(HttpError.new(url, "Unknown Error", resultDict, 500, deltaMs))
			end
		end

		-- tests don't allow yielding, so 
		if self._ALLOW_YIELDING then
			spawn(createHttpPromise)
		else
			createHttpPromise()
		end
	end)

	return p
end


-- requestPromise : (Promise<HttpResponse/HttpError>) a promise from self:request
-- numRequests : (int) the number of times the request should be sent before failing
-- returns : (Promise<HttpResponse/HttpError>)
function Networking:retry(requestPromise, numRequests)

end


-- requestPromise : (Promise<HttpResponse/HttpError>) a promise from self:request
-- returns : (Promise<HttpResponse/HttpError>)
function Networking:parseJSON(requestPromise)
	assert(requestPromise.andThen ~= nil, "'requestPromise' must be a Promise")

	-- attempt to convert the body from a string to a table
	return requestPromise:andThen(function(httpResponse)
		if self._DEBUG then
			print("Attempting to parse the response...")
		end
		local success, jsonBody = pcall(HttpService.JSONDecode, HttpService, httpResponse.Body)
		if not success then
			if self._DEBUG then
				print("Attempting to parse the response...")
			end
			return Promise.reject()
		end

		httpResponse.Body = jsonBody
		return httpResponse

	end, function(httpError)
		return httpError
	end)
end

-- url : (string)
-- customHeaders : (dictionary<string, string>, optional)
-- returns : (Promise<HttpResponse/HttpError>)
function Networking:GET(url, customHeaders)
	if not customHeaders then
		customHeaders = self._headers
	end

	assert(type(url) == "string", "expected 'url' to be a string")
	assert(type(customHeaders) == "table", "expected 'customHeaders' to be a dictionary")

	return self:request({
		Url = url,
		Method = "GET",
		Headers = customHeaders,
	})
end


-- url : (string)
-- body : (string)
-- customHeaders : (dictionary<string, string>, optional)
-- returns : (Promise<HttpResponse/HttpError>)
function Networking:POST(url, body, customHeaders)
	if not customHeaders then
		customHeaders = self._headers
	end

	assert(type(url) == "string", "expected 'url' to be a string")
	assert(type(body) == "string", "expected 'body' to be a string")
	assert(type(customHeaders) == "table", "expected 'customHeaders' to be a dictionary")

	return self:request({
		Url = url,
		Method = "POST",
		Headers = customHeaders,
		Body = body,
	})
end

return Networking

