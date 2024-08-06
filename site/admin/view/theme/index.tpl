<p id="in_progress" class="pull-right"><i class="fa fa-circle-o-notch fa-spin fa-fw"></i> Đang xử lí</p>
<input type="hidden" id="PostIdUpdate">

<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý danh sách templates website</h1>
		</div>
		<div class="col-md-4 text-right">
			<a href="?mod=theme&site=create" class="btn btn-primary"><i class="fa fa-plus fa-fw"></i> Thêm Mới</a>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-8">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_keyword}">
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
	</div>
	<div class="col-md-4">
	    <div class="form-group form-inline text-right">
	        <select class="left form-control" name="bulk1">
	            <option value="">Chọn tác vụ</option>
	            <option value="0">Xóa</option>
	            <option value="1">Kích hoạt</option>
	            <option value="2">Hủy kích hoạt</option>
	        </select>
	        <button id="search_btn" type="button" class="btn btn-default" onclick="BulkAction(1);">Áp dụng</button>
        </div>
	</div>
</div>

<div class="table-responsive">
    <table class="table table-bordered table-hover table-striped hls_list_table">
        <thead>
        <tr>
            <th class="text-center" width="20"><input type="checkbox" class="SelectAllRows"></th>
            <th>Tiêu đề</th>
            <th class="text-center">TT</th>
            <th class="text-right"></th>
        </tr>
        </thead>
        <tbody>
        {if $result neq NULL}
            {foreach from=$result item=data}
                <tr id="field{$data.id}">
                    <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
                    <td width="50%">
                    	<div class="row row-small">
                    		<div class="col-md-3">
                    			<img class="img" src="{$data.avatar}">
                    		</div>
                    		<div class="col-md-9">
                    			<h4>{$data.title}</h4>
		                        <p>Tên theme: {$data.name}</p>
		                        <p>Cập nhật lần cuối: {$data.date_update|date_format:'%d/%m/%Y'}</p>
                    		</div>
                    	</div>
                    </td>
                    <td class="text-center" id="stt{$data.id}">{$data.status}</td>
                    <td class="text-right" style="min-width:88px">
                        <a href="{$data.url_edit}" class="btn btn-default btn-xs" title="Sửa"><i class="fa fa-pencil fa-fw"></i></a>
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('posts', {$data.id}, 'ajax_delete');"><i class="fa fa-trash fa-fw"></i></button>
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
    var position=$("#position").val();
    var cat = $("#category").val();
    var url = "?mod=posts&site=index";
    if(cat!=0) url = url + "&cat=" + cat;
    if(position!=0) url = url + "&position=" + position;
    if(key!='') url = url + "&key=" + key;
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
    else if (bulk == 0) BulkDelete('posts', 'ajax_bulk_delete');
    else if (bulk == 1) BulkActive('posts', 1);
    else if (bulk == 2) BulkActive('posts', 0);
}

</script>
{/literal}