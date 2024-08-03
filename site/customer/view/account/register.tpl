<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col-md-5">
			<div class="card mt-4">
				<div class="card-body mx-4">
					<div id="FrmRegister">
						<div class="text-center">
							<a href="{$arg.domain}"><img alt="hodine logo" src="{$arg.url_upload}generals/logo.png" style="width: 240px"></a>
						</div>
						<h5 class="text-center mb-4">Đăng ký tài khoản Hodine</h5>
						<hr>
						<div class="form-group">
							<label>Họ tên đầy đủ:</label> 
							<input type="text" name="Name" class="form-control lg-sm" placeholder="Ví dụ: Nguyen Van An">
						</div>
		
						<div class="form-group">
							<label>Tài khoản đăng nhập:</label> 
							<input type="text" name="Username" class="form-control" placeholder="Ví dụ: nguyenvanan">
							<small class="form-text text-muted">Lưu ý: tên đăng nhập gồm các ký tự chữ và số, viết liền không dấu.</small>
						</div>
						<div class="row row-sm">
							<div class="col-md-6">
								<div class="form-group">
									<label>Mật khẩu:</label> 
									<input type="password" name="Password" class="form-control" placeholder="Mật khẩu">
								</div>
							</div>
							<div class="col-md-6">
								<div class="form-group">
									<label>Nhập lại mật khẩu:</label> 
									<input type="password" name="RePass" class="form-control" placeholder="Xác nhận mật khẩu">
								</div>
							</div>
						</div>
						<div class="form-group">
							<label>Số điện thoại:</label> 
							<input type="text" name="Phone" class="form-control" placeholder="Ví dụ: 0912345678">
						</div>
						<div class="form-group">
							<label>Email:</label> 
							<input type="text" name="Email" class="form-control" placeholder="Ví dụ: nguyenvanan@hodine.com">
						</div>
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label"> 
									<input class="form-check-input" type="checkbox" checked="checked">Đồng ý với các điều khoản của chúng tôi.
								</label>
							</div>
						</div>
						<div class="form-group">
							<button type="button" onclick="HodineRegister();" id="BtnRegister" class="btn btn-success">Đăng ký tài khoản ngay</button>
						</div>
						<p>Nếu đã có tài khoản, vui lòng <a href="?site=login">đăng nhập</a></p>
						<hr>
						<p class="mb-2">Hoặc tiếp tục đăng nhập với</p>
						<div class="form-group">
							<button type="button" class="btn btn-primary"><i class="fa fa-facebook"></i> Facebook</button>
							<button type="button" class="btn btn-danger"><i class="fa fa-google"></i> Google</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

{literal}
<script>
function HodineRegister() {
	var Data = {};
	Data['Name'] = $("#FrmRegister input[name=Name]").val();
	Data['Username'] = $("#FrmRegister input[name=Username]").val();
	Data['Password'] = $("#FrmRegister input[name=Password]").val();
	Data['RePass'] = $("#FrmRegister input[name=RePass]").val();
	Data['Phone'] = $("#FrmRegister input[name=Phone]").val();
	Data['Email'] = $("#FrmRegister input[name=Email]").val();
	if (Data['Name'] == '' || Data['Name'].length < 6) {
		noticeMsg('Thông báo', 'Vui lòng nhập họ tên của bạn.', 'error');
		$("#FrmRegister input[name=Name]").focus();
		return false;
	} else if (Data['Username'] == '' || Data['Username'].length < 6) {
		noticeMsg('Thông báo', 'Vui lòng nhập tài khoản tối thiểu 6 ký tự.', 'error');
		$("#FrmRegister input[name=Username]").focus();
		return false;
	} else if (Data['Password'] == '' || Data['Password'].length < 6) {
		noticeMsg('Thông báo', 'Vui lòng nhập mật khẩu tối thiểu 6 ký tự.', 'error');
		$("#FrmRegister input[name=Password]").focus();
		return false;
	} else if (Data['RePass'] != Data['Password']) {
		noticeMsg('Thông báo', 'Mật khẩu xác nhận không chính xác, vui lòng nhập lại.', 'error');
		$("#FrmRegister input[name=RePass]").focus();
		return false;
	} else {
		Data['action'] = 'ajax_register';
		loading();
		$.post("?site=register", Data).done(function(e) {
			rt = JSON.parse(e);
			if (rt.Code == 0) {
				noticeMsg('Thông báo', rt.Msg, 'error');
				endloading();
			} else {
				noticeMsg('Thông báo', rt.Msg, 'success');
				endloading();
				location.href = arg.domain;
			}
		});
	}
}
</script>
{/literal}
