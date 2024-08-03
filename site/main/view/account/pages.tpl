
<div class="bg-white py-3">
	<div class="container">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb">
				<li class="breadcrumb-item"><a href="?mod=account&site=index">Tài khoản của bạn</a></li>
				<li class="breadcrumb-item">Danh sách gian hàng</li>

			</ol>
		</nav>
		<h1 class="h2">Danh sách gian hàng của bạn</h1>
		<hr>
		<div class="my-3">
			<div class="form-inline">
				<div class="form-group mb-2 mr-2">
					<input type="text" class="form-control" id="filter_key" placeholder="Search" value="{$out.key|default:''}">
				</div>
				<select class="form-control mb-2 mr-2" id="package_id">{$out.filter_package}</select>
				<select class="form-control mb-2 mr-2" id="location_id">{$out.filter_location}</select>
				<button type="button" onclick="filter();" class="btn btn-primary mb-2 btn-sm-block">Search</button>
			</div>
		</div>


		<div class="row">
			{foreach from=$pages key=k item=data}
			<div class="col-md-6">
				<div class="card mb-3">
					<div class="supplier-rank-card">
						<div class="card-body">
							<div class="row row-nm">
								<div class="col-2">
									<a href="{$data.url_page}"><img class="img-thumbnail" src="{$data.logo}" width="100%"></a>
								</div>
								<div class="col-10">
									<h5 class="card-title mb-1"><a href="{$data.url_page}"
											class="text-dark text-b">{$data.name}</a></h5>
									<p class="mb-1">
										<span class="text-small"><i class="fa fa-globe"></i> Vai trò:
											{$data.position}</span>
										<span class="text-small ml-2"><i class="fa fa-globe"></i> Mã:
											{$data.idcode|default:''}</span>
										<span class="text-small ml-2"><i class="fa fa-diamond"></i> Gói:
											<b>{$data.package|default:'Free'} {if $data.package}(Hết hạn:
												{$data.package_end|date_format:'%d-%m-%Y'}){/if}</b></span>
										<span class="text-small ml-2"><i class="fa fa-globe"></i> Sản phẩm:
											{$a_product[$data.id]|default:0}</span>
									</p>
									<p>Quản trị: {$data.users|default:''}</p>
									<p class="mb-0 mt-3">
										<a class="btn btn-contact-o rounded-pill btn-sm" href="{$data.url_admin}" style="border-color: #9c9c9c"
											target="_blank"><i class="fa fa-cog"></i> Vào trang quản lý</a>
									</p>
								</div>
							</div>
						</div>
					</div>
					<!--end supplier-rank-card-->
				</div>
			
			</div>
			{/foreach}
			<div class="col-md-6">
				<div class="card">
					<div class="card-body">
						<h3 class="mb-4">Đăng ký gian hàng để cùng bán trên Daisan</h3>
						<a href="?mod=account&site=createpage" class="btn btn-lg btn-success btn-block">Đăng Ký Gian Hàng Ngay</a>
					</div>
				</div>
			</div>
		</div>
		<nav aria-label="Page navigation example">
			{$paging}
		</nav>
	</div>
</div>
{literal}
<script type="text/javascript">
	$(document).ready(function () {
		$('#filter_key').keypress(function (event) {
			if (event.which == 13) filter();
		});
	});

	function filter() {
		var key = $("#filter_key").val();
		var package_id = $("#package_id").val();
		var location_id = $("#location_id").val();
		var url = "?mod=account&site=pages";
		if (key != '') url = url + "&key=" + key;
		if (package_id != 0) url = url + "&package_id=" + package_id;
		if (location_id != 0) url = url + "&location_id=" + location_id;
		location.href = url;
	}
</script>
{/literal}