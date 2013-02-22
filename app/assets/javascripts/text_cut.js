$(document).ready(function(){
    $("[class^='textcut']").each(function() {
        var cutlength = parseInt($(this).attr('class').replace("textcut", ""));
        var text = $(this).html().trim();
        $(this).attr("title", text);
        text = (text.length > cutlength + 2) ? (text.substring(0, cutlength) + "...") : text;
        $(this).html(text);
    });

});