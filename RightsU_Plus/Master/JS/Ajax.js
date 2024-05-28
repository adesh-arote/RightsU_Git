Ajax = {};

Ajax.makeRequest = function(method, url, callbackMethod, params)
{

	this.request =  Ajax.getXmlHTTP();
	//alert('inside makeRequest---'+method)
	this.request.onreadystatechange=callbackMethod;
	if (method == 'POST'){
	alert(url);
		this.request.open(method,url,'false');
		this.request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		this.request.setRequestHeader("Content-length",params.length);
		this.request.setRequestHeader("Connection","close");
		this.request.send(params);		
		 //alert('after send');
	}
	else{
	
        var currentTime = new Date();
        var strDate = currentTime.getDate() + currentTime.getTime(); 
       	url=url+'?'+params +"&rTime="+strDate;	
		this.request.open("GET",url,'false');
		this.request.send(null);
	}
}

Ajax.checkReadyState = function(_id)
{
    //alert('inside checkReadyState --' +this.request.readyState)
	switch(this.request.readyState)
	{
		case 1:
			document.getElementById(_id).innerHTML = '<img src="../images/waiting.gif" alt="Loading..." /> Loading ...';
			break;
		case 2:
			document.getElementById(_id).innerHTML = '<img src="../images/waiting.gif" alt="Loading..." /> Loading ...';
			break;
		case 3:
			document.getElementById(_id).innerHTML = '<img src="../images/waiting.gif" alt="Loading..." /> Loading ...';
			break;
		case 4:
			AjaxUpdater.isUpdating = false;
			document.getElementById(_id).innerHTML = '';
			return HTTP.status(this.request.status);
		default:
			document.getElementById(_id).innerHTML = "An unexpected error has occurred.";
	}
}


	Ajax.getXmlHTTP =function()
	{
		var objXmlHttpRequest;
		try
		{		
			if (window.XMLHttpRequest)
			{
				objXmlHttpRequest=new XMLHttpRequest();				
				return objXmlHttpRequest;
			}
			else if (typeof ActiveXObject != "undefined")
			{
				var a = ['MSXML2.XMLHTTP.5.0', 'MSXML2.XMLHTTP.4.0','MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'MICROSOFT.XMLHTTP.1.0','MICROSOFT.XMLHTTP.1', 'MICROSOFT.XMLHTTP'];
				for (var i = 0; i < a.length ; i++) 
				{
					try 
					{
						objXmlHttpRequest = new ActiveXObject(a[i]);						
						return objXmlHttpRequest;
						break;
					} 
					catch (e) 
					{						
					}
				}
			}			
		}catch(e)
		{
			alert("Exception in Creating XMLHTTPReq Object \n Description: "+e.toString());
		}	
	}
