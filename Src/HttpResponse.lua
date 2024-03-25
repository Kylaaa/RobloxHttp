local HttpService = game:GetService("HttpService")

local HttpResponse = {}
HttpResponse.__index = HttpResponse
HttpResponse.__tostring = function(hr)
	local success, result = pcall(HttpService.JSONEncode, HttpService, hr)
	return success and result or hr.Body
end

-- resBody : (string) the response body from the server
-- resCode : (number) the response code from the server. ex) 200
-- resTime : (number) the number of milliseconds to complete the request
-- options : (table) all of the options from the original request
function HttpResponse.new(resBody, resCode, resTime, options)
	local h = {
		Body = resBody,
		Code = resCode,
		Time = resTime,
		RequestOptions = options,
	}
	setmetatable(h, HttpResponse)

	return h
end

return HttpResponse