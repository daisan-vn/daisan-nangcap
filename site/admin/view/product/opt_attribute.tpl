<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Thêm lựa chọn thuộc tính</h1>
		</div>
		<div class="col-md-4 text-right">
		</div>
	</div>
</div>
<form method="post">
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
					<a href="?mod=product&site=opt_attribute_img&id={$smarty.get.id}" class="btn btn-success btn-sm">
						<i class="fa fa-plus fa-fw"></i>
						Thêm hình cho thuộc tính con
					</a>
					<a href="?mod=product&site=attribute" class="btn btn-success btn-sm">
						<i class="fa fa-plus fa-fw"></i>
						Thêm loại thuộc tính mới
					</a>
				</div>
			</div>
		</div>
		<div class="panel-body">
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Loại thuộc tính</label>
				<label class="col-sm-8 col-form-label">Lựa chọn cho thuộc tính</label>
			</div>
			<hr>
			<!-- dataAttribute -->
			<div class="class" id="contentsAttribute">
				{if count($result)>0}
				{foreach from=$result key=k item=v}
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">{$v.name}</label>
					<div class="col-sm-8">
						<input class="form-control" type="hidden" name="name_{$k+1}" value="{$v.name}">
						<textarea class="form-control" name="contents_{$k+1}" rows="8" placeholder="lựa chọn 1 <enter>
lựa chọn 2 <enter>">{$v.show_content}</textarea>
						<input type="hidden" name="lenght_attribute_child_{$k+1}" value="{count($v.contents)}">
					</div>
				</div>
				{/foreach}
				{/if}
			</div>
			
		</div>
		<div class="panel-body">
			<div class="form-group row">
				<div class="col-sm-10">
					<input type="hidden" name="lenght_attribute" value="{count($result)}">
					<button type="submit" name="submit" class="btn btn-primary btn-lg">Lưu thông tin</button>
				</div>
			</div>
		</div>
	</div>
</form>
<input type="hidden" name="json_keywords" value='{$json_keywords}'>

<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce-config.js"></script>

{literal}
<script>
	var ArrImg = [];
	var Images = $("input[name=images]").val();
	var Folder = $("input[name=folder]").val();
	if (Images != '') ArrImg = Images.split(';');
	var id = $("input[name=id]").val();
	var json_keywords = JSON.parse($("input[name=json_keywords]").val());
	// $("select#attribute_id").change(function () {
	// 	console.log('change attribute');
	// 	var selected = $(this).children("option:selected").val();
	// 	console.log(selected);
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

	function changeAttribute($value) {


		// var Data = {};
		// Data['id'] = $value;
		// Data['ajax_action'] = "load_detail_attribute";
		// console.log($value);
		// loading();
		// $.post('?mod=product&site=ajax_handle', Data).done(function (e) {
		// 	var $data = JSON.parse(e);
		// 	var xhtml = "";
		// 	$data.forEach((element, index) => {
		// 		var i = index + 1;
		// 		xhtml += `<div class="form-group row">
		// 		<label class="col-sm-2 col-form-label">`+ element + `</label>
		// 		<div class="col-sm-8">
		// 			<input type="hidden" name="detail_attribute_name_`+ i + `" value="` + element + `">
		// 			<input type="text" class="form-control" name="detail_attribute_content_`+ i + `">
		// 		</div>
		// 	</div>`;
		// 	});

		// 	$("#detailAttribute").html(xhtml);
		// 	$("#lenght_attribute").val($data.length);
		// 	console.log($data.length);
		// 	// lenght_attribute
		// 	endloading();
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
		$('#ShowImg img').attr('src', arg.noimg);
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