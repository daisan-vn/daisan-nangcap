<div class="header-mobile cate-mobile fixed d-block d-sm-none">
	<div class="container">
		<div class="row">
			<div class="col-7">
				<span onclick="goBackHistory()"><i class="fa fa-arrow-left"></i></span>
				<span class="title" onclick="showSearch()">{$category.name}</span> <span
					onclick="showSearch()" style="position: absolute; right: -45px;"><i
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

<section id="content-search" class="d-sm-none">
	<div class="search-bar-header">
		<div class="container">
			<div class="row">
				<div class="col-1" onclick="goBack()">
					<span class="icon-back"><img
						src="http://daisannews.com/site/themes/webroot/images/back.png"
						class="img-fluid lazy"></span>
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
						aria-controls="nav-home" aria-selected="true" onclick="SetType(0)">SẢN
						PHẨM</a> <a class="nav-item nav-link" id="nav-profile-tab"
						data-toggle="tab" href="#nav-profile" role="tab"
						aria-controls="nav-profile" onclick="SetType(1)">NHÀ CUNG CẤP</a>
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

<div class="S-1">
	<div class="container">
		<div class="row">
			<div
				class="col-lg-4 col-md-4 col-12 align-self-center d-none d-sm-block">
				{$category.name}</div>
			<div class="col-lg-7 col-md-8 col-12 d-none d-sm-block">
				{foreach from=$a_product key=k item=data} {if $k <3} <img
					class="d-inline-block mr-2" src="{$data.avatar}"> {/if}
				{/foreach}
			</div>
		</div>
	</div>
</div>
<div class="S-2">
	<div class="container p-0 main-category-hot">
		<div class="product">
			<ul class="row m-0 bg-white" id="NewContent">
				{foreach from=$a_product key=k item=data}
				<li class="col-5th col-sm-5th"><a href="{$data.url}" class="d-block">
						<img class="d-block w-100" src="{$data.avatar}" alt="{$data.name}">
				</a>
					<div class="prod-info">
						<div class="title">
							<span class="kind">Gian hàng tiêu chuẩn</span>
							<h3>
								<a href="{$data.url}">{$data.name}</a>
							</h3>
						</div>
						<div class="price">{$data.price}{if $data.pricemax gt
							0}-{$data.pricemax|number_format}{/if}</div>
						<div class="moq">Tối thiểu: {$data.minorder} {$data.unit}</div>
					</div></li>{/foreach}
			</ul>

			<div class="w-100 text-center p-3">
				<button type="button" class="btn btn-primary btn-lg"
					onclick="LoadMore();" id="LoadMore">Xem thêm</button>
				<div id="showalert" class="alert alert-light hide" role="alert">
					Bạn đã kết thúc<br> Tìm kiếm thêm để tiếp tục khám phá
				</div>
			</div>

		</div>
		<div class="bg-white border border-top-0 py-3 px-4">
			{foreach from=$a_category_all key=k item=data} <a
				class="py-0 px-1 btn btn-outline-secondary mr-2 mb-2"
				href="{$data.url}">{$data.name}</a> {/foreach}
		</div>
	</div>
</div>
<script type="text/javascript">
	var id = '{$out.id}';
	var all_product = '{$all_product}';
</script>

{literal}
<script>
	var page = 1;
	function LoadMore() {
		loading();
		page = page + 1;
		limit = 40;
		number = page * limit;
		console.log(all_product);
		$.post('?mod=product&site=ajax_loadmore_product', {
			'page' : page,
			'id' : id,
		}).done(function(e) {
			console.log(e);
			if (number > all_product) {
				$("#LoadMore").hide();
				$("#showalert").removeClass("hide");
				$("#NewContent").append(e);
			} else {
				$("#NewContent").append(e);
			}
			endloading();
		});
	}
</script>
{/literal}
