<section class="loginn bg-white py-5">
	<div class="container">
		<div class="row">
			<div class="col-xl-7">
				<!-- Ad Page Login Social Daisanvn -->
				<ins class="adsbygoogle" style="display:block" data-ad-client="ca-pub-7751440498976455"
					data-ad-slot="3958031855" data-ad-format="auto" data-full-width-responsive="true"></ins>
				<script>
					(adsbygoogle = window.adsbygoogle || []).push({});
				</script>
			</div>
			<div class="col-xl-5">
				<div class="form_login">
					<div class="card">
						<div class="card-body text-center">
							<h3>Đăng nhập</h3>
							<div id="FrmLogin">
								<p class="text-center">
									<a class="btn btn-secondary btn-block py-2" href="?mod=account&site=register">Đăng
										ký
										tài khoản</a>
									<span class="d-block my-2">Hoặc tiếp tục bằng</span>
									<a href="{$btn_fb_login}" class="btn btn-block btn-primary btn-login-facebook"><i
											class="fa fa-facebook-square cl-blue fz32"></i> Đăng
										nhập facebook</a>
									<a href="javascript:void(0)" id="customBtn1"
										class="btn btn-block btn-danger btn-login-google"><i class="fa fa-google"></i>
										Đăng nhập Google</a>
								</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>



<input type="hidden" value="{$arg.client_id}" id="google_login_id">

<input type="hidden" value="{$out.url}" id="url_redirect">

<link href="{$arg.stylesheet}css/pnotify.min.css" rel="stylesheet">

<link href="{$arg.stylesheet}css/animate.min.css" rel="stylesheet">

<script src="{$arg.stylesheet}js/pnotify.min.js"></script>

<script src="https://apis.google.com/js/api:client.js"></script>

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



	var googleUser = {};

	var google_login_id = $("#google_login_id").val();

	var startApp = function () {

		gapi.load('auth2', function () {

			auth2 = gapi.auth2.init({

				client_id: google_login_id,

				cookiepolicy: 'single_host_origin',

			});

			onSignInGoogle(document.getElementById('customBtn'));

		});

	};



	function onSignInGoogle(element) {

		auth2.attachClickHandler(element, {},

			function (googleUser) {

				var datalogin = {};

				console.log(googleUser);

				datalogin.id = googleUser.getBasicProfile().getId();

				datalogin.name = googleUser.getBasicProfile().getName();

				datalogin.avatar = googleUser.getBasicProfile().getImageUrl();

				datalogin.email = googleUser.getBasicProfile().getEmail();

				datalogin.action = 'ajax_login_google';

				$.post("?mod=account&site=login", datalogin).done(function (e) {

					var rt = JSON.parse(e);

					if (rt.code == 0) {

						noticeMsg('Thông báo', rt.msg, 'error');

						endloading();

						return false;

					} else {

						noticeMsg('Thông báo', 'Đăng nhập thành công.', 'success');

						endloading();

						var url_redirect = $("#url_redirect").val();

						var url_fr = $("#url_fr").val();

						if (rt.Token && rt.Token != '' && url_fr != '') url_redirect += '&token=' + rt.Token;

						location.href = url_redirect;

					}

				});

			});

	}

	startApp();



</script>

{/literal}