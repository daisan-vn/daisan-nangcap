<link rel="stylesheet" href="{$arg.stylesheet}css/jquery.scrolling-tabs.min.css">
<script src="{$arg.stylesheet}js/jquery.scrolling-tabs.min.js"></script>

<div class="main_content toprank promonotions">
	{foreach from=$banner item = data}
	{if $data.position eq 4}
	<div class="zone-header d-none d-sm-block"
		style="background: url('{$data.image}');background-size: 100%;">
		<div class="countdown" data-countdown="{$arg.end_countdown}"></div>
	</div>
	{/if}
	{/foreach}
	
	{if $is_mobile}
	<header id="mheader" class="oem d-block d-sm-none">
		<div class="mtophead">
			<div class="d-flex justify-content-between bd-highlight p-4">
				<div class="bd-highlight"><a href=""><img src="{$arg.stylesheet}images/arrow-l.png"></a></div>
				<div class="bd-highlight text-lg">Ưu Đãi Trong Hôm Nay</div>
				<div class="bd-highlight">&nbsp;</div>
			</div>
			<div class="countdown py-5" data-countdown="2020/12/06"></div>
		</div>

		<div class="head_menu">
			<div class="head_menu_scoll">
				<ul class="nav" role="tablist">
					<li class="nav-item" role="presentation">
						<a class="nav-link active tab-product" data-toggle="pill" href="#tab-0">Toàn bộ danh mục</a>
					</li>
					{foreach from=$a_category key=k item=data}
					<li class="nav-item " role="presentation">
						<a class="nav-link tab-product" data-toggle="pill" href="#tax-{$data.id}">{$data.name}</a>
					</li>
					{/foreach}
				</ul>
			</div>
		</div>
	</header>
	{/if}
</div>
<div class="container pt-3">
	{if !$is_mobile}
	<ul class="nav nav-pills mb-3" id="pills-tab-product-new" role="tablist">
		<li class="nav-item" role="presentation">
			<a class="nav-link active tab-product" data-toggle="pill" href="#tab-0">Toàn bộ danh mục</a>
		</li>
		{foreach from=$a_category key=k item=data}
		<li class="nav-item" role="presentation">
			<a class="nav-link tab-product" data-toggle="pill" href="#tax-{$data.id}">{$data.name}</a>
		</li>
		{/foreach}
	</ul>
	{/if}
	<div class="tab-content" id="pills-tabContent">
		<div class="tab-pane fade show active" id="tab-0" role="tabpanel" aria-labelledby="pills-home-tab">
			<div class="mt-3 product-deal">
				<h3 class="text-white text-b py-3">Chỉ dành cho bạn</h3>
				<div class="row row-nm" id="LoadProduct0">
					{foreach from=$result item=v}
					<div class="col-xl-5th col-lg-5th col-md-5th col-sm-5th">
						<div class="rounded-10 bg-white item-product mb-3">
							<a href="{$v.url}"><img class="rounded-top-10 img-fluid" src="{$v.avatar}" alt="{$v.name}"></a>
							<div class="prod-info p-3">
								<h3 class="text-nm-1 line-2">
									<a href="{$v.url}">{$v.name}</a>
								</h3>
								<div class="product-item-price text-oneline">{$v.price_promo}</div>
								<p class="mb-3">
									<span class="price-old">{$v.price_show}</span>
									<span class="price-promo">-{$v.promo}%</span>
								</p>
								<div class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</div>
							</div>
						</div>
					</div>
					{/foreach}
				</div>
			</div>
		</div>
		{foreach from=$a_category key=k item=data}
		<div class="tab-pane fade" id="tax-{$data.id}" role="tabpanel">
			<div class="mt-3 product-deal">
				<h3 class="text-white text-b py-3">{$data.name}</h3>
				<div class="row row-nm" id="LoadProduct{$data.id}"></div>
			</div>
			<!-- end product -->
		</div>
		{/foreach}
	</div>
</div>
</div>
{literal}
<script>
	var a_tab = {};
	a_tab.page = 1;
	a_tab.id = 0;
	$('.nav-pills').scrollingTabs({
		scrollToTabEdge: true,
		cssClassLeftArrow: 'fa fa-angle-left',
		cssClassRightArrow: 'fa fa-angle-right',
		disableScrollArrowsOnFullyScrolled: true,
		handleDelayedScrollbar: true,
		forceActiveTab: true
	});
	function ShowMenumCategories() {
		$(".mmenu_all_categories").toggleClass("active")
	}
	$('.mmenu_all_categories ul li').click(function () {
		$('.mmenu_all_categories').removeClass('active');
	});
	$('.tab-product').click(function () {
		var h = $(this).attr('href');
		var a_h = h.split('-');
		var data = {};
		data.id = a_h[1];
		$('#LoadProduct' + a_h[1]).load('?mod=product&site=load_more_promotions', data);
		a_tab.id = a_h[1];
		$(window).scrollTop(0);
		a_tab.page = 1;
	});

	$(window).scroll(function () {
		var h = $(document).height() - $(window).height() - $('footer').height();
		if ($(window).scrollTop() >= h) {
			a_tab.page = a_tab.page + 1;
			if (a_tab.page < 11) {
				$.post('?mod=product&site=load_more_promotions', a_tab, function (data) {
					$('#LoadProduct' + a_tab.id).append(data);
					console.log(a_tab);
				});
			}
		}
	});	
</script>
{/literal}