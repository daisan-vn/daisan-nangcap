$(function () {
	CheckTbody();
	$(".SelectAllRows").click(function () {
		$(".item_checked, .SelectAllRows").prop('checked', $(this).prop('checked'));
	});
});

function ChangeUrl(value, obj) {
	var str = get_alias(value);
	$(obj).val(str);
}

function get_alias(str) {
	str = str.toLowerCase();
	str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
	str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
	str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
	str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
	str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
	str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
	str = str.replace(/đ/g, "d");
	str = str.replace(/ /g, "-");
	str = str.replace(/&|'|"|<|>|\?|\.|,|;|\/|`|{|}|[|]|“|”| /g, "-");
	str = str.replace(/[\W]/g, "-");
	str = str.replace(/-+-/g, "-"); //thay thế 2- thành 1-
	str = str.replace(/^\-+|\-+$/g, ""); //cắt bỏ ký tự - ở đầu và cuối chuỗi
    str = encodeURI(str);
	return str;
}


function noticeMsg(title, text, type){
	if(type==null) type = "info";
	var notice = new PNotify({
		title: title,
		text: text,
		type: type,
		mouse_reset: false,
		buttons: { sticker: false },
		animate: { animate: true, in_class: 'fadeInDown', out_class: 'fadeOutRight' }
	});
	notice.get().click(function () { notice.remove(); });
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

function setFeatured(Table, Id) {
	loading();
	$.post("?mod=help&site=ajax_set_featured_item", {'Table': Table, 'Id': Id}).done(function (data) {
		if (data == '0') noticeMsg('Thông báo', 'Cập nhật thất bại.', 'error');
		else {
			$("#fea"+Id).html(data);
			noticeMsg('Thông báo', 'Cập nhật thành công.', 'success');
		}
		endloading();
	});
}
function sortItem(table, id, sort) {
	$('#in_progress').show();
	$('input[name=sort]').keyup(function () {
		var sort_val = $(this).val();
		var positive_num = sort_val.match(/^\d+$/);
		if (positive_num === null) {
			$(this).val(0);
			sortItem(table, id, 0);
		}
	});
	$.post("?mod=help&site=ajax_sort", {'table': table, 'id': id, 'sort': sort}).done(function(){
		$('#in_progress').hide();
	});
}
function LoadDeleteItem(mod, id, site, check) {
	PNotify.removeAll();
	var field_name = $('#field' + id + ' .field_name').html();
	if (field_name != undefined) {
		field_name = field_name.replace(/— /g, "");
	}
	$('#ConfirmDelete').on('show.bs.modal', function () {
		$('#ConfirmDelete .del_name').html(field_name);
	});
	$("#DeleteItem").attr("onclick", "DeleteItem('" + mod + "', '" + site + "', " + id + ", '" + field_name + "', '" + check + "');");
	$("#ConfirmDelete").modal('show');
}


function DeleteItem(mod, site, id, table) {
	loading();
	//$('#ConfirmDelete').modal('hide');
	$('.modal').modal('hide');
	$.post("?mod="+mod+"&site="+site, {'Id': id, 'Table': table}).done(function (e) {
		endloading();
		var data = JSON.parse(e);
		if (data.code == 0) {
			//noticeMsg('Thông báo', data.msg, 'error');
		} else if (data.code == 1) {
			$('#field'+id).css('background', '#F2DEDE').fadeOut(700);
			setTimeout(function () {
				$('#field' + id).remove();
			}, 700);
			//noticeMsg('Thông báo', data.msg, 'success');
		}
	});
}

function ConfirmDelete(Id, Table, mod, site) {
	var field_name = $('#field' + Id + ' .field_name').html();
	if (field_name != undefined) {
		field_name = field_name.replace(/— /g, "");
	}
	$('#ConfirmDelete').on('show.bs.modal', function () {
		$('#ConfirmDelete .del_name').html(field_name);
	});
	if(!mod || mod=='' || mod==null){
		mod = 'help';
		site = 'ajax_delete';
	}else if(!site || site=='' || site==null) site = 'ajax_delete';
	
	if(mod=='help' && (!Table || Table=='' || Table==null)){
		noticeMsg('Thông báo', 'Vui lòng truyền đầy đủ tham số vào chức năng xóa');
		return false;
	}
	
	$("#ConfirmDelete #DeleteItem").attr("onclick", "DeleteItem('"+mod+"', '"+site+"', "+Id+", '"+Table+"');");
	$("#ConfirmDelete").modal('show');
}

function BulkDelete(mod, site) {
	PNotify.removeAll();
	if (!site || site == '' || site == null || site == 'undefined') site = "ajax_bulk_delete";
	var arr = [];
	$(".item_checked").each(function () {
		if ($(this).is(':checked')) {
			var value = $(this).val();
			arr.push(value);
		}
	});
	if (arr.length < 1) {
		noticeMsg('Chọn mục xử lí', 'Vui lòng chọn các mục cần xử lí', 'info');
		return false;
	}
	var str = arr.toString();
	$('#ConfirmBulkDelete').modal('show');
	$('#DeleteList').empty();
	$.each(arr, function (index, value) {
		var delete_name = $('#field' + value + ' .field_name').html();
		if (delete_name != undefined) {
			delete_name = delete_name.replace(/— /g, "");
		}
		$('#DeleteList').append("<p><b>"+delete_name+"</b></p>");
	});
	$('#DeleteBulk').unbind().click(function () {
		$('#ConfirmBulkDelete').modal('hide');
		$('#cover_data').show();
		$('#save_btn').prop('disabled', true);
		loading();
		$.post("?mod="+mod+"&site="+site+"", {'id': str}).done(function (data) {
			endloading();
			$('#cover_data').hide();
			$('#save_btn').prop('disabled', false);
			var data = JSON.parse(data);
			var deleted_id = data.deleted_id.split("-");
			$.each(deleted_id, function (index, value) {
				$('#field' + value).css('background', '#F2DEDE').fadeOut(700);
				setTimeout(function () {
					$('#field' + value).remove();
					try {
						CheckTbody();
						CancelEdit();
					} catch(e) {
						return false;
					}
				}, 700);
			});
			if (data.deleted != null && data.deleted != '')
				noticeMsg('Đã xóa', '<b>'+data.deleted+'</b>', 'success');
			if ((data.deleted == null || data.deleted == '') && data.deleted_id != null && data.deleted_id != '') 
				noticeMsg('Xóa thành công', 'Đã xóa các mục được chọn', 'success');
			if (data.notdeleted != null && data.notdeleted != '') 
				noticeMsg('Không thể xóa', '<b>'+data.notdeleted+'</b>', 'error');
			try {
				RenewSelect();
			} catch(e) {
				return false;
			}
		});
	});
}

function BulkActive(table, type) {
	var arr = [];
	$(".item_checked").each(function () {
		if ($(this).is(':checked')) {
			var value = $(this).val();
			arr.push(value);
		}
	});

	if (arr.length < 1) {
		noticeMsg('Chọn mục xử lí', 'Vui lòng chọn các mục cần xử lí', 'info');
		return false;
	}
	var str = arr.toString();
	loading();
	$.post("?mod=help&site=ajax_active_multi", {'table': table, 'type': type, 'id': str})
		.done(function () {
			endloading();
			var mes_text = '';
			if (type == 1) {
				$.each(arr, function (index, value) {
					$('#stt' + value).html('<button type="button" class="btn btn-success btn-xs" title="Đổi trạng thái" onclick="activeItem(\'' + table + '\', ' + value + ');"><i class="fa fa-check fa-fw"></i></button>');
				});
				mes_text = 'kích hoạt';
			}
			else if (type == 2) {
				$.each(arr, function (index, value) {
					$('#stt' + value).html('<button type="button" class="btn btn-danger btn-xs" title="Đổi trạng thái" onclick="activeItem(\'' + table + '\', ' + value + ');"><i class="fa fa-lock fa-fw"></i></button>');
				});
				mes_text = 'hủy kích hoạt';
			}
			noticeMsg('Xử lí thành công', 'Đã '+mes_text+' các mục được chọn', 'success');
			try {
				RenewSelect();
			} catch (e) {
				return false;
			}
		});
}


function CheckTbody(){
	var tbody = $(".hls_list_table tbody");
	if (tbody.children().length <= 1) {
		$('#non_item').show();
	}
	else {
		$('#non_item').hide();
	}
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

function loading(){
	$("#loading").show();
}

function endloading(){
	$("#loading").hide();
}

function rtJson(str) {
    try {
    	var rt = JSON.parse(str);
    } catch (e) {
        return false;
    }
    return rt;
}

function DisableForm(form) {
	$('#in_progress').show();
	$(form+" :input").prop('readonly', true);
	$(form+" select").prop('disabled', true);
	$(form+" :button").prop('disabled', true);
}

function EnableForm(form) {
	$('#in_progress').hide();
	$(form+" :input").prop('readonly', false);
	$(form+" select").prop('disabled', false);
	$(form+" :button").prop('disabled', false);
}

function DisableAll(element) {
	$(element).find('button').prop('disabled', true);
}

function ImgUpload(input, obj) {
	if (input.files && input.files[0]) {
		var fileImg = input.files[0];
		var fileType = input.files[0]['type'];
		var ValidImgTypes = ["image/jpeg", "image/png"];
		if ($.inArray(fileType, ValidImgTypes)>=0) {
			var _URL = window.URL || window.webkitURL;
			var img = new Image();
	        img.onload = function () {
	            if(this.width/this.height>8 || this.width/this.height<0.125){
	            	noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp tỉ lệ, vui lòng chọn lại.', 'error');
	            	$(input).val('');
	            	$('#'+obj+'ShowImg').attr('src', arg.noimg);
	            	$('#'+obj).val('');
	            	return false;
	            }else{
	        		var reader = new FileReader();
	        		reader.onload = function(e) {
	        			$('#'+obj+'ShowImg').attr('src', e.target.result);
	        			$('#'+obj).val(e.target.result);
	        		}
	        		reader.readAsDataURL(fileImg);
	            }
	        }
	        img.src = _URL.createObjectURL(fileImg);
		}else{
			noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng jpg hoặc png.', 'error');
			$(input).val('');
		}
	}
}
function SetLocation(){
	var location1 = $("select[name=location]").val();
	$.post('?mod=home&site=ajax_set_location_used',{'location1':location1}).done(function(){
		alert(location1);
		location.reload();
	});
}