<div class="main-content-wrap">
	<div class="container-fluid">
		<div class="banner mb-3">
			<img src="{$arg.stylesheet}images/H5a3b5e1221e84ceda2b0a1c55a3a6e889.jpg" class="w-100">
		</div>
		<div class="row row-nm">
			<div class="col-xl-2">
				<div class="card filter border-0">
					<div class="card-body">
						{if count($out.a_category) gt 0}
						<div class="left-filters__filter-wrapper">
							<h3>Danh mục</h3>
							<ul class="nav flex-column">
								{foreach from=$out.a_category item=v}
								<li><a href="{$v.url}">{$v.name}</a></li>
								{/foreach}
							</ul>
						</div>
						{/if}
						<div class="left-filters__filter-wrapper my-3">
							<h3>Loại nhà cung cấp</h3>
							<ul class="nav flex-column">
								{foreach from=$out.a_supplier_type key=k item=v}
								<li>
									<a href="{$v.url}">
										<input type="checkbox" name="radio" {if $v.active}checked="checked"{/if}> 
										<span class="checkmark"></span>
										<label class="wm-checkbox">{$v.title}</label>
									</a>
								</li>
								{/foreach}
							</ul>
						</div>
						<div class="left-filters__filter-wrapper my-3">
							<h3>Loại sản phẩm</h3>
							<ul class="nav flex-column">
								{foreach from=$out.a_product_type key=k item=v}
								<li><a href="{$v.url}">
										<input type="checkbox" name="radio" {if $v.active}checked="checked"{/if}> 
										<span class="checkmark"></span>
										<label class="wm-checkbox">{$v.title}</label>
									</a>
								</li>
								{/foreach}
							</ul>
						</div>
						<div class="left-filters__filter-wrapper my-3">
							<h3>Min. Order</h3>
							<div class="input-group mb-3">
								<input type="text" class="form-control rounded" id="filter_minorder" placeholder="Less than" value="{$filter.minorder}">
								<div class="ml-2">
									<button type="button" onclick="filter();" class="btn btn-sm rounded-pill px-4">OK</button>
								</div>
							</div>
						</div>
						<div class="left-filters__filter-wrapper my-3">
							<h3>Mức giá</h3>
							<div class="input-group mb-3">
								<input type="text" class="form-control rounded" id="filter_minprice" placeholder="Min" value="{$filter.minprice}">
								<span class="mx-2">-</span>
								<input type="text" class="form-control rounded" id="filter_maxprice" placeholder="Max" value="{$filter.maxprice}">
								<div class="ml-2">
									<button type="button" onclick="filter();" class="btn btn-sm rounded-pill px-4">OK</button>
								</div>
							</div>
						</div>
						<div class="left-filters__filter-wrapper my-3">
							<div class="panel panel-default">
								<div class="panel-heading" role="tab" id="heading1">
									<h3 class="panel-title">
										<a class="collapsed" role="button" data-toggle="collapse" href="#collapse1">
											<i class="more-less fa fa-angle-up pull-right"></i> Địa điểm
										</a>
									</h3>
								</div>
								<div id="collapse1" class="panel-collapse collapse in show" role="tabpanel"
									aria-labelledby="heading1">
									<div class="panel-body">
										<div class="input-group mb-3">
											<div class="input-group-prepend">
												<span class="input-group-text bg-transparent" id="basic-addon1"><i
														class="fa fa-search"></i></span>
											</div>
											<input type="text" class="form-control" placeholder="search">
										</div>
										<div class="country-region__groups">
											<ul class="left-sidebar-ul">
												{foreach from=$out.a_location item=v}
												<li><a href="{$v.url}">
														<i class="fa {if in_array($v.Id,$filter.a_location)}fa-check-square-o{else}fa-square-o{/if} text-lg" aria-hidden="true"></i>
														<span class="checkmark"></span>
														<label class="wm-checkbox">{$v.Name}</label>
													</a></li>
												<li>
												{/foreach}
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!--end left-filters-->
					</div>
				</div>
			</div>
			<div class="col-xl-10">
				<div class="d-flex pl-3 py-3 pr-0 refine-filters__result-section">
					<div class=" flex-grow-1 align-self-center refine-filters__result-left">
						<!-- <b>{$out.number|default:0}</b> kết quả cho "{$out.key|default:''}" -->
						<b>Danh sách sản phẩm cho từ khóa "{$out.key|default:''}"</b>
					</div>
					<div class="refine-filters__result-right">
						<ul class="nav">
							<li class="nav-item nav-link d-none d-sm-block"><b>Sắp xếp theo:</b></li>
							<li class="nav-item nav-link ischild d-none d-sm-block">Độ phù hợp <i class="fa fa-angle-down"></i>
								<ul class="nav">
									<li class="nav-item"><a href="" class="nav-link  text-dark">Độ phù hợp</a></li>
									<li class="nav-item"><a href="" class="nav-link  text-dark">Giá bán tốt</a></li>
								</ul>
							</li>
							
							<!-- <li class="nav-item nav-link px-1 view-type"><a href="#" class="view-list"></a></li>
							<li class="nav-item nav-link px-1 view-type"><a href="#" class="view-grid"></a></li>
							<li class="nav-item nav-link pr-0 d-block d-sm-none" id="collapse_filter"><i
									class="fa fa-sort-amount-desc fa-fw" aria-hidden="true"></i> Refine</li> -->
						</ul>
					</div>
					<div class="refine-filters__result-right"></div>
				</div>
				<div class="search-result__content view-grid">
					<div class="row row-nm">
						{foreach from=$result key=k item=v}
						<div class="col-xl-3 col-6 item-result__content">
							<div class="card border-0">
								<div class="card-body">
									<div class="product-list-recommend">
										<div class="item-img">
											<div class="owl-carousel owl__product-search">
												{foreach from=$v.a_img item=img}
												<div class="item">
													<a href="{$v.url}"><img src="{$img}" class="img-fluid zoom-in"></a>
												</div>
												{/foreach}
											</div>
										</div>
										<div class="search-item-info">
											<h3 class="text-nm-1 pt-2"><a href="{$v.url}" class="text-twoline text-dark">{$v.name}</a></h3>
											<div class="product-item-price text-oneline mt-3">
												{if $v.price_show eq 'Liên hệ'}
												<span>Giá bán:</span>
												{/if}
												{$v.price_show}
												{if $v.price_show ne 'Liên hệ'}
												<span class="unit">/ {$v.unit}</span>
												{/if}
											</div>
											<p class="product-item-order mb-3"><b>{$v.minorder} {$v.unit}</b>
												(Min Order)</p>
											<div class="seller-info d-none d-sm-block">
												<div class="media mb-2">
													<div class="media-body">
														<h3 class="mt-0 text-oneline seller-intro-title">
															<a href="{$v.url_page}" title="{$v.page}">{$v.page}</a>
														</h3>
														<span class="yrs mr-2">
															<b class="number">{$v.yearexp|default:1}</b><small>YRS</small>
														</span>
														{if $v.package_id gt 0}
														<i class="fa fa-gg-circle col-gold"></i>
														{/if}
														{if $v.is_verification}
														<i class="fa fa-check col-verify-1"></i>
														<span class="col-verify">Verified</span>
														{/if}
													</div>
												</div>
											</div>
											<div class="dropdown-divider d-none d-sm-block"></div>
											<div class="d-flex align-items-center">
												<div class="">
													<a href="{$v.url_rfq}" class="btn btn-sm btn-contact rounded-pill">Liên hệ nhà cung cấp</a>
												</div>
												<div class="px-2 d-none d-sm-block">
													<a href="{$v.url_addcart}"><i class="fa fa-plus"></i> Đặt hàng</a>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!--end col-3-->
						{/foreach}
					</div>
				</div>
			</div>
		</div>
		{if $out.number eq 40}
		<div class="filter__search-pagination mb-3">
			<div class="card card-body border-0">
				{$paging}
			</div>
		</div>
		{/if}
		<div class="filter__search-keyword mb-3">
			<div class="card card-body border-0">
				<ul class="nav">
					<li class="nav-item nav-link">Tìm kiếm liên quan:</li>
					{foreach from=$out.a_keyword item=v}
					<li class="nav-item">
						<a class="nav-link" href="{$v.url}">{$v.name}</a>
					</li>
					{/foreach}
				</ul>
			</div>
		</div>
		<!--end filter__search-keyword-->
	</div>
