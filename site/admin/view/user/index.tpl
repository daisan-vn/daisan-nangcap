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
	        <input type="search" class="left form-control" id="key" placeholder="Từ khóa..." value="{$out.key|default:''}">
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
	<table
		class="table table-bordered table-hover table-striped hls_list_table">
		<thead>
			<tr>
				<th class="text-center" style="width: 3%"><input type="checkbox" class="SelectAllRows"></th>
				<th>Id</th>
				<th>Họ tên</th>
				<th>Điện thoại</th>
				<th class="">Cập nhật</th>
				<th class="text-center">TT</th>
				<th class="text-center">Admin</th>
			</tr>
		</thead>
		<tbody>
			{if $result neq NULL} {foreach from=$result item=data}
			<tr id="field{$data.id}">
				<td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
				<td>{$data.id}</td>
				<td width="50%">
					<div class="row row-small">
						<div class="col-md-2">
							<img class="img thumbnail" id="img{$data.id}" src="{$data.avatar}">
						</div>
						<div class="col-md-10">
							<span class="field_name">{$data.name}</span> <br>
							<span class="text-small"><i class="fa fa-user-o fa-fw"></i> {$data.username}</span><br>
							<span class="text-small"><i class="fa fa-envelope-open"></i> {$data.email}</span>
						</div>
					</div>
				</td>
				<td>{$data.phone}</td>
				<td class="">{$data.created|date_format:'%H:%M %d-%m-%Y'}</td>
				<td class="text-center" id="stt{$data.id}">{$data.status}</td>
				<td class="text-center" id="isadmin{$data.id}">{$data.isadmin}</td>
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
$('#key,#category').keypress(function( event ){
    if ( event.which == 13 ) filter();
});

function filter(){
    var key = $.trim($("#key").val());
    var url = "?mod=user&site=index";
    if(key!='') url = url + "&key=" + key;
    window.location.href = url;
}

function setAdmin(Table, Id) {
	loading();
	$.post("?mod=user&site=ajax_setadmin", {'Id': Id}).done(function (data) {
		if (data == '0') noticeMsg('Message', 'Cập nhật trạng thái thất bại.', 'error');
		else {
			$("#isadmin" + Id).html(data);
			noticeMsg('Message', 'Cập nhật trạng thái thành công.', 'success');
		}
		endloading();
	});
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