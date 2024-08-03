<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý lịch sử tìm kiếm</h1>
		</div>
		<div class="col-md-4 text-right">
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-8">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_key}">
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
            <th class="text-center" width="45"><input type="checkbox" class="SelectAllRows"></th>
            <th>Từ khóa</th>
            <th class="text-right">Mã từ khóa</th>
            <th class="text-right">Mã user</th>
            <th>IP</th>
            <th class="text-right">Thời gian</th>
            <th class="text-right" width="100"></th>
        </tr>
        </thead>
        <tbody>
        {if $result neq NULL}
        {foreach from=$result item=data}
        <tr id="field{$data.id}">
            <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
            <td width="40%" class="field_name">{$data.keyword_name}</td>
            <td class="text-right">{$data.keyword_id}</td>
            <td class="text-right">{$data.user_id}</td>
            <td>{$data.user_ip}</td>
            <td class="text-right">{$data.created|date_format:'%H:%M:%S %d-%m-%Y'}</td>
            <td class="text-right" style="min-width:88px">
            	{if $data.keyword_id eq 0}
            	<button class="btn btn-default btn-xs" onclick="SetKeyword('{$data.keyword_name}');"><i class="fa fa-check fa-fw"></i></button>
                {/if}
                <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('keyword', {$data.id}, 'ajax_delete_history');"><i class="fa fa-trash fa-fw"></i></button>
            </td>
        </tr>
        {/foreach}
        {else}
        <tr><td class="text-center" colspan="10"><br>Không có nội dung nào được tìm thấy<br><br></td></tr>
        {/if}
        </tbody>
    </table>
</div>

<div class="paging">{$paging}</div>

{literal}
<script>
$('#keyword,#category').keypress(function( event ){
    if ( event.which == 13 ) filter();
});

function filter(){
    var key = $.trim($("#keyword").val());
    var status = $("#status").val();
    var cat = $("#category").val();
    var url = "?mod=keyword&site=history";
    if(cat!=0) url = url+"&cat="+cat;
    if(status!=-1) url = url+"&status="+status;
    if(key!='') url = url+"&key="+key;
    window.location.href = url;
}

function SetKeyword(key){
	var data = {};
	data.key = key;
	data.ajax_action = 'set_keyword';
	$.post('?mod=keyword&site=history', data).done(function(e){
		location.reload();
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
    else if (bulk == 1) BulkActive('pages', 1);
    else if (bulk == 2) BulkActive('pages', 2);
}
</script>
{/literal}
