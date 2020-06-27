AjaxUpdater = {};

AjaxUpdater.initialize = function()
{
	AjaxUpdater.isUpdating = false;
}

AjaxUpdater.initialize();

AjaxUpdater.Update = function(method , service, callback, params)
{ 
	//alert('inside update123--'+params+'---callback--'+callback);
	if(callback == undefined || callback == "")
	{
		callback = AjaxUpdater.onResponse;
	}
	
	Ajax.makeRequest(method, service, callback, params);
	AjaxUpdater.isUpdating = true;
}

AjaxUpdater.onResponse = function()
{
	if(Ajax.checkReadyState('loading') == "OK")
	{
		AjaxUpdater.isUpdating = false;
	}
}