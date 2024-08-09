<div class="card-header">
	<h3>Danh sách sản phẩm đồng bộ lên phần mềm bán hàng</h3>
</div>
<div class="card-body">
	<div class="form-inline mb-3">
		<div class="form-group mr-2">
			<input type="text" id="filter_key" class="form-control" placeholder="Search" value="{$out.key|default:''}">
		</div>
		<button type="button" class="btn btn-primary mr-2" onclick="filter();"><i class="fa fa-fw fa-search"></i>
			Search</button>
	</div>

	<table class="table table-bordered">
		<tr>
			<th>Mã nội bộ</th>
			<th>Tên sản phẩm</th>
			<th>Image Url</th>
			<th>Mô tả (Nội dung)</th>
			<th>Giá bán</th>
			<th>Giá vốn</th>
			<th>Số lượng</th>
			<th>Đơn vị tính</th>
			<th>Đơn vị tính mua hàng</th>
			<th>Loại sản phẩm</th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td>{$data.code}</td>
			<td>{$data.name}</td>
			<td>{$data.avatar}</td>
			<td>{$data.name}</td>
			<td><b>{$data.price}</b></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>m2</td>
			<td>m2</td>
			<td>Sản phẩm lưu kho</td>
		</tr>
		{/foreach}
	</table>
	<nav aria-label="Page navigation example">
		{$paging}
	</nav>
</div>
<div class="modal fade" tabindex="-1" id="CopyProduct">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Sao chép sản phẩm</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Tên sản phẩm</label>
					<input type="hidden" value="" name="id">
					<input type="text" class="form-control" name="name">
					<small class="form-text text-muted">Nhập tên sản phẩm mới bạn đang cần copy từ sản phẩm
						trên.</small>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="Copy();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>
{literal}
<script>
	function filter() {
		var key = $("#filter_key").val();
		var status = $("#status").val();
		var category = $("#category").val();
		var url = "?mod=product&site=odooproduct";
		if (key != '') url = url + "&key=" + key;
		location.href = url;
	}
</script>
{/literal}