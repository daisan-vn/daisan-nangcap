<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Thêm mới, cập nhật thông tin gian
				hàng
			</h1>
		</div>
		<div class="col-md-4 text-right"></div>
	</div>
</div>
<form method="post">
    <input type="hidden" id="page_id" value="{$smarty.get.id}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Tên doanh nghiệp</label>
		<div class="col-sm-8">
			<input type="text" class="form-control" name="name"
				value="{$page.name|default:''}"> <small
				id="passwordHelpBlock" class="form-text text-muted">Nhập đầy
				đủ và chính xác tên đăng ký doanh nghiệp của bạn. </small>
		</div>
	</div>
	<div class="form-group row">
			<label class="col-sm-2 col-form-label">Logo đại diện</label>
			<div class="col-sm-8">
				<div class="row row-sm mb-3">
					<div class="col-md-2">
						<span class="border d-block" style="min-height: 110px">
							<img src="{$page.logo_img|default:''}" id="ShowLogo" width="100%" height="110">
						</span>
					</div>
					<div class="col-md-10">
						<input type="file" id="UploadLogo" name="logo"> 
						<small class="form-text text-muted"> Kích thước file tối đa 200Mb, hỗ trợ định dạng jpg, png.</small>
						<small class="form-text text-muted"> Tỉ lệ ảnh phù hợp là 1x1. Nên để kích thước 100x100 pixcel.</small>
					</div>
				</div>
				
				<div class="row row-sm">
					<div class="col-md-5">
						<span class="border d-block" style="min-height: 93px">
							<img src="{$page.logo_custom_img|default:''}" id="ShowLogo2" width="100%" height="93">
						</span>
					</div>
					<div class="col-md-7">
						<input type="file" id="UploadLogo2" name="logo2"> 
						<small class="form-text text-muted"> Kích thước file tối đa 200Mb, hỗ trợ định dạng jpg, png.</small>
						<small class="form-text text-muted"> Tỉ lệ ảnh phù hợp là 3x1. Nên để kích thước 300x100 pixcel.</small>
					</div>
				</div>
			</div>
		</div>
	
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Loại hình doanh nghiệp</label>
		<div class="col-sm-3">
			<select class="form-control" name="type">{$out.type}
			</select>
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Danh mục kinh doanh</label>
		<div class="col-sm-3">
			<select class="form-control" name="taxonomy_id">{$out.taxonomy_id}
			</select>
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Mã doanh nghiệp</label>
		<div class="col-sm-3">
			<input type="text" class="form-control" name="code"
				value="{$page.code|default:''}">
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Tên viết tắt</label>
		<div class="col-sm-5">
			<input type="text" class="form-control" name="name_short"
				value="{$page.name_short|default:''}">
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Tên tiếng Anh</label>
		<div class="col-sm-5">
			<input type="text" class="form-control" name="name_global"
				value="{$page.name_global|default:''}">
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Ngày ĐK kinh doanh</label>
		<div class="col-sm-3">
			<input type="text" class="form-control datepicker" name="date_start"
				value="{$page.date_start|default:''}">
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Số lượng nhân viên</label>
		<div class="col-sm-3">
			<select name="number_mem" class="form-control">
				{$out.number_mem}
			</select>
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Địa chỉ đăng ký</label>
		<div class="col-sm-10">
			<div class="row">
				<div class="form-group col-md-3">
					<label for="inputState">Tỉnh thành</label> <select
						name="province_id" id="inputState" class="form-control"
						onchange="LoadLocation('district', this.value);">{$out.Province}
					</select>
				</div>
				<div class="form-group col-md-3">
					<label for="district">Quận huyện</label> <select name="district_id"
						class="form-control" id="district"
						onchange="LoadLocation('wards', this.value);">{$out.District}
					</select>
				</div>
				<div class="form-group col-md-3">
					<label for="wards">Phường xã</label> <select id="wards"
						name="wards_id" class="form-control">{$out.Wards}
					</select>
				</div>
			</div>
			<div class="row">
				<div class="form-group col-md-9">
					<label>Địa chỉ chi tiết</label> <input type="text"
						class="form-control" name="address"
						value="{$page.address|default:''}">
				</div>
			</div>
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Website</label>
		<div class="col-sm-5">
			<input type="text" class="form-control" name="website"
				value="{$page.website|default:''}">
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Số điện thoại</label>
		<div class="col-sm-5">
			<input type="text" class="form-control" name="phone"
				value="{$page.phone|default:''}">
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Email liên hệ</label>
		<div class="col-sm-5">
			<input type="text" class="form-control" name="email"
				value="{$page.email|default:''}">
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Hiển thị SĐT DAISAN</label>
		<div class="col-sm-5">
			<input class="form-check-input" type="checkbox" {if $page.isphone
				eq 1}checked{/if}
			name="isphone"
				value="{$page.isphone|default:0}">
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">OEM</label>
		<div class="col-sm-5">
			<input class="form-check-input" type="checkbox" name="is_oem"
				value="{$page.is_oem|default:0}" {if $page.is_oem eq 1}checked{/if}> <small
				id="passwordHelpBlock" class="form-text text-muted">Đơn vị nhận gia công sản phẩm (OEM)</small>
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Gian hàng được xác minh</label>
		<div class="col-sm-5">
			<input class="form-check-input" type="checkbox"
				{if $page.is_verification
				eq 1}checked{/if}
			name="is_verification"
				value="{$page.is_verification|default:0}"> <small
				id="passwordHelpBlock" class="form-text text-muted">Tích vào
				xác nhận đã xác minh gian hàng</small>
		</div>
	</div>
	<div class="form-group row">
		<div class="col-sm-2"></div>
		<div class="col-sm-10">
			<button type="submit" name="submit" class="btn btn-primary">Lưu
				thông tin</button>
			<button type="reset" class="btn">Reset</button>
		</div>
	</div>

