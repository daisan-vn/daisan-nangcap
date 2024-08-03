<div class="card-header">
	<h3>Khởi tạo dịch vụ của công ty</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<form>

		<div class="card-header mb-3">Tạo mới dịch vụ của bạn hoặc chọn các dịch vụ đã có sẵn thông tin để sử dụng</div>
		<input type="hidden" class="form-control" name="service_id">
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Danh mục</label>
			<div class="col-sm-4">
				<select name="taxonomy_id" class="form-control" onchange="LoadServices();">
					{$out.select_category}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Tên dịch vụ</label>
			<div class="col-sm-6">
				<input type="text" class="form-control" name="name">
			</div>
		</div>
		<div class="form-group row" id="LoadServices">
			<label class="col-sm-2 col-form-label"></label>
			<div class="col-sm-10">
				<div class="border p-3" id="ShowContent">
					
				</div>
			</div>
		</div>
		
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Ảnh đại diện</label>
			<div class="col-sm-8">
				<div class="row row-sm mb-3">
					<div class="col-md-3">
						<span class="border d-block" style="min-height: 122px">
							<img src="{$arg.noimg}" id="ShowLogo" width="100%" height="122">
						</span>
					</div>
					<div class="col-md-9">
						<input type="file" id="UploadLogo" name="logo">
						<input type="hidden" name="avatar">
						<small class="form-text text-muted"> Kích thước file tối đa 300Mb, hỗ trợ định dạng jpg, png.</small>
						<small class="form-text text-muted"> Tỉ lệ ảnh phù hợp là 4x3. Nên để kích thước 400x300 pixcel.</small>
					</div>
				</div>
			</div>
		</div>
		
		
		<div class="form-group row">
			<div class="col-sm-2"></div>
			<div class="col-sm-10">
				<div class="form-check">
					<input class="form-check-input" type="checkbox" id="gridCheck1">
					<label class="form-check-label" for="gridCheck1"> Xác nhận dịch vụ này do chúng tôi cung cấp </label>
				</div>
			</div>
		</div>
		<div class="form-group row">
			<div class="col-sm-2"></div>
			<div class="col-sm-10">
				<button type="button" onclick="CreateService();" class="btn btn-primary">Khởi tạo dịch vụ</button>
			</div>
		</div>

	</form>

</div>

<script type="text/javascript">
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
	            if(this.width/this.height<1 || this.width/this.height>1.8){
	            	noticeMsg('Thông báo', 'Kích thước ảnh không đúng tỉ lệ 4x3, vui lòng chọn lại.', 'error');
	            	$("#UploadLogo").val('');
	            	$("#ShowLogo").attr('src', arg.noimg);
	            	$("input[name=avatar]").val('');
	            	return false;
	            }else{
					var reader = new FileReader();
					reader.onload = function(e) {
						$("#ShowLogo").attr('src', e.target.result);
						$("input[name=avatar]").val(e.target.result);
					}
					reader.readAsDataURL(fileImg);
	            }
	        }
	        img.src = _URL.createObjectURL(fileImg);
		}else{
			noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng jpg hoặc png.', 'error');
			$("#ShowLogo").attr('src', arg.noimg);
			$("input[name=avatar]").val('');
		}
	}
	$("#UploadLogo").val('');
});


function LoadServices(){
	var taxonomy_id = $("select[name=taxonomy_id]").val();
	var name = $("input[name=name]").val();
	
	$('#ShowContent').load("?mod=service&site=load_services", {
		'taxonomy_id': taxonomy_id,
		'name': name
	}, function(){
		$("input[name=service_id]").val('');
		$("#ShowContent").show();
	});
}


function CreateService(){
	var Data = {};
	Data['taxonomy_id'] = $("select[name=taxonomy_id]").val();
	Data['name'] = $("input[name=name]").val();
	Data['avatar'] = $("input[name=avatar]").val();
	Data['service_id'] = $("input[name=service_id]").val();
	if(Data['taxonomy_id']==0){ 
		noticeMsg('Thông báo', 'Vui lòng chọn danh mục dịch vụ.', 'error');
		$("select[name=taxonomy_id]").focus();
		return false;
	}else if(Data['name']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập tên dịch vụ.', 'error');
		$("input[name=name]").focus();
		return false;
	}
	Data['ajax_action'] = "create_service";
	loading();
	$.post('?mod=service&site=create', Data).done(function(e){
		noticeMsg('Thông báo', 'Khởi tạo dịch vụ thành công.', 'success');
		//return false;
		setTimeout(function(){
			location.href = "?mod=service&site=editdetail&ServiceId="+e;
		}, 3000);
	});
}

function SetService(service_id){
	var name = $("#Service"+service_id+" small").html();
	var img = $("#Service"+service_id+" img").attr('src');
	
	console.log(name);
	
	$("input[name=service_id]").val(service_id);
	$("input[name=name]").val(name);
	$("#ShowLogo").attr('src', img);
	
	$("#ShowContent").hide();
	noticeMsg('Thông báo', 'Chọn dịch vụ trên hệ thống làm dịch vụ do công ty cung cấp.', 'success');
}
</script>