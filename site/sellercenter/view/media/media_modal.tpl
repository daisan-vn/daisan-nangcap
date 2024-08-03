<!-- Modal Avatar -->
<div class="modal fade" id="LoadMedia">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-body">
				<div>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
					<!-- Nav tabs -->
					<ul class="nav nav-tabs" id="myTab" role="tablist">
						<li class="nav-item active"><a class="nav-link active" id="home-tab"
							data-toggle="tab" href="#home" role="tab" aria-controls="home"
							aria-selected="true">Thư
								viện media</a></li>
						<li class="nav-item"><a class="nav-link" id="home-tab"
							data-toggle="tab" href="#profile" role="tab" aria-controls="home"
							aria-selected="true">Upload file</a></li>
					</ul>

					<!-- Tab panes -->
					<div class="tab-content">
						<div class="tab-pane active" id="home">
							<input type="hidden" id="MediaAction">
							<div class="row">
								<div class="col-md-3 col-sm-4" id="folder_view"
									style="margin: 15px 0;">{include '../media/folder.tpl'}</div>
								<div class="col-md-9 col-sm-8" id="media_view">{include
									'../media/select_media.tpl'}</div>
							</div>
						</div>
						<div class="tab-pane" id="profile">
							<form id="ajax_upload_form" class="form-horizontal" method="post"
								enctype="multipart/form-data">
								<br>
								<div class="form-group">
									<label class="col-lg-2 col-md-3 col-sm-4 control-label">Chọn
										file</label>
									<div class="col-lg-10 col-md-9 col-sm-8">
										<input type="file" required name="image" id="UploadMedia">
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-lg-2 col-md-3 col-sm-4">Thư
										mục</label>
									<div class="col-lg-4 col-md-5 col-sm-7">
										<select class="form-control col-md-9" name="taxonomy_id">{$out.select_media_folder}
										</select>
									</div>
								</div>
								<div class="form-group">
									<div
										class="col-lg-10 col-lg-offset-2 col-md-9 col-md-offset-3 col-sm-8 col-sm-offset-4">
										<button id="ajax_action" class="btn btn-primary" type="button">
											<i class="fa fa-cloud-upload fa-fw"></i> Tải lên và chọn
										</button>
									</div>
								</div>
							</form>
						</div>
					</div>

				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
			</div>
		</div>
	</div>
</div>

<script>
	var active_folder = 0;
