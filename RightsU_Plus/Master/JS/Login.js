// JScript File

    // Function to check doNotAllowTag, fnEnterKey & removeSpace, all in one to maintain return type
    function checkAllOnKeyPressWithoutSpace(event, buttonToClick, txt){
        if(doNotAllowTag(event) && fnEnterKey(event, buttonToClick) && removeSpace(event, txt)){
            return true;
        }
        return false;
    }
    
    // Function to check doNotAllowTag & fnEnterKey all in one to maintain return type
    function checkAllOnKeyPress(event, buttonToClick, txt){
        if(doNotAllowTag(event) && fnEnterKey(event, buttonToClick)){
            return true;
        }
        return false;
    }

    // Function that does not allow HTML tags('<' & '>')
    /*
    function doNotAllowTag(event){
        if(event == null){
            return false;
        }
        var keyCode = (window.Event) ? event.which : event.keyCode;
        if(keyCode == 60 || keyCode == 62){
            event.cancelBubble = true; 
            event.returnValue = false; 
	        return false;
	    }
	    return true;
    }
    */
    //----- Above method is commented by dada on 03Jan2012 due to not working properly.
    function doNotAllowTag() {
        if (event.keyCode == 60 || event.keyCode == 62) {
            event.returnValue = false;

        }
        return true;
    }

    
    // Function to click button when hit ENTER key
    function fnEnterKey(event, buttonToClick) {
        if(event == null){
            return false;
        }
        var keyCode = (window.Event) ? event.which : event.keyCode;
        if (keyCode == 13) { 
            event.cancelBubble = true; 
            event.returnValue = false; 
            document.getElementById(buttonToClick).click();
            return false;
        }
        return true;
    }
    
    //Function to remove space 
    function removeSpace(event, txt){
        if(event == null){
            return false;
        }
        var keyCode = (window.Event) ? event.which : event.keyCode;
        if(keyCode==32){
            event.cancelBubble = true; 
            event.returnValue = false; 
            document.getElementById(txt).focus();
            return false;
        }
        return true;
    }
    
    //function to check if all the characters are spaces
	function checkBlank(str){
		isblank = new String;
		isblank = "";
		isblank1 = new String;
		isblank1 = "";

		for(j = 0; j < str.length ; j++){
			if(str.substring(j, j+1) == ' '){ 
			    isblank = isblank + '1'; 
			}
			else{ 
			    isblank = isblank + '0'; 
			}
			isblank1 = isblank1 + '1';
		}
		if(isblank == isblank1){
		    return false; 
		}
		return true; 
	}

    //function to check email
	function checkEMail(strEmail){
		var atrate=0;
		
		if (strEmail == ""){
			return false;
		}
		else{
			for (var i = 0; i < strEmail.length; i++){
				var ch = strEmail.substring(i, i + 1);
			    if( 
					((ch < "a" || "z" < ch) && (ch < "A" || "Z" < ch)) && 
					(ch < "0" || "9" < ch) && 
					(ch != '_') && 
					(ch != '-') &&
					(ch != '@') && 
					(ch != '.')){
					return false;
				}
			}

			if ((strEmail.indexOf ('@') == -1) || (strEmail.indexOf ('.') == -1) || (strEmail.indexOf (' ') > 0)){
				return false
			}
			
			for (var i = 0; i < strEmail.length; i++){
				var ch = strEmail.substring(i, i + 1);
				if ( ch=='@')
				    atrate=atrate+1;
			}
			
			if (atrate > 1 ){
				return false
			}
			
			if(strEmail.length < 6){
			    return false;
			}
		}
	    return true
	}
	
	//Function to check hidden field for Add/Edit mode of GrodView
	function canEditRecord(hdn){
	    hdn = document.getElementById(hdn);
	    
	    if(hdn != null && hdn != undefined && hdn.value != ""){
	        var btn = document.getElementById(hdn.value);
	        alert('Please complete Add/Edit operation first');
	        btn.focus();
	        return false;
	    }
	    return true;
	}
	
	function canEditRecordWithConfirm(hdn, msg){
	    if(canEditRecord(hdn)){
	        return confirm(msg);
	    }else{
	        return false;
	    }
	}
	
	