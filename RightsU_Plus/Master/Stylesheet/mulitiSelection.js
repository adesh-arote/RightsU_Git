function move(fbox, tbox) 
	{
		var arrFbox = new Array();
		var arrTbox = new Array();
		var arrLookup = new Array();
		var i;
		for (i = 0; i < tbox.options.length; i++)
		{
			arrLookup[tbox.options[i].text] = tbox.options[i].value;
			arrTbox[i] = tbox.options[i].text;
		}
		var fLength = 0;
		var tLength = arrTbox.length;
		for(i = 0; i < fbox.options.length; i++) 
		{
			arrLookup[fbox.options[i].text] = fbox.options[i].value;
			if (fbox.options[i].selected && fbox.options[i].value != "")
			{
				arrTbox[tLength] = fbox.options[i].text;
				tLength++;
			}
			else 
			{
				arrFbox[fLength] = fbox.options[i].text;
				fLength++;
		   }
		}
	arrFbox.sort();
	arrTbox.sort();
	fbox.length = 0;
	tbox.length = 0;
	var c;
	for(c = 0; c < arrFbox.length; c++)
{
	var no = new Option();
	no.value = arrLookup[arrFbox[c]];
	no.text = arrFbox[c];
	fbox[c] = no;
}
for(c = 0; c < arrTbox.length; c++)
{
var no = new Option();
no.value = arrLookup[arrTbox[c]];
no.text = arrTbox[c];
tbox[c] = no;
   }
}

function showSelectedList( sourceListBox, destinationText, delimiter )
	{

		var size = sourceListBox.length;
		var str="";

		var unSortedArray = new Array();
		var sortedArray = new Array();
		var arrayCounter=0;

		for (i =0; i < size; i++)
			if (sourceListBox[i].value !='' )
				unSortedArray[arrayCounter++]=sourceListBox[i].value;

		sortedArray = unSortedArray.sort();
		unSortedArray.sort();

		if (delimiter == null) delimiter = ",";


		for (i = 0; i < sortedArray.length; i++)
			str += sortedArray[i]+delimiter;

		str=str.substring(0,(str.length-1))
		destinationText.value = str;
		return str;
}

function moveAll(fromObj, toObj) {

    var fromObjLen = fromObj.options.length;
    for (var i = 0; i < fromObjLen; i++) {
        if (fromObj.options[0] != null) {
            fromObj.options[0].selected = true;
        }
        move(fromObj, toObj)
    }
}
