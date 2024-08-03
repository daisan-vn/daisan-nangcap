<section class="loginn bg-white py-5">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-xl-5">
				<div class="form_login">
					<div class="logo text-center py-3">
						<img src="{$arg.url_img}logo-red.png" height="40">
					</div>
					<div class="card">
						<div class="card-body">
							<h3>Quên mật khẩu</h3>
							<div id="FrmCont">
								<div class="form-group">
									<label for="exampleInputEmail1" class="text-b pb-2">Nhập email đã lưu trong tài khoản</label>
									<input type="text" name="email" class="form-control">
								</div>
								<p>Vui lòng nhập chính xác email của bạn đã lưu với tài khoản quên mật khẩu.</p>
								<p class="pb-2">Chúng tôi sẽ gửi một đường dẫn tới email để thực hiện việc cấp lại mật khẩu mới cho
									bạn.</p>
								<div class="form-group">
									<button type="button" onclick="ForgetPass();" class="btn btn-primary btn-block btn-login text-dark">Gửi thông tin
										tới email</button>
								</div>
								<hr>
								<p class="pb-2">Nếu có mật khẩu hoặc chưa có tài khoản, vui lòng thực hiện đăng nhập hoặc tạo tài
									khoản mới.</p>
								<p class="clearfix">
									<a href="?mod=account&site=login" class="btn btn-outline-secondary">Đăng nhập</a>
									<a href="?mod=account&site=register" class="btn btn-outline-secondary">Tạo tài
										khoản</a>
								</p>
							</div>
						</div>
					</div>
					<div class="account-divider text-center">
						<span>Bạn chưa có tài khoản trên Daisan.vn?</span>
					</div>
					<a href="?mod=account&site=register" class="btn btn-primary btn-block btn-register">
						Đăng ký tài khoản
					</a>
				</div>
			</div>
		</div>
	</div>
</section>

{literal}
<script>
	function ForgetPass() {
		var data = {};
		data['email'] = $("#FrmCont input[name=email]").val();
		data['ajax_action'] = 'forget_password';
		if (data.email.length == 0) {
			noticeMsg('System Message', 'Vui lòng nhập email của bạn.', 'error');
			$("#FrmCont input[name=email]").focus();
			return false;
		}
		loading();
		$.post("?mod=account&site=forgetpass", data).done(function (e) {
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