$(document).ready(function(){
	$('#Keyword').keypress(function(event){
	    if(event.which==13) search();
	});
});

function noticeMsg(title, text, type){
	if(type==null) type = "info";
	var notice = new PNotify({
		title: title,
		text: text,
		type: type,
		mouse_reset: false,
		buttons: {sticker: false},
		animate: {animate: true, in_class: 'fadeInDown', out_class: 'fadeOutRight'}
	});
	notice.get().click(function () {
		notice.remove();
	});
}

function loading(){
	$("#loading").show();
}

function endloading(){
	$("#loading").hide();
}
