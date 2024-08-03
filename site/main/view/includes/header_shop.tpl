<div class="shop_header">
	<div class="shop_header-info">
		<div class="media mb-2">
			<img alt="{$profile.name}" src="{$profile.logo_img}" class="mr-3" width="64">
			<div class="media-body">
				<h3 class="mt-0 text-oneline shop_header-title">
					{$profile.name}
				</h3>
				<span class="yrs">
					<i class="fa fa-clock-o col-yearexp"></i>
					<span class="number">{$profile.yearexp|default:1}</span> Năm kinh nghiệm
				</span>
			</div>
		</div>
	</div>
	<div class="shop_header-menu">
		<div class="d-flex bd-highlight px-0 px-sm-4">
			<div class="flex-grow-1 bd-highlight">
				<ul class="nav">
					<li class="nav-item {if $arg.site eq 'index'}active{/if}">
						<a class="nav-link" href="{$profile.url}">Cửa hàng</a>
					</li>
					<li class="nav-item {if $arg.site eq 'products' or $arg.site eq 'search'}active{/if}">
						<a class="nav-link" href="{$profile.url}?site=products">Tất cả sản phẩm</a>
					</li>
					<li class="nav-item {if $arg.site eq 'profile'}active{/if}">
						<a class="nav-link" href="{$profile.url}?site=profile">Hồ sơ cửa hàng</a>
					</li>
					<li class="nav-item {if $arg.site eq 'showrooms'}active{/if}">
						<a class="nav-link" href="{$profile.url}?site=showrooms">Hệ thống cửa hàng</a>
					</li>
				</ul>
			</div>
			<div class="shop_header-search d-none d-sm-block">
				<div class="icon-search"><i class="fa fa-search"></i></div>
				<input type="text" value="" placeholder="Tìm sản phẩm tại cửa hàng" id="filter_key"
					onchange="filter()" value="{$out.key|default:''}">
			</div>
		</div>
	</div>
</div>
<input type="hidden" value="{$profile.url}" id="filter_url">
<script type="text/javascript">
	function filter() {
		var url = $("#filter_url").val();
		var k = $("#filter_key").val();
		url = url + "?site=search";
		url = (k != '') ? url + "&k=" + k : url;
		location.href = url;
	}
</script>
