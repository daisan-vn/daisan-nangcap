<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col-md-4">
			<div class="card mt-4">
				<div class="card-body mx-4">
					<div id="FrmCont">
						<div class="text-center">
							<a href="{$arg.domain}"><img alt="hodine logo" src="{$arg.url_upload}generals/logo.png" style="width: 240px"></a>
						</div>
						<h5 class="text-center mb-4">Cập nhật mật khẩu mới Hodine</h5>
						<hr>
						{if $out.status eq 1}
						<div class="form-group">
							<label>Mật khẩu mới</label> 
							<input type="password" name="pass" autofocus="autofocus" class="form-control">
						</div>
						<div class="form-group">
							<label>Xác nhận mật khẩu</label> 
							<input type="password" name="repass" class="form-control">
						</div>
						<p>Vui lòng nhập mật khẩu mới để thay thế cho mật khẩu đã quên của bạn.</p> 
						<div class="form-group">
							<button type="button" onclick="ChangePass();" class="btn btn-success">Cập nhật mật khẩu</button>
						</div>
						{else}
						<h5 class="mb-2">Thông báo</h5>
						<p>{$out.message}</p>
						<p>Vui lòng click vào nút "Quên mật khẩu" bên dưới để thực hiện lại chức năng.</p>
						<p><a href="?site=forgetpass" class="btn btn-primary">Quên mật khẩu</a></p>
						{/if}
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
function ChangePass(){
	var data = {};
	data['pass'] = $("#FrmCont input[name=pass]").val();
	data['repass'] = $("#FrmCont input[name=repass]").val();
	data['ajax_action'] = 'change_password';
	
	if(data.pass.length < 6){
		noticeMsg('System Message', 'Vui lòng nhập tối thiểu 6 ký tự.', 'error');
		$("#FrmCont input[name=pass]").focus();
		return false;
	}else if(data.repass.length < 6){
		noticeMsg('System Message', 'Vui lòng nhập tối thiểu 6 ký tự.', 'error');
		$("#FrmCont input[name=repass]").focus();
		return false;
	}else if(data.repass!=data.pass){
		noticeMsg('System Message', 'Mật khẩu xác nhận không chính xác.', 'error');
		$("#FrmCont input[name=repass]").focus();
		return false;
	}

	loading();
	$.post('?site=resetpass', data).done(function(e){
		var rt = JSON.parse(e);
		if(rt.code==0){
			noticeMsg('System Message', rt.msg, 'error');
			endloading();
		}else{
			noticeMsg('System Message', rt.msg, 'success');
			setTimeout(function(){ location.href="?site=login"; }, 2000);
		}
		
	});

}
</script>
{/literal}
