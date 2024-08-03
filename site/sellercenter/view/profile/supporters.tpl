<div class="card-header">
	<h3>Nhân viên chăm sóc khách hàng</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<div class="row">
		<div class="col-md-6">
			<form method="post" id="FrmCont" enctype="multipart/form-data">
				<input type="hidden" name="Id">
				<div class="form-group row">
					<label for="inputPassword" class="col-sm-3 col-form-label">Tên liên hệ</label>
					<div class="col-sm-7">
						<input type="text" class="form-control" name="Name" placeholder="Vd: Chăm sóc khách hàng"> 
						<small id="passwordHelpBlock" class="form-text text-muted"> Tên liên hệ có thể là tên nhân viên chăm sóc khách hàng hoặc tên phòng ban, bộ phận chăm sóc. </small>
					</div>
				</div>
				<div class="form-group row">
					<label for="inputPassword" class="col-sm-3 col-form-label">Ảnh đại diện</label>
					<div class="col-sm-9">
						<div class="row row-sm">
							<div class="col-md-3">
								<span class="border d-block" style="min-height: 85px">
									<img src="{$arg.noimg}" id="ShowImg" width="100%" height="85">
								</span>
							</div>
							<div class="col-md-8">
								<input type="file" id="ImgUpload" name="Image"> 
								<small class="form-text text-muted">Kích thước file 200Mb, hỗ trợ định dạng jpg, png. Tỉ lệ ảnh phù hợp là 1x1. Nên để kích thước 100x100 pixcel.</small>
							</div>
						</div>
					</div>
				</div>
				
				<div class="form-group row">
					<label for="inputPassword" class="col-sm-3 col-form-label">Điện thoại</label>
					<div class="col-sm-7">
						<input type="text" class="form-control" name="Phone" placeholder="0964368282"> 
					</div>
				</div>

				<div class="form-group row">
					<label for="inputPassword" class="col-sm-3 col-form-label">Email</label>
					<div class="col-sm-7">
						<input type="text" class="form-control" name="Email" placeholder="chungit.dsc@daisan.vn"> 
					</div>
				</div>

				<div class="form-group row">
					<label for="inputPassword" class="col-sm-3 col-form-label">Skype chat</label>
					<div class="col-sm-7">
						<input type="text" class="form-control" name="Skype" placeholder="skype_name"> 
					</div>
				</div>
				
				<div class="form-group row">
					<div class="col-sm-3"></div>
					<div class="col-sm-8">
						<button type="submit" name="SaveSupporter" class="btn btn-primary">Lưu thông tin</button>
						<button type="reset" class="btn" onclick="resetForm();">Reset</button>
					</div>
				</div>
			</form>
		
		</div>
		<div class="col-md-6">
			<h5>Danh sách</h5>
			<div class="table-responsive mt-3">
				<table class="table">
					<tr>
						<th colspan="2">Nhân viên hỗ trợ</th>
						<th>Điện thoại</th>
						<th>Skype</th>
						<th></th>
					</tr>
					{foreach from=$supporters item=data}
					<tr id="FID{$data.id}">
						<td class="text-center"><img src="{$data.avatar}" width="40"></td>
						<td>
							{$data.name}
						</td>
						<td>{$data.phone}</td>
						<td>{$data.skype}</td>
						<td class="text-right">
							<button type="button" class="btn btn-outline-primary btn-sm" onclick="LoadFrm({$data.id});"><i class="fa fa-fw fa-pencil"></i></button>
							<button type="button" class="btn btn-outline-danger btn-sm" onclick="DeleteItem('pagesupporters', {$data.id}, 'profile', 'delete_supporter');"><i class="fa fa-fw fa-remove"></i></button>
						</td>
					</tr>
					{/foreach}
				</table>
			</div>
		
		</div>
	</div>



</div>

<script type="text/javascript">
var noimg = '{$arg.noimg}';
</script>
{literal}
<script>
function LoadFrm(Id){
	$("#FrmCont input").val('');
	$("#FrmCont input[name=Id]").val(Id);
	var Data = {};
	Data['Id'] = Id;
	Data['Action'] = 'load_frm';
	loading();
	$.post('?mod=profile&site=supporters', Data).done(function(e){
		var data = JSON.parse(e);
		$("#FrmCont input[name=Name]").focus();
		$("#FrmCont input[name=Name]").val(data.name);
		$("#FrmCont input[name=Phone]").val(data.phone);
		$("#FrmCont input[name=Skype]").val(data.skype);
		$("#FrmCont input[name=Email]").val(data.email);
		$("#FrmCont #ShowImg").attr('src', data.avatar);
		endloading();
	});
}

function resetForm(){
	$("#FrmCont input").val('');
}

$('#ImgUpload').change(function() {
	readURL(this, '#ShowImg');
});

function readURL(input, imgShow) {
	if (input.files && input.files[0]) {
		var fileImg = input.files[0];
		var _URL = window.URL || window.webkitURL;
		var img = new Image();
        img.onload = function () {
            if(this.width/this.height>1.5 || this.width/this.height<0.75){
            	noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp tỉ lệ 1x1, vui lòng chọn lại.', 'error');
            	$("#ImgUpload").val('');
            	$(imgShow).attr('src', arg.noimg);
            	return false;
            }else{
        		var reader = new FileReader();
        		reader.onload = function(e) {
        			$(imgShow).attr('src', e.target.result);
        		}
        		reader.readAsDataURL(fileImg);
            }
        }
        img.src = _URL.createObjectURL(fileImg);
	}
}
</script>
{/literal}