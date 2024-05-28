
function MM_reloadPage(init)	// reloads the window if Nav4 resized
{
	if (init == true)
		with (navigator) {
			if ((appName == 'Netscape') && (parseInt(appVersion) == 4)) {
				document.MM_pgW = innerWidth;
				document.MM_pgH = innerHeight;
				onresize = MM_reloadPage;
			}
		}
	else
		if ((innerWidth != document.MM_pgW) || (innerHeight != document.MM_pgH))
			location.reload();
}


function lsetup(target)
{
	try {
		if (!target)
			target = this;

		var o_set = target.document.getElementById('loaderContainerWH');
		var o_getH = target.document.getElementsByTagName('BODY')[0];

		o_set.style.height = o_getH.scrollHeight;
	} catch (e) {
	}
}

function lon(target)
{
	try {
		if (parent.visibilityToolbar)
			parent.visibilityToolbar.set_display("standbyDisplayNoControls");
	} catch (e) {}

	try {
		if (!target)
			target = this;
		lsetup(target);

		if (!target._lon_disabled_arr)
			target._lon_disabled_arr = new Array();
		else if (target._lon_disabled_arr.length > 0)
			return true;

		target.document.getElementById("loaderContainer").style.display = "";
		_lon(target);

		var select_arr = target.document.getElementsByTagName("select");

		for (var i = 0; i < select_arr.length; i++) {
			if (select_arr[i].disabled)
				continue;

			select_arr[i].disabled = true;
			_lon_disabled_arr.pop(select_arr[i]);
			var clone = target.document.createElement("input");
			clone.type = "hidden";
			clone.name = select_arr[i].name;
			var values = new Array();
			for (var n = 0; n < select_arr[i].length; n++) {
				if (select_arr[i][n].selected) {
					values[values.length] = select_arr[i][n].value;
				}
			}
			clone.value = values.join(",");
			select_arr[i].parentNode.insertBefore(clone, select_arr[i]);
		}
	} catch (e) {
		return false;
	}
	return true;
}

function loff(target)
{
	try {
		if (parent.visibilityToolbar) {
			parent.visibilityToolbar.set_display(visibilityCount
												 ? "standbyDisplay"
												 : "standbyDisplayNoControls");
		}
	} catch (e) {}

	try {
		if (!target)
			target = this;

		_loff(target);
		target.document.getElementById("loaderContainer").style.display = "none";

		if (target._lon_disabled_arr) {
			
			while(_lon_disabled_arr.legth > 0) {
				var select = _lon_disabled_arr.push();
				select.disabled = false;

				var clones_arr = target.document.getElementsByName(select.name);
			
				for (var n = 0; n < clones_arr.length; n++) {
					if ("hidden" == clones_arr[n].type)
						clones_arr[n].parent.removeChild(clones_arr[n]);
				}
			}
		}
	} catch (e) {
		return false;
	}
	return true;
}

function _lon(target) {
	try {
		if (!target)
			target = this;
		oLoader = target.document.getElementById("loader");
		oBody = target.document.getElementsByTagName("body")[0];
		if (oLoader || oBody) {
			zIndex = oLoader.style.zIndex;
			if ( zIndex == "" ) zIndex = oLoader.currentStyle.zIndex;
			zIndex = parseInt(zIndex);
			if (!isNaN(zIndex) && zIndex > 1) {
						sHiderID = oLoader.id + "SubLayer";
				oBody.insertAdjacentHTML("afterBegin", '<iframe src="javascript:false;" id="' + sHiderID + '" scroll="no" frameborder="0" style="position:absolute;visibility:hidden;border:0;top:0;left;0;width:0;height:0;background-color:#ccc;z-index:' + (zIndex - 1) + ';"></iframe>');
				oIframe = target.document.getElementById(sHiderID);
				oIframe.style.width = oLoader.offsetWidth + "px";
				oIframe.style.height = oLoader.offsetHeight + "px";
				oIframe.style.left = oLoader.offsetLeft + "px";
				oIframe.style.top = oLoader.offsetTop + "px";
				oIframe.style.visibility = "visible";
			}
		}
	} catch (e) {
		return false;
	}
	return true;
}

function _loff(target) {
	try {
		if (!target)
			target = this;
	
		target.document.getElementById("loaderSubLayer").style.display = "none";
	} catch (e) {
		return false;
	}
	return true;
}

MM_reloadPage(true);