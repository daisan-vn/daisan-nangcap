<div class="card-header">
	<h3>Khởi tạo sản phẩm</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<form method="post">

		<div class="card mb-3">
			<div class="card-header">Thông tin sản phẩm</div>
			<div class="card-body">
				<input type="hidden" name="id" value="{$product.id|default:0}">
				<input type="hidden" name="folder" value="{$product.folder|default:''}">
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Tên sản phẩm</label>
					<div class="col-sm-7">
						<input type="text" class="form-control" name="name" value="{$product.name|default:''}">
					</div>
					<div class="col-sm-1 col-form-label"><a href="{$product.source}" target="_blank">Nguồn</a></div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Mã sản phẩm</label>
					<div class="col-sm-3">
						<input type="text" class="form-control" name="code" value="{$product.code|default:''}">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Tên thương hiệu</label>
					<div class="col-sm-4">
						<input type="text" class="form-control" name="trademark" value="{$product.trademark|default:''}">
					</div>
				</div>
				<div class="form-group row row-sm">
					<label class="col-sm-2 col-form-label">Từ khóa</label>
					<div class="col-sm-3">
						<input type="text" class="form-control keyword" name="key[]" value="{$keywords[0]|default:''}">
					</div>
					<div class="col-sm-3">
						<input type="text" class="form-control keyword" name="key[]" value="{$keywords[1]|default:''}">
					</div>
					<div class="col-sm-3">
						<input type="text" class="form-control keyword" name="key[]" value="{$keywords[2]|default:''}">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Thời gian giao hàng</label>
					<div class="col-sm-6">
						<input type="text" class="form-control" name="ordertime" value="{$product.ordertime|default:''}">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Khả năng cung cấp</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" name="ability" value="{$product.ability|default:''}" placeholder="Vd: Cung cấp 1000 sản phẩm/ ngày">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Số lượng đặt hàng tối thiểu</label>
					<div class="col-sm-2">
						<input type="text" class="form-control" name="minorder" value="{$product.minorder|default:1}">
					</div>
				</div>
				<div class="form-group row">
				<label class="col-sm-2 col-form-label">Số lượng tồn kho</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" name="inventory" value="{$product.inventory|default:1}">
				</div>
				<div class="col-sm-2">
					<select class="form-control" name="unit_id">{$product.s_unit}</select>
				</div>
			</div>
			</div>
		</div>
		
		<div class="card mb-3">
			<div class="card-header">
				<div class="row">
					<div class="col-md-8">Mô tả thêm thông tin</div>
					<div class="col-md-4 text-right">
						<button type="button" class="btn btn-light btn-sm" onclick="AddDetail();"><i class="fa fa-plus fa-fw"></i>Thêm</button>
					</div>
				</div>
			</div>
			<div class="card-body" id="LoadDetail"></div>
		</div>

		<div class="card mb-3">
			<div class="card-header">
				<div class="row">
					<div class="col-md-8">Mô tả thêm thông tin</div>
				</div>
			</div>
			<div class="card-body">
				<div class="mb-2">
					<input type="hidden" name="images" value="{$product.images|default:''}">
					<input type="file" id="UploadImg"> 
					<small class="form-text text-muted"> Kích thước file ảnh tối đa 300Mb, hỗ trợ định dạng jpg, png.</small>
				</div>

				<div class="row">
					<div class="col-sm-11">
						<div class="card-group mb-4" id="ShowImg">
							{foreach from=$a_image_show key=k item=img}
							<div class="card" id="Img{$k}">
								<div class="card-body align-middle p-0">
									<img alt="{$k}" src="{$img}" width="100%">
								</div>
								<div class="card-footer text-center p-1">
									{if $img eq $arg.noimg}
									<small>No Image</small>
									{else}
									<small><a href="javascript:void(0);" onclick="RemoveImg({$k});">Remove image</a></small>
									{/if}
								</div>
							</div>
							{/foreach}
						</div>
					</div>
				</div>
			
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Mô tả sản phẩm</label>
					<div class="col-sm-9">
						<textarea class="form-control" name="description" rows="12" id="post_content">{$product.description|default:''}</textarea>
					</div>
				</div>

				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Quy cách đóng gói</label>
					<div class="col-sm-9">
						<textarea class="form-control" name="package" rows="8">{$product.package|default:''}</textarea>
					</div>
				</div>

				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Câu hỏi thường gặp</label>
					<div class="col-sm-9">
						<textarea class="form-control" name="qa" rows="8">{$product.qa|default:''}</textarea>
					</div>
				</div>
			
			
			</div>
		</div>

	
		<div class="card mb-3">
			<div class="card-header">
				<div class="row">
					<div class="col-md-8">Bảng giá sản phẩm</div>
					<div class="col-md-4 text-right">
						<button type="button" class="btn btn-light btn-sm" onclick="AddPrice();"><i class="fa fa-plus fa-fw"></i>Thêm</button>
					</div>
				</div>
			</div>
			<div class="card-body" id="LoadPrice"></div>
		</div>
		
		<div class="form-group row">
			<div class="col-sm-10">
				<button type="submit" name="submit" class="btn btn-primary btn-lg">Lưu thông tin</button>
			</div>
		</div>
	</form>
