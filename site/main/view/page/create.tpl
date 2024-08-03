<div class="container">
	<div class="card-group">
		<div class="card"></div>
		<div class="card">
			<div class="card-body">
				<h3 class="card-title">Đăng ký khởi tạo trang</h3>
				<hr>
				<form method="post" id="FrmCreatePage">
					<div class="form-group">
						<label>Tên trang</label>
						<input type="text" class="form-control input-lg" name="Name" placeholder="Tên doanh nghiệp hoặc cửa hàng">
					</div>
					<div class="row row-nomal">
						<div class="col-md-6">
							<div class="form-group">
								<input type="text" class="form-control input-lg" name="Code" placeholder="Mã đăng ký kinh doanh">
							</div>
						</div>
					</div>
					
					<label>Địa chỉ</label>
					<div class="row row-nomal">
						<div class="col-md-6">
							<div class="form-group">
								<select class="form-control input-lg" name="ProvinceId" onchange="LoadLocation('district', this.value);">
									{$out.Province}
								</select>
							</div>
						</div>
						<div class="col-md-6">
							<div class="form-group">
								<select class="form-control input-lg" name="DistrictId" id="district" onchange="LoadLocation('wards', this.value);">
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
						<input type="text" class="form-control input-lg" name="Address" placeholder="Địa chỉ đường, số nhà">
						<small>Trụ sở chính hoặc địa chỉ đăng ký kinh doanh</small>
					</div>
					<div class="form-group">
						<div class="form-check">
							<label class="form-check-label"> 
								<input class="form-check-input" type="checkbox" value="1" checked> Tôi đồng ý với các <a href="#">điều khoản sử dụng</a> trên website.
							</label>
						</div>
					</div>
					<div class="form-group margin-top-3x text-center">
						<button type="button" onclick="CreatePage();" class="btn btn-success btn-lg btn-block"><i class="fa fa-fw fa-check"></i> Khởi tạo trang trên hệ thống</button>
					</div>
				</form>
			</div>
		
		</div>
	</div>
</div>

<link href="{$arg.stylesheet}css/pnotify.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/animate.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}js/pnotify.min.js"></script>

{literal}
<script>
function CreatePage(){
	var Data = {};
	Data['Name'] = $("#FrmCreatePage input[name=Name]").val();
	Data['Code'] = $("#FrmCreatePage input[name=Code]").val();
	Data['Address'] = $("#FrmCreatePage input[name=Address]").val();
	Data['ProvinceId'] = $("#FrmCreatePage select[name=ProvinceId]").val();
	Data['DistrictId'] = $("#FrmCreatePage select[name=DistrictId]").val();
	Data['WardsId'] = $("#FrmCreatePage select[name=WardsId]").val();
	
	console.log(Data);
	
	if(Data['Name']=='' || Data['Name'].length < 6){
		noticeMsg('Thông báo', 'Vui lòng nhập tên gian hàng tối thiểu 6 ký tự.', 'error');
		$("#FrmCreatePage input[name=Name]").focus();
		return false;
	}else if(Data['ProvinceId']==0 || Data['ProvinceId']==''){
		noticeMsg('Thông báo', 'Vui lòng chọn tỉnh thành phố cho gian hàng.', 'error');
		$("#FrmCreatePage select[name=ProvinceId]").focus();
		return false;
	}else if(Data['DistrictId']==0 || Data['DistrictId']==''){
		noticeMsg('Thông báo', 'Vui lòng chọn quận huyện cho gian hàng.', 'error');
		$("#FrmCreatePage select[name=DistrictId]").focus();
		return false;
	}else if(Data['Address']=='' || Data['Address'].length < 6){
		noticeMsg('Thông báo', 'Vui lòng nhập chính xác địa chỉ của gian hàng bao gồm địa chỉ số nhà, đường phố.', 'error');
		$("#FrmCreatePage input[name=Address]").focus();
		return false;
	}
	Data['action'] = 'create_page';
	
	loading();
	$.post('?mod=page&site=create', Data).done(function(e){
		var data = JSON.parse(e);
		if(data.code==1){
			location.href = "?mod=page&site=index";
			endloading();
		}else{
			noticeMsg('Thông báo', data.msg, 'error');
			endloading();
		}
	});
}

function LoadLocation(Type, Value){
	loading();
	$.post('?mod=help&site=ajax_load_location', {'Type':Type, 'Value':Value}).done(function(e){
		$("#"+Type).html(e);
		if(Type=='district') $("#wards").html('');
		endloading();
	});
}
</script>
{/literal}