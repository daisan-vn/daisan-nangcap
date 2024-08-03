<div class="card-header">
	<h3>Danh sách tin tuyển dụng</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<table class="table table-bordered">
		<tr>
			<th>Tin tuyển dụng</th>
			<th>Địa điểm</th>
			<th>Mức lương</th>
			<th>Hạn nộp hồ sơ</th>
			<th></th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td width="50%">
				<p class="mb-1"><b>{$data.title}</b></p>
				<small><i class="fa fa-fw fa-tag"></i>{$data.category}</small>
			</td>
			<td>{$data.places}</td>
			<td>{$data.salary}</td>
			<td>{$data.date_finish|date_format:'%d-%m-%Y'}</td>
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