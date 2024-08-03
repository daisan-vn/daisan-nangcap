<header>
	<div class="container">
		<div class="py-3">
		<div class="row row-no">
			<div class="col-md-3 col-8">
				<a class="logo" href="./">
					<img src="{$arg.logo.image|default:$arg.noimg}" class="img-fluid">
				</a>
			</div>
			<div class="col-md-3 d-none d-md-block">
				<h2><a href="./">Customer Manager</a></h2>
			</div>
			<div class="col text-right">
				<div class="dropdown">
					<button class="btn btn-primary dropdown-toggle" type="button"
						role="button" id="dropdownMenuLink" data-toggle="dropdown"
						aria-haspopup="true" aria-expanded="false"> Tài khoản </button>

					<div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenuLink">
						{if $arg.login_role eq 'admin'}
						<a class="dropdown-item" href="?site=allcustomer"><i class="fa fa-users"></i> Dữ liệu khách hàng</a>
						{/if}
						<a class="dropdown-item" href="?site=statistics"><i class="fa fa-bar-chart"></i> Thống kê kết quả gọi</a>
						<a class="dropdown-item" href="?mod=account&site=logout"><i class="fa fa-user-times"></i> Đăng xuất</a>
					</div>
				</div>

			</div>
		</div>
		</div>
	</div>
</header>

