/*!
 * jquery.sumoselect - v3.0.3
 * http://hemantnegi.github.io/jquery.sumoselect
 * 2016-12-12
 *
 * Copyright 2015 Hemant Negi
 * Email : hemant.frnz@gmail.com
 * Compressor http://refresh-sf.com/
 */

(function (factory) {
    'use strict';
    if (typeof define === 'function' && define.amd) {
        define(['jquery'], factory);
    } else if (typeof exports !== 'undefined') {
        module.exports = factory(require('jquery'));
    } else {
        factory(jQuery);
    }

})(function ($) {
    'namespace sumo';
    $.fn.SumoSelect = function (options) {
 
        var selectAll_dummy = false;
        if (this[0] != undefined) {
            var j = 0;
            for (var i = 0; i < this[0].options.length; i++) {
                if (this[0].options[i].selected == true) {
                    var option = document.createElement('option');
                    option.text = this[0].options[i].text;
                    option.value = this[0].options[i].value;
                    option.selected = 'selected';
                    this[0].options.remove(i);
                    this[0].options.add(option, j);
                    j = j + 1;
                }
            }
            if (this[0].children.length > 2 && this[0].children.length < 500) {
                selectAll_dummy = true;
            }
            else {
                selectAll_dummy = false;
            }
        }
        var settings = $.extend({
            placeholder: 'Select Here',   // Dont change it here.
            csvDispCount: 4,              // display no. of items in multiselect. 0 to display all.
            captionFormat: '{0} Selected', // format of caption text. you can set your locale.
            captionFormatAllSelected: '{0} Selected', // format of caption text when all elements are selected. set null to use captionFormat. It will not work if there are disabled elements in select.
            floatWidth: 400,              // Screen width of device at which the list is rendered in floating popup fashion.
            forceCustomRendering: false,  // force the custom modal on all devices below floatWidth resolution.
            nativeOnDevice: ['Android', 'BlackBerry', 'iPhone', 'iPad', 'iPod', 'Opera Mini', 'IEMobile', 'Silk'], //
            outputAsCSV: false,           // true to POST data as csv ( false for Html control array ie. default select )
            csvSepChar: ',',              // separation char in csv mode
            okCancelInMulti: false,       // display ok cancel buttons in desktop mode multiselect also.
            triggerChangeCombined: true,  // im multi select mode wether to trigger change event on individual selection or combined selection.
            selectAll: true,             // to display select all button in multiselect mode.|| also select all will not be available on mobile devices.

            search: true,                // to display input for filtering content. selectAlltext will be input text placeholder
            searchText:'Search...',      // placeholder for search input
            noMatch: 'No matches for "{0}"',
            prefix: '',                   // some prefix usually the field name. eg. '<b>Hello</b>'
            locale: ['OK', 'Cancel', 'Select All'],  // all text that is used. don't change the index.
            up: false,                    // set true to open upside.
            showTitle: false               // set to false to prevent title (tooltip) from appearing
        }, options);


        var ret = this.each(function () {
      
            settings.selectAll = selectAll_dummy;
            var selObj = this; // the original select object.
            if (this.sumo || !$(this).is('select')) return; //already initialized

            this.sumo = {
                E: $(selObj),   //the jquery object of original select element.
                is_multi: $(selObj).attr('multiple'),  //if its a multiple select
                select: '',
                caption: '',
                placeholder: '',
                optDiv: '',
                CaptionCont: '',
                ul: '',
                is_floating: false,
                is_opened: false,
                //backdrop: '',
                mob: false, // if to open device default select
                Pstate: [],

                createElems: function () {
                    var O = this;
                    O.E.wrap('<div class="SumoSelect" tabindex="0" role="button" aria-expanded="false">');
                    O.select = O.E.parent();
                    O.caption = $('<span>');
                    O.CaptionCont = $('<p class="CaptionCont SelectBox" ><label><i></i></label></p>')
                        .attr('style', O.E.attr('style'))
                        .prepend(O.caption);
                    O.select.append(O.CaptionCont);

                    // default turn off if no multiselect
                    if (!O.is_multi) settings.okCancelInMulti = false

                    if (O.E.attr('disabled'))
                        O.select.addClass('disabled').removeAttr('tabindex');

                    //if output as csv and is a multiselect.
                    if (settings.outputAsCSV && O.is_multi && O.E.attr('name')) {
                        //create a hidden field to store csv value.
                        O.select.append($('<input class="HEMANT123" type="hidden" />').attr('name', O.E.attr('name')).val(O.getSelStr()));

                        // so it can not post the original select.
                        O.E.removeAttr('name');
                    }

                    //break for mobile rendring.. if forceCustomRendering is false
                    if (O.isMobile() && !settings.forceCustomRendering) {
                        O.setNativeMobile();
                        return;
                    }

                    // if there is a name attr in select add a class to container div
                    if (O.E.attr('name')) O.select.addClass('sumo_' + O.E.attr('name').replace(/\[\]/, ''))

                    //hide original select
                    O.E.addClass('SumoUnder').attr('tabindex', '-1');

                    //## Creating the list...
                    O.optDiv = $('<div class="optWrapper ' + (settings.up ? 'up' : '') + '">');

                    //branch for floating list in low res devices.
                    O.floatingList();

                    //Creating the markup for the available options
                    O.ul = $('<ul class="options">');
                    O.optDiv.append(O.ul);

                    // Select all functionality
                    if (settings.selectAll && O.is_multi) O.SelAll();

                    // search functionality
                    if (settings.search) O.Search();

                    O.ul.append(O.prepItems(O.E.children()));

                    //if multiple then add the class multiple and add OK / CANCEL button
                    if (O.is_multi) O.multiSelelect();

                    O.select.append(O.optDiv);
                    O.basicEvents();
                    O.selAllState();
                },

                prepItems: function (opts, d) {
                   
                    var lis = [], O = this;
                    $(opts).each(function (i, opt) {       // parsing options to li
                        opt = $(opt);
                        lis.push(opt.is('optgroup') ?
                            $('<li class="group ' + (opt[0].disabled ? 'disabled' : '') + '"><label>' + opt.attr('label') + '</label><ul></ul></li>')
                            .find('ul')
                            .append(O.prepItems(opt.children(), opt[0].disabled))
                            .end()
                            :
                            O.createLi(opt, d)
                        );
                    });
                    return lis;
                },

                //## Creates a LI element from a given option and binds events to it
                //## returns the jquery instance of li (not inserted in dom)
                createLi: function (opt, d) {
              
                    var O = this;

                    if (!opt.attr('value')) opt.attr('value', opt.val());
                    var li = $('<li class="opt"><label>' + opt.text() + '</label></li>');

                    li.data('opt', opt);    // store a direct reference to option.
                    opt.data('li', li);    // store a direct reference to list item.
                    if (O.is_multi) li.prepend('<span><i></i></span>');

                    if (opt[0].disabled || d)
                        li = li.addClass('disabled');

                    O.onOptClick(li);

                    if (opt[0].selected)
                        li.addClass('selected');

                    if (opt.attr('class'))
                        li.addClass(opt.attr('class'));

                    if (opt.attr('title'))
                        li.attr('title', opt.attr('title'));

                    return li;
                },

                //## Returns the selected items as string in a Multiselect.
                getSelStr: function () {
                    
                    // get the pre selected items.
                    sopt = [];
                    this.E.find('option:selected').each(function () { sopt.push($(this).val()); });
                    return sopt.join(settings.csvSepChar);
                },

                //## THOSE OK/CANCEL BUTTONS ON MULTIPLE SELECT.
                multiSelelect: function () {
                   
                    var O = this;
                    O.optDiv.addClass('multiple');
                    O.okbtn = $('<p tabindex="0" class="btnOk">' + settings.locale[0] + '</p>').click(function () {

                        //if combined change event is set.
                        if (settings.triggerChangeCombined) {

                            //check for a change in the selection.
                            changed = false;
                            if (O.E.find('option:selected').length != O.Pstate.length) {
                                changed = true;
                            }
                            else {
                                O.E.find('option').each(function (i, e) {
                                    if (e.selected && O.Pstate.indexOf(i) < 0) changed = true;
                                });
                            }

                            if (changed) {
                                O.callChange();
                                O.setText();
                            }
                        }
                        O.hideOpts();
                    });
                    O.cancelBtn = $('<p tabindex="0" class="btnCancel">' + settings.locale[1] + '</p>').click(function () {
                        O._cnbtn();
                        O.hideOpts();
                    });
                    var btns = O.okbtn.add(O.cancelBtn);
                    O.optDiv.append($('<div class="MultiControls">').append(btns));

                    // handling keyboard navigation on ok cancel buttons.
                    btns.on('keydown.sumo', function (e) {
                        
                        var el = $(this);
                        switch (e.which) {
                            case 32: // space
                            case 13: // enter
                                el.trigger('click');
                                break;

                            case 9:  //tab
                                if (el.hasClass('btnOk')) return;
                            case 27: // esc
                                O._cnbtn();
                                O.hideOpts();
                                return;
                        }
                        e.stopPropagation();
                        e.preventDefault();
                    });
                },

                _cnbtn: function () {
                    
                    var O = this;
                    //remove all selections
                    O.E.find('option:selected').each(function () { this.selected = false; });
                    O.optDiv.find('li.selected').removeClass('selected')

                    //restore selections from saved state.
                    for (var i = 0; i < O.Pstate.length; i++) {
                        O.E.find('option')[O.Pstate[i]].selected = true;
                        O.ul.find('li.opt').eq(O.Pstate[i]).addClass('selected');
                    }
                    O.selAllState();
                },

                SelAll: function () {
                    var O = this;
                    if (!O.is_multi) return;
                    O.selAll = $('<p class="select-all"><span><i></i></span><label>' + settings.locale[2] + '</label></p>');
                    O.optDiv.addClass('selall');
                    O.selAll.on('click', function () {
                        O.selAll.toggleClass('selected');
                        O.toggSelAll(O.selAll.hasClass('selected'), 1);
                        // O.selAllState();
                    });

                    O.optDiv.prepend(O.selAll);
                },

                // search module (can be removed if not required.)
                Search: function () {
               
                    var O = this,
                        cc = O.CaptionCont.addClass('search'),
                        P = $('<p class="no-match">');
                        O.ftxt = $('<input type="text" class="search-txt" value="" placeholder="' + ShowMessage.MsgPlaceSearch + '">')
                        //O.ftxt = $('<input type="text" class="search-txt" value="" placeholder="' + settings.searchText + '">')
                    
                        .on('click', function (e) {
                            e.stopPropagation();
                        });
                    cc.append(O.ftxt);
                    O.optDiv.children('ul').after(P);

                    O.ftxt.on('keyup.sumo', function () {
              
                        var vc = 0, sc = 0;
                        var hid = O.optDiv.find('ul.options li.opt').each(function (ix, e) {
                            e = $(e);
                            if (e.text().toLowerCase().indexOf(O.ftxt.val().toLowerCase()) > -1) 
                                e.removeClass('hidden');
                            else
                                e.addClass('hidden');
                        }).not('.hidden');

                      
                        if (vc == 0) {
                            $('.select-all').css('display', 'none');
                        }
                        else if (vc > 0) {
                            $('.select-all').css('display', 'block');
                        }
                        //alert(O.optDiv.find('li.opt').not('.hidden').length);
                        if (O.optDiv.find('li.opt').not('.hidden').length > 2 && O.optDiv.find('li.opt').not('.hidden').length < 500) {
                            selectAll_dummy = true;
                            //alert(selectAll_dummy);
                            O.SelAll();
                            vc++;
                        }
                  
                        P.html(settings.noMatch.replace(/\{0\}/g, '<em></em>')).toggle(!hid.length);
                        P.find('em').text(O.ftxt.val());
                        O.selAllState();
                    });
                },

                selAllState: function () {
             
                    var O = this;
                    if (settings.selectAll && O.is_multi) {
                        var sc = 0, vc = 0;
                        O.optDiv.find('li.opt').not('.hidden').each(function (ix, e) {
                            if ($(e).hasClass('selected'))
                            { sc++; }
                            if (!$(e).hasClass('disabled')) {
                                vc++;
                                // O.itemClicked($(e), true);
                            }

                            //if ($(e).hasClass('selected')) { O.itemClicked($(e), false); }
                            //else {
                            //    O.itemClicked($(e), true);
                            //}
                        });
                        //select all checkbox state change.
                        if (sc == vc) {
                            O.selAll.removeClass('partial').addClass('selected');
                            //alert('sc==vc');
                            //settings.selectAll = false;
                        }
                        else if (sc == 0) {
                            //  alert('1st tiem');
                            O.selAll.removeClass('selected partial');
                            //settings.selectAll = false;

                        }
                        else {
                            O.selAll.addClass('partial')
                        }//.removeClass('selected');
                        //if (vc == 0) {
                        //    $('.select-all').css('display', 'none');
                        //}
                        //else if (vc > 0) {
                        //    $('.select-all').css('display', 'block');
                        //}
                    }

                },

                showOpts: function () {
                    var O = this;
                    if (O.E.attr('disabled')) return; // if select is disabled then retrun
                    O.E.trigger('sumo:opening', O);
                    O.is_opened = true;
                    O.select.addClass('open').attr('aria-expanded', 'true');
                    O.E.trigger('sumo:opened', O);

                    if (O.ftxt) O.ftxt.focus();
                    else O.select.focus();

                    // hide options on click outside.
                    $(document).on('click.sumo', function (e) {
                        if (!O.select.is(e.target)                  // if the target of the click isn't the container...
                            && O.select.has(e.target).length === 0) { // ... nor a descendant of the container
                            if (!O.is_opened) return;
                            O.hideOpts();
                            if (settings.okCancelInMulti) O._cnbtn();
                        }
                    });

                    if (O.is_floating) {
                        H = O.optDiv.children('ul').outerHeight() + 2;  // +2 is clear fix
                        if (O.is_multi) H = H + parseInt(O.optDiv.css('padding-bottom'));
                        O.optDiv.css('height', H);
                        $('body').addClass('sumoStopScroll');
                    }

                    O.setPstate();
                },

                //maintain state when ok/cancel buttons are available storing the indexes.
                setPstate: function () {
                    var O = this;
                    if (O.is_multi && (O.is_floating || settings.okCancelInMulti)) {
                        O.Pstate = [];
                        // assuming that find returns elements in tree order
                        O.E.find('option').each(function (i, e) { if (e.selected) O.Pstate.push(i); });
                    }
                },

                callChange: function () {
                    this.E.trigger('change').trigger('click');
                },

                hideOpts: function () {
                    
                    var O = this;
                    if (O.is_opened) {
                        O.E.trigger('sumo:closing', O);
                        O.is_opened = false;
                        O.select.removeClass('open').attr('aria-expanded', 'true').find('ul li.sel').removeClass('sel');
                        O.E.trigger('sumo:closed', O);
                        $(document).off('click.sumo');
                        O.select.focus();
                        $('body').removeClass('sumoStopScroll');

                        // clear the search
                        if (settings.search) {
                            O.ftxt.val('');
                            O.optDiv.find('ul.options li').removeClass('hidden');
                            O.optDiv.find('.no-match').toggle(false);
                        }
                    }
                },
                setOnOpen: function () {
            
                    var O = this,
                        li = O.optDiv.find('li.opt:not(.hidden)').eq(settings.search ? 0 : O.E[0].selectedIndex);
                    if (li.hasClass('disabled')) {
                        li = li.next(':not(disabled)')
                        if (!li.length) return;
                    }
                    O.optDiv.find('li.sel').removeClass('sel');
                    li.addClass('sel');
                    O.showOpts();
                },
                nav: function (up) {
                    var O = this, c,
                    s = O.ul.find('li.opt:not(.disabled, .hidden)'),
                    sel = O.ul.find('li.opt.sel:not(.hidden)'),
                    idx = s.index(sel);
                    if (O.is_opened && sel.length) {

                        if (up && idx > 0)
                            c = s.eq(idx - 1);
                        else if (!up && idx < s.length - 1 && idx > -1)
                            c = s.eq(idx + 1);
                        else return; // if no items before or after

                        sel.removeClass('sel');
                        sel = c.addClass('sel');

                        // setting sel item to visible view.
                        var ul = O.ul,
                            st = ul.scrollTop(),
                            t = sel.position().top + st;
                        if (t >= st + ul.height() - sel.outerHeight())
                            ul.scrollTop(t - ul.height() + sel.outerHeight());
                        if (t < st)
                            ul.scrollTop(t);

                    }
                    else
                        O.setOnOpen();
                },

                basicEvents: function () {
                    var O = this;
                    O.CaptionCont.click(function (evt) {
                        O.E.trigger('click');
                        if (O.is_opened) O.hideOpts(); else O.showOpts();
                        evt.stopPropagation();
                    });

                    O.select.on('keydown.sumo', function (e) {
                        switch (e.which) {
                            case 38: // up
                                O.nav(true);
                                break;

                            case 40: // down
                                O.nav(false);
                                break;

                            case 65: // shortcut ctrl + a to select all and ctrl + shift + a to unselect all.
                                if (O.is_multi && e.ctrlKey) {
                                    O.toggSelAll(!e.shiftKey, 1);
                                    break;
                                }
                                else
                                    return;

                            case 32: // space
                                if (settings.search && O.ftxt.is(e.target)) return;
                            case 13: // enter
                                if (O.is_opened)
                                    O.optDiv.find('ul li.sel').trigger('click');
                                else
                                    O.setOnOpen();
                                break;
                            case 9:	 //tab
                                if (!settings.okCancelInMulti)
                                    O.hideOpts();
                                return;
                            case 27: // esc
                                if (settings.okCancelInMulti) O._cnbtn();
                                O.hideOpts();
                                return;
                            default:
                                return; // exit this handler for other keys
                        }
                        e.preventDefault(); // prevent the default action (scroll / move caret)
                    });

                    $(window).on('resize.sumo', function () {
                        O.floatingList();
                    });
                },

                itemClicked: function (li, refresh, unselect) {
                    
                    var O = this;
                    if (li.hasClass('disabled')) return;
                    txt = "";
                    if (O.is_multi) {
                        li.toggleClass('selected');
                        li.data('opt')[0].selected = li.hasClass('selected');
                        O.selAllState();
                    }
                    else {
                        li.parent().find('li.selected').removeClass('selected'); //if not multiselect then remove all selections from this list
                        li.toggleClass('selected');
                        li.data('opt')[0].selected = true;
                    }

                    //branch for combined change event.
                    if (!(O.is_multi && settings.triggerChangeCombined && (O.is_floating || settings.okCancelInMulti))) {
                        if (refresh) {
                            O.setText();
                            O.callChange();
                        }
                    }
                    if (!O.is_multi) O.hideOpts(); //if its not a multiselect then hide on single select.
                },

                onOptClick: function (li) {
                   
                    var O = this;
                    li.click(function (event) {
                        var li = $(this);
                        event.stopImmediatePropagation();
                        O.itemClicked(li, true);
                    });
                },
                setText: function () {
                    var O = this;
                    O.placeholder = "";
                    if (O.is_multi) {
                        sels = O.E.find(':selected').not(':disabled'); //selected options.

                        for (i = 0; i < sels.length; i++) {
                            if (i + 1 >= settings.csvDispCount && settings.csvDispCount) {
                                if (sels.length == O.E.find('option').length && settings.captionFormatAllSelected) {
                                    O.placeholder = settings.captionFormatAllSelected.replace(/\{0\}/g, sels.length) + ',';
                                } else {
                                    O.placeholder = settings.captionFormat.replace(/\{0\}/g, sels.length) + ',';
                                }

                                break;
                            }
                            else O.placeholder += $(sels[i]).text() + ", ";
                        }
                        O.placeholder = O.placeholder.replace(/,([^,]*)$/, '$1'); //remove unexpected "," from last.
                    }
                    else {
                        O.placeholder = O.E.find(':selected').not(':disabled').text();
                    }

                    var is_placeholder = false;

                    if (!O.placeholder) {

                        is_placeholder = true;

                        O.placeholder = O.E.attr('placeholder');
                        if (!O.placeholder)                  //if placeholder is there then set it
                            O.placeholder = O.E.find('option:disabled:selected').text();
                    }

                    O.placeholder = O.placeholder ? (settings.prefix + ' ' + O.placeholder) : settings.placeholder

                    //set display text
                    O.caption.html(O.placeholder);
                    if (settings.showTitle) O.CaptionCont.attr('title', O.placeholder);

                    //set the hidden field if post as csv is true.
                    var csvField = O.select.find('input.HEMANT123');
                    if (csvField.length) csvField.val(O.getSelStr());

                    //add class placeholder if its a placeholder text.
                    if (is_placeholder) O.caption.addClass('placeholder'); else O.caption.removeClass('placeholder');
                    return O.placeholder;
                },

                isMobile: function () {

                    // Adapted from http://www.detectmobilebrowsers.com
                    var ua = navigator.userAgent || navigator.vendor || window.opera;

                    // Checks for iOs, Android, Blackberry, Opera Mini, and Windows mobile devices
                    for (var i = 0; i < settings.nativeOnDevice.length; i++) if (ua.toString().toLowerCase().indexOf(settings.nativeOnDevice[i].toLowerCase()) > 0) return settings.nativeOnDevice[i];
                    return false;
                },

                setNativeMobile: function () {
                    var O = this;
                    O.E.addClass('SelectClass')//.css('height', O.select.outerHeight());
                    O.mob = true;
                    O.E.change(function () {
                        O.setText();
                    });
                },

                floatingList: function () {
                    var O = this;
                    //called on init and also on resize.
                    //O.is_floating = true if window width is < specified float width
                    O.is_floating = $(window).width() <= settings.floatWidth;

                    //set class isFloating
                    O.optDiv.toggleClass('isFloating', O.is_floating);

                    //remove height if not floating
                    if (!O.is_floating) O.optDiv.css('height', '');

                    //toggle class according to okCancelInMulti flag only when it is not floating
                    O.optDiv.toggleClass('okCancelInMulti', settings.okCancelInMulti && !O.is_floating);
                },

                //HELPERS FOR OUTSIDERS
                // validates range of given item operations
                vRange: function (i) {
                    var O = this;
                    var opts = O.E.find('option');
                    if (opts.length <= i || i < 0) throw "index out of bounds"
                    return O;
                },

                //toggles selection on c as boolean.
                toggSel: function (c, i) {
                    
                    var O = this;
                    var opt;
                    if (typeof (i) === "number") {
                        O.vRange(i);
                        opt = O.E.find('option')[i];
                    }
                    else {
                        opt = O.E.find('option[value="' + i + '"]')[0] || 0;
                    }
                    if (!opt || opt.disabled)
                        return;

                    if (opt.selected != c) {
                        opt.selected = c;
                        if (!O.mob) $(opt).data('li').toggleClass('selected', c);

                        O.callChange();
                        O.setPstate();
                        O.setText();
                        O.selAllState();
                    }
                },

                //toggles disabled on c as boolean.
                toggDis: function (c, i) {
                    
                    var O = this.vRange(i);
                    O.E.find('option')[i].disabled = c;
                    if (c) O.E.find('option')[i].selected = false;
                    if (!O.mob) O.optDiv.find('ul.options li').eq(i).toggleClass('disabled', c).removeClass('selected');
                    O.setText();
                },

                // toggle disable/enable on complete select control
                toggSumo: function (val) {
                   
                    var O = this;
                    O.enabled = val;
                    O.select.toggleClass('disabled', val);

                    if (val) {
                        O.E.attr('disabled', 'disabled');
                        O.select.removeAttr('tabindex');
                    }
                    else {
                        O.E.removeAttr('disabled');
                        O.select.attr('tabindex', '0');
                    }

                    return O;
                },

                // toggles all option on c as boolean.
                // set direct=false/0 bypasses okCancelInMulti behaviour.
                toggSelAll: function (c, direct) {
                   
                    var O = this;
                    O.optDiv.find('li.opt:not(.hidden,.disabled)')
                    .each(function (ix, e) {
                        var e = $(e),
                            is_selected = e.hasClass('selected');
                        if (!!c) {
                            if (!is_selected) O.itemClicked(e, false);
                        }
                        else {
                            if (is_selected) {
                                O.itemClicked(e, false);
                            }
                        }
                    });

                    if (!direct) {
                        if (!O.mob && O.selAll) O.selAll.removeClass('partial').toggleClass('selected', !!c);
                        O.callChange();
                        O.setText();
                        O.setPstate();
                    }
                    else {
                        O.callChange();
                        O.setText();
                        O.setPstate();
                    }
                },

                /* outside accessibility options
                 which can be accessed from the element instance.
                 */
                reload: function () {
              
                    var elm = this.unload();

                    return $(elm).SumoSelect(settings);
                },

                unload: function () {
                  
                    var O = this;
                    O.select.before(O.E);
                    O.E.show();

                    if (settings.outputAsCSV && O.is_multi && O.select.find('input.HEMANT123').length) {
                        O.E.attr('name', O.select.find('input.HEMANT123').attr('name')); // restore the name;
                    }
                    O.select.remove();
                    delete selObj.sumo;
                    return selObj;
                },

                //## add a new option to select at a given index.
                add: function (val, txt, i) {
                    if (typeof val == "undefined") throw "No value to add"

                    var O = this;
                    opts = O.E.find('option')
                    if (typeof txt == "number") { i = txt; txt = val; }
                    if (typeof txt == "undefined") { txt = val; }

                    opt = $("<option></option>").val(val).html(txt);

                    if (opts.length < i) throw "index out of bounds"

                    if (typeof i == "undefined" || opts.length == i) { // add it to the last if given index is last no or no index provides.
                        O.E.append(opt);
                        if (!O.mob) O.ul.append(O.createLi(opt));
                    }
                    else {
                        opts.eq(i).before(opt);
                        if (!O.mob) O.ul.find('li.opt').eq(i).before(O.createLi(opt));
                    }

                    return selObj;
                },

                //## removes an item at a given index.
                remove: function (i) {
                    var O = this.vRange(i);
                    O.E.find('option').eq(i).remove();
                    if (!O.mob) O.optDiv.find('ul.options li').eq(i).remove();
                    O.setText();
                },

                //## Select an item at a given index.
                selectItem: function (i) { this.toggSel(true, i); },

                //## UnSelect an iten at a given index.
                unSelectItem: function (i) { this.toggSel(false, i); },

                //## Select all items  of the select.
                selectAll: function () { this.toggSelAll(true); },

                //## UnSelect all items of the select.
                unSelectAll: function () { this.toggSelAll(false); },

                //## Disable an iten at a given index.
                disableItem: function (i) { this.toggDis(true, i) },

                //## Removes disabled an iten at a given index.
                enableItem: function (i) { this.toggDis(false, i) },

                //## New simple methods as getter and setter are not working fine in ie8-
                //## variable to check state of control if enabled or disabled.
                enabled: true,
                //## Enables the control
                enable: function () { return this.toggSumo(false) },

                //## Disables the control
                disable: function () { return this.toggSumo(true) },


                init: function () {
                    var O = this;
                    O.createElems();
                    O.setText();
                    return O
                }

            };

            selObj.sumo.init();
        });

        return ret.length == 1 ? ret[0] : ret;
    };


});
