<div class="S-2">
	{if !$is_mobile}
	<div class="header-deal" style="background:url('{$event.banner}')">
		<div class="container">
			<div class="content_deal">
				<div class="row row-sm">
					{foreach from=$result item=data}
					<div class="col-sm-3 col-12 mb-2">
						<div class="card">
							<a href="{$data.url}"><img src="{$data.avatar}" alt="Card image cap"
								class="d-block w-100"></a>
							<div class="card-body">
								<h5 class="card-title"><a href="{$data.url}">{$data.name}</a></h5>
								<p class="card-price">
									{$data.promo|number_format}</b>
									<del>{$data.price|number_format}</del>
								</p>
								<span class="btn btn-outline-danger">{$data.percent} OFF</span> <a
									href="{$data.url}" class="btn btn-primary">Xem chi tiết</a>
							</div>
						</div>
					</div>
					{/foreach}
					<div class="w-100">{$paging}</div>
				</div>
			</div>
		</div>
		<div class="card count-down">
			<div class="card-body">
				<h5 class="card-title text-center countdown"
					data-countdown="{$event.date_finish}">Card title</h5>
			</div>
		</div>
	</div>
	{else}
	<div class="header-mobile cate-mobile fixed">
		<div class="container">
			<div class="row">
				<div class="col-7">
					<span onclick="goBackHistory()"><i class="fa fa-arrow-left"></i></span>
					<span class="title" onclick="showSearch()">Sản phẩm khuyến
						mãi</span> <span onclick="showSearch()"
						style="position: absolute; right: -45px;"><i
						class="fa fa-search fa-fw"></i></span>
				</div>
				<div class="col-5 text-right">
					<span><i class="fa fa-cloud-download fa-fw"></i></span>
					<div class="dropdown dropdown-tools-right">
						<span class="dropdown-toggle" id="dropdownMenuButton"
							data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i
							class="fa fa-bars"></i></span>
						<div class="dropdown-menu rounded-0"
							aria-labelledby="dropdownMenuButton">
							<a class="dropdown-item" href="#"><i class="fa fa-home"></i>Trang
								chủ</a> <a class="dropdown-item"
								href="?mod=account&amp;site=messages"><i
								class="fa fa-envelope-o"></i>Tin nhắn liên hệ</a> <a
								class="dropdown-item" href="{$arg.url_sourcing}"><i
								class="fa fa-bullhorn"></i>Yêu cầu báo giá</a> <a
								class="dropdown-item" href="?mod=account&site=pagefavorites"><i
								class="fa fa-star"></i>Gian hàng theo dõi</a> <a
								class="dropdown-item" href="?mod=account&site=productfavorites"><i
								class="fa fa-heart-o"></i>Sản phẩm yêu thích</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<section id="content-search">
		<div class="search-bar-header">
			<div class="container">
				<div class="row">
					<div class="col-1" onclick="goBack()">
						<span class="icon-back"><img
							src="http://daisannews.com/site/themes/webroot/images/back.png"
							class="img-fluid"></span>
					</div>
					<div class="col-10">
						<input class="form-control" id="Keyword"
							value="{$filter.key|default:''}"
							placeholder="Nhập vào từ khóa tìm kiếm...">
					</div>
				</div>
				<nav>
					<div class="nav nav-pill" id="pills-tab" role="tablist">
						<a class="nav-item nav-link active" id="nav-home-tab"
							data-toggle="tab" href="#nav-home" role="tab"
							aria-controls="nav-home" aria-selected="true"
							onclick="SetType(0)">SẢN PHẨM</a> <a class="nav-item nav-link"
							id="nav-profile-tab" data-toggle="tab" href="#nav-profile"
							role="tab" aria-controls="nav-profile" onclick="SetType(1)">NHÀ
							CUNG CẤP</a>
					</div>
				</nav>
			</div>
		</div>
		<div class="search-bar-content">
			<input type="hidden" id="Type" value="0">
			<div class="container">
				<div class="popular-keyword">
					<h3 class="keyword-title">Từ khóa phổ biến</h3>
					<div class="box-tag">
						{foreach from = $keyword.hot item = data} <a
							href="./product?k={$data.name}">{$data.name}</a> {/foreach}
					</div>

					<div class="clearfix"></div>
				</div>
				<div class="history-keyword">
					<h3 class="keyword-title">Lịch sử tìm kiếm:</h3>
					<div class="box-tag">
						{foreach from = $keyword.history item = data} <a
							href="./product?k={$data.name}">{$data.keyword_name}</a>
						{/foreach}
					</div>
				</div>
			</div>
		</div>

	</section>

	<div class="container p-0 main-category-hot">
		<div class="product">
			<ul class="row mt-5 bg-white" id="NewContent">
				{foreach from=$result item=data}
				<li class="col-5th"><a href="{$data.url}" class="d-block">
						<img class="d-block w-100" src="{$data.avatar}" alt="{$data.name}">
				</a>
					<div class="prod-info">
						<div class="title">
							<h3 class="py-2 fz-14">
								<a href="{$data.url}">{$data.name}</a>
							</h3>
						</div>
						<p class="card-text fz-18">
							<b class="mr-2">{$data.promo|number_format}</b>
							<del>{$data.price|number_format}</del>
							<span class="badge badge-danger ml-3">{$data.percent}</span>
						</p>
					</div></li> {/foreach}
			</ul>
		</div>
		<div class="">{$paging}</div>
	</div>
</div>
{/if}
<script type="text/javascript"
	src="https://deal.daisan.vn/site/themes/view/vsctheme/webroot/js/jquery.countdown.min.js"></script>
<script>
	$('[data-countdown]').each(function() {
		var $this = $(this), finalDate = $(this).data('countdown');
		$this.countdown(finalDate, function(event) {
			$this.html(event.strftime('%D:%H:%M:%S'));
		});
	});
</script>