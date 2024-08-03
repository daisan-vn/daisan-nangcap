<p id="in_progress" class="pull-right"><i class="fa fa-circle-o-notch fa-spin fa-fw"></i> Đang xử lí</p>
<div class="body-head">
	<h1><i class="fa fa-bars fa-fw"></i> Quản lý thư viện Media</h1>
</div>

<div class="row">
	<div class="col-md-8">
		<div class="form-group form-inline">
			<div class="btn-group">
				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					<i class="fa fa-cog fa-fw"></i> Thư mục &nbsp;<span class="caret"></span>
				</button>
				<ul class="dropdown-menu">
					<li><a href="javascript:void(0);" data-toggle="modal" data-target="#FolderModal" onclick="LoadFolderName(0);"><i class="fa fa-plus fa-fw"></i> Tạo thư mục</a></li>
					<li class="folder_option{if $out.folder_list eq ''} hidden{/if}"><a id="RenameFolderBtn" href="javascript:void(0);" data-toggle="modal" data-target="#FolderModal" onclick="LoadFolderName({$out.active_folder});"><i class="fa fa-pencil fa-fw"></i> Đổi tên thư mục</a></li>
					<li class="folder_option{if $out.folder_list eq ''} hidden{/if}"><a href="javascript:void(0);" data-toggle="modal" data-target="#ConfirmFolderDelete" onclick="LoadDeleteFolder();"><i class="fa fa-trash fa-fw"></i> Xóa thư mục</a></li>
				</ul>
			</div>
			<a href="?mod=media&site=upload" class="btn btn-default"><i class="fa fa-picture-o"></i> Upload hình ảnh</a>
			<button type="button" class="btn btn-default" id="button_active" onclick="getcheck(1)"><span id="p_active"><i class="fa fa-check fa-fw"></i> Chọn nhiều</span></button>
			<button style="display:none" type="button" class="btn btn-danger" id="btn_delete" onclick="DeleteAll('media','ajax_load_delete_media')"><span id="p_active"><i class="fa fa-trash fa-fw"></i> Xóa mục đã chọn</span></button>
		</div>
	</div>
	<div class="col-md-4">
		<div class="form-group form-inline text-right">
			<div id="folder_view1" class="btn-group">
				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
					<i class="fa fa-cog fa-fw"></i> Chọn thư mục &nbsp;<span class="caret"></span>
				</button>
				<ul id="folder_view" class="dropdown-menu dropdown-menu-right">
					{$out.folder_list|default:NULL}
				</ul>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-md-12 col-sm-8" id="media_view">
        {include '../media/media.tpl'}
	</div>
</div>

<div class="modal fade" id="FolderModal">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
				<h4 class="modal-title" id="FolderModalTitle">Tạo thư mục mới</h4>
			</div>
			<div class="modal-body">
                <form id="FolderForm" method="post" action="" onkeypress="return event.keyCode != 13;">
                    <input type="hidden" name="folder_id">
				    <input class="form-control" name="folder_name" title="Tên thư mục" placeholder="Tên thư mục">
                </form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
				<button id="SaveFolderBtn" type="button" class="btn btn-primary" onclick="SaveFolder();">Lưu lại</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade  bs-example-modal-lg" tabindex="-1" id="UpdateFrom">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
				<h4 class="modal-title" id="cate_article">Chỉnh sửa file</h4>
			</div>
			<form id="uploadFile" class="form-horizontal" method="post" enctype="multipart/form-data">
				<div class="modal-body body_img">
					<div id="ImgModalLoading" class="media_loading text-primary text-center">
						<i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i>
						<h4>Đang tải</h4>
					</div>

					<div class="row row_img ImgModalBody">
						<div class="col-md-7 col-xs-12 div_info">
							<div class="img_modal">
								<img id="img_change" src="">
							</div>
							<div class="form-group change_image">
								<a id="edit_link" href="?mod=media&site=edit&id=" style="padding: 3px 9px;"><i class="fa fa-magic fa-fw"></i> Chỉnh sửa hình ảnh</a>
							</div>
						</div>
						<div class="col-md-5 col-xs-12">
							<h3>Thông tin chi tiết</h3>
							<div class="form-group">
								<label class="control-label col-md-3 col-sm-3 col-xs-12">Tiêu đề</label>
								<div class="col-md-9 col-sm-8 col-xs-12">
									<input type="hidden" name="post_id">
									<input type="text" name="post_title" class="form-control col-md-7 col-xs-12">
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-md-3 col-sm-3 col-xs-12">Mô tả</label>
								<div class="col-md-9 col-sm-8 col-xs-12">
									<textarea name="post_description" class="form-control col-md-7 col-xs-12"></textarea>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer ImgModalBody">
                    <button type="button" class="btn btn-danger" name="delete" onclick="LoadDeleteItem('media', this.value, 'ajax_delete',1);"><i class="fa fa-trash-o"></i> Xóa file</button>
					<!-- <button type="submit" class="btn btn-primary" name="submit_change">Lưu thay đổi</button> -->
                    <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
				</div>
			</form>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->


