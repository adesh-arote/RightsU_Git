/*
 * jQuery Minimun Password Requirements 1.1
 * http://elationbase.com
 * Copyright 2014, elationbase
 * Check Minimun Password Requirements
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
*/
  
(function($){
    $.fn.extend({
        passwordRequirements: function(options) {

            // options for the plugin
            var defaults = {
				numCharacters: 8,
                useAlphabetcase: true,
				useNumbers: true,
                useSpecial: true,
                useNewConfirmPWD: true,
				infoMessage: '',
				style: "light", // Style Options light or dark
                fadeTime: 300, // FadeIn / FadeOut in milliseconds  
                numMinAlphabet: 1,
                numMinNumber: 1,
                numMinSpecialChar: 1,
                useSpecialChar: ''
            };

            options = $.extend(defaults, options);
            $('#btnSave').prop('disabled', true);
            return this.each(function() {
                var o = options;
                //o.infoMessage = 'The minimum password length is ' + o.numCharacters + ' characters and must contain at least 1 lowercase letter, 1 capital letter, 1 number, and 1 special character.';
                o.infoMessage = 'The password must contain atleast ' + o.numCharacters + ' characters, Atleast ' + o.numMinAlphabet + ' Alphabet, Atleast ' + o.numMinNumber + ' Number (0-9), Atleast ' + o.numMinSpecialChar + ' Special Character (' + o.useSpecialChar.replace(/(.{1})/g, "$&,") +'), New and Confirm Password should same.';
				// Add Variables for the li elements
                var numCharactersUI = '<li class="pr-numCharacters"><span></span>Atleast ' + o.numCharacters +' Character</li>',
					useNumbersUI   = '',
                    useSpecialUI = '',
                    useAlphabetcaseUI = '';
                if (o.useAlphabetcase === true) {
                    useAlphabetcaseUI = '<li class="pr-useAlphabetcase"><span></span>Atleast '+ o.numMinAlphabet +' Alphabet</li>';
                }
				if (o.useNumbers === true) {
                    useNumbersUI = '<li class="pr-useNumbers"><span></span>Atleast '+ o.numMinNumber +' Number (0-9)</li>';
				}
				if (o.useSpecial === true) {
                    useSpecialUI = '<li class="pr-useSpecial"><span></span>Atleast ' + o.numMinSpecialChar + ' Special Character (' + o.useSpecialChar.replace(/(.{1})/g, "$&,") +')</li>';
				}
                if (o.useNewConfirmPWD === true) {
                    useNewConfirmPWDUI = '<li class="pr-useNewConfirmPWD"><span></span>New and Confirm Password should same</li>';
                }
				// Append password hint div
                var messageDiv = '<div id="pr-box"><i></i><div id="pr-box-inner"><p>' + o.infoMessage + '</p><ul>' + numCharactersUI + useAlphabetcaseUI + useNumbersUI + useSpecialUI + useNewConfirmPWDUI + '</ul></div></div>';
				
				// Set campletion vatiables
                var numCharactersDone = false,
                    useNumbersDone = false,
                    useSpecialDone = false,
                    useAlphabetcaseDone = false,
                    useNewConfirmPWDDone = false;
                
				// Show Message reusable function 
                var showMessage = function () {
                    if (numCharactersDone === false || useNumbersDone === false || useSpecialDone === false || useAlphabetcaseDone === false || useNewConfirmPWDDone === false) {
						$(".pr-password").each(function() {
							// Find the position of element
							var posH = $(this).offset().top,
								itemH = $(this).innerHeight(),
								totalH = posH+itemH,
								itemL = $(this).offset().left;
							// Append info box tho the body
							$("body")     .append(messageDiv);
							$("#pr-box")  .addClass(o.style)
										  .fadeIn(o.fadeTime)
										  .css({top:totalH, left:itemL});
                        });                        
					}
				};
				
				// Show password hint 
				$(this).on("focus",function (){
					showMessage();
				});
				
				// Delete Message reusable function 
				var deleteMessage = function () {
					var targetMessage = $("#pr-box");
					targetMessage.fadeOut(o.fadeTime, function(){
						$(this).remove();
                    });
				};
				
				// Show / Delete Message when completed requirements function 
                var checkCompleted = function () {
                    if (numCharactersDone === true && useNumbersDone === true && useSpecialDone === true && useAlphabetcaseDone === true && useNewConfirmPWDDone === true) {
                        if ($('#OldPassword').val() != '') {
                            $('#btnSave').prop('disabled', false);
                        } else {
                            $('#btnSave').prop('disabled', true);
                        }                        
                        deleteMessage();
                    } else {
                        $('#btnSave').prop('disabled', true);
                        showMessage(); 
					}
				};
				
				// Show password hint 
				$(this).on("blur",function (){
					deleteMessage();
                });

                //var strSpecialChar = new Array(o.useSpecialChar.replace(/(.{1})/g, "$&,"));
				// Show or Hide password hint based on user's event
                // Set variables
                var strSpecialChar = new Array("!%&@#$ ^*? _~<>");
				var numbers     		= new RegExp('[0-9]'),
                    //specialCharacter = new RegExp('[!,%,&,@,#,$,^,*,?,_,~]'),
                    specialCharacter = new RegExp('['+o.useSpecialChar.replace(/(.{1})/g, "$&,")+']'),                    
                    AlphabetCase = new RegExp('[A-Za-z]'),
                    CountAlphabetCase = new RegExp(/[a-zA-Z]/g),
                    CountNumberCase = new RegExp(/[0-9]/g),
                    CountSpecialCharCase = new RegExp(/[!,%,&,@,#,$,^,*,?,_,~]/g);
				
				// Show or Hide password hint based on keyup
				$(this).on("keyup focus", function (){
                    var thisVal = $(this).val();
					checkCompleted();
					
					// Check # of characters
					if ( thisVal.length >= o.numCharacters ) {
						$(".pr-numCharacters span").addClass("pr-ok");
						numCharactersDone = true;
					} else {
						$(".pr-numCharacters span").removeClass("pr-ok");
						numCharactersDone = false;
					}					
					// UseNumber meet requirements
					if (o.useNumbers === true) {
                        if (thisVal.match(numbers)) {
                            if (thisVal.match(CountNumberCase).length >= o.numMinNumber) {
                                $(".pr-useNumbers span").addClass("pr-ok");
                                useNumbersDone = true;
                            } else {
                                $(".pr-useNumbers span").removeClass("pr-ok");
                                useNumbersDone = false;
                            }  							
						} else {
							$(".pr-useNumbers span").removeClass("pr-ok");
							useNumbersDone = false;
						}
					}
					// SpecialCase meet requirements
                    if (o.useSpecial === true) {
                        var SpecialCharFlag = false;
                        if (thisVal.match(specialCharacter)) {
                            SpecialCharFlag = true;
                        }
                        else {
                            SpecialCharFlag = false;
                        }
                        var str = thisVal;
                        const specialAllow = o.useSpecialChar;
                        var count = 0;
                        for (let i = 0; i < str.length; i++) {
                            if (!specialAllow.includes(str[i])) {
                                continue;
                            };
                            count++;
                        };
                        if (SpecialCharFlag == true && count >= Number(o.numMinSpecialChar)) {
                            $(".pr-useSpecial span").addClass("pr-ok");
                                useSpecialDone = true;
                        }
                        else {
                            $(".pr-useSpecial span").removeClass("pr-ok");
                                useSpecialDone = false;
                        }      
                    }
                    // AlphabetCase meet requirements
                    if (o.useAlphabetcase === true) {
                        if (thisVal.match(AlphabetCase)) {
                            if (thisVal.match(CountAlphabetCase).length >= o.numMinAlphabet) {
                                $(".pr-useAlphabetcase span").addClass("pr-ok");
                                useAlphabetcaseDone = true;
                            } else {
                                $(".pr-useAlphabetcase span").removeClass("pr-ok");
                                useAlphabetcaseDone = false;
                            }                                                      
                        } else {
                            $(".pr-useAlphabetcase span").removeClass("pr-ok");
                            useAlphabetcaseDone = false;                                                                                  
                        }
                    }
                    // End AlphabetCase
                    // useNewConfirmPWD meet requirements
                    if (o.useNewConfirmPWD === true) {
                        if ($('#NewPassword').val() === $('#ConfirmPassword').val() && $('#NewPassword').val() != '' && $('#ConfirmPassword').val()!='') {
                            $(".pr-useNewConfirmPWD span").addClass("pr-ok");
                            useNewConfirmPWDDone = true;
                        } else {
                            $(".pr-useNewConfirmPWD span").removeClass("pr-ok");
                            useNewConfirmPWDDone = false;
                        }
                    }
                    // End useNewConfirmPWD
				});
            });
        }
    });
})(jQuery);
