
<table class="table table-bordered">
	<tr>
		<th>STT</th>
		<th>Sản phẩm</th>
		<th>Giá</th>
		<th>Số lượng</th>
	</tr>
	{foreach from=$detail key=k item=data}
	<tr id="FID{$data.id}">
		<td>{$k+1}</td>
		<td>{$data.productname}</td>
		<td>{$data.price|number_format}</td>
		<td>{$data.number}</td>
	</tr>
	{/foreach}
</table>

