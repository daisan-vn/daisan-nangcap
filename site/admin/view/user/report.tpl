<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Quản lý danh sách người dùng
			</h1>
		</div>
		<div class="col-md-4 text-right">
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
	<div class="col-md-4">
	    <div class="form-group form-inline text-right">
	        <select class="left form-control" name="bulk1">
	            <option value="">Chọn tác vụ</option>
	            <option value="1">Kích hoạt</option>
	            <option value="2">Hủy kích hoạt</option>
	        </select>
	        <button id="search_btn" type="button" class="btn btn-default" onclick="BulkAction(1);">Áp dụng</button>
        </div>
	</div>
</div>

<div class="table-responsive">
	<table class="table table-bordered table-hover table-striped">
		<thead>
			<tr>
				<th>#</th>
				<th>Shop</th>
				<th>Products</th>
				<th>Amount</th>
			</tr>
		</thead>
		<tbody>
		{if $result neq NULL} {foreach from=$result item=data}
			<tr>
				<td>{$data.name}</td>
				<td>{$data.pages}</td>
				<td>{$data.products}</td>
				<td>---</td>
			</tr>
		{/foreach}
		{/if}
		</tbody>
	</table>
</div>
<div class="paging">{$paging}</div>

{literal}
<script>
$('#key,#category').keypress(function( event ){
    if ( event.which == 13 ) filter();
});

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
    var url = "?mod=user&site=report";
    if(from!='') url = url + "&from=" + from;
    if(to!='') url = url + "&to=" + to;
    window.location.href = url;
}


function BulkAction(pos) {
    PNotify.removeAll();
    var bulk = $('select[name=bulk'+pos+']').val();
    if (bulk == '') {
        var notice = new PNotify({
            title: 'Chọn tác vụ',
            text: 'Vui lòng chọn 1 tác vụ',
            type: 'info',
            mouse_reset: false,
            buttons: { sticker: false },
            animate: { animate: true, in_class: 'fadeInDown', out_class: 'fadeOutRight' }
        });
        notice.get().click(function () { notice.remove(); });
    } 
    else if (bulk == 0) BulkDelete('product', 'ajax_bulk_delete');
    else if (bulk == 1) BulkActive('users', 1);
    else if (bulk == 2) BulkActive('users', 2);
}
</script>
{/literal}
