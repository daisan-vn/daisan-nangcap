<div id="Deal" class="S-2" style="background-color: #111 !important;">
	<div class="header-deal">
		<img alt="trade-show" src="{$arg.img_gen}trade-show.jpg" class="w-100 d-none d-md-block">
		<img alt="trade-show" src="{$arg.img_gen}m-trade-show.jpg" class="w-100 d-block d-md-none">
		<div class="container">
			<div class="content_deal">
				<h2 class="text-center col-white py-5">Chương Trình Đang Diễn Ra</h2>
				<div class="row">
					{foreach from=$result item=data}
					<div class="col-md-4 mb-4">
						<div class="card">
							<a href="{$data.url}"><img src="{$data.avatar}" class="d-block w-100"></a>
							<div class="card-body">
								<h3 style="font-size: 16px">
									<a href="{$data.url}" class="text-dark">{$data.name}</a>
								</h3>
								<p class="countdown btn btn-primary btn-block"
									data-countdown="{$data.date_finish}"></p>
							</div>

						</div>
					</div>
					{/foreach}
				</div>
			</div>
			
			<div id="hotproduct">
				<h2 class="text-center col-white py-5">Sản Phẩm Nổi Bật</h2>
				<div class="row row-nm">
					{foreach from=$products item=v}
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
			</div>
			
		</div>
	</div>
</div>
<script type="text/javascript" src="{$arg.stylesheet}js/jquery.countdown.min.js"></script>
<script>
	$('[data-countdown]').each(function() {
		var $this = $(this), finalDate = $(this).data('countdown');
		$this.countdown(finalDate, function(event) {
			$this.html(event.strftime('%D:%H:%M:%S'));
		});
	});
</script>
