<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Lịch sử cập nhật dữ liệu hệ thống
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
				<th class="text-center" style="width: 5%"><input type="checkbox" class="SelectAllRows"></th>
				<th>Table</th>
				<th>Type</th>
				<th>Type</th>
				<th>User</th>
				<th class="text-right">Timer</th>
			</tr>
		</thead>
		<tbody>
			{if $result neq NULL} {foreach from=$result item=data}
			<tr id="field{$data.id}">
				<td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
				<td>{$data.obj}</td>
				<td>{$data.type}</td>
				<td>
					{foreach from=$data.content key=k1 item=k2}
					<p>{$k1}:{$k2}</p>
					{/foreach}
				</td>
				<td>{$data.username}</td>
				<td class="text-right">{$data.created|date_format:'%H:%S %d-%m-%Y'}</td>
			</tr>
			{/foreach} 
			{else}
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
    var url = "?site=tablechangelogs";
    if(from!='') url = url + "&from=" + from;
    if(to!='') url = url + "&to=" + to;
    window.location.href = url;
}

</script>
{/literal}