</div>
<input type="hidden" value="{$out.filter_url}" id="filter_url">
<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="assets/js/jquery-1.12.2.min.js"></script>
<script src="assets/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="assets/js/owl.carousel.min.js"></script>
<script src="assets/js/jquery.flipper-responsive.js"></script>
<script src="assets/js/jquery.scrolling-tabs.min.js"></script>
<script src="assets/slick-1.8.1/slick/slick.min.js"></script>
<script src="assets/js/main.js"></script>
<script>
	function filter(){
		var url = $('#filter_url').val();
		var minorder = $('#filter_minorder').val();
		var minprice = $('#filter_minprice').val();
		var maxprice = $('#filter_maxprice').val();
		if(minorder!='' && minorder>0) url += '&minorder='+minorder;
		if(minprice!='' && minprice>0) url += '&minprice='+minprice;
		if(maxprice!='' && maxprice>0) url += '&maxprice='+maxprice;
		location.href = url;
	}
	$(".open-mega-menu").click(function () {
		$('body').addClass('no-scroll-active')
		$('.mega-menu').addClass('active');
		$('.overlay').fadeIn();
	});
	$(".close-mega").click(function () {
		$('body').removeClass('no-scroll-active')
		$('.mega-menu').removeClass('active');
		$('.overlay').fadeOut();
	});
	$('#collapse_filter').on('click', function () {
		$(".filter").addClass("active");
		$('.overlay').fadeIn();
	});
	$('.close_filter').on('click', function () {
		$(".filter").removeClass("active");
		$('.overlay').fadeOut();
	});
	$('.overlay').on('click', function () {
		$('.filter').removeClass('active');
		$('.overlay').fadeOut();
	});

	function goback() {
		$(".mega-menu-dropdown-header").removeClass("show");
	}
	function showUlCategory() {
		$(".mega-menu-dropdown-header").toggleClass('hmenu-translateX');
	}
	$('.owl-category-hot').owlCarousel({
		loop: false,
		margin: 20,
		nav: true,
		dots: false,
		navText: [
			"<img src='{$arg.stylesheet}images/arrow-l.png'>",
			"<img src='{$arg.stylesheet}images/arrow-r.png'>"],
		responsive: {
			0: {
				items: 3
			},
			600: {
				items: 8
			},
			1000: {
				items: 12
			}
		}
	});
	$('.owl__product-search').owlCarousel({
		loop: true,
		thumbsPrerendered: true,
		items: 1,
		nav: true,
		thumbs: true,
		navText: ["<i class='fa fa-chevron-left'></i>", "<i class='fa fa-chevron-right'></i>"]
	});

	$('.left-filters__filter-wrapper').on('hidden.bs.collapse', toggleIcon);
 		$('.left-filters__filter-wrapper').on('shown.bs.collapse', toggleIcon);
	function toggleIcon(e) {
		$(e.target)
			.prev('.panel-heading')
			.find(".more-less")
			.toggleClass('fa-angle-up fa-angle-down');
		}

</script>

