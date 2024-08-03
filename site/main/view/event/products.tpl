<link rel="stylesheet" href="{$arg.stylesheet}css/jquery.scrolling-tabs.min.css">
<script src="{$arg.stylesheet}js/jquery.scrolling-tabs.min.js"></script>

<div class="main_content toprank promonotions">
	<div class="zone-header d-none d-sm-block" style="background:url('{$event.banner}');">
		<div class="countdown" data-countdown="{$event.date_finish}"></div>
	</div>
</div>
<div class="container pt-3">
	<div class="tab-content" id="pills-tabContent">
		<div class="mt-3 product-deal">
			<h1 class="text-b py-5 text-center">Sản Phẩm Trưng Bày</h1>
			<div class="row row-nm">
				{foreach from=$result item=v}
				<div class="col-xl-5th col-lg-5th col-md-5th col-sm-5th">
					<div class="rounded-10 bg-white item-product mb-3">
						<a href="{$v.url}"><img class="rounded-top-10 img-fluid" src="{$v.avatar}"
								alt="{$v.name}"></a>
						<div class="prod-info p-3">
							<h3 class="text-nm-1 line-2">
								<a href="{$v.url}">{$v.name}</a>
							</h3>
							<div class="product-item-price text-oneline">{$v.promo|number_format}đ</div>
							<p class="mb-3">
								<span class="price-old">{$v.price|number_format}đ</span>
								<span class="price-promo">-{$v.percent}</span>
							</p>
							<div class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</div>
						</div>
					</div>
				</div>
				{/foreach}
			</div>
			<div class="mt-3">{$paging}</div>
		</div>
	</div>
</div>
<input type="hidden" value="{$out.id}" id="event_id">
{literal}
<script>
	function ShowMenumCategories() {
		$(".mmenu_all_categories").toggleClass("active")
	}
	$('.mmenu_all_categories ul li').click(function () {
		$('.mmenu_all_categories').removeClass('active');
	});
</script>
{/literal}