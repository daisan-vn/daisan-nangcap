<div class="card-header">
	<h3>Hình ảnh trên website</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<div>
		<div class="card-header mb-3">Hình ảnh trên website</div>
		<input type="hidden" name="images" class="form-control" value="{$profile.img_sliders|default:''}"> 
		<input type="hidden" name="folder" class="form-control" value="{$arg.url_upload}{$page.folder|default:''}"> 
		
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Hình ảnh sliders</label>
			<div class="col-sm-10">

				<div class="mb-2">
					<input type="file" id="UploadImg"> 
					<small class="form-text text-muted"> Kích thước file ảnh tối đa 500Mb, hỗ trợ định dạng jpg, png.</small>
				</div>

				<div class="card-group" id="ShowImg">
					{foreach from=$a_sliders_show key=k item=img}
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
		<hr>


		<div class="form-group row" id="img_intro">
			<label class="col-sm-2 col-form-label">Ảnh banner trang giới thiệu</label>
			<div class="col-sm-8">
				<div class="row row-sm">
					<div class="col-md-6">
						<span class="border d-block" style="min-height: 93px">
							<img src="{$profile.img_intro_show}" width="100%" height="93">
						</span>
					</div>
					<div class="col-md-6">
						<input type="file" class="mt-3" onchange="UploadImg(this.files[0], 'img_intro', 1200);"> 
						<small class="form-text text-muted"> Kích thước file tối đa 500Mb, hỗ trợ định dạng jpg, png.</small>
					</div>
				</div>
			</div>
		</div>
		<hr>

		<div class="form-group row" id="img_service">
			<label class="col-sm-2 col-form-label">Ảnh banner trang dịch vụ</label>
			<div class="col-sm-8">
				<div class="row row-sm">
					<div class="col-md-6">
						<span class="border d-block" style="min-height: 93px">
							<img src="{$profile.img_service_show}" width="100%" height="93">
						</span>
					</div>
					<div class="col-md-6">
						<input type="file" class="mt-3" onchange="UploadImg(this.files[0], 'img_service', 1200);"> 
						<small class="form-text text-muted"> Kích thước file tối đa 500Mb, hỗ trợ định dạng jpg, png.</small>
					</div>
				</div>
			</div>
		</div>
		<hr>

		<div class="form-group row" id="img_product">
			<label class="col-sm-2 col-form-label">Ảnh banner trang sản phẩm</label>
			<div class="col-sm-8">
				<div class="row row-sm">
					<div class="col-md-6">
						<span class="border d-block" style="min-height: 93px">
							<img src="{$profile.img_product_show}" width="100%" height="93">
						</span>
					</div>
					<div class="col-md-6">
						<input type="file" class="mt-3" onchange="UploadImg(this.files[0], 'img_product', 1200);"> 
						<small class="form-text text-muted"> Kích thước file tối đa 500Mb, hỗ trợ định dạng jpg, png.</small>
					</div>
				</div>
			</div>
		</div>
		<hr>

		<div class="form-group row" id="img_contact">
			<label class="col-sm-2 col-form-label">Ảnh banner trang liên hệ</label>
			<div class="col-sm-8">
				<div class="row row-sm">
					<div class="col-md-6">
						<span class="border d-block" style="min-height: 93px">
							<img src="{$profile.img_contact_show}" width="100%" height="93">
						</span>
					</div>
					<div class="col-md-6">
						<input type="file" class="mt-3" onchange="UploadImg(this.files[0], 'img_contact', 1200);"> 
						<small class="form-text text-muted"> Kích thước file tối đa 500Mb, hỗ trợ định dạng jpg, png.</small>
					</div>
				</div>
			</div>
		</div>

	</div>
</div>

{literal}
<script>
var ArrImg = [];
var Images = $("input[name=images]").val();
var Folder = $("input[name=folder]").val();
if(Images!='') ArrImg = Images.split(';');

$(window).ready(function(){
	LoadImgForm();
	$('#UploadImg').change(function() {
		var Number = ArrImg.length;
		if (Number > 3){
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
					$.post('?mod=theme&site=images', Data).done(function(e){
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
	$.post('?mod=theme&site=images', Data).done(function(e){
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

function UploadImg(fileImg, type, width){
	var fileType = fileImg["type"];
	var fileName = fileImg["name"];
	var ValidImageTypes = ["image/jpeg", "image/png"];
	if ($.inArray(fileType, ValidImageTypes)>=0) {
		var reader = new FileReader();
		reader.onload = function(e) {
			var Data = {};
			Data['imgname'] = fileName;
			Data['img'] = e.target.result;
			Data['type'] = type;
			Data['width'] = width;
			loading();
			$.post('?mod=theme&site=ajax_upload_img', Data).done(function(e){
				if(e==0) noticeMsg('Xảy ra lỗi', 'Không thể lưu được ảnh, vui lòng thử lại sau.', 'error');
				else{
					$("#"+type+" img").attr('src', e);
					noticeMsg('Thông báo', 'Thay đổi ảnh mới thành công.', 'success');
				}
				endloading();
			});
		}
		reader.readAsDataURL(fileImg);
	}else{
		noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng jpg hoặc png.', 'error');
	}
	$("#"+type+" input").val('');
}

</script>
{/literal}