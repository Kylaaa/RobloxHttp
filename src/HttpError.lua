local HttpService = game:GetService("HttpService")

local HttpError = {}
HttpError.__index = HttpError
HttpError.__tostring = function(he)
	local success, result = pcall(HttpService.JSONEncode, HttpService, he)
	return success and result or he.Message
end
HttpError.ErrorCodes = {
	BadRequest = 400,
	Unauthorized = 401,
	Forbidden = 403,
	NotFound = 404,
	ServerError = 500,
}

-- targetUrl : (string) the url that failed to resolve
-- errMsg : (string) the message from the error, could be from lua
-- resBody : (string) the response body from the server
-- resCode : (number) the response code from the server. ex) 200
-- resTime : (number) the number of milliseconds to complete the request
-- options : (table) all of the options from the original request
function HttpError.new(targetUrl, errMsg, resBody, errCode, resTime, options)
	local h = {
		Target = targetUrl,
		Message = errMsg,
		Body = resBody,
		Code = errCode,
		Time = resTime,
		RequestOptions = options,
	}
	setmetatable(h, HttpError)

	return h
end

function HttpError.isSuccessfulError(errorCode)
	-- any 2XX response is technically a success, but requests
	return errorCode > 200 and errorCode < 300
end

function HttpError.isRequestError(errorCode)
	return errorCode >= 400 and errorCode < 500
end

function HttpError.isServerError(errorCode)
	return errorCode >= 500 and errorCode < 600
end

return HttpError
