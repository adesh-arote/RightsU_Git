HTTP = {};

HTTP.status = function(_status)
{
	var s = _status.toString().split("");
	switch(s[0])
	{
		case "1":
			return HTTP.getInformationalStatus(_status);
			break;
		case "2":
			return HTTP.getSuccessfulStatus(_status);
			break;
		case "3":
			return HTTP.getRedirectionStatus(_status);
			break;
		case "4":
			return HTTP.getClientErrorStatus(_status);
			break;
		case "5":
			return HTTP.getServerErrorStatus(_status);
			break;
		default:
			return "An unexpected error has occured.";
	}
}

HTTP.getInformationalStatus = function(_status)
{
	// Informational 1xx
	// http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.1
	switch(_status)
	{
		case 100:
			return "Continue";
			break;
		case 101:
			return "Switching Protocols";
			break;
		default:
			return "An unexpected error has occured.";
	}
}

HTTP.getSuccessfulStatus = function(_status)
{
	// Successful 2xx
	// http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.2
	switch(_status)
	{
		case 200:
			return "OK";
			break;
		case 201:
			return "Created";
			break;
		case 202:
			return "Accepted";
			break;
		case 203:
			return "Non-Authoritative Information";
			break;
		case 204:
			return "No Content";
			break;
		case 205:
			return "Reset Content";
			break;
		case 206:
			return "Partial Content";
			break;
		default:
			return "An unexpected error has occured.";
	}
}

HTTP.getRedirectionStatus = function(_status)
{
	// Redirection 3xx
	// http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.3
	switch(_status)
	{
		case 300:
			return "Multiple Choices";
			break;
		case 301:
			return "Moved Permanently";
			break;
		case 302:
			return "Found";
			break;
		case 303:
			return "See Other";
			break;
		case 304:
			return "Not Modified";
			break;
		case 305:
			return "Use Proxy";
			break;
		case 307:
			return "Temporary Redirect";
			break;
		default:
			return "An unexpected error has occured.";
	}
}

HTTP.getClientErrorStatus = function(_status)
{
	// Client Error 4xx
	// http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4
	switch(_status)
	{
		case 400:
			return "Bad Request";
			break;
		case 401:
			return "Unauthorized";
			break;
		case 402:
			return "Payment Required";
			break;
		case 403:
			return "Forbidden";
			break;
		case 404:
			return "File not found";
			break;
		case 405:
			return "Method Not Allowed";
			break;
		case 406:
			return "Not Acceptable";
			break;
		case 407:
			return "Proxy Authentication Required";
			break;
		case 408:
			return "Request Timeout";
			break;
		case 409:
			return "Conflict";
			break;
		case 410:
			return "Gone";
			break;
		case 411:
			return "Length Required";
			break;
		case 412:
			return "Precondition Failed";
			break;
		case 413:
			return "Request Entity Too Large";
			break;
		case 414:
			return "Request-URI Too Long";
			break;
		case 415:
			return "Unsupported Media Type";
			break;
		case 416:
			return "Requested Range Not Satisfiable";
			break;
		case 417:
			return "Expectation Failed";
			break;
		default:
			return "An unexpected error has occured.";
	}
}

HTTP.getServerErrorStatus = function(_status)
{
	// Server Error 5xx
	// http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.5
	switch(_status)
	{
		case 500:
			return "Internal Server Error";
			break;
		case 501:
			return "Not Implemented";
			break;
		case 502:
			return "Bad Gateway";
			break;
		case 503:
			return "Service Unavailable";
			break;
		case 504:
			return "Gateway Timeout";
			break;
		case 505:
			return "HTTP Version Not Supported";
			break;
		default:
			return "An unexpected error has occured.";
	}
}