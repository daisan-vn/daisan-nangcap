<div class="bg-white py-3">
	<div class="container">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb">
				<li class="breadcrumb-item"><a href="?mod=account&site=index">Tài khoản của bạn</a></li>
				<li class="breadcrumb-item">Danh sách nhu cầu</li>
			</ol>
		</nav>
		<h1 class="h2">Danh sách nhu cầu của tôi</h1>
		<hr>
		<div class="mt-3">
			<div class="form-inline">
				<div class="form-group mb-2 mr-2">
					<input type="text" class="form-control" id="filter_key" placeholder="Search"
						value="{$out.key|default:''}">
				</div>
				<button type="button" onclick="filter();" class="btn btn-primary mb-2">Search</button>
			</div>
		</div>
		<div class="card">
			<div class="card-body">
				{foreach from=$rfq item=data}
				<div class="row row-nm">
					<div class="col-2">
						<a href="{$data.url}"><img class="img-thumbnail" src="{$data.avatar}" width="100%"></a>
					</div>
					<div class="col-10">
						<h5 class="card-title mb-1"><a href="{$data.url}">{$data.title}</a></h5>
						<p class="mb-2">
							<span><i class="fa fa-clock-o"></i> {$data.created|date_format:'%H:%M %d/%m/%Y'}</span>
							<span class="col-gray ml-2"><i class="fa fa-cubes"></i> Cần:</span> {$data.number} {$data.unit}
							{if $data.location}<span class="col-gray ml-2"><i class="fa fa-map-marker"></i> Địa điểm:</span>
							{$data.location}, Việt Nam{/if}
							<a class="ml-2" href="{$data.url_quote}"><i class="fa fa-calendar-check-o"></i> Có
								<b>{$data.number_quotation}</b> báo giá</a>
							<a class="ml-2" href="{$data.url_edit}"><i class="fa fa-pencil"></i> Chỉnh sửa</a>
						</p>
						<p class="line-2 mb-0">{$data.description}</p>
					</div>
				</div>
				{/foreach}
				<nav aria-label="Page navigation example">
					{$paging}
				</nav>
			</div>
		</div>
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
		var url = "?mod=account&site=pages";
		if (key != '') url = url + "&key=" + key;
		location.href = url;
	}
</script>
{/literal}