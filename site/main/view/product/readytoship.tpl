<link rel="stylesheet" href="{$arg.stylesheet}css/jquery.scrolling-tabs.min.css">
<script src="{$arg.stylesheet}js/jquery.scrolling-tabs.min.js"></script>

<header id="mheader" class="oem d-block d-sm-none">
	<div class="mtophead">
		<div class="d-flex justify-content-between bd-highlight p-4">
			<div class="bd-highlight"><a href=""><img src="{$arg.stylesheet}images/arrow-l.png"></a></div>
			<div class="bd-highlight text-lg">Sản Phẩm Sẵn Sàng Giao Ngay</div>
			<div class="bd-highlight">&nbsp;</div>
		</div>
	</div>

	<div class="head_menu">
		<div class="head_menu_scoll">
			<ul class="nav" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link active tab-item" data-toggle="pill" href="#tax-0">Tất cả danh mục</a>
				</li>
				{foreach from=$a_main_category key=k item=data}
				<li class="nav-item " role="presentation">
					<a class="nav-link tab-item" data-toggle="pill" href="#tax-{$data.id}">{$data.name}</a>
				</li>
				{/foreach}
			</ul>
		</div>
	</div>
</header>
<div class="main-content-wrap">
	<div class="new-arrivals d-none d-sm-block">
		<div class="video-container">
			{foreach from=$banner item = data}
			{if $data.position eq 3}
			<img src="{$data.image}" class="img-fluid">
			{/if}
			{/foreach}
		</div>
		<div class="recommend-layout">
			<div class="container-cate">
				<h3>Sản Phẩm Sẵn Sàng Giao Ngay</h3>
			</div>
		</div>
	</div>

	<div class="tab-category">
		<div class="container-cate">
			{if !$is_mobile}
			<ul class="nav nav-pills mb-3" id="pills-tab-oem" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link active tab-item" data-toggle="pill" href="#tax-0">Tất cả danh mục</a>
				</li>
				{foreach from=$a_main_category key=k item=data}
				<li class="nav-item" role="presentation">
					<a class="nav-link tab-item" data-toggle="pill" href="#tax-{$data.id}">{$data.name}</a>
				</li>
				{/foreach}
			</ul>
			{/if}
			<div class="tab-content" id="pills-tabContent">
				<div class="tab-pane fade show active" id="tax-0" role="tabpanel" aria-labelledby="pills-home-tab">
					<h3 class="text-white text-b py-3">Chỉ dành cho bạn</h3>
					<div class="row row-nm" id="Loaddb-0">
						{foreach from=$result item=v}
						<div class="col-xl-5th col-lg-5th col-md-5th col-sm-5th mb-3">
							<div class="card border-0 rounded-8">
								<div class="product-list-recommend">
									<div class="list-item-img">
										<a href="{$v.url}"><img src="{$v.avatar}" alt="{$v.name}" class="img-fluid"></a>
									</div>
									<div class="list-item-info">
										<h3 class="text-nm-1"><a href="{$v.url}" class="text-twoline text-dark">{$v.name}</a></h3>
										<div class="product-item-price text-oneline">{$v.price} {$v.pricemax}</div>
										<p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>
									</div>
								</div>
							</div>
						</div>
						<!--end col-5th-->
						{/foreach}
					</div>
				</div>
				{foreach from=$a_main_category key=k item=data}
				<div class="tab-pane fade" id="tax-{$data.id}" role="tabpanel">
					<div class="mt-3 product-deal">
						<h3 class="text-white text-b py-3">{$data.name}</h3>
						<div class="row row-nm" id="Loaddb-{$data.id}"></div>
					</div>
					<!-- end product -->
				</div>
				{/foreach}
			</div>
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
$('.tab-item').click(function () {
	var h = $(this).attr('href');
	var a_h = h.split('-');
	var data = {};
	data.id = a_h[1];
	$('#Loaddb-' + a_h[1]).load('?mod=product&site=load_more_readytoship', data);
	a_tab.id = a_h[1];
	$(window).scrollTop(0);
	a_tab.page = 1;
});

$(window).scroll(function () {
	var h = $(document).height() - $(window).height() - $('footer').height();
	if ($(window).scrollTop() >= h) {
		a_tab.page = a_tab.page + 1;
		if (a_tab.page < 11) {
			$.post('?mod=product&site=load_more_readytoship', a_tab, function (data) {
				$('#Loaddb-' + a_tab.id).append(data);
				console.log(a_tab);
			});
		}
	}
});	
</script>
{/literal}
