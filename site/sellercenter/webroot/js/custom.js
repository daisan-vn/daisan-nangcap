arg = JSON.parse(arg);

$(document).ready(function(){
	$('#Keyword').keypress(function(event){
	    if(event.which==13) search();
	});
});

function URLToArray(url) {
    var request = {};
    var pairs = url.substring(url.indexOf('?') + 1).split('&');
    for (var i = 0; i < pairs.length; i++) {
        if(!pairs[i])  continue;
        var pair = pairs[i].split('=');
        request[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1]);
     }
     return request;
}

function search(kid) {
	var search_router = router?router:'search';
	var Keyword = $("#search #Keyword").val();
	var url;
	if(Keyword=='' && arg.domain!=arg.thislink){
		url = arg.domain;
		window.location.href = url;
	}else if(Keyword!=''){
		url = arg.domain + search_router + "?k=" + encodeURI(Keyword);
		if(kid && kid!=0) url = url + "&kId="+kid;
		url = url + "&lg=vi&pg=1";
		window.location.href = url;
	}else{
		$("#search #Keyword").tooltip("toggle");
	}
}

function noticeMsg(title, text, type){
	if(type==null)
		type = "info";
	var notice = new PNotify({
		title: title,
		text: text,
		type: type,
		mouse_reset: false,
		buttons: {
			sticker: false
		},
		animate: {
			animate: true,
			in_class: 'fadeInDown',
			out_class: 'fadeOutRight'
		}
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

function SetMoney(obj){
	var n = 0;
	var value = $(obj).val().replace(/,/g, "");
	if(value==null || value=='') value = 0;
	var re = '\\d(?=(\\d{' + (3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
    var rt = parseFloat(value).toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$&,');
	if(rt==0) rt = '';
	$(obj).val(rt);
}

function DeleteItem(table, id, mod, site){
	$("#ConfirmDelete").modal('show');
	if(!mod) mod = 'help';
	if(!site) site = 'ajax_delete_item';
	$("#ConfirmDelete #Btn").attr("onclick", "DeleteItemAction('"+table+"', "+id+", '"+mod+"', '"+site+"');");
}

function DeleteItemAction(table, id, mod, site){
	loading();
	if(!mod) mod = 'help';
	if(!site) site = 'ajax_delete_item';
	$.post('?mod='+mod+'&site='+site,{
		'action':'delete_item', 'id':id, 'table':table
	}).done(function(e){
		var rt = JSON.parse(e);
		if(rt.code==1){
			$("#FID"+id).remove();
			noticeMsg('Message', 'Xóa thông tin thành công.', 'success');
		}else{
			if(!rt.msg || rt.msg=='') rt.msg = 'Xóa thông tin thất bại.';
			noticeMsg('Message', rt.msg, 'error');
		}
		$("#ConfirmDelete").modal('hide');
		endloading();
	});
}

function activeItem(Table, Id) {
	loading();
	$.post("?mod=help&site=ajax_active_item", {'table': Table, 'id': Id}).done(function (data) {
		if (data == '0') noticeMsg('Message', 'Cập nhật trạng thái thất bại.', 'error');
		else {
			$("#stt" + Id).html(data);
			noticeMsg('Message', 'Cập nhật trạng thái thành công.', 'success');
		}
		endloading();
	});
}

function ShowModal(obj, value){
	var a_value = value.split(':');
	console.log(a_value);
	$(obj+' input[name='+a_value[0]+']').val(a_value[1]);
	$(obj).modal('show');
}