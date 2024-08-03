<div class="main-content-wrap">
	<div class="container-fluid container-cate mt-0">
		{include file='../includes/header_shop.tpl'}
		<div class="shop_main">
			<section class="shop_main-productlist px-3 px-sm-0">
				<div class="card border-0 pt-3">
                    <h2 class="px-3 text-lg d-none d-sm-block">Tất Cả Sản Phẩm: <span>{$out.number} kết quả</span></h2>
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
											<h3 class="text-nm-1"><a href="{$v.url}" class='text-twoline text-dark'>{$v.name}</a></h3>
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
											<p class="mt-1"><b>{$v.minorder} {$v.unit}</b> (Min Order)</p>
										</div>
									</div>
								</div>
							</div>
						</div>
						{/foreach}
					</div>
					{if $paging}
					<hr>
					<div class="mb-3">{$paging}</div>
					{/if}
				</div>
			</section>
		</div>
	</div>
</div>
