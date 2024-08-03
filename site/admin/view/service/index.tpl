<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý dịch vụ</h1>
		</div>
		<div class="col-md-4 text-right">
			<a href="{$out.url_create}" class="btn btn-primary"><i class="fa fa-plus fa-fw"></i> Thêm Mới</a>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-8">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_keyword}">
	        <select class="left form-control" id="category">{$out.filter_category}</select>
	        <select class="left form-control" id="status">{$out.filter_status}</select>
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
            <th class="text-center"><input type="checkbox" class="SelectAllRows"></th>
            <th>Tiêu đề</th>
            <th>Vị trí</th>
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
                    		<div class="col-md-2">
                    			<img class="img" id="img{$data.id}" src="{$data.avatar}" onclick="ViewImage('{$data.avatar}', {$data.id});">
                    		</div>
                    		<div class="col-md-10">
		                        <span class="field_name">{$data.name}</span>
		                        {if $data.category neq NULL}<br><span class="text-small"><i class="fa fa-folder-open-o fa-fw"></i> {$data.category}</span>{/if}
                    		</div>
                    	</div>
                    </td>
                    <td style="max-width: 160px;"></td>
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

<!-- Content Modal -->
<div class="modal fade" id="ContentPost">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Hiển thị chi tiết bài viết</h4>
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- View Image Modal -->
<div class="modal fade" id="ViewImage">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="MediaName">Hiển thị hình ảnh</h4>
            </div>
            <div class="modal-body">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="BtnChange">Thay đổi ảnh</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

{include '../media/media_modal.tpl'}

{literal}
<script>
$('#keyword,#category').keypress(function( event ){
    if ( event.which == 13 ) filter();
});

function filter(){
    var key = $.trim($("#keyword").val());
    var status=$("#status").val();
    var cat = $("#category").val();
    var url = "?mod=service&site=index";
    if(cat!=0) url = url + "&cat=" + cat;
    if(status!=-1) url = url + "&status=" + status;
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
    else if (bulk == 0) BulkDelete('service', 'ajax_bulk_delete');
    else if (bulk == 1) BulkActive('services', 1);
    else if (bulk == 2) BulkActive('services', 0);
}

function ViewImage(image, id){
	loading();
    $("#ViewImage .modal-body").load('?mod=media&site=detail',{'image':image}, function (data) {
        $("#ViewImage").modal('show');
        $('#ViewImage #BtnChange').attr('onclick', "LoadMedia('ChangeImage');");
        $('#PostIdUpdate').val(id);
        endloading();
    });
	
}

function ChangeImage(media_id) {
    loading();
    var post_id = $('#PostIdUpdate').val();
    $.post("?mod=posts&site=images", {
    	'ajax': 'save_image_update', 'media_id':media_id, 'post_id':post_id
    }).done(function (e) {
    	$("#img"+post_id).attr("src",e);
    	$("#LoadMedia").modal('hide');
    	endloading();
    });
}
</script>
{/literal}
