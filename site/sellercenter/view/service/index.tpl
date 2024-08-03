<div class="card-header">
	<h3>Danh sách dịch vụ</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<p>Danh sách tất cả các dịch vụ do doanh nghiệp bạn cung cấp.</p>
	<p>Bạn có thể vào mục <a href="">Thêm có sẵn</a> để tìm kiếm nội dung dịch vụ đã có sẵn để thêm vào dịch vụ. Nếu dịch vụ chưa tồn tại trên hệ thống thì bạn có thể click vào <a href="">Thêm mới</a> để tạo dịch vụ.</p>
	
	<table class="table table-bordered">
		<tr>
			<th>Dịch vụ</th>
			<th>Dịch vụ</th>
			<th>Dịch vụ</th>
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
						<small>{$data.description}</small>
					</div>
				</div>
			</td>
			<td>Dịch vụ</td>
			<td>Dịch vụ</td>
			<td class="text-right">
				<a href="{$data.url_edit}" class="btn btn-light btn-sm"><i class="fa fa-pencil fa-fw"></i></a>
				<button type="button" class="btn btn-light btn-sm" onclick="DeleteItem('', {$data.id}, 'service', 'ajax_delete');"><i class="fa fa-trash fa-fw"></i></button>
			</td>
		</tr>
		{/foreach}
	</table>

	<nav aria-label="Page navigation example">
		{$paging}
	</nav>


</div>