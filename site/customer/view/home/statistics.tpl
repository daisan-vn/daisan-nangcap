<div class="card rounded-0">
	<div class="card-body">
		
		<h3>Lọc theo thời gian</h3>
		<div class="form-group row row-nm mb-0" id="filter">
			<div class="col-sm-3">
				<input name="from" type="text" class="form-control mb-3 datepicker" placeholder="Từ ngày..." value="{$out.date_from|default:''}">
			</div>
			<div class="col-sm-3">
				<input name="to" type="text" class="form-control mb-3 datepicker" placeholder="Đến ngày..." value="{$out.date_to|default:''}">
			</div>
			<div class="col-sm-2">
				<button type="button" class="btn btn-success btn-block" onclick="filter();"><i class="fa fa-search"></i> Tìm kiếm</button>
			</div>
		</div>
		<hr>

		<h5>Thống kê theo trạng thái cuộc gọi</h5>
		<table class="table">
			<tr>
				<th width="5%" class="text-right">STT</th>
				<th class="text-right">Nhân viên</th>
				{foreach from=$out.status item=data}
				<th class="text-right">{$data}</th>
				{/foreach}
			</tr>
			{foreach from=$user_status key=k item=data}
			<tr>
				<td class="text-right">{$k+1}</td>
				<td class="text-right">{$data.name}</td>
				<td class="text-right">{$data.status_0}</td>
				<td class="text-right">{$data.status_1}</td>
				<td class="text-right">{$data.status_2}</td>
				<td class="text-right">{$data.status_3}</td>
				<td class="text-right">{$data.status_4}</td>
			</tr>
			{/foreach}
		</table>


		<h5 class="mt-4">Thống kê theo trạng thái khách hàng</h5>
		<table class="table">
			<tr>
				<th width="5%" class="text-right">STT</th>
				<th class="text-right">Nhân viên</th>
				{foreach from=$out.type item=data}
				<th class="text-right">{$data}</th>
				{/foreach}
			</tr>
			{foreach from=$user_type key=k item=data}
			<tr>
				<td class="text-right">{$k+1}</td>
				<td class="text-right">{$data.name}</td>
				<td class="text-right">{$data.type_1}</td>
				<td class="text-right">{$data.type_2}</td>
				<td class="text-right">{$data.type_3}</td>
				<td class="text-right">{$data.type_4}</td>
				<td class="text-right">{$data.type_5}</td>
			</tr>
			{/foreach}
		</table>
		
	</div>
</div>

{literal}
<script type="text/javascript">
$(window).ready(function(){
	var dateToday = new Date();
	$( ".datepicker" ).datepicker({
		dateFormat: 'dd-mm-yy',
		maxDate: '0'
	});
});

function filter(){
	var from = $("#filter input[name=from]").val();
	var to = $("#filter input[name=to]").val();
	
	var url = "./?site=statistics";
	if(from) url = url+"&from="+from;
	if(to) url = url+"&to="+to;
	window.location.href = url;
	return false;
}

</script>
{/literal}
