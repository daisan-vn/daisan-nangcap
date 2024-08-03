<div class="card-header">
	<h3>Thư viện ảnh của gian hàng</h3>
	<hr>
	<span class="mr-3">Số lượng ảnh: {$out.number_file}</span>
	<span class="mr-3">Dung lượng sử dụng: {$out.folder_size} Mb</span>
	<span class="mr-3">Dung lượng còn lại: {50-$out.folder_size} Mb</span>
</div>

<div class="card-body">
	<div class="row row-sm">
		{foreach from=$result item=data}
		<div class="col-md-2">
			<a class="d-block mt-2">
				<img alt="" src="{$data}" class="w-100">
			</a>
		</div>
		{/foreach}
	</div>
	<nav class="mt-3" aria-label="Page navigation example">
		{$paging}
	</nav>
</div>