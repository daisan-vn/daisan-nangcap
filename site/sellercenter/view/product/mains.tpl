<div class="card-header">
	<h3>Danh sách sản phẩm showcase</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<h4>Danh sách sản phẩm Showcase</h4>
	<p class="mb-1">Đây là những sản phẩm trọng tâm, cốt lõi của công ty (Tối đa <b>{$package.numb_showcase}</b> sản phẩm).</p>
	<p>Khi đưa sản phẩm của bạn vào danh sách này, rank của sản phẩm sẽ được tăng lên đáng kể.</p>
	<table class="table table-bordered">
		<tr>
			<th>Sản phẩm</th>
			<th>Giá bán</th>
			<th>Active/Featured</th>
			<th></th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td width="50%">
				<div class="row row-sm">
					<div class="col-3">
						<a href="javascript:void(0);" class="img-thumbnail d-block"><img alt="{$data.name}" src="{$data.avatar}" width="100%"></a>
					</div>
					<div class="col-9">
						<p class="mb-1">{$data.name}</p>
						<small><i class="fa fa-fw fa-tag"></i>{$data.category}</small>
					</div>
				</div>
			</td>
			<td>Giá từ: <b>{$data.price|number_format}đ</b></td>
			<td>{$data.status}</td>
			<td class="text-right">
				<button type="button" class="btn btn-light btn-sm" onclick="DeleteItem('', {$data.id}, 'product', 'ajax_delete_product_main');"><i class="fa fa-trash fa-fw"></i></button>
			</td>
		</tr>
		{/foreach}
	</table>

	<nav aria-label="Page navigation example">
		{$paging}
	</nav>

</div>