<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Thống kê khối lượng quản trị
			</h1>
		</div>
	</div>
</div>


<div class="row">
	<div class="col-md-8">
	    <div class="form-group form-inline">
	        <input type="text" class="left form-control datepicker" id="from" placeholder="Từ ngày..." value="{$out.from|default:''}">
	        <input type="text" class="left form-control datepicker" id="to" placeholder="Đến ngày..." value="{$out.to|default:''}">
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
	</div>
</div>

<div class="table-responsive">
	<table
		class="table table-bordered table-hover table-striped hls_list_table">
		<thead>
			<tr>
				<th class="text-center" style="width: 3%"><input type="checkbox" class="SelectAllRows"></th>
				<th>Tài khoản</th>
				<th class="text-right">Gian hàng</th>
				<th class="text-right">Sản phẩm</th>
				<th class="text-right">Từ khóa</th>
				<th class="text-right">Bài viết</th>
				<th class="text-right">Sửa danh mục</th>
				<th class="text-right">Tổng tiền</th>
			</tr>
		</thead>
		<tbody>
			{if $result neq NULL} {foreach from=$result item=data}
			<tr id="field{$data.id}">
				<td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
				<td class="field_name">{$data.name} ({$data.username})</td>
				<td class="text-right">{$data.pages|number_format}</td>
				<td class="text-right">{$data.products|number_format}</td>
				<td class="text-right">{$data.keywords|number_format}</td>
				<td class="text-right">{$data.posts|number_format}</td>
				<td class="text-right">{$data.page_cate|number_format}</td>
				<td class="text-right">{$data.price_product|number_format} VNĐ</td>
			</tr>
			{/foreach} {else}
			<tr>
				<td colspan="10">Không có nội dung nào được tìm thấy.</td>
			</tr>
			{/if}
		</tbody>
	</table>
</div>
<div class="paging">{$paging}</div>

{literal}
<script>
$(window).ready(function(){
	var dateToday = new Date();
	$( ".datepicker" ).datepicker({
		dateFormat: 'dd-mm-yy',
		maxDate: '0'
	});
});

function filter(){
    var from = $.trim($("#from").val());
    var to = $.trim($("#to").val());
    var url = "?mod=account&site=statistics";
    if(from!='') url = url + "&from=" + from;
    if(to!='') url = url + "&to=" + to;
    window.location.href = url;
}

</script>
{/literal}