</div>
{include '../media/media_modal.tpl'}
<input type="hidden" name="json_keywords" value='{$json_keywords}'>

<link href="{$arg.stylesheet}plugins/chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}plugins/chosen/chosen.jquery.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce-config.js"></script>
{literal}
<script>
var ArrImg = [];
var Images = $("input[name=images]").val();
var Folder = $("input[name=folder]").val();
if(Images!='') ArrImg = Images.split(';');
var id = $("input[name=id]").val();
var json_keywords = JSON.parse($("input[name=json_keywords]").val());

$(window).ready(function(){
	$( ".keyword" ).autocomplete({
	      source: json_keywords
	});
	LoadImgForm();
	$('#UploadImg').change(function() {
		var Number = ArrImg.length;
		if (Number > 5){
			noticeMsg('Thông báo', 'Đã vượt quá số lượng ảnh được phép đăng.', 'error');
		}else if (this.files && this.files[0]) {
			var fileType = this.files[0]["type"];
			var fileName = this.files[0]["name"];
			var ValidImageTypes = ["image/jpeg","image/png"];
			
			if ($.inArray(fileType, ValidImageTypes)>=0) {
				var reader = new FileReader();
				reader.onload = function(e) {
					var Data = {};
					Data['imgname'] = fileName;
					Data['img'] = e.target.result;
					Data['ajax_action'] = 'upload_images';
					loading();
					$.post('?mod=product&site=editdetail&id='+id, Data).done(function(e){
						ArrImg.push(e);
						LoadImgForm();
						endloading();
					});
				}
				reader.readAsDataURL(this.files[0]);
			}else{
				noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng.', 'error');
			}
		}
		$("#UploadImg").val('');
	});
});

function RemoveImg(Key){
	var Data = {};
	Data['imgname'] = ArrImg[Key];
	Data['ajax_action'] = 'remove_images';
	loading();
	$.post('?mod=product&site=editdetail&id='+id, Data).done(function(e){
		ArrImg.splice(Key, 1);
		LoadImgForm();
		endloading();
	});
}

function LoadImgForm(){
	$('#ShowImg img').attr('src', arg.noimg);
	$("#ShowImg small").html('No image');
	$.each(ArrImg, function(k, item){
		$('#Img'+k+' img').attr('src', Folder+item);
		$("#Img"+k+" small").html('<a href="javascript:void(0)" onclick="RemoveImg('+k+');">Remove</a>');
	});
}

$(".chosen").chosen({disable_search_threshold: 10});
$("#LoadDetail").load('?mod=product&site=load_details');
$("#LoadPrice").load('?mod=product&site=load_prices');

function AddDetail(){
	$.post('?mod=product&site=ajax_handle', {'ajax_action':'add_detail'}).done(function(e){
		var rt = JSON.parse(e);
		if(rt.code==0){
			noticeMsg('Thông báo', rt.msg, 'error');
			return false;
		}
		$("#LoadDetail").load('?mod=product&site=load_details');
	});
}
function SetDetail(type, id, value){
	var Data = {};
	Data['type'] = type;
	Data['id'] = id;
	Data['value'] = value;
	Data['ajax_action'] = 'set_detail';
	$.post('?mod=product&site=ajax_handle', Data).done(function(){
		noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
	});
}
function DeleteDetail(id){
	$.post('?mod=product&site=ajax_handle', {'ajax_action':'delete_detail','id':id}).done(function(){
		$("#LoadDetail").load('?mod=product&site=load_details');
	});
}
function SortDetail(id, type){
	$.post('?mod=product&site=ajax_handle', {'ajax_action':'sort_detail','id':id,'type':type}).done(function(){
		$("#LoadDetail").load('?mod=product&site=load_details');
	});
}

/*-------------------*/
function AddPrice(){
	$.post('?mod=product&site=ajax_handle', {'ajax_action':'add_price'}).done(function(e){
		var data = JSON.parse(e);
		if(data.code==1){
			$("#LoadPrice").load('?mod=product&site=load_prices');
		}else{
			noticeMsg('Thông báo', data.msg, 'error');
		}
	});
}
function SetPrice(type, id, value){
	var Data = {};
	Data['type'] = type;
	Data['id'] = id;
	Data['value'] = value;
	Data['ajax_action'] = 'set_price';
	$.post('?mod=product&site=ajax_handle', Data).done(function(){
		noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
	});
}
function DeletePrice(id){
	$.post('?mod=product&site=ajax_handle', {'ajax_action':'delete_price','id':id}).done(function(){
		$("#LoadPrice").load('?mod=product&site=load_prices');
	});
}
function SortPrice(id, type){
	$.post('?mod=product&site=ajax_handle', {'ajax_action':'sort_price','id':id,'type':type}).done(function(){
		$("#LoadPrice").load('?mod=product&site=load_prices');
	});
}
</script>
{/literal}
