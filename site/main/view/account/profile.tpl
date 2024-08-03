<div class="bg-white py-3">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-md-7">
				<nav aria-label="breadcrumb">
					<ol class="breadcrumb">
						<li class="breadcrumb-item"><a href="?mod=account&site=index">Tài khoản của bạn</a></li>
						<li class="breadcrumb-item">Đăng nhập & bảo mật</li>

					</ol>
				</nav>
				<h1>Đăng nhập & bảo mật</h1>
				<div class="card">
					<div class="card-body">
						<p class="mb-1">Tài khoản <b>{$user.name|default:''}</b> đã được khởi tạo ngày
							{$user.created|date_format:"d/m/Y"}</p>
						<p class="mb-3">Dưới đây là các thông tin cơ bản cho tài khoản, bạn có thể cập nhật lại các
							thông tin
							bên dưới</p>

						<table class="table table-border-bottom">
							<tr>
								<td width="25%">Ảnh đại diện</td>
								<td>
									<div class="img-thumbnail w-25">
										<img class="rounded-circle" alt="avatar" src="{$user.avatar}" width="100%">
									</div>
								</td>
								<td width="20%" class="text-right">
									<a href="javascript:void(0);" data-toggle="modal" data-target="#FormAvatar"
										class="text-sm">
										<i class="fa fa-fw fa-pencil"></i>Chỉnh sửa
									</a>
								</td>
							</tr>
							<tr>
								<td width="25%">Họ tên</td>
								<td><b id="show-name">{$user.name|default:''}</b></td>
								<td width="20%" class="text-right">
									<a href="javascript:void(0);" onclick="LoadChange('name');" class="text-sm">
										<i class="fa fa-fw fa-pencil"></i>Chỉnh sửa
									</a>
								</td>
							</tr>
							<tr>
								<td width="25%">Điện thoại</td>
								<td><b id="show-phone">{$user.phone|default:''}</b></td>
								<td class="text-right">
									<a href="javascript:void(0);" onclick="LoadChange('phone');" class="text-sm">
										<i class="fa fa-fw fa-pencil"></i>Chỉnh sửa
									</a>
								</td>
							</tr>
							<tr>
								<td width="25%">Email</td>
								<td><b id="show-email">{$user.email|default:''}</b></td>
								<td class="text-right">
									<a href="javascript:void(0);" onclick="LoadChange('email');" class="text-sm">
										<i class="fa fa-fw fa-pencil"></i>Chỉnh sửa
									</a>
								</td>
							</tr>
							<tr>
								<td width="25%">Mật khẩu</td>
								<td>
									<h3>************</h3>
									<p class="text-sm">(Khuyến cáo nên thay đổi mật khẩu sau 3 tháng sử dụng để đảm bảo
										tính bảo
										mật)</p>
								</td>
								<td class="text-right">
									<a href="javascript:void(0);" data-toggle="modal" data-target="#FormPassword"
										class="text-sm">
										<i class="fa fa-fw fa-pencil"></i>Chỉnh sửa
									</a>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" tabindex="-1" id="FormAvatar">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Cập nhật ảnh đại diện</h5>
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
			</div>
			<div class="modal-body">

				<div class="row row-sm mb-3">
					<div class="col-md-3">
						<span class="border d-block">
							<img src="{$user.avatar}" id="ShowImg" width="100%">
						</span>
					</div>
					<div class="col-md-9">
						<input type="file" id="UploadImg" onchange="LoadImage(this);">
						<input type="hidden" name="avatar">
						<small class="form-text text-muted"> Kích thước file tối đa 200Mb, hỗ trợ định dạng jpg,
							png.</small>
						<small class="form-text text-muted"> Tỉ lệ ảnh phù hợp là 1x1. Nên để kích thước 100x100
							pixcel.</small>
					</div>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="SaveAvatar();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" tabindex="-1" id="FormName">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Cập nhật tên tài khoản</h5>
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Tên tài khoản được hiển thị khi nhìn thấy bạn</label>
					<input type="text" class="form-control" name="name">
					<small class="form-text text-muted">Nên để tên cá nhân hoặc biệt danh để người khác dễ dàng nhận ra
						bạn.</small>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="SaveName();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" tabindex="-1" id="FormPhone">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Cập nhật số điện thoại</h5>
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<input type="text" class="form-control" name="phone">
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="SavePhone();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" tabindex="-1" id="FormEmail">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Cập nhật email</h5>
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<input type="text" class="form-control" name="email">
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="SaveEmail();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" tabindex="-1" id="FormPassword">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Thay đổi mật khẩu đăng nhập</h5>
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
			</div>
			<div class="modal-body">
				<p>Nhập đầy đủ các thông tin bên dưới để thay đổi mật khẩu của bạn.</p>
				<div class="form-group row mb-5">
					<label class="col-sm-4 col-form-label">Mật khẩu cũ</label>
					<div class="col-sm-8">
						<input type="password" class="form-control" name="oldpass">
					</div>
				</div>

				<div class="form-group row">
					<label class="col-sm-4 col-form-label">Mật khẩu mới</label>
					<div class="col-sm-8">
						<input type="password" class="form-control" name="newpass">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-4 col-form-label">Xác nhận mật khẩu</label>
					<div class="col-sm-8">
						<input type="password" class="form-control" name="renewpass">
					</div>
				</div>

				<div class="form-group">
					<small class="form-text text-muted"><b>Lưu ý:</b> Mật khẩu phải có độ dài tối thiểu là 6 ký tự, bao
						gồm các ký tự chữ hoặc số hoặc một số ký tự đặc biệt (_*@#).</small>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="ChangePass();">Thay đổi mật khẩu</button>
			</div>
		</div>
	</div>
</div>


{literal}
<script type="text/javascript">
	function LoadChange(type) {
		loading();
		$.post('?mod=account&site=profile', { 'ajax_action': 'load_account_content' }).done(function (e) {
			var data = JSON.parse(e);
			if (type == 'name') {
				$("#FormName input[name=name]").val(data.name);
				$("#FormName").modal('show');
			} else if(type=='phone'){
				$("#FormPhone input[name=phone]").val(data.phone);
				$("#FormPhone").modal('show');
			} else if(type=='email'){
				$("#FormEmail input[name=email]").val(data.email);
				$("#FormEmail").modal('show');
			}
			endloading();
		});
	}

	function SaveName() {
		var data = {};
		data['name'] = $("#FormName input[name=name]").val();
		data['ajax_action'] = 'save_account_content';
		data['type'] = 'name';

		if (data.name.length < 6) {
			noticeMsg('System Message', 'Vui lòng nhập tối thiểu 6 ký tự.', 'error');
			$("#FormName input[name=name]").focus();
			return false;
		}
		loading();
		$.post('?mod=account&site=profile', data).done(function (e) {
			$("#show-name").html(data.name);
			noticeMsg('System Message', 'Cập nhật tên tài khoản thành công.', 'success');
			$("#FormName").modal('hide');
			endloading();
		});
	}
	function SavePhone() {
		var data = {};
		data['phone'] = $("#FormPhone input[name=phone]").val();
		data['ajax_action'] = 'save_account_content';
		data['type'] = 'phone';

		if (data.phone.length =='') {
			noticeMsg('System Message', 'Vui lòng nhập số điện thoại cần thay đổi.', 'error');
			$("#FormPhone input[name=phone]").focus();
			return false;
		}
		loading();
		$.post('?mod=account&site=profile', data).done(function (e) {
			$("#show-phone").html(data.phone);
			noticeMsg('System Message', 'Cập nhật số điện thoại thành công.', 'success');
			$("#FormPhone").modal('hide');
			endloading();
		});
	}
	function SaveEmail() {
		var data = {};
		data['email'] = $("#FormEmail input[name=email]").val();
		data['ajax_action'] = 'save_account_content';
		data['type'] = 'email';

		if (data.email.length =='') {
			noticeMsg('System Message', 'Vui lòng nhập email cần thay đổi.', 'error');
			$("#FormEmail input[name=email]").focus();
			return false;
		}
		loading();
		$.post('?mod=account&site=profile', data).done(function (e) {
			$("#show-email").html(data.email);
			noticeMsg('System Message', 'Cập nhật email thành công.', 'success');
			$("#FormEmail").modal('hide');
			endloading();
		});
	}

	function ChangePass() {
		var data = {};
		data['oldpass'] = $("#FormPassword input[name=oldpass]").val();
		data['newpass'] = $("#FormPassword input[name=newpass]").val();
		data['renewpass'] = $("#FormPassword input[name=renewpass]").val();
		data['ajax_action'] = 'change_password';

		if (data.oldpass.length < 6) {
			noticeMsg('System Message', 'Vui lòng nhập tối thiểu 6 ký tự.', 'error');
			$("#FormPassword input[name=oldpass]").focus();
			return false;
		} else if (data.newpass.length < 6) {
			noticeMsg('System Message', 'Vui lòng nhập tối thiểu 6 ký tự.', 'error');
			$("#FormPassword input[name=newpass]").focus();
			return false;
		} else if (data.renewpass.length < 6) {
			noticeMsg('System Message', 'Vui lòng nhập tối thiểu 6 ký tự.', 'error');
			$("#FormPassword input[name=renewpass]").focus();
			return false;
		} else if (data.renewpass != data.newpass) {
			noticeMsg('System Message', 'Mật khẩu xác nhận không chính xác.', 'error');
			$("#FormPassword input[name=renewpass]").focus();
			return false;
		}

		loading();
		$.post('?mod=account&site=profile', data).done(function (e) {
			var rt = JSON.parse(e);
			if (rt.code == 0) {
				noticeMsg('System Message', rt.msg, 'error');
			} else {
				noticeMsg('System Message', rt.msg, 'success');
				$("#FormPassword").modal('hide');
				$("#FormPassword input").val('');
			}
			endloading();
		});

	}

	function LoadImage(input) {
		loading();
		if (input.files && input.files[0]) {
			var fileImg = input.files[0];
			var _URL = window.URL || window.webkitURL;
			var img = new Image();
			img.onload = function () {
				if (this.width / this.height > 1.5 || this.width / this.height < 0.5) {
					noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp tỉ lệ 1x1, vui lòng chọn lại.', 'error');
					$("#UploadImg").val('');
					$("#FormAvatar input[name=avatar]").val('');
					$("#ShowImg").attr('src', arg.noimg);
					return false;
				} else {
					var reader = new FileReader();
					reader.onload = function (e) {
						$("#ShowImg").attr('src', e.target.result);
						$("#FormAvatar input[name=avatar]").val(e.target.result);
					}
					reader.readAsDataURL(fileImg);
				}
			}
			img.src = _URL.createObjectURL(fileImg);
			endloading();
		}
	}

	function SaveAvatar() {
		var data = {};
		data['avatar'] = $("#FormAvatar input[name=avatar]").val();
		data['ajax_action'] = "change_avatar";
		if (data.avatar.length < 10) {
			noticeMsg('System Message', 'Vui lòng chọn ảnh avatar.', 'error');
			return false;
		}

		loading();
		$.post('?mod=account&site=profile', data).done(function (e) {
			noticeMsg('System Message', 'Thay đổi ảnh đại diện thành công.', 'success');
			$("#FormAvatar").modal('hide');
			$("#UploadImg").val('');
			$("#FormAvatar input[name=avatar]").val('');
			location.reload();
			endloading();
		});

	}
</script>
{/literal}