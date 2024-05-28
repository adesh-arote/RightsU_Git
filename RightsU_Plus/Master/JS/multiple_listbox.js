function move(from, to) {

    debugger;
    // Move them over
    //comment by sachin by :sachin
    //new function written for move item in two list box 
    if (!hasOptions(from)) { return; }
    for (var i = 0; i < from.options.length; i++) {
        var o = from.options[i];
        if (o.selected) {
            if (!hasOptions(to)) { var index = 0; } else { var index = to.options.length; }
            to.options[index] = new Option(o.text, o.value, false, false);
        }
    }
    // Delete them from original
    for (var i = (from.options.length - 1); i >= 0; i--) {
        var o = from.options[i];
        if (o.selected) {
            from.options[i] = null;
        }
    }
    //	if ((arguments.length<3) || (arguments[2]==true)) {
    //		sortSelect(from);
    //	sortSelect(to);
    //		}
    from.selectedIndex = -1;
    to.selectedIndex = -1;
    if (from.options.length > 0) {
        from.options[0].focus();
        from.options[0].selected = true;

    }

}

function fill_up(s_interest_code, a_sub_interest_code, s_sub_interest_code) {
    for (i = 1; i < s_interest_code.options.length; i++) {
        //alert ( a_sub_interest_code );

        a_sub_interest_code = s_interest_code.form.available_sub_interest_code;
        for (j = 0; j < a_sub_interest_code.options.length; j++) {
            var a_found = false;

            av_interest_code_array = a_sub_interest_code.options[j].value.split("~");
            av_interest_code = av_interest_code_array[0];

            //alert ( s_interest_code.options[i].value +'== av '+av_interest_code );

            if (s_interest_code.options[i].value == av_interest_code) {
                a_found = true;
                break;
            }
        }

        for (j = 0; j < s_sub_interest_code.options.length; j++) {
            var s_found = false;

            se_interest_code_array = s_sub_interest_code.options[j].value.split("~");
            se_interest_code = se_interest_code_array[0];

            if (s_interest_code.options[i].value == se_interest_code) {
                s_found = true;
                break;
            }
        }

        if (a_found == false && s_found == false) {
            for (var ii in interest_array) {
                interest_code_array = ii.split("~");
                interest_code = interest_code_array[0];

                if (interest_code == s_interest_code.options[i].value && interest_code_array.length > 1) {
                    var no = new Option();
                    no.value = ii;
                    no.text = interest_array[ii];
                    a_sub_interest_code[a_sub_interest_code.options.length] = no;
                }
            }
        }
    }
    return;
}

function remove_up(s_interest_code, a_sub_interest_code, s_sub_interest_code) {
    for (j = 0; j < a_sub_interest_code.options.length; j++) {
        found = false;
        interest_code_array = a_sub_interest_code.options[j].value.split("~");
        interest_code = interest_code_array[0];

        for (i = 0; i < s_interest_code.options.length; i++) {
            if (s_interest_code.options[i].value == interest_code) {
                found = true;
                break;
            }
        }

        if (found == false)
            a_sub_interest_code.options[j--] = null;
    }

    for (j = 0; j < s_sub_interest_code.options.length; j++) {
        found = false;
        interest_code_array = s_sub_interest_code.options[j].value.split("~");
        interest_code = interest_code_array[0];

        for (i = 0; i < s_interest_code.options.length; i++) {
            if (s_interest_code.options[i].value == interest_code) {
                found = true;
                break;
            }
        }

        if (found == false)
            s_sub_interest_code.options[j--] = null;
    }
    return;
}


function showSelectedList(sourceListBox, destinationText, delimiter) {

    var size = sourceListBox.length;
    var str = "";

    var unSortedArray = new Array();
    var sortedArray = new Array();
    var arrayCounter = 0;

    for (i = 0; i < size; i++)
        if (sourceListBox[i].value != '')
        unSortedArray[arrayCounter++] = sourceListBox[i].value;

    sortedArray = unSortedArray.sort();
    unSortedArray.sort();

    if (delimiter == null) delimiter = "#";


    for (i = 0; i < sortedArray.length; i++)
        str += sortedArray[i] + delimiter;

    str = str.substring(0, (str.length - 1))
    destinationText.value = str;
    return str;
}


function showSelectedListWithOutSort(sourceListBox, destinationText, delimiter, output_string) {

    var size = sourceListBox.length;
    var str = "";

    var unSortedArray = new Array();
    var sortedArray = new Array();
    var arrayCounter = 0;

    for (i = 0; i < size; i++)
        if (sourceListBox[i].value != '') {
        unSortedArray[arrayCounter++] = sourceListBox[i].value;
        if (output_string != null) {
            output_string.value += sourceListBox[i].text + ", ";
        }
    }

    sortedArray = unSortedArray;

    if (delimiter == null) delimiter = "#";


    for (i = 0; i < sortedArray.length; i++)
        str += sortedArray[i] + delimiter;


    if (output_string != null)
        output_string.value = output_string.value.substring(0, (output_string.value.length - 2))

    str = str.substring(0, (str.length - 1))
    destinationText.value = str;
    return str;
}

function shuffle(search_field_assigned, to) {
    if (search_field_assigned.selectedIndex < 0) {
        alert("Please select an item");
        search_field_assigned.focus();
        return;
    }

    var index = search_field_assigned.selectedIndex;
    var total = search_field_assigned.length - 1;
    var _index = '';
    var _text1 = '';
    var _value1 = '';
    var _text2 = '';
    var _value2 = '';
    _index = index + to;
    if (to == +1 && index == total) return false;
    if (to == -1 && index == 0) return false;
    if (total < 0) return false;
    //if(index==0) return false;
    //if(index==1 && to==-1) return false;

    //this is for where to swap the item
    _text1 = search_field_assigned.options[_index].text;
    _value1 = search_field_assigned.options[_index].value;

    //this is for selected item
    _text2 = search_field_assigned.options[index].text;
    _value2 = search_field_assigned.options[index].value;

    //swapping the selected item to up/down side,depends upon the click
    search_field_assigned.options[_index].text = _text2;
    search_field_assigned.options[_index].value = _value2;

    //re-swapping the old item to earlier selected place of item
    search_field_assigned.options[index].text = _text1;
    search_field_assigned.options[index].value = _value1;

    //this is to show selected the item
    search_field_assigned.selectedIndex = _index;
}
function hasOptions(obj) {
    if (obj != null && obj.options != null) { return true; }
    return false;
}
function sortSelect(obj) {
    var o = new Array();
    if (!hasOptions(obj)) { return; }
    for (var i = 0; i < obj.options.length; i++) {
        o[o.length] = new Option(obj.options[i].text, obj.options[i].value, obj.options[i].defaultSelected, obj.options[i].selected);
    }
    if (o.length == 0) { return; }
    o = o.sort(
		function(a, b) {
		    if ((a.text + "") < (b.text + "")) { return -1; }
		    if ((a.text + "") > (b.text + "")) { return 1; }
		    return 0;
		}
		);

    for (var i = 0; i < o.length; i++) {
        obj.options[i] = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
    }
}
