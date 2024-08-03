<link href="{$arg.stylesheet}css/owl.carousel.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}js/owl.carousel.min.js"></script>
<style>
	.owl-carousel .owl-item img {
		width: auto !important;
		margin: 0 auto;
	}
</style>
<div class="bg-white pt-3 box-account">
	<div class="container">
		<h1 class="mb-3">Tài khoản</h1>
		<div class="row row-nm">
			<div class="col-md-4 mb-3">
				<div class="card mb-4 h-100 account-item">
					<div class="card-body">
						<a href="?mod=account&site=orders" class="text-dark ">
							<div class="row row-sm">
								<div class="col-3">
									<img alt="Your Orders" class="w-100"
										src="{$arg.url_img}icons/account_ic_cart.png">
								</div>
								<div class="col-9">
									<div>
										<h2 class="h4">Đơn đặt hàng</h2>
										<span class="text-secondary">Đơn mua hàng từ các nhà bán</span>
									</div>
								</div>
							</div>
						</a>
					</div>
				</div>
			</div>
			<div class="col-md-4 mb-3">
				<div class="card h-100 account-item">
					<div class="card-body">
						<a href="?mod=account&site=profile" class="text-dark ">
							<div class="row row-sm">
								<div class="col-3">
									<img alt="Your Orders" class="w-100"
										src="{$arg.url_img}icons/account_ic_locks.png">
								</div>
								<div class="col-9">
									<div>
										<h2 class="h4">Tài khoản và bảo mật</h2>
										<span class="text-secondary">Quản lý thông tin tài khoản và bảo mật</span>
									</div>
								</div>
							</div>
						</a>
					</div>
				</div>
			</div>
			<div class="col-md-4 mb-3">
				<div class="card h-100 account-item">
					<div class="card-body">
						<a href="?mod=account&site=pages" class="text-dark ">
							<div class="row row-sm">
								<div class="col-3">
									<img alt="Your Orders" class="w-100"
										src="{$arg.url_img}icons/account_ic_shop.png">
								</div>
								<div class="col-9">
									<div>
										<h2 class="h4">Gian hàng của bạn</h2>
										<span class="text-secondary">Danh sách gian hàng bán trên Daisan</span>
									</div>
								</div>
							</div>
						</a>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card mb-4 h-100 account-item">
					<div class="card-body">
						<a href="?mod=account&site=rfq" class="text-dark ">
							<div class="row row-sm">
								<div class="col-3 text-center">
									<img alt="Your Orders" class=""
										src="{$arg.url_img}icons/account_rfq.png" height="35">
								</div>
								<div class="col-9">
									<div>
										<h2 class="h4">RFQ</h2>
										<span class="text-secondary">Yêu cầu báo giá sản phẩm</span>
									</div>
								</div>
							</div>
						</a>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card mb-4 h-100 account-item">
					<div class="card-body">
						<a href="?mod=account&site=messages" class="text-dark ">
							<div class="row row-sm">
								<div class="col-3">
									<img alt="Your Orders" class="w-100"
										src="{$arg.url_img}icons/account_ic_1.png">
								</div>
								<div class="col-9">
									<div>
										<h2 class="h4">Tin nhắn và liên hệ</h2>
										<span class="a-color-secondary">Các ưu đãi, quà tặng dành riêng cho bạn</span>
									</div>
								</div>
							</div>
						</a>
					</div>
				</div>
			</div>
		</div>
		<hr class="my-5">
		<div class="row row-nm">
			{foreach from=$category item=c}
			<div class="col-md-4 mb-3">
				<div class="card h-100">
					<div class="card-body">
						<h2 class="h5 text-b">{$c.name}</h2>
						<ul class="a-unordered-list a-nostyle a-vertical">
							{foreach from=$c.posts item=v}
							<li class="mb-2"><span class="a-list-item"><a href="{$arg.url_helpcenter}display.html?pId={$v.id}">{$v.title}</a></span></li>
							{/foreach}
						</ul>
					</div>
				</div>
			</div>
			{/foreach}
		</div>
	</div>
	<hr class="mt-4">
	<div class="container-fluid">
		<div class="cate-banner-wrap">
			<h2 class="h4 text-b py-4">Sản Phẩm Có Thể Bạn Quan Tâm</h2>
			<div id="product_justforyou" class="mb-3"></div>
		</div>
	</div>
</div>
{literal}
<script>
	$('.owl-sanphambanchay').owlCarousel(
		{
			loop: true,
			margin: 10,
			nav: true,
			dots: false,
			thumbs: true,
			navText: ["<i class='fa fa-chevron-left'></i>",
				"<i class='fa fa-chevron-right'></i>"],
			responsive: {
				0: {
					items: 2,
				},
				600: {
					items: 3,
				},
				1000: {
					items: 7,
				}
			}
		});
</script>
{/literal}