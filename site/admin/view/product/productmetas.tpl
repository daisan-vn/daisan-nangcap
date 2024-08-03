<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý thuộc tính sản phẩm</h1>
		</div>
		<div class="col-md-4 text-right">
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-4">
		<p>Thuộc tính chỉ được thêm cho danh mục cấp thấp nhất</p>
		<p>Vui lòng chọn danh mục cấp thấp nhất để tạo các thuộc tính cho nó.</p>
	    <div class="form-group">
	    	<label>Chọn danh mục</label>
	        <select class="form-control" id="cat_l0" onchange="filter();">{$out.s_cat_l0}</select>
	    </div>
	    <div class="form-group">
	        <select class="form-control" id="cat_l1" onchange="filter();">{$out.s_cat_l1}</select>
	    </div>
	    <div class="form-group">
	        <select class="form-control" id="cat_l2" onchange="filter();">{$out.s_cat_l2}</select>
	    </div>
	    <div class="form-group">
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
	</div>
	<div class="col-md-8">
	    <div class="form-group form-inline text-right">
	    	{if $out.taxonomy_id}
	    	<button type="button" class="btn btn-primary" onclick="LoadMeta(0);"><i class="fa fa-plus"></i> Thêm mới</button>
	        {/if}
	        <select class="left form-control" name="bulk1">
	            <option value="">Chọn tác vụ</option>
	            <option value="1">Kích hoạt</option>
	            <option value="2">Hủy kích hoạt</option>
	        </select>
	        <button id="search_btn" type="button" class="btn btn-default" onclick="BulkAction(1);">Áp dụng</button>
        </div>
        
        
		<div class="table-responsive">
		    <table class="table table-bordered table-hover table-striped">
		        <thead>
		        <tr>
		            <th class="text-center"><input type="checkbox" class="SelectAllRows"></th>
		            <th>Tên thuộc tính</th>
		            <th class="text-right"></th>
		        </tr>
		        </thead>
		        <tbody>
		        {if $result neq NULL}
		            {foreach from=$result item=data}
		                <tr id="field{$data.id}">
		                    <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
		                    <td width="50%">
				                <span>{$data.meta_key}</span>
		                    </td>
		                    <td class="text-right" style="min-width:88px">
		                        <button type="button" class="btn btn-default btn-xs" onclick="LoadMeta({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
		                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('product', {$data.id}, 'ajax_delete_meta');"><i class="fa fa-trash fa-fw"></i></button>
		                    </td>
		                </tr>
		            {/foreach}
		        {else}
		            <tr><td class="text-center" colspan="10"><br>Không có nội dung nào được tìm thấy<br><br></td></tr>
		        {/if}
		        </tbody>
		    </table>
		</div>
		
	</div>
</div>


<!-- Content Modal -->
<div class="modal fade" id="AddMeta">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Thuộc tính sản phẩm</h4>
            </div>
            <div class="modal-body">
				<div class="form-group">
					<label>Tên thuộc tính</label> 
					<input type="text" class="form-control" name="meta_key">
					<input type="hidden" name="id">
					<input type="hidden" name="taxonomy_id" value="{$out.taxonomy_id}">
					<small class="form-text text-muted">Các thuộc tính cho sản phẩm ví dụ: "Mà sắc, kích thước, chất liệu".</small>
				</div>
			</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" onclick="SaveMeta();">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
$('#keyword,#category').keypress(function( event ){
    if ( event.which == 13 ) filter();
});

function LoadMeta(id){
	var data = {};
	data.id = id;
	data.ajax_action = 'load_metas';
	loading();
	$.post('?mod=product&site=productmetas', data).done(function(e){
		var rt = JSON.parse(e);
		$("#AddMeta input[name=id]").val(id);
		$("#AddMeta input[name=meta_key]").val(rt.meta_key);
		$("#AddMeta").modal('show');
		endloading();
	});
}

function SaveMeta(){
	var data = {};
	data.id = $("#AddMeta input[name=id]").val();
	data.taxonomy_id = $("#AddMeta input[name=taxonomy_id]").val();
	data.meta_key = $("#AddMeta input[name=meta_key]").val();
	data.ajax_action = 'save_metas';
	loading();
	$.post('?mod=product&site=productmetas', data).done(function(e){
		var rt = JSON.parse(e);
		if(rt.code==0){
			noticeMsg('System Message', rt.msg, 'error');
			endloading();
		}else{
			noticeMsg('System Message', rt.msg, 'success');
			setTimeout(function(e){
				location.reload();
			}, 1500);
		}
	});
}

function filter(){
    var cat_l0 = $("#cat_l0").val();
    var cat_l1 = $("#cat_l1").val();
    var cat_l2 = $("#cat_l2").val();
    var url = "?mod=product&site=productmetas";
    if(cat_l0!=0) url = url+"&cat_l0="+cat_l0;
    if(cat_l1 && cat_l1!=0 && cat_l0!=0) url = url+"&cat_l1="+cat_l1;
    if(cat_l2 && cat_l2!=0 && cat_l0!=0 && cat_l1!=0) url = url+"&cat_l2="+cat_l2;
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
    else if (bulk == 1) BulkActive('products', 1);
    else if (bulk == 2) BulkActive('products', 2);
}
</script>
{/literal}
