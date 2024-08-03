<div class="card-header">
	<h3>Chương trình khuyến mại</h3>
</div>

<div class="card-body">
	
	<div>
		<p class="mb-1">Đưa sản phẩm của bạn vào các chương trình, sự kiện khuyến mại của hệ thống.</p>
		<p>Số vé đưa sản phẩm vào chương trình khuyến mại còn lại là <b>{$out.numb_use|default:0|number_format}/{$out.numb_event|default:0|number_format}</b> cho tháng này</p>
	</div>
	
	<table class="table table-bordered">
		<tr>
			<th width="160"></th>
			<th>Chương trình</th>
			<th>Bắt đầu</th>
            <th>Kết thúc</th>
			<th>Sản phẩm</th>
			<th>Khởi tạo</th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td><img src="{$data.avatar}" width="100%"></td>
			<td><a href="?mod=event&site=products&id={$data.id}">{$data.name}</a></td>
			<td>{$data.date_start|date_format:"%d/%m/%Y"}</td>
			<td>{$data.date_finish|date_format:"%d/%m/%Y"}</td>
			<td>{$data.total_product}</td>
			<td>{$data.created|date_format:"%H:%M:%S %d/%m/%Y"}</td>
		</tr>
		{/foreach}
	</table>

	<nav aria-label="Page navigation example">
		{$paging}
	</nav>
</div>