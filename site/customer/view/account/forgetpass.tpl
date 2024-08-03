<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col-md-4">
			<div class="card mt-4">
				<div class="card-body mx-4">
					<div id="FrmCont">
						<div class="text-center">
							<a href="{$arg.domain}"><img alt="hodine logo" src="{$arg.url_upload}generals/logo.png" style="width: 240px"></a>
						</div>
						<h5 class="text-center mb-4">Quên mật khẩu tài khoản Hodine</h5>
						<hr>
						<div class="form-group">
							<label>Nhập email đã lưu trong tài khoản</label> 
							<input type="text" name="email" autofocus="autofocus" class="form-control">
						</div>
						<p>Vui lòng nhập chính xác email của bạn đã lưu với tài khoản quên mật khẩu.</p> 
						<p>Chúng tôi sẽ gửi một đường dẫn tới email để thực hiện việc cấp lại mật khẩu mới cho bạn.</p>
						<div class="form-group">
							<button type="button" onclick="ForgetPass();" class="btn btn-success">Gửi thông tin tới email</button>
						</div>
						<hr>
						<p>Nếu có mật khẩu hoặc chưa có tài khoản, vui lòng thực hiện đăng nhập hoặc tạo tài khoản mới.</p>
						<p class="clearfix">
							<a href="?site=login" class="btn btn-outline-secondary btn-sm">Đăng nhập</a>
							<a href="?site=register" class="btn btn-outline-secondary btn-sm">Tạo tài khoản mới</a>
						</p>
		
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

{literal}
<script>
$('#FrmLogin input[name=Username],#FrmLogin input[name=Password]').keypress(function(event) {
	if(event.which == 13) HodineLogin();
});

function ForgetPass() {
	var data = {};
	data['email'] = $("#FrmCont input[name=email]").val();
	data['ajax_action'] = 'forget_password';
	if (data.email.length==0) {
		noticeMsg('System Message', 'Vui lòng nhập email của bạn.', 'error');
		$("#FrmCont input[name=email]").focus();
		return false;
	}
	loading();
	$.post("?site=forgetpass", data).done(function(e) {
		var Data = JSON.parse(e);
		if (Data.code == 0) {
			noticeMsg('System Message', Data.msg, 'error');
			endloading();
		} else {
			noticeMsg('System Message', Data.msg, 'success');
			$("#FrmCont input[name=email]").val('');
			endloading();
		}
	});
}
</script>
{/literal}
