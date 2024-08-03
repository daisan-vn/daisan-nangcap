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