</form>

{literal}
<script>
	$(window).ready(function() {
		var dateToday = new Date();
		$(".datepicker").datepicker({
			dateFormat : 'dd-mm-yy',
			maxDate : '0'
		});
	});
	$('#UploadLogo').change(function() {
		if(this.files && this.files[0]) {
			var fileImg = this.files[0];
			var fileType = this.files[0]["type"];
			var fileName = this.files[0]["name"];
			var ValidImageTypes = ["image/jpeg", "image/png"];
			if ($.inArray(fileType, ValidImageTypes)>=0) {
				var _URL = window.URL || window.webkitURL;
				var img = new Image();
		        img.onload = function () {
		            if((this.width/this.height)>4 || (this.width/this.height)<0.25){
		            	noticeMsg('Thông báo', 'Kích thước ảnh không đúng tỉ lệ 1x1, vui lòng chọn lại.', 'error');
		            	return false;
		            }else{
						var reader = new FileReader();
						reader.onload = function(e) {
							var Data = {};
							Data['imgname'] = fileName;
							Data['img'] = e.target.result;
							Data['page_id']=$("#page_id").val();
							Data['ajax_action'] = 'upload_logo';
							loading();
							$.post('?mod=pages&site=form', Data).done(function(e){
								console.log(e);
								if(e==0) noticeMsg('Xảy ra lỗi', 'Không thể lưu được ảnh, vui lòng thử lại sau.', 'error');
								else{
									$("#ShowLogo").attr('src', e);
									noticeMsg('Thông báo', 'Thay đổi logo mới thành công.', 'success');
								}
								endloading();
							});
						}
						reader.readAsDataURL(fileImg);
		            }
		        }
		        img.src = _URL.createObjectURL(fileImg);
			}else{
				noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng jpg hoặc png.', 'error');
			}
		}
		$("#UploadImg").val('');
	});
	
	$('#UploadLogo2').change(function() {
		if(this.files && this.files[0]) {
			var fileImg = this.files[0];
			var fileType = this.files[0]["type"];
			var fileName = this.files[0]["name"];
			var ValidImageTypes = ["image/jpeg", "image/png"];
			if ($.inArray(fileType, ValidImageTypes)>=0) {
				var _URL = window.URL || window.webkitURL;
				var img = new Image();
		        img.onload = function () {
					var reader = new FileReader();
					reader.onload = function(e) {
						var Data = {};
						Data['imgname'] = fileName;
						Data['img'] = e.target.result;
						Data['page_id']=$("#page_id").val();
						Data['ajax_action'] = 'upload_logo_custom';
						loading();
						$.post('?mod=pages&site=form', Data).done(function(e){
							if(e==0) noticeMsg('Xảy ra lỗi', 'Không thể lưu được ảnh, vui lòng thử lại sau.', 'error');
							else{
								$("#ShowLogo2").attr('src', e);
								noticeMsg('Thông báo', 'Thay đổi logo mới thành công.', 'success');
							}
							endloading();
						});
					}
					reader.readAsDataURL(fileImg);
		        }
		        img.src = _URL.createObjectURL(fileImg);
			}else{
				noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng jpg hoặc png.', 'error');
			}
		}
		$("#UploadImg2").val('');
	});
	function LoadLocation(Type, Value) {
		loading();
		$.post('?mod=help&site=ajax_load_location', {
			'Type' : Type,
			'Value' : Value
		}).done(function(e) {
			$("#" + Type).html(e);
			if (Type == 'district')
				$("#wards").html('');
			endloading();
		});
	}
</script>
{/literal}
