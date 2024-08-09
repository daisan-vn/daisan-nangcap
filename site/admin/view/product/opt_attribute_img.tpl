<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Thêm lựa chọn thuộc tính</h1>
		</div>
		<div class="col-md-4 text-right">
		</div>
	</div>
</div>
<form method="post" enctype="multipart/form-data">
	<input type="hidden" name="folder" value="{$folder|default:''}">
	<div class="panel panel-primary">
		<div class="panel-heading">
			<div class="row">
				<div class="col-md-4">
					<a href="?mod=product&site=list_attribute" class="btn btn-primary btn-sm">
						<i class="fa fa-list fa-fw"></i>
						Thuộc tính
					</a>
				</div>
				<div class="col-md-8 text-right">
					<a href="?mod=product&site=opt_attribute&id={$smarty.get.id}" class="btn btn-success btn-sm">
						<i class="fa fa-plus fa-fw"></i>
						Thêm thuộc tính con
					</a>
					<a href="?mod=product&site=attribute" class="btn btn-success btn-sm">
						<i class="fa fa-plus fa-fw"></i>
						Thêm loại thuộc tính mới
					</a>
				</div>
			</div>
		</div>
		<div class="panel-body">
			<div class="table-responsive">
				<table class="table table-bordered table-hover table-striped">
					<thead>
						<tr>
							<th class="text-center" width="20%">Loại thuộc tính</th>
							<th>Thuộc tính con</th>
							
						</tr>
					</thead>
					<tbody>
						{if count($result)>0}
						{foreach from=$result key=k item=v}
						<tr>
							<th class="text-right">
								{$v.name}
								<input class="form-control" type="hidden" name="name_{$k}" value="{$v.name}">
							</th>
							<td>
								{foreach from=$v.contents key=k2 item=v2}
								{if $k2!= 0}
								<hr>
								{/if}
								<p>
									<div class="row">
										<div class="col-md-4">
											<span class="text-small">
												{$v2.name}
												<input class="form-control" type="hidden" name="name_{$k}_{$k2}" value="{$v2.name}">
											</span>
										</div>
										<div class="col-md-4">
											<div id="ShowImg">
												{if $v2.img_name}
													{$imgName = $v2.img_name}
													{$url_img = "$folder$imgName"}
												{else}
													{$imgName = "default.png"}
													{$url_img = "$folder$imgName"}
												{/if}
												<input type="hidden" name="imgName_{$k}_{$k2}" id="imgName_{$k}_{$k2}" value="{$v2.img_name}">
												<input type="hidden" name="imgID_{$k}_{$k2}" id="imgID_{$k}_{$k2}" value="{$v2.img_id}">
												<img class="img-fluid" id="img_{$k}_{$k2}" src="{$url_img}" alt="" style="max-width: 80px;">
												<input type="file" name="fileName_{$k}_{$k2}" id="fileName_{$k}_{$k2}" onclick="AjaxUploadImg('{$k}_{$k2}');">
											
											</div>
										</div>
										<div class="col-md-4 text-right">
											<button type="button" class="btn btn-default btn-danger"  onclick="RemoveImgAttr('{$k}_{$k2}');">
												<i class="fa fa-trash fa-fw"></i>
												Xóa hình
											</button>
										</div>
										
									</div>
								</p>
								
								{/foreach}
								
								<input type="hidden" name="lenght_attribute_{$k}" value="{count($v.contents)}">
							</td>
							
						</tr>
						{/foreach}
						{/if}
						
					</tbody>
				</table>
			</div>

			<hr>

			
		</div>
		<div class="panel-body">
			<div class="form-group row">
				<div class="col-sm-10">
					<input type="hidden" name="lenght_attribute" value="{count($result)}">
					<input type="hidden" name="folder_url" id="folder_url" value="{$folder}">
					<button type="submit" name="submit" class="btn btn-primary btn-lg">Lưu thông tin</button>
				</div>
			</div>
		</div>
	</div>
</form>

<input type="hidden" name="id" value="{$id}">
<input type="hidden" name="json_keywords" value='{$json_keywords|default:'{}'}'>

<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce-config.js"></script>

