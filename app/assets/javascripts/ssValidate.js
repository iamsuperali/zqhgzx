/*!Author: stian karlsen / http://stiankarlsen.me/super-simple-form-validation / v0.3*/

// ****************************************************************** //
// ****************************************************************** //
// @@ What: Super Simple Form Validation with jQuery               ** //
// @@ Who: Stian Karlsen                                           ** //
// @@ Version: 0.3                                                 ** //
// @@ License: None                                                ** //
// @@ Website: http://stiankarlsen.me/super-simple-form-validation ** //
// ****************************************************************** //
// ****************************************************************** //

jQuery(document).ready(function(){

    jQuery.fn.ssValidate = function() {

        // Custom error messages
        var emptyError  = "<p class='error-message empty-message'>必填</p>";
		
        var emailError  = "<p class='error-message email-message'>请输入邮箱格式</p>";
		
        var numberError = "<p class='error-message number-message'>请输入数字</p>";
		
        var urlMessage    = "<p class='error-message url-message'>That is not a valid URL</p>";
		
        var textareaError  = "<p class='error-message empty-message'>必填</p>";
        
        var nameError = "<p class='error-message empty-message'>请输入中文名</p>";
	
        // Regular expressions
        var emailRegEx  = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        var numberRegEx = /[0-9-()+]{3,20}/;
        var urlRegEx    = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;
					
        // Create variables
        var vEmpty        = jQuery("input.validateEmpty");
		
        var vEmail        = jQuery("input.validateEmail");
        var vEmailOpt     = jQuery("input.validateEmailOptional");
		
        var vNumber       = jQuery("input.validateNumber");
        var vNumberOpt    = jQuery("input.validateNumberOptional");
		
        var vUrl          = jQuery("input.validateUrl");
        var vUrlOpt       = jQuery("input.validateUrlOptional");
		
        var vTextarea     = jQuery("textarea.validateTextarea");
			
		
        $("input:submit").click(function(){
		
            // ***************************************
            // VALIDATE REQUIRED FIELD FOR ANY INPUT
            // ***************************************
            if ($(vEmpty)[0]) {  // check if element exists
                // if it does
                if (vEmpty.val()=='') {
                    vEmpty.addClass('error');
                    vEmpty.before(emptyError);
                    jQuery(vEmpty).focus();
                    return false;
                } else vEmpty.removeClass('error'); 
                jQuery("p.empty-message").hide();
            }
		
            // ***************************************
            // VALIDATE REQUIRED EMAIL
            // ***************************************
            if ($(vEmail)[0]) {  // check if element exists
                // if it does
                if(!emailRegEx.test(vEmail.val())){
                    vEmail.addClass('error');
                    vEmail.before(emailError);
                    jQuery(vEmail).focus();
                    return false;
                } else vEmail.removeClass('error');
                jQuery("p.email-message").hide();   
            }
				
            // ***************************************
            // VALIDATE OPTIONAL EMAIL
            // ***************************************
            if ($(vEmailOpt)[0]) {  // check if element exists
                // if it does
                if (vEmailOpt.val()=='') {
                // if it is empty, do nothing
                } else if(!emailRegEx.test(vEmailOpt.val())){
                    vEmailOpt.addClass('error');
                    vEmailOpt.before(emailError);
                    jQuery(vEmailOpt).focus();
                    return false;
                } else vEmpty.removeClass('error');
                jQuery("p.email-message").hide();   
            }
				
            // ***************************************
            // VALIDATE REQUIRED NUMBER
            // ***************************************
            if ($(vNumber)[0]) {  // check if element exists
                // if it does
                if(!numberRegEx.test(vEmail.val())){
                    vNumber.addClass('error');
                    vNumber.before(numberError);
                    jQuery(vNumber).focus();
                    return false;
                } else vNumber.removeClass('error');
                jQuery("p.number-message").hide();   
            }
			
            // ***************************************
            // VALIDATE OPTIONAL NUMBER
            // ***************************************
            if ($(vNumberOpt)[0]) {  // check if element exists
                // if it does
                if (vNumberOpt.val()=='') {
                // if it is empty, do nothing
                } else if(!NumberRegEx.test(vNumberOpt.val())){
                    vNumberOpt.addClass('error');
                    vNumberOpt.before(numberError);
                    jQuery(vNumberOpt).focus();
                    return false;
                } else vEmpty.removeClass('error');
                jQuery("p.number-message").hide();   
            }
			
							
            // ***************************************
            // URL - Validate URLs
            // ***************************************
            if ($(vUrl)[0]) {  // check if element exists
                // if it does
                if(!urlRegEx.test(vUrl.val())){
                    vUrl.addClass('error');
                    jQuery(vUrl).focus();
                    return false;
                } else vUrl.removeClass('error');
                jQuery("p.url-message").hide();   
            }
			
            // ***************************************
            // VALIDATE OPTIONAL URL
            // ***************************************
            if ($(vUrlOpt)[0]) {  // check if element exists
                // if it does
                if (vUrlOpt.val()=='') {
                // if it is empty, do nothing
                } else if(!urlRegEx.test(vUrlOpt.val())){
                    vUrlOpt.addClass('error');
                    vUrlOpt.before(urlMessage);
                    jQuery(vUrlOpt).focus();
                    return false;
                } else vEmpty.removeClass('error');
                jQuery("p.email-message").hide();
            }
				
            // ***************************************
            // VALIDATE TEXTAREA
            // ***************************************
            if ($(vTextarea)[0]) {  // check if element exists
                // if it does
                if (vTextarea.val()=='') {
                    vTextarea.addClass('error');
                    vTextarea.before(textareaError);
                    jQuery(vTextarea).focus();
                    return false;
                } else vTextarea.removeClass('error'); 
                jQuery("p.empty-message").hide();  
            }
        }); // end of submit .click
								
    }; // end of ssValidate function
	
    $("form.required").ssValidate();

});