<section class="loginn bg-white py-5">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-xl-5">
				<div class="form_login">
					<div class="card">
						<div class="card-body">
							<h3>Đăng nhập</h3>
							<div id="FrmLogin">
								<div class="form-group">
									<label for="exampleInputEmail1" class="text-b">Email đăng
										nhập</label> <input type="email" class="form-control" id="exampleInputEmail1"
										name="Email">
								</div>
								<div class="form-group">
									<label for="password" class="text-b">Mật khẩu</label> <input type="password"
										class="form-control" id="password" name="Password">
								</div>
								<button type="button" class="btn btn-primary btn-block btn-login text-dark"
									onclick="HodineLogin();" id="BtnLogin">Đăng nhập</button>
								<p class="pt-3">
									Bằng cách tiếp tục, bạn đồng ý với <a target="_blank" href="/helpcenter/display.html?pId=11">Điều khoản
										sử dụng</a> và <a target="_blank" href="/helpcenter/display.html?pId=12">Thông báo về quyền riêng tư</a> của
									Daisan.vn
								</p>
								<p>
									<i class="fa fa-sort-desc fa-fw" aria-hidden="true"></i><a data-toggle="collapse"
										href="#user-login-help" role="button" aria-expanded="false"
										aria-controls="collapseExample">Cần
										giúp đỡ?</a>
								</p>
								<div class="collapse" id="user-login-help">
									<div class="card card-body border-0 pt-0">
										<a href="?mod=account&site=forgetpass">Quên mật khẩu?</a> <a href="">Các vấn đề
											khác với Đăng nhập</a>
									</div>
								</div>
								<p class="mt-3 text-center mb-3">Hoặc sử dụng tài khoản mạng xã hội</p>
								<!-- <p class="mb-2">
									<a href="{$btn_fb_login}" class="btn btn-secondary btn-block btn-login-facebook"><i class="fa fa-facebook-square cl-blue fz32"></i> Đăng
										nhập facebook</a>
								</p> -->
								<p>
									<a href="javascript:void(0)" id="customBtn1" class="btn btn-secondary btn-block mb-3 btn-login-google"><i
											class="fa fa-google text-white mr-1"></i> Đăng nhập Google</a>
								</p>
							</div>
						</div>
					</div>
					<div class="account-divider text-center">
						<span>Bạn chưa có tài khoản trên Daisan.vn?</span>
					</div>
					<a href="?mod=account&site=register" class="btn btn-primary btn-block btn-register"> Đăng ký tài
						khoản </a>
				</div>
			</div>
		</div>
	</div>
</section>
<link href="{$arg.stylesheet}css/pnotify.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/animate.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}js/pnotify.min.js"></script>
{literal}
<script>
	$('#FrmLogin input[name=Username],#FrmLogin input[name=Password]')
		.keypress(function (event) {
			if (event.which == 13)
				HodineLogin();
		});

	function HodineLogin() {
		var Email = $("#FrmLogin input[name=Email]").val();
		var Password = $("#FrmLogin input[name=Password]").val();
		var url_redirect = $("#url_redirect").val();
		if (Email == '') {
			noticeMsg('Thông báo', 'Vui lòng nhập vào email',
				'error');
			$("#FrmLogin input[name=Email]").focus();
			return false;
		} else if (Password == '' || Password.length < 6) {
			noticeMsg('Thông báo', 'Vui lòng nhập mật khẩu tối thiểu 6 ký tự',
				'error');
			$("#FrmLogin input[name=Password]").focus();
			return false;
		} else {
			loading();
			$("#FrmLogin input[name=Email]").attr('disabled', 'disabled');
			$("#FrmLogin input[name=Password]").attr('disabled', 'disabled');
			$("#FrmLogin #BtnLogin").attr('disabled', 'disabled');
			$.post("?mod=account&site=login", {
				'action': 'ajax_login',
				'Email': Email,
				'Password': Password
			}).done(function (Data) {
				Data = JSON.parse(Data);
				if (Data.Code == 0) {
					$("#FrmLogin input[name=Email]").removeAttr('disabled');
					$("#FrmLogin input[name=Password]").removeAttr('disabled');
					$("#FrmLogin #BtnLogin").removeAttr('disabled');
					noticeMsg('Thông báo', Data.Msg, 'error');
					endloading();
				} else {
					noticeMsg('Thông báo', Data.Msg, 'success');
					$.post("?mod=system&site=SetSessionLogin", {
						'Action': 'set_session_login',
						'UserId': Data.UserId
					}).done(function (e) {
						//console.log(e);
						endloading();
						location.href = url_redirect;
					});
				}
			});
		}
	}
</script>
{/literal}