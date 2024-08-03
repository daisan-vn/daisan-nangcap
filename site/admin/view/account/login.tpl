<div class="col-sm-6 col-sm-offset-3 col-md-4 col-md-offset-4">
	<div id="login">
		<div class="text-center">
			<div><img alt="login" src="{$arg.img_gen}login.png" width="30%"></div>
			<h1>Đăng nhập</h1>
			<p>{$message}</p>
		</div>
		<hr>
		<form method="post" action="" class="form-horizontal">
			<div class="form-group">
				<input type="text" autofocus class="form-control input-lg text-center" placeholder="Tài khoản..." name="login" required>
			</div>
			<div class="form-group">
				<input type="password" class="form-control input-lg text-center" placeholder="Mật khẩu..." name="pass" required>
			</div>
			<div class="form-group text-center">
				<button type="submit" class="btn btn-success btn-lg btn-block" name="submit"><i class="fa fa-user fa-fw"></i> Đăng Nhập Quản Trị</button>
			</div>
		</form>
	</div>
</div>
