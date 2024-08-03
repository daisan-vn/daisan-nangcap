<div class="container">
	<div class="card-group my-5 shadow">
		<div class="card text-center">
			<img alt="" src="{$arg.img_gen}dang-ky-ngay.gif" class="mt-5 w-100">
		</div>
		<div class="card">
			<div class="card-body">
				<h3 class="card-title">Đăng ký khởi tạo gian hàng</h3>
				<hr>
				<div id="FrmCreatePage">
					<div class="form-inline mb-3">
						<div class="form-group">
							<label class="col-form-label">Loại hình</label>
						</div>
						<div class="form-group mx-sm-3">
							<select class="form-control" name="type">{$out.type}
							</select>
						</div>
					</div>
					<div class="form-group">
						<label>Tên trang</label> <input type="text"
							class="form-control input-lg" name="Name"
							placeholder="Tên doanh nghiệp hoặc cửa hàng"
							onchange="AICheckPage(this.value);">
					</div>
					<div class="row row-nomal">
						<div class="col-md-6">
							<div class="form-group">
								<input type="text" class="form-control input-lg" name="Code"
									placeholder="Mã đăng ký kinh doanh">
							</div>
						</div>
					</div>

					<label>Địa chỉ</label>
					<div class="row row-nomal">
						<div class="col-md-6">
							<div class="form-group">
								<select class="form-control input-lg" name="ProvinceId"
									onchange="LoadLocation('district', this.value);">
									{$out.Province}
								</select>
							</div>
						</div>
						<div class="col-md-6">
							<div class="form-group">
								<select class="form-control input-lg" name="DistrictId"
									id="district" onchange="LoadLocation('wards', this.value);">
									<option value="0">Quận huyện</option>
								</select>
							</div>
						</div>
					</div>
					<div class="row row-nomal">
						<div class="col-md-6">
							<div class="form-group">
								<select class="form-control input-lg" name="WardsId" id="wards">
									<option value="0">Phường xã</option>
								</select>
							</div>
						</div>
					</div>
					<div class="form-group">
						<input type="text" class="form-control input-lg" name="Address"
							placeholder="Địa chỉ đường, số nhà"> <small>Trụ
							sở chính hoặc địa chỉ đăng ký kinh doanh</small>
					</div>

					<div class="row row-nomal">
						<div class="col-md-6">
							<div class="form-group">
								<input type="text" class="form-control input-lg" name="Phone"
									placeholder="Số điện thoại">
							</div>
						</div>
						<div class="col-md-6">
							<div class="form-group">
								<input type="text" class="form-control input-lg" name="Email"
									placeholder="Email">
							</div>
						</div>
					</div>
					<div class="form-group">
						<label>Website</label> <input type="text"
							class="form-control input-lg" name="Website"
							placeholder="Link website doanh nghiệp hoặc cửa hàng">
					</div>
					<div class="form-group">
						<div class="form-check">
							<label class="form-check-label"> <input
								class="form-check-input" type="checkbox" value="1" checked>
								Tôi đồng ý với các <a target="_blank" href="/helpcenter/display.html?pId=11">điều khoản sử dụng</a> trên
								website.
							</label>
						</div>
					</div>
					<div class="form-group margin-top-3x text-center">
						<button type="button" onclick="CreatePage();"
							class="btn btn-success btn-lg btn-block">
							<i class="fa fa-fw fa-check"></i> Khởi tạo gian hàng trên hệ thống
						</button>
					</div>
				</div>
			</div>

		</div>
	</div>
</div>

<link href="{$arg.stylesheet}css/pnotify.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/animate.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}js/pnotify.min.js"></script>

{literal}
<script>
	function CreatePage() {
		var Data = {};
		Data['Name'] = $("#FrmCreatePage input[name=Name]").val();
		Data['Code'] = $("#FrmCreatePage input[name=Code]").val();
		Data['Type'] = $("#FrmCreatePage select[name=type]").val();
		Data['Address'] = $("#FrmCreatePage input[name=Address]").val();
		Data['ProvinceId'] = $("#FrmCreatePage select[name=ProvinceId]").val();
		Data['DistrictId'] = $("#FrmCreatePage select[name=DistrictId]").val();
		Data['WardsId'] = $("#FrmCreatePage select[name=WardsId]").val();
		Data['Phone'] = $("#FrmCreatePage input[name=Phone]").val();
		Data['Email'] = $("#FrmCreatePage input[name=Email]").val();
		Data['Website'] = $("#FrmCreatePage input[name=Website]").val();

		console.log(Data);

		if (Data['Name'] == '' || Data['Name'].length < 6) {
			noticeMsg('Thông báo',
					'Vui lòng nhập tên gian hàng tối thiểu 6 ký tự.', 'error');
			$("#FrmCreatePage input[name=Name]").focus();
			return false;
		} else if (Data['ProvinceId'] == 0 || Data['ProvinceId'] == '') {
			noticeMsg('Thông báo',
					'Vui lòng chọn tỉnh thành phố cho gian hàng.', 'error');
			$("#FrmCreatePage select[name=ProvinceId]").focus();
			return false;
		} else if (Data['DistrictId'] == 0 || Data['DistrictId'] == '') {
			noticeMsg('Thông báo', 'Vui lòng chọn quận huyện cho gian hàng.',
					'error');
			$("#FrmCreatePage select[name=DistrictId]").focus();
			return false;
		} else if (Data['Address'] == '' || Data['Address'].length < 6) {
			noticeMsg(
					'Thông báo',
					'Vui lòng nhập chính xác địa chỉ của gian hàng bao gồm địa chỉ số nhà, đường phố.',
					'error');
			$("#FrmCreatePage input[name=Address]").focus();
			return false;
		}
		Data['action'] = 'create_page';

		loading();
		$.post('?mod=account&site=createpage', Data).done(function(e) {
			var data = JSON.parse(e);
			if (data.code == 1) {
				location.href = "?mod=account&site=pages";
				endloading();
			} else {
				noticeMsg('Thông báo', data.msg, 'error');
				endloading();
			}
		});
	}

	function AICheckPage(value) {
		loading();
		$.post('?mod=account&site=ajax_check_page', {
			'value' : value
		}).done(function(e) {
			var data = JSON.parse(e);
			if (data.code == 0) {
				noticeMsg('Thông báo', 'Gian hàng đã tồn tại', 'error');
				endloading();
			}else{
				noticeMsg('Thông báo', 'Ok', 'success');
				endloading();
			}
		});
	}

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
