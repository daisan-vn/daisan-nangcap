<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Thông tin giới thiệu công ty
			</h1>
		</div>
	</div>
</div>

<div class="card-body">
	
	<form method="post">
		<input type="hidden" name="images" class="form-control" value="{$profile.images|default:''}"> 
		<input type="hidden" name="folder" class="form-control" value="{$arg.url_upload}{$page.folder|default:''}"> 
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Giới thiệu sơ lược</label>
			<div class="col-sm-8">
				<textarea name="description" rows="6" class="form-control" id="post_content">{$profile.description|default:''}</textarea>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Hình ảnh</label>
			<div class="col-sm-8">

				<div class="mb-2">
					<input type="file" id="UploadImg"> 
					<small class="form-text text-muted"> Kích thước file ảnh tối đa 300Mb, hỗ trợ định dạng jpg, png.</small>
				</div>
				<div class="card-group" id="ShowImg">
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
			<label class="col-sm-2 col-form-label">Thời gian làm việc</label>
			<div class="col-sm-6">
				<input type="text" name="time_open" class="form-control" value="{$profile.time_open|default:''}"> 
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Doanh thu năm</label>
			<div class="col-sm-4">
				<select name="revenue" class="form-control">
					{$out.revenue}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Hoạt động kinh doanh tại</label>
			<div class="col-sm-4">
				<div class="form-check">
					<input name="is_global" class="form-check-input" type="checkbox" id="gridCheck2">
					<label class="form-check-label" for="gridCheck2"> Hoạt động quốc tế </label>
				</div>
				<div class="form-check">
					<input name="is_nation" class="form-check-input" type="checkbox" id="gridCheck1" checked>
					<label class="form-check-label" for="gridCheck1"> Hoạt động trong nước </label>
				</div>
				
				<fieldset class="form-group mt-2">
					<div class="row">
						<div class="col-sm-10">
							<div class="form-check">
								<input class="form-check-input" type="radio" name="gridRadios"
									id="gridRadios1" value="option1" checked> <label
									class="form-check-label" for="gridRadios1"> Toàn quốc </label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="gridRadios"
									id="gridRadios2" value="option2"> <label
									class="form-check-label" for="gridRadios2"> Một số tỉnh thành
								</label>
							</div>
						</div>
					</div>
				</fieldset>
				
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Khả năng sản xuất/ cung cấp dịch vụ</label>
			<div class="col-sm-8">
				<textarea name="supply_ability" rows="4" class="form-control">{$profile.supply_ability|default:''}</textarea>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Link facebook</label>
			<div class="col-sm-8">
				<input type="text" name="url_facebook" class="form-control" value="{$profile.url_facebook|default:''}"> 
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Link Google</label>
			<div class="col-sm-8">
				<input type="text" name="url_google" class="form-control" value="{$profile.url_google|default:''}"> 
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Link Youtube</label>
			<div class="col-sm-8">
				<input type="text" name="url_youtube" class="form-control" value="{$profile.url_youtube|default:''}"> 
			</div>
		</div>
		<div class="form-group row">
			<div class="col-sm-2"></div>
			<div class="col-sm-10">
				<button type="submit" name="submit" class="btn btn-primary">Lưu thông tin</button>
				<button type="reset" class="btn">Reset</button>
			</div>
		</div>

	</form>

</div>
<script src="{$arg.stylesheet}tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce-config.js"></script>
{literal}
<script>
var ArrImg = [];
var Images = $("input[name=images]").val();
var Folder = $("input[name=folder]").val();
if(Images!='') ArrImg = Images.split(';');

console.log(ArrImg);

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
					$.post('?mod=profile&site=intro', Data).done(function(e){
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
	$.post('?mod=profile&site=intro', Data).done(function(e){
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

</script>
{/literal}