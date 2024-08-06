<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý danh sách các gói gian hàng VIP</h1>
		</div>
		<div class="col-md-4 text-right">
			<button class="btn btn-primary" onclick="LoadForm(0);"><i class="fa fa-plus fa-fw"></i> Thêm Mới</button>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-8">
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
            <th class="text-center">Tên gói</th>
            <th class="text-center">SL sản phẩm</th>
            <th class="text-center">Sourcing</th>
            <th class="text-center">SP showcase</th>
            <th class="text-center">Điểm quảng cáo</th>
            <th class="text-center">SP khuyến mại</th>
            <th class="text-center">Top logo</th>
            <th class="text-center">Top sản phẩm</th>
            <th class="text-center">Giá</th>
            <th class="text-center">Trạng thái</th>
            <th class="text-right" width="100"></th>
        </tr>
        </thead>
        <tbody>
        {if $result neq NULL}
            {foreach from=$result item=data}
                <tr id="field{$data.id}">
                    <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
                    <td class="field_name text-center">{$data.name}</td>
                    <td class="text-center">{$data.numb_product}</td>
                    <td class="text-center">{$data.numb_sourcing} báo giá</td>
                    <td class="text-center">{$data.numb_showcase}</td>
                    <td class="text-center">{$data.numb_ads} điểm</td>
                    <td class="text-center">{$data.numb_event}</td>
                    <td class="text-center">{$data.numb_homelogo} ngày</td>
					<td class="text-center">{$data.limit_push_top}</td>
					<td class="text-center">{$data.price|number_format}đ</td>
                    <td class="text-center" id="stt{$data.id}">{$data.status}</td>
                    <td class="text-center" style="min-width:88px">
                        <button class="btn btn-default btn-xs" onclick="LoadForm({$data.id});" title="Chỉnh sửa">
							<i class="fa fa-pencil fa-fw"></i>
						</button>
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" 
							onclick="LoadDeleteItem('pages', {$data.id}, 'ajax_delete_package');">
							<i class="fa fa-trash fa-fw"></i>
						</button>
                    </td>
                </tr>
            {/foreach}
        {else}
            <tr><td class="text-center" colspan="10"><br>Không có nội dung nào được tìm thấy<br><br></td></tr>
        {/if}
        </tbody>
    </table>
</div>


<div class="modal fade" id="Form">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" id="titleModal">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel"></h4>
            </div>
            <div class="modal-body">
            	<input type="hidden" name="id">
				<div class="form-group row">
					<label class="col-sm-3">Tên gói VIP</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="name">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">Giá</label>
					<div class="col-sm-6">
						<input type="number" class="form-control" name="price">
					</div>
				</div>
				{* <div class="form-group row">
					<label class="col-sm-3">Mô tả thêm</label>
					<div class="col-sm-9">
						<textarea class="form-control" rows="4" name="description"></textarea>
					</div>
				</div> *}
				<div class="form-group row">
					<label class="col-sm-3">Số lượng sản phẩm</label>
					<div class="col-sm-3">
						<input type="number" class="form-control" name="numb_product">
					</div>
					<label class="col-sm-3">Báo giá sourcing</label>
					<div class="col-sm-3">
						<input type="number" class="form-control" name="numb_sourcing">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">SP showcase</label>
					<div class="col-sm-3">
						<input type="number" class="form-control" name="numb_showcase">
					</div>
					<label class="col-sm-3">Điểm quảng cáo</label>
					<div class="col-sm-3">
						<input type="number" class="form-control" name="numb_ads">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">SP khuyến mại</label>
					<div class="col-sm-3">
						<input type="number" class="form-control" name="numb_event">
					</div>
					<label class="col-sm-3">Top logo (ngày)</label>
					<div class="col-sm-3">
						<input type="number" class="form-control" name="numb_homelogo">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">Thứ tự</label>
					<div class="col-sm-3">
						<input type="number" class="form-control" name="sort">
					</div>
					<label class="col-sm-3">Giới hạn đẩy top</label>
					<div class="col-sm-3">
						<input type="number" class="form-control" name="limit_push_top" value="3">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">Mô tả thêm</label>
					<div class="col-sm-9">
						<textarea class="form-control" rows="4" name="description"></textarea>
					</div>
				</div>
			</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-info" onclick="SaveForm();">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
function LoadForm(id){
	if(id!=0){
		$("#titleModal h4").text('Chỉnh sửa gói vip');
	}else {
		$("#titleModal h4").text('Thêm mới gói vip');
	};
	var data = {};
	data.id = id;
	data.ajax_action = 'load_package';
	$.post('?mod=pages&site=package', data).done(function(e){
		$("#Form input[name=id]").val(id);
		var rt = JSON.parse(e);
		$("#Form input[name=name]").val(rt.name);
		$("#Form input[name=price]").val(rt.price);
		$("#Form textarea[name=description]").val(rt.description);
		$("#Form input[name=numb_showcase]").val(rt.numb_showcase);
		$("#Form input[name=numb_ads]").val(rt.numb_ads);
		$("#Form input[name=numb_product]").val(rt.numb_product);
		$("#Form input[name=numb_sourcing]").val(rt.numb_sourcing);
		$("#Form input[name=numb_event]").val(rt.numb_event);
		$("#Form input[name=numb_homelogo]").val(rt.numb_homelogo);
		$("#Form input[name=sort]").val(rt.sort);
		$("#Form input[name=limit_push_top]").val(rt.limit_push_top);
		$("#Form").modal('show');
	});
}

function SaveForm(){
	var data = {};
	data.id = $("#Form input[name=id]").val();
	data.name = $("#Form input[name=name]").val();
	data.price = $("#Form input[name=price]").val();
	data.description = $("#Form textarea[name=description]").val();
	data.numb_showcase = $("#Form input[name=numb_showcase]").val();
	data.numb_ads = $("#Form input[name=numb_ads]").val();
	data.numb_product = $("#Form input[name=numb_product]").val();
	data.numb_sourcing = $("#Form input[name=numb_sourcing]").val();
	data.numb_event = $("#Form input[name=numb_event]").val();
	data.numb_homelogo = $("#Form input[name=numb_homelogo]").val();
	data.sort = $("#Form input[name=sort]").val();
	data.limit_push_top = $("#Form input[name=limit_push_top]").val();
	data.ajax_action = 'save_package';
	
	if(data.name.length < 3){
		noticeMsg('Message System', 'Vui lòng nhập từ khóa tối thiểu 3 ký tự.', 'error');
		$("#Form input[name=name]").focus();
		return false;
	}
	
	$.post('?mod=pages&site=package', data).done(function(e){
		var rt = JSON.parse(e);
		noticeMsg('Message System', 'Cập nhật thông tin thành công.', 'success');
		$("#Form").modal('hide');
		// if(data.id==0){
			setTimeout(function(){
				window.location.reload();
			}, 1000);
		// }else $("#field"+data.id+" .field_name").html(data.name);
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
