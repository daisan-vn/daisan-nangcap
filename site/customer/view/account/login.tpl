<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col-md-4">
			<div class="card my-5">
				<div class="card-body mx-4">
					<div id="FrmLogin">
						<h4 class="text-center mb-4">Đăng nhập tài khoản</h4>
						<hr>
						<div class="form-group">
							<label>Tài khoản</label> 
							<input type="text" name="Username" autofocus="autofocus" class="form-control">
						</div>
						<div class="form-group">
							<label>Mật khẩu đăng nhập</label> 
							<input type="password" name="Password" class="form-control">
						</div>
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label"> 
									<input class="form-check-input" type="checkbox" name="remember" value="1"> Ghi nhớ cho lần đăng nhập tiếp theo
								</label>
							</div>
						</div>
						<div class="form-group">
							<button type="button" onclick="HodineLogin();" id="BtnLogin" class="btn btn-success">Đăng nhập</button>
						</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<input type="hidden" value="{$out.url}" id="url_redirect">
{literal}
<script>
$('#FrmLogin input[name=Username],#FrmLogin input[name=Password]').keypress(function(event) {
	if (event.which == 13) HodineLogin();
});

function HodineLogin() {
	var data = {};
	data.Username = $("#FrmLogin input[name=Username]").val();
	data.Password = $("#FrmLogin input[name=Password]").val();
	data.remember = $("#FrmLogin input[name=remember]:checked").val();
	data.action = 'ajax_login';
	data.remember = data.remember?data.remember:0;
	
	console.log(data);
	var url_redirect = $("#url_redirect").val();
	if (data.Username == '' || data.Username.length < 4) {
		noticeMsg('Thông báo', 'Vui lòng nhập tài khoản tối thiểu 4 ký tự', 'error');
		$("#FrmLogin input[name=Username]").focus();
		return false;
	} else if (data.Password == '' || data.Password.length < 6) {
		noticeMsg('Thông báo', 'Vui lòng nhập mật khẩu tối thiểu 6 ký tự', 'error');
		$("#FrmLogin input[name=Password]").focus();
		return false;
	} else {
		loading();
		$("#FrmLogin input[name=Username]").attr('disabled', 'disabled');
		$("#FrmLogin input[name=Password]").attr('disabled', 'disabled');
		$("#FrmLogin #BtnLogin").attr('disabled', 'disabled');
		$.post("?mod=account&site=login", data).done(function(Data) {
			Data = JSON.parse(Data);
			if (Data.Code == 0) {
				$("#FrmLogin input[name=Username]").removeAttr('disabled');
				$("#FrmLogin input[name=Password]").removeAttr('disabled');
				$("#FrmLogin #BtnLogin").removeAttr('disabled');
				noticeMsg('Thông báo', Data.Msg, 'error');
				endloading();
			} else {
				noticeMsg('Thông báo', Data.Msg, 'success');
				setTimeout(function(){
					endloading();
					location.href = url_redirect;
				}, 1500);
			}
		});
	}
}
</script>
{/literal}
