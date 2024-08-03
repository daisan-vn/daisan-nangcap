{if !$is_mobile}
<header>
	<div class="head_main py-2 shadow-sm">
		<div class="container-fluid px-2 px-sm-5">
			<nav class="navbar navbar-expand-lg px-0">
				<a class="navbar-brand" href="./"><img src="{$arg.logo.image}"
					height="36"></a>
				<form class="form-inline my-2 my-lg-0 w-sm-100 search">
					<div class="input-group">
						<input type="text" class="form-control"
							aria-label="Tôi đang tìm kiếm" placeholder="Tôi đang tìm kiếm" id="search_key">
						<div class="input-group-append">
							<button
								class="btn bg-white border-top border-bottom border-right dropdown-toggle"
								type="button" data-toggle="dropdown" aria-haspopup="true"
								aria-expanded="false"></button>
							<div class="dropdown-menu">
								<ul class="categories-list row row-sm">
									<li class="col-6 categories-list-item"><a href="#1"
										data-id="1" class="js-choose_category"><span
											class="icon icon-restaurant icon_small"></span>Nhà hàng</a></li>
									<li class="col-6 categories-list-item"><a href="#2"
										data-id="2" class="js-choose_category"><span
											class="icon icon-coffee icon_small"></span>Café</a></li>
									<li class="col-6 categories-list-item"><a href="#3"
										data-id="3" class="js-choose_category"><span
											class="icon icon-entertainment icon_small"></span>Giải trí</a></li>
									<li class="col-6 categories-list-item"><a href="#4"
										data-id="4" class="js-choose_category"><span
											class="icon icon-atm icon_small"></span>ATM &amp; Ngân hàng</a></li>
									<li class="col-6 categories-list-item"><a href="#5"
										data-id="5" class="js-choose_category"><span
											class="icon icon-fuel icon_small"></span>Trạm xăng</a></li>
									<li class="col-6 categories-list-item"><a href="#6"
										data-id="6" class="js-choose_category"><span
											class="icon icon-health icon_small"></span>Dịch vụ y tế</a></li>
									<li class="col-6 categories-list-item"><a href="#7"
										data-id="7" class="js-choose_category"><span
											class="icon icon-hotel icon_small"></span>Khách sạn &amp; Du
											lịch</a></li>
								</ul>
							</div>
						</div>
					</div>
					<div class="ml-sm-3 w-sm-100">
						<select class="custom-select" id="inputGroupSelect01">
							<option selected>Vị trí hiện tại của bản đồ</option>
							<option value="1">Hà Nội</option>
							<option value="2">Hồ Chí Minh</option>
							<option value="3">Đà Nẵng</option>
						</select>
					</div>
					<div class="ml-sm-3">
						<button type="button" class="btn btn-success btn-sm-block px-5">
							<i class="fa fa-search"></i>
						</button>
					</div>
				</form>
				<ul class="navbar-nav ml-auto">
					<li class="nav-item"><a class="nav-link" href="#">Phản
							hồi</a></li>
					<li class="nav-item"><a class="nav-link"
						href="https://partner.daisan.vn/">Đăng ký nhà bán</a></li>

				</ul>
			</nav>
			<!-- end nav -->
		</div>
		<!-- end nav -->
	</div>
</header>
{else}
<header>
	<div id="headsearch" class="p-2">
		<div class="input-group">
			<div class="input-group-append">
				<span class="input-group-text border-0" id="mmenu_map"><i
					class="fa fa-bars" aria-hidden="true"></i> </span> <span
					class="input-group-text border-0 bg-white"><i
					class="fa fa-search"></i></span>
			</div>
			<input class="form-control border-0 rounded-0"
				placeholder="Tìm kiếm sản phẩm or nhà cung cấp">
		</div>
	</div>
	<nav id="sidebar" class="active d-block d-sm-none">
		<div class="sidebar-header">
			{if $arg.login eq 0}
			<div class="avatar mb-2">
				<a href="#"><img src="{$arg.loginimg}" class="img-fluid"></a>
			</div>
			<a href="?mod=account&site=login">Đăng nhập</a><span
				class="split-line">|</span><a href="?mod=account&site=register">Đăng
				ký</a> {else}
			<div class="avatar mb-2">
				<a href="#"><img src="{$user.avatar}" class="img-fluid"></a>
			</div>
			<a href="?mod=account&site=index">{$user.name|default:''}</a> <span
				class="px-1">|</span> <a href="?mod=account&site=logout"
				class="link-black">Thoát</a>{/if}
		</div>
		<ul class="list-unstyled components">
			<li><a href="./"><i class="fa fa-home fa-fw"></i>Trang chủ</a></li>
			<div class="dropdown-divider"></div>
			{if $arg.login neq 0}
			<li><a href="?mod=account&site=index"><i
					class="fa fa-user-o fa-fw"></i><span> Tài khoản</span></a></li> {/if}
			<li><a href="{$arg.url_sourcing}?site=createRfq"><i
					class="fa fa-envelope-o fa-fw"></i><span> Tạo yêu cầu báo
						giá</span></a></li>
			<li><a href="?mod=account&site=rfq"> <i
					class="fa fa-heart-o fa-fw"></i><span> Danh sách nhu cầu</span></a></li>
			<li><a href="?mod=account&site=pages"><i
					class="fa fa-fw fa-diamond"></i> Quản lý gian hàng</a></li>
			<li><a href="?mod=account&site=messages"><i
					class="fa fa-envelope-o fa-fw"></i><span> Tin nhắn liên hệ</span></a></li>
			<li><a href="?mod=product&site=cart"> <i
					class="fa fa-shopping-basket fa-fw"></i><span> Giỏ hàng</span></a></li>
			<li><a href="?mod=account&site=orders"> <i
					class="fa fa-file-o fa-fw"></i><span> Đơn đặt hàng</span></a></li>
			<li><a href="?mod=account&site=pagefavorites"> <i
					class="fa fa-heart-o fa-fw"></i><span> Gian hàng theo dõi</span></a></li>
			<li><a href="?mod=account&site=productfavorites"> <i
					class="fa fa-heart-o fa-fw"></i><span> Sản phẩm yêu thích</span></a></li>
		</ul>
	</nav>
</header>
{/if} {literal}
<script>
	$("#search_key").click(function() {
		$('.dropdown-menu').toggleClass('show')
	});
	$(document).ready(function() {
		if ($(window).width() < 700) {
			$('#mmenu_map').on('click', function() {
				$('#sidebar').removeClass('active');
				$('.overlay').fadeIn();
				$('a[aria-expanded=true]').attr('aria-expanded', 'false');
			});
			$('.overlay').on('click', function() {
				$('#sidebar').addClass('active');
				$('.overlay').fadeOut();
			});

		} else {
			$('#mmenu_map').on('click', function() {
				$("#sidebar").toggleClass('active');
				$('#content').toggleClass('active');
			});
		}
	});
</script>
{/literal}
