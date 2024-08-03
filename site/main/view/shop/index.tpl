<div class="main-content-wrap">
	<div class="container-fluid container-cate mt-0">
		{include file='../includes/header_shop.tpl'}

		<div class="shop_main">
			{if $a_home_sliders_show}
			<section class="mt-3">
				<div class="shop_main-slide">
					<div class="owl-carousel owl-shop-main">
						{foreach from=$a_home_sliders_show key=k item=img}
						<div class="item">
							<img src="{$img}" alt="">
						</div>
						{/foreach}
					</div>
				</div>
			</section>
			{/if}
			{if $a_category}
			<section class="shop_main-category px-3 px-sm-0 ">
				<div class="section-title">
					<h2>Danh mục nổi bật</h2>
				</div>
				<div class="row row-nm">

					{foreach from=$a_category key=k item=v}

					<div class="col-xl-6 col-lg-6 col-md-6 col-6">

						<div class="card border-0 mb-3">

							<div class="d-flex align-items-center pb-2 px-sm-3 pt-2">

								<div class="flex-grow-1 text-oneline">

									<a href="{$profile.url}?site=products&cat={$v.id}"
										class="text-nm-1 text-dark text-b">{$v.name}</a>

								</div>

							</div>

							<div class="row row-sm">

								{foreach from=$v.products key=k2 item=v2}

								<div class="col-md-3 col-4 {if $k2 eq 3}d-none d-sm-block{/if}">

									<div class="item p-sm-3 text-center">

										<a href="{$v2.url}" class="overlay-link">

											<img class="img-fluid" src="{$v2.avatar}">

										</a>

									</div>

								</div>

								{/foreach}

							</div>

							<!-- end row -->

						</div>

					</div>

					{/foreach}

				</div>

				<div class="show-more-text d-block d-sm-none"><span>Xem Tất Cả<i
							class="fa fa-angle-right fa-fw"></i></span></div>

			</section>
			{/if}
			{if $a_home_product_main}
			<section class="shop_main-producthot px-3 px-sm-0">
				<div class="section-title">
					<div class="d-flex align-items-center">
						<div class="flex-grow-1 text-oneline">
							<h2>Bán chạy nhất</h2>
						</div>
						<a href="{$profile.url}?site=products" class="d-none d-sm-block">Xem tất cả</a>
					</div>
				</div>
				<div class="row row-nm">
					{foreach from=$a_home_product_main key=k item=v}
					<div class="col-xl-3">
						<div class="card border-0 mb-3">
							<div class="card-body">
								<div class="producthot__badage">
									<img src="{$arg.url_img}icons/label_top.png">
									<span class="producthot__badage-value">{$k+1}</span>
								</div>
								<div class="item-img text-center">
									<a href="{$v.url}" class="d-block"><img src="{$v.avatar}" class="img-fluid"></a>
								</div>
								<div class="list-item-info">
									<h3 class="text-nm-1"><a href="{$v.url}"
											class="text-twoline text-dark">{$v.name}</a></h3>
									<div class="product-item-price text-oneline mt-3">
										{$v.price}
									</div>
								</div>
							</div>
						</div>
					</div>
					<!--end col-4-->
					{/foreach}
				</div>
				<div class="show-more-text d-block d-sm-none"><span>Xem Tất Cả<i
							class="fa fa-angle-right fa-fw"></i></span></div>
			</section>
			{/if}
			<section class="shop_main-productlist px-3 px-sm-0 mt-3">
				<div class="section-title">
					<div class="d-flex align-items-center">
						<div class="flex-grow-1 text-oneline">
							<h2>Sản phẩm mới</h2>
						</div>
						<a href="{$profile.url}?site=products" class="d-none d-sm-block">Xem tất cả</a>
					</div>
				</div>
				<div class="card border-0">
					<div class="row row-nm">
						{foreach from=$result item=v}
						<div class="col-xl-5th col-sm-5th col-6 mb-3">
							<div class="shop_main-product-item">
								<div class="card border-0 rounded-8">
									<div class="p-3">
										<div class="list-item-img">
											<a href="{$v.url}"><img src="{$v.avatar}" class='img-fluid'></a>
										</div>
										<div class="list-item-info">
											<h3 class="text-nm-1"><a href="{$v.url}"
													class='text-twoline text-dark'>{$v.name}</a></h3>
											{if $v.promo eq 0}
											{if $v.price eq 'Liên hệ'}
											<p>Giá bán: <b>{$v.price_show}</b></p>
											{else}
											<p class="product-item-price">{$v.price_show}</p>
											{/if}
											{else}
											<p class="product-item-price">{$v.price_promo}</p>
											<p>
												<span class="price-old">{$v.price_show}</span>
												<span class="price-promo">-{$v.promo}%</span>
											</p>
											{/if}
										</div>
									</div>
								</div>
							</div>
						</div>
						{/foreach}
					</div>
					<div class="text-center my-3">
						<a href="{$profile.url}?site=products" class="btn btn-outline-primary btn">Xem thêm</a>
					</div>
			</section>
		</div>
	</div>
</div>

<script>
	$('.owl-shop-main').owlCarousel({
		loop: true,
		margin: 10,
		responsiveClass: true,
		navText: ["<i class='fa fa-chevron-left'></i>", "<i class='fa fa-chevron-right'></i>"],
		responsive: {
			0: {
				items: 1,
				nav: true
			},
			600: {
				items: 1,
				nav: false
			},
			1000: {
				items: 1,
				nav: true,
				stagePadding: 200,
				margin: 20,
			}
		}
	})
</script>