<section class="py-5">
	<div class="container">
        <div class="row justify-content-center" >
            <div class="col-xl-5">
                <div class="form_login" id="FrmRegister">
                    <div class="card">
                        <div class="card-body">
                            <h3>Đăng ký tài khoản</h3>
                            <form>
                                <div class="form-group">
                                    <label for="Yourname" class="text-b">Họ tên</label>
                                    <input type="text" name="Name" class="form-control" placeholder="Ví dụ: Nguyen Van A">
                                </div>
                                <div class="form-group">
                                    <label for="Email" class="text-b">Email đăng nhập</label>
                                    <input type="email" class="form-control" id="Email" name="Email" aria-describedby="">
                                </div>
                                <div class="form-group">
                                    <label for="password" class="text-b">Mật khẩu</label>
                                    <input type="password" class="form-control" id="Password" name="Password" aria-describedby="">
                                    <small class="form-text text-muted">Mật khẩu phải có ít nhất 6 ký tự.</small>
                                </div>
                                <div class="form-group">
                                    <label for="password" class="text-b">Nhập lại mật khẩu</label>
                                    <input type="password" class="form-control" id="RePass" name="RePass" aria-describedby="">
                                </div>
                                <button type="button" class="btn btn-primary btn-block btn-login text-dark" onclick="HodineRegister();">
                                   Đăng ký tài khoản trên Daisan.vn
                                </button>
                                <p class="pt-3">Bằng cách tạo tài khoản, bạn đồng ý với <a target="_blank" href="/helpcenter/display.html?pId=11">Điều kiện sử dụng</a>
                                    và <a target="_blank" href="/helpcenter/display.html?pId=12">Thông báo về quyền riêng tư </a> của Daisan.vn</p>
                            </form>
                            <div class="account-divider text-center">
                                <span>Bạn đã có một tài khoản?</span>
                            </div>
                            <p>Bạn đã có một tài khoản?&nbsp;<a href="?mod=account&site=login">Đăng nhập</a></p>
                        </div>
                    </div>


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
function HodineRegister() {
    var Data = {};
    Data['Name'] = $("#FrmRegister input[name=Name]").val();
    Data['Email'] = $("#FrmRegister input[name=Email]").val();
	Data['Password'] = $("#FrmRegister input[name=Password]").val();
	Data['RePass'] = $("#FrmRegister input[name=RePass]").val();
  
    if (Data['Name'] == '' || Data['Name'].length < 6) {
		noticeMsg('Thông báo', 'Vui lòng nhập họ tên của bạn.', 'error');
		$("#FrmRegister input[name=Name]").focus();
		return false;
	}else if (Data['Email'] == '') {
		noticeMsg('Thông báo', 'Vui lòng nhập vào Email', 'error');
		$("#FrmRegister input[name=Email]").focus();
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
		$.post("?mod=account&site=register", Data).done(function(e) {
            rt = JSON.parse(e);
			if (rt.Code == 0) {
				noticeMsg('Thông báo', rt.Msg, 'error');
				endloading();
			} else {
				noticeMsg('Thông báo', rt.Msg, 'success');
				endloading();
				location.href ="?mod=account&site=verify_register"
			}
		});
	}
}
</script>
{/literal}