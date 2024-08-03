<div class="main-content-wrap">
	<div class="container container-cate">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb">
				{$breadcrumb}
			</ol>
		</nav>
		<div class="section-title">
			<h2 class="title-not-line text-center">{$out.number|default:0} sản phẩm trong "{$taxonomy.name}"</h2>
		</div>
		{if isset($out.a_keyword)}
			<div class="search__suggestions mb-3">
				{foreach from=$out.a_keyword key=k item=v}
				<a href="{$v.url}" class="image-tag" onclick="setViewKey({$v.id});">
					<div class="image-tag__img" style="background: url('{$v.image}');">
					</div>
					{$v.name}
				</a>
				{/foreach}
			</div>
		{/if}
		<section class="section-product-recommend overflow-hidden">
			{if count($a_category) eq 0}
			{if $ads}
			<div class="owl-carousel owl-theme owl-adsproduct mb-3">
				{foreach from=$ads key=k item=v}
				<div class="item card border-0 rounded-8">
					<div class="product-list-recommend">
						<div class="list-item-img">
							<a href="{$v.url}?{$v.url_ads}"><img data-src="{$v.avatar}" class="img-fluid" loading="lazy"></a>
						</div>
						<div class="list-item-info">
							<h3 class="text-nm-1"><a href="{$v.url}?{$v.url_ads}"
									class="text-twoline text-dark">{$v.name}</a></h3>
							<div class="product-item-price text-oneline">
								{$v.price}
							</div>
							<p class="pt-1 mb-0"><a href="{$v.url_page}?{$v.url_ads}" class="text-twoline"
									title="{$v.metas.page}">{$v.metas.page}</a>
							</p>
						</div>
					</div>
				</div>
				{/foreach}
				{if $out.isads neq 1 && count($ads) gt 15}
				<div class="d-flex justify-content-center flex-column text-center view-all-productads">
					<a href="{$out.link_ads}" class="shadow-sm p-3 bg-white rounded-circle icon-view-all"><i
							class="fa fa-long-arrow-right" aria-hidden="true"></i></a>
					<a href="{$out.link_ads}" class="mt-2">Xem tất cả</a>
				</div>
				{/if}
			</div>
			{/if}
			<div class="row row-nm">
				{foreach from=$result key=k item=v}
				<div class="col-xl-5th col-sm-5th col-6 mb-3">
					<div class="card border-0 rounded-8">
						<div class="product-list-recommend">
							<div class="list-item-img">
								<a href="{$v.url}"><img data-src="{$v.avatar}" class="img-fluid" loading="lazy"></a>
							</div>
							<div class="list-item-info">
								<h3 class="text-nm-1"><a href="{$v.url}" class="text-twoline text-dark">{$v.name}</a>
								</h3>
								<div class="product-item-price text-oneline">
									{$v.price} {$v.pricemax}
									<span class="unit">/ {$v.unit}</span>
								</div>
								<p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>
							</div>
						</div>
					</div>
				</div>
				{/foreach}
			</div>
			{else}
			<div class="row row-nm">
				<div class="col-xl-5th col-sm-5th mb-3 d-none d-md-block">
					<div id="nav-pindex" class="pt-3">
						{foreach from=$a_category item=v}
						<p><a href="{$v.url}">{$v.name}</a></p>
						{/foreach}
					</div>
				</div>
				<div class="col">
					<div class="row row-nm">
						{foreach from=$result item=v}
						<div class="col-md-3 col-6 mb-3">
							<div class="card border-0 rounded-8">
								<div class="product-list-recommend">
									<div class="list-item-img">
										<a href="{$v.url}"><img data-src="{$v.avatar}" class="img-fluid" loading="lazy"></a>
									</div>
									<div class="list-item-info">
										<h3 class="text-nm-1"><a href="{$v.url}"
												class="text-twoline text-dark">{$v.name}</a></h3>
										<div class="product-item-price text-oneline">
											{$v.price} {$v.pricemax}
											<span class="unit">/ {$v.unit}</span>
										</div>
										<p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>
									</div>
								</div>
							</div>
						</div>
						{/foreach}
					</div>


				</div>
			</div>
			{/if}
			<div class="mt-3">{$paging}</div>
		</section>
	</div>
</div>

{literal}
<script>
	$('.owl-adsproduct').owlCarousel(
		{
			loop: false,
			margin: 10,
			nav: true,
			dots: false,
			thumbs: true,
			autoplay: true,
			slideBy: 7,
			smartSpeed: 50,
			stagePadding: 50,
			navText: ["<i class='fa fa-chevron-left'></i>",
				"<i class='fa fa-chevron-right'></i>"],
			responsive: {
				0: {
					items: 2,
				},
				600: {
					items: 2,
				},
				1000: {
					items: 6,
				}
			}
		});
</script>
{/literal}