{foreach from=$result item=v}
<div class="col-xl-5th col-lg-5th col-md-5th col-sm-5th mb-3">
	<div class="card border-0 rounded-8">
		<div class="product-list-recommend">
			<div class="list-item-img">
				<a href="{$v.url}"><img src="{$v.avatar}" alt="{$v.name}" class="img-fluid"></a>
			</div>
			<div class="list-item-info">
				<span class="import_product_label">Nhập khẩu</span>
				<h3 class="text-nm-1"><a href="{$v.url}"
						class="text-twoline text-dark">{$v.name}</a></h3>
				<div class="product-item-price text-oneline">
					{$v.price} {$v.pricemax}
					<span class="unit">/ {$v.unit}</span>
				</div>
				<p class="product-item-order">
					{$v.minorder} {$v.unit} (Min. Order)</p>
				<div class="dropdown-divider"></div>
				<p>Cập nhật: {$v.created|date_format:'%b %d, %Y'}</p>
			</div>
		</div>
	</div>
</div>
{/foreach}