<!-- Confirm Bulk Image Delete Modal -->
<div class="modal fade" id="ConfirmBulkDelete">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
				<h4 class="modal-title" id="myModalLabel">Xóa các file đã chọn?</h4>
			</div>
			<div class="modal-body">
				<p>Bạn chắc chắn muốn xóa vĩnh viễn các file đã chọn chứ?</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
				<button type="button" class="btn btn-danger" id="DeleteBulk">Xóa</button>
			</div>
		</div>
	</div>
</div>

<!-- Confirm Folder Delete Modal -->
<div class="modal fade" id="ConfirmFolderDelete">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
				<h4 class="modal-title" id="myModalLabel">Xóa thư mục này?</h4>
			</div>
			<div class="modal-body">Bạn chắc chắn muốn xóa vĩnh viễn thư mục <b id="folder_name"></b> chứ?</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
				<button type="button" class="btn btn-danger" id="DeleteFolderBtn" onclick="DeleteFolder();">Xóa</button>
			</div>
		</div>
	</div>
</div>

<script>
var active_folder = '{$out.active_folder}';
</script>

{literal}
<script>
$(document).on('show.bs.modal', '.modal', function () {
	var zIndex = 1040 + (10 * $('.modal:visible').length);
	$(this).css('z-index', zIndex);
	setTimeout(function() {
		$('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
	}, 0);
});

$(document).on('hidden.bs.modal', '.modal', function () {
	$('.modal:visible').length && $(document.body).addClass('modal-open');
});

$('#FolderModal').on('shown.bs.modal', function () {
	PNotify.removeAll();
	$('input[name=folder_name]').focus();
});

$('#FolderModal').on('hidden.bs.modal', function () {
	PNotify.removeAll();
	$('#FolderForm')[0].reset();
	$('#SaveFolderBtn').prop('disabled', false).html('Lưu lại');
});

$('input[name=folder_name]').keypress(function( event ){
    if ( event.which == 13 ) {
        SaveFolder();
    }
});

function LoadFolderName(id) {
	if (id == 0) {
		$('input[name=folder_id]').val(0);
		$('#FolderModalTitle').html('Tạo thư mục mới');
	}
	else {
		$('#FolderModalTitle').html('Đổi tên thư mục');
		$('input[name=folder_id]').val(active_folder);
		$('input[name=folder_name]').val($.trim($('#folder_view li.active').text()));
	}
}

function SaveFolder() {
	PNotify.removeAll();
	$('#SaveFolderBtn').prop('disabled', true).html('<i class="fa fa-circle-o-notch fa-spin fa-fw"></i> Đang lưu');
    var formdata = new FormData($('#FolderForm')[0]);
    $.post({
        url: '?mod=media&site=ajax_save_folder',
        data: formdata,
        contentType: false,
        processData: false,
        success: function(e) {
			var data = JSON.parse(e);
			if (data.mes == 'exist') {
				noticeMsg('Trùng tên', 'Thư mục đã tồn tại, vui lòng chọn tên khác', 'error');
				$('#SaveFolderBtn').prop('disabled', false).html('Lưu lại');
			}
			else {
				$('#FolderModal').modal('hide');
				ReloadFolder(active_folder);
				if (data.mes == 0 || data.mes == 'unique') {
					$('.folder_option').removeClass('hidden');
				}
				if (data.mes == 'unique') {
					ChangeFolder(data.folder_unique);
				}
			}
        }
    });
}

function LoadDeleteFolder() {
	$('#folder_name').html($.trim($('#FolderList li.active').text()));
}

function DeleteFolder() {
	$('#ConfirmFolderDelete').modal('hide');
	$.post("?mod=media&site=ajax_delete_folder",{'id':active_folder}).done(function (e) {
		var data = JSON.parse(e);
		if (data.ok == 0) {
			noticeMsg('Không thể xóa', data.mes, 'error');
		} else if (data.ok == 1) {
			noticeMsg('Xóa thành công', data.mes, 'success');
			$('#in_progress').show();
			$.post("?mod=media&site=get_a_folder").done(function (e) {
				ChangeFolder(e);
			});
			if (data.count != undefined && data.count == 0) {
				$('.folder_option').addClass('hidden');
			}
		}
	});
}

function ChangeFolder(id) {
	ReloadFolder(id);
	ReloadMedia(id,1);
	$('#RenameFolderBtn').attr('onclick', 'LoadFolderName('+id+')');
	$("#button_active").attr("onclick","getcheck(1);");
	$("#btn_delete").hide();
	$("#p_active").html('<i class="fa fa-check fa-fw"></i> Chọn nhiều');
	active_folder = id;
}

function GetFileFolder() {
	$('#media_view').html('<div class="media_loading text-primary text-center"><i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i> <h4>Đang tải</h4></div>');
	$.post("?mod=media&site=reload_media",{
		'type':'file',
		'folder':0,
		'page':1
	}).done(function (e) {
		$('#media_view').html(e);
	});
	$('#RenameFolderBtn').attr('onclick', 'LoadFolderName(0)');
	$("#button_active").attr("onclick","getcheck(1);");
	$("#btn_delete").hide();
	$("#p_active").html('<i class="fa fa-check fa-fw"></i> Chọn nhiều');
	$("#FolderList li").removeClass('active');
	$("#FolderList li#FileFolder").addClass('active');
	active_folder = 0;
}

function ReloadFolder(cur_folder) {
	$('#in_progress').show();
	$.post("?mod=media&site=reload_folder_select",{'active_folder':cur_folder}).done(function (e) {
		$('#folder_view').html(e);
		$('#in_progress').hide();
	});
}

function ReloadMedia(folder, page) {
	$('#media_view').html('<div class="media_loading text-primary text-center"><i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i> <h4>Đang tải</h4></div>');
	$.post("?mod=media&site=reload_media",{'folder':folder, 'page':page}).done(function (e) {
		$('#media_view').html(e);
	});
}

function MediaPaging(page) {
	ReloadMedia(active_folder, page);
}

function getinfoimg(id){
	$('.ImgModalBody').hide();
	$('#ImgModalLoading').show();
	$.post("?mod=media&site=ajax_load_media", {'id': id}).done(function (data) {
		var data = JSON.parse(data);
		$("#img_change").attr('src',data.image);
		$("input[name=post_id]").val(data.id);
		$("button[name=delete]").val(data.id);
		$("input[name=post_title]").val(data.media_title);
		$("select[name=type]").html(data.select_type);
		$("textarea[name=post_description]").val(data.description);
        $("#edit_link").attr('href', '?mod=media&site=edit&id='+data.id);
		$('#ImgModalLoading').hide();
		$('.ImgModalBody').show();
		if(data.type=='file')
			$(".change_image").hide();
		else
			$(".change_image").show();
    });
}

function getcheck(check) {
	if (check == 1) {
		$("#btn_delete").show();
		$(".img_change").removeAttr('onclick');
		$(".img_change").removeAttr('data-toggle');
		$(".img_change").removeAttr('data-target');
		$('.img_change').each(function () {
			var this_id = $(this).attr('id').substr(6);
			$(this).attr("onclick","active_delete("+this_id+");");
		});

		$("#button_active").removeAttr('onclick');
		$("#button_active").attr("onclick","getcheck(0);");
		$("#p_active").html('<i class="fa fa-times fa-fw"></i> Hủy chọn');
	}
	else {
        $("#btn_delete").hide();
		$(".check_active").addClass("unactive");
		$("#button_active").attr("onclick","getcheck(1);");
		$('.img_change').each(function () {
			var this_id = $(this).attr('id').substr(6);
			$(this).attr("onclick","getinfoimg("+this_id+");");
		});
		$(".img_change").attr('data-toggle','modal');
		$(".img_change").attr('data-target','#UpdateFrom');
		$("#p_active").html('<i class="fa fa-check fa-fw"></i> Chọn nhiều');
		$(".active_img").attr("class","img_div");
	}
}

function active_delete(id) {
	$("#div_active"+id).toggleClass("active_img");
	$("#check_active"+id).toggleClass("unactive");
}

function DeleteAll(mod, site) {
	if (!site || site == '' || site == null || site == 'undefined')
		site = "ajax_load_delete_media";
	var arr = [];
	$(".active_img").each(function () {
		var this_id = $(this).attr('id').substr(10);
		arr.push(this_id);
	});
	if (arr.length < 1) {
		var notice = new PNotify({
			title: 'Chọn mục xử lí',
			text: 'Vui lòng chọn các mục cần xử lí',
			type: 'info',
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
		return false;
	}
	var str = arr.toString();
	$('#ConfirmBulkDelete').modal('show');
	$('#DeleteBulk').unbind().click(function () {
		$('#ConfirmBulkDelete').modal('hide');
		$.post("?mod="+mod+"&site="+site+"", {'id': str}).done(function (data) {
			var data = JSON.parse(data);
			var deleted_id = data.deleted_id.split("-");
			$.each(deleted_id, function (index, value) {
				$('#field' + value).css('background', '#F2DEDE').fadeOut(700);
				setTimeout(function () {
					$('#field' + value).remove();
					$(".item").removeAttr("style");
					try {
						CheckTbody();
						CancelEdit();
					} catch(e) {
						return false;
					}
				}, 700);
			});
			if (data.deleted != null && data.deleted != '') {
				var notice = new PNotify({
					title: 'Đã xóa',
					text: '<b>'+data.deleted+'</b>',
					type: 'success',
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
			if (data.notdeleted != null && data.notdeleted != '') {
				var notice = new PNotify({
					title: 'Không thể xóa',
					text: '<b>'+data.notdeleted+'</b>',
					type: 'error',
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
			try {
				RenewSelect();
			} catch(e) {
				return false;
			}
		});
	});
}

function filter() {
	var type = $("#type_filter").val();
	var url = "?mod=media&site=index";
	url += "&type=" + type;
	window.location.href = url;
}
</script>
{/literal}