{literal}
<script>
	var ArrImg = [];
	var Images = $("input[name=images]").val();
	var Folder = $("input[name=folder]").val();
	if (Images) ArrImg = Images.split(';');
	var id = $("input[name=id]").val();
	var json_keywords = JSON.parse($("input[name=json_keywords]").val());

	// $("select#attribute_id").change(function () {
	// 	var selected = $(this).children("option:selected").val();
	// });

	$(window).ready(function () {
		$(".keyword").autocomplete({
			source: json_keywords
		});
		LoadImgForm();
		$('#UploadImg').change(function () {
			var Number = ArrImg.length;
			if (Number > 5) {
				noticeMsg('Thông báo', 'Đã vượt quá số lượng ảnh được phép đăng.', 'error');
			} else if (this.files && this.files[0]) {
				var fileType = this.files[0]["type"];
				var fileName = this.files[0]["name"];
				var ValidImageTypes = ["image/jpeg", "image/png"];

				if ($.inArray(fileType, ValidImageTypes) >= 0) {
					var reader = new FileReader();
					reader.onload = function (e) {
						var Data = {};
						Data['imgname'] = fileName;
						Data['img'] = e.target.result;
						Data['ajax_action'] = 'upload_images';
						loading();
						$.post('?mod=product&site=ajax_handle&id=' + id, Data).done(function (e) {
							ArrImg.push(e);
							LoadImgForm();
							endloading();
						});
					}
					reader.readAsDataURL(this.files[0]);
				} else {
					noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng.', 'error');
				}
			}
			$("#UploadImg").val('');
		});

		$("#unit_name").val($("#unit_id option:selected").html());
		$("#unit_id").change(function () {
			$.each($("#unit_id option:selected"), function () {
				$("#unit_name").val($(this).html());
			});
		});
	});
	

	function RemoveImgAttr($id) {
		var tag_name = "imgName_"+ $id;
		var tag_img = "img_" + $id;
		var tag_id = "imgID_" + $id;

		var name = $("#"+tag_name);
		var img = $("#"+ tag_img);
		var id = $("#" + tag_id);
		var url = $("#folder_url").val();

		var group_id = $("input[name=id]").val();
		
		if (confirm("Bạn có chắc muốn xóa hình này") == true) {
			var Data = {};
			Data['ajax_action'] = 'remove_image_attribute';
			Data['folder'] = url;
			Data['imgName'] = name.val();
			Data['imgID'] = id.val();
			Data['groupID'] = group_id;

			loading();
			$.post('?mod=product&site=ajax_handle&id=' + id.val(), Data).done(function (e) {
				if (e == true) {
					name.val('');
					id.val(0)
					img.attr('src', url + 'default.png');
				}
				endloading();
			});
		}
		
	}

    function AjaxUploadImg($key){
        // var str_fileName = "#fileName_"+ $key;
        // var file_data = $(str_fileName).prop('files')[0];
        // var type = file_data.type;
        // var match = ["image/gif", "image/png", "image/jpg",];
        // var form_data = new FormData();
        // Data['ajax_action'] = 'remove_images';
        // form_data.append('file', file_data);

        
        // loading();
        // $.post('?mod=product&site=ajax_handle&id=' + id, form_data).done(function (e) {

        //     endloading();
        // });
    }

	function LoadCategory(id, level) {
		var Data = {};
		Data['id'] = id;
		Data['ajax_action'] = "load_category";
		var id_set = level + 1;

		loading();
		$.post('?mod=product&site=ajax_handle', Data).done(function (e) {
			$("#Cate" + id_set + " select").html(e);
			endloading();
		});
	}

	function RemoveImg(Key) {
		var Data = {};
		Data['imgname'] = ArrImg[Key];
		Data['ajax_action'] = 'remove_images';
		loading();
		$.post('?mod=product&site=ajax_handle&id=' + id, Data).done(function (e) {
			ArrImg.splice(Key, 1);
			LoadImgForm();
			endloading();
		});
	}

	function LoadImgForm() {
		// $('#ShowImg img').attr('src', arg.noimg);
		$("#ShowImg small").html('No image');
		$.each(ArrImg, function (k, item) {
			$('#Img' + k + ' img').attr('src', Folder + item);
			$("#Img" + k + " small").html('<a href="javascript:void(0)" onclick="RemoveImg(' + k + ');">Remove</a>');
		});
	}

	$(".chosen").chosen({ disable_search_threshold: 10 });
	$("#LoadDetail").load('?mod=product&site=load_details');
	$("#LoadPrice").load('?mod=product&site=load_prices');

	function AddDetail() {
		$.post('?mod=product&site=ajax_handle', { 'ajax_action': 'add_detail' }).done(function (e) {
			var rt = JSON.parse(e);
			if (rt.code == 0) {
				noticeMsg('Thông báo', rt.msg, 'error');
				return false;
			}
			$("#LoadDetail").load('?mod=product&site=load_details');
		});
	}
	function SetDetail(type, id, value) {
		var Data = {};
		Data['type'] = type;
		Data['id'] = id;
		Data['value'] = value;
		Data['ajax_action'] = 'set_detail';
		$.post('?mod=product&site=ajax_handle', Data).done(function () {
			noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
		});
	}
	function DeleteDetail(id) {
		$.post('?mod=product&site=ajax_handle', { 'ajax_action': 'delete_detail', 'id': id }).done(function () {
			$("#LoadDetail").load('?mod=product&site=load_details');
		});
	}
	function SortDetail(id, type) {
		$.post('?mod=product&site=ajax_handle', { 'ajax_action': 'sort_detail', 'id': id, 'type': type }).done(function () {
			$("#LoadDetail").load('?mod=product&site=load_details');
		});
	}

	/*-------------------*/
	function AddPrice() {
		$.post('?mod=product&site=ajax_handle', { 'ajax_action': 'add_price' }).done(function (e) {
			var data = JSON.parse(e);
			if (data.code == 1) {
				$("#LoadPrice").load('?mod=product&site=load_prices');
			} else {
				noticeMsg('Thông báo', data.msg, 'error');
			}
		});
	}
	function SetPrice(type, id, value) {
		var Data = {};
		Data['type'] = type;
		Data['id'] = id;
		Data['value'] = value;
		Data['ajax_action'] = 'set_price';
		$.post('?mod=product&site=ajax_handle', Data).done(function () {
			noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
		});
	}
	function DeletePrice(id) {
		$.post('?mod=product&site=ajax_handle', { 'ajax_action': 'delete_price', 'id': id }).done(function () {
			$("#LoadPrice").load('?mod=product&site=load_prices');
		});
	}
	function SortPrice(id, type) {
		$.post('?mod=product&site=ajax_handle', { 'ajax_action': 'sort_price', 'id': id, 'type': type }).done(function () {
			$("#LoadPrice").load('?mod=product&site=load_prices');
		});
	}
</script>
{/literal}