</script>
{literal}
<script>
	ReloadFolder(0);
	function ReloadFolder(cur_folder, show_file) {
		$.post("?mod=media&site=reload_folder", {
			'active_folder' : cur_folder,
			'show_file' : show_file
		}).done(function(e) {
			$('#folder_view1').html(e);
		});
	}

	function ReloadSelectMedia(action, folder, page) {
		$('#media_view')
				.html(
						'<div class="media_loading text-primary text-center"><i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i> <h4>Đang tải</h4></div>');
		$.post("?mod=media&site=reload_select_media", {
			'action' : action,
			'folder' : folder,
			'page' : page
		}).done(function(e) {
			$('#media_view').html(e);
		});
	}

	function ChangeFolder(id) {
		var action = $("#LoadMedia #MediaAction").val();
		ReloadFolder(id);
		ReloadSelectMedia(action, id, 1);
		active_folder = id;
	}

	function GetFileFolder() {
		var action = "File2Editor";
		//ReloadFolder(0);
		$('#media_view')
				.html(
						'<div class="media_loading text-primary text-center"><i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i> <h4>Đang tải</h4></div>');
		$.post("?mod=media&site=reload_select_media", {
			'action' : action,
			'folder' : 0,
			'page' : 1
		}).done(function(e) {
			$('#media_view').html(e);
		});
		$("#FolderList li").removeClass('active');
		$("#FolderList li#FileFolder").addClass('active');
		active_folder = 0;
	}

	function LoadMedia(action, option) {
		$("#LoadMedia").modal("show");
		$("#LoadMedia #MediaAction").val(action);
		$("#FileFolder").hide();
		var show_file = 0;
		if (action == 'Image2Editor')
			show_file = 1;
		ReloadFolder(0, show_file);
		ReloadSelectMedia(action, 0);
		$.post("?mod=media&site=ajax_load_modal_media").done(
				function(e) {
					var data = JSON.parse(e);
					$('#ajax_upload_form select[name=taxonomy_id]').html(
							data.select_category);
				});

		if (action == 'SetPostAvatar')
			$('#ajax_action').attr('onclick', 'AjaxUploadImage(0)');
		else if (action == 'Image2Editor') {
			$('#ajax_action').attr('onclick', 'AjaxUploadImage(1)');
			$("#FileFolder").show();
		} else if (action == 'SetListImage')
			$('#ajax_action').attr('onclick', 'AjaxUploadImage(2)');
		else if (action == 'SetImgRls') {
			$('#DataImgCate').val(option);
			$('#ajax_action').attr('onclick', 'AjaxUploadImage(3)');
		} else if (action == 'SetTaxAvatar') {
			$('#TaxId').val(option);
			$('#ajax_action').attr('onclick', 'AjaxUploadImage(4)');
		} else if (action == 'ChangeImage') {
			$("#ViewImage").modal('hide');
			$('#ajax_action').attr('onclick', 'AjaxUploadImage(5)');
		}
	}

	function MediaPaging(page) {
		var action = $("#LoadMedia #MediaAction").val();
		ReloadSelectMedia(action, active_folder, page);
	}

	function AjaxUploadImage(action) {
		if ($('#ajax_upload_form input[name=image]').val() == '') {
			PNotify.removeAll();
			noticeMsg('Vui lòng chọn file',
					'Hãy chọn file và thư mục để upload', 'info');
			return false;
		}
		$('#ajax_action')
				.html(
						'<i class="fa fa-circle-o-notch fa-spin fa-fw"></i> Đang tải lên')
				.prop('disabled', true);
		var formdata = new FormData($('#ajax_upload_form')[0]);
		$.post({
			url : '?mod=media&site=ajax_upload',
			data : formdata,
			contentType : false,
			processData : false,
			success : function(e) {
				if (action == 0)
					SetPostAvatar(e);
				else if (action == 1)
					Image2Editor(e);
				else if (action == 2)
					SetListImage(e);
				else if (action == 3)
					SetImgRls(e);
				else if (action == 4)
					SetTaxAvatar(e);
				else if (action == 5)
					ChangeImage(e);
				$('#ajax_upload_form input[name=image]').val('');
				$('#ajax_action').html(
						'<i class="fa fa-upload fa-fw"></i> Tải lên và chọn')
						.prop('disabled', false);
			}
		});
	}

	$('#LoadMedia').on(
			'hidden.bs.modal',
			function() {
				$('#ajax_upload_form')[0].reset();
				$('#ajax_action').html(
						'<i class="fa fa-upload fa-fw"></i> Tải lên và chọn')
						.prop('disabled', false);
				$('.nav-tabs a:first').tab('show');
			});

	function SetPostAvatar(id) {
		$('#LoadMedia').modal('hide');
		$('#img_id').val(id);
		$.post("?mod=media&site=ajax_get_image", {
			'id' : id
		}).done(
				function(e) {
					$('#PostAvatar').attr('src', decodeURIComponent(e))
							.removeClass('hidden');
				});
	}

	function Image2Editor(id) {
		$('#LoadMedia').modal('hide');
		$.post("?mod=media&site=ajax_get_image", {
			'id' : id,
			'thumb' : 0
		})
				.done(
						function(e) {
							tinymce.get("post_content")
									.execCommand(
											'mceInsertContent',
											false,
											'<img src="'
													+ decodeURIComponent(e)
													+ '">');
						});
	}

	$('#LoadMedia').on('shown.bs.modal', function() {
		var wimg = $('.col-media').width();
		$('.col-media').css('height', wimg + 'px');
	});
</script>
{/literal}
