{if $out.login eq 0}
<div class="px-3">
	<h4 class="py-2">Bắt đầu ngay bây giờ</h4>
	<div class="">
		<a href="?mod=account&site=login"
			class="btn btn-main btn-sm link-white">Đăng nhập</a> <span
			class="p-2">Hoặc</span> <a href="?mod=account&site=register"
			class="btn btn-outline-main btn-sm">Đăng ký</a>
	</div>
	<p class="">Tiếp tục với:</p>
	<ul class="list-inline">
		<li class="list-inline-item"><a href="{$btn_fb_login}"><i
				class="fa fa-facebook-square cl-blue fz32"></i></a></li>
		<li class="list-inline-item"><a href=""><i
				class="fa fa-google-plus-square cl-red fz32"></i></a></li>
	</ul>
	<div class="py-3 login-terms">
		<div class="form-check">
			<label class="form-check-label disabled"> <input
				class="form-check-input" type="checkbox" value="" disabled
				checked="checked"> I agree to <a href=""
				class="link-black">Free Membership Agreement</a>
			</label>
		</div>
		<div class="form-check">
			<label class="form-check-label disabled"> <input
				class="form-check-input" type="checkbox" value="" disabled
				checked="checked"> I agree to <a href=""
				class="link-black">Receive Marketing Materials</a>
			</label>
		</div>
	</div>
</div>
{else}
<div class="mydaisan">
	<a href="?mod=account&site=index"
		class="link-black px-3 first">Hi, {$user.name|default:''}</a>
	<div class="px-3">
		<a class="link-black" href="?mod=account&site=index"><i
			class="fa fa-fw fa-user-circle"></i> Thông tin hồ sơ</a> <a
			class="link-black" href="?mod=account&site=index"><i
			class="fa fa-fw fa-key"></i> Đổi mật khẩu</a> <a
			class="link-black" href="?mod=account&site=pages"><i
			class="fa fa-fw fa-globe"></i> Quản lý gian hàng</a> <a
			class="link-black" href="?mod=account&site=createpage"><i
			class="fa fa-fw fa-plus"></i> Tạo gian hàng</a>
		<div class="dropdown-divider"></div>
		<a class="link-black" href="?mod=account&site=logout"><i
			class="fa fa-fw fa-sign-out"></i> Đăng xuất</a>
	</div>
</div>
{/if}