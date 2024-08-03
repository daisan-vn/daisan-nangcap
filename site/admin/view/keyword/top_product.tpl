<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý sản phẩm từ khóa</h1>
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

	</div>
</div>

<div class="table-responsive">
    <table class="table table-bordered table-hover table-striped">
        <thead>
            <tr>
                <th class="text-center" width="45"><input type="checkbox" class="SelectAllRows"></th>
                <th class="text-center">Id</th>
                <th width="100">Hình ảnh</th>
                <th>Sản phẩm</th>
                <th class="text-center">Sắp xếp</th>
                <th class="text-center" width="100">Tùy chọn</th>
            </tr>
        </thead>

        <tbody>
            {foreach from=$products item=$item}
            <tr>
                <td>
                </td>
                <td class="text-center">{$item.id}</td>
                <td>
                    {if $item.avatar}
                        <img class="img" src="{$item.avatar}" alt=""/>
                    {/if}
                </td>
                <td>{$item.name}</td>
                <td class="text-center">0</td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>

<div class="paging">{$paging}</div>

<div class="modal fade" id="Form">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Thêm sản phẩm</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>Gian hàng</label>
                    <select id="page_select" name="page_id" class="form-control chosen">
                    </select>
                </div>
                <div class="form-group">
                    <label>Sản phẩm</label>
                    <select id="product_select" name="product_id" class="form-control chosen">
                    </select>
                </div>
                <div class="form-group">
                    <label>Thứ tự</label>
                    <input type="number" value="0" class="form-control" name="sort">
                </div>
                <input type="hidden" value="" name="id">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-info" onclick="SaveForm();">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>

<link href="https://daisan.vn/site/sellercenter/webroot/plugins/chosen/chosen.min.css" rel="stylesheet">
<script src="https://daisan.vn/site/sellercenter/webroot/plugins/chosen/chosen.jquery.min.js"></script>

<script>

let page_id = 0;

$(function() {
    let chosen_option = {}
    chosen_option.width = '100%';
    // chosen_option.disable_search_threshold = 10;

    $('.chosen').chosen(chosen_option);

    $('#page_select').on('change', function() {
        LoadProducts($('#page_select').val());
    });
});

function LoadProducts(page_id) {
    let data = {};
    data.page_id = page_id;
    data.ajax_action = 'load_products';

    $.post('?mod=keyword&site=top_product', data).done(function(res){
        let product_list = JSON.parse(res);
        items = [];
        for (let item of product_list) {
            items.push('<option value="' + item.id + '">' + item.name + '</option>');
        }
        let $product_select = $('#product_select');
        $product_select.html(items.join(''));
        $product_select.trigger('chosen:updated');
    });
}

function LoadForm(id){
	let data = {};
	data.id = id || 0;
	data.ajax_action = 'load_pages';

    $("#Form").modal('show');

    $.post('?mod=keyword&site=top_product', data).done(function(res){
        let pages_list = JSON.parse(res);
        items = [];
        for (let item of pages_list) {
            items.push('<option value="' + item.id + '">' + item.name + '</option>');
        }

        let $page_select = $('#page_select');

        $page_select.html(items.join(''));
        $page_select.trigger('chosen:updated');

        LoadProducts($('#page_select').val());
	});

    
}

function SaveForm(){
	let data = {};
	data.id = $("#Form input[name=id]").val();
	data.page_id = $("#Form select[name=page_id]").val();
	data.product_id = $("#Form select[name=product_id]").val();
	data.ajax_action = 'add_product';
	
    $.post('?mod=keyword&site=top_product', data).done(function(e){
		let rt = JSON.parse(e);
		noticeMsg('Message System', 'Cập nhật thông tin thành công.', 'success');
		$("#Form").modal('hide');
		if(data.id==0){
			setTimeout(function(){
				// location.reload();
			}, 1000);
		}else $("#field"+data.id+" .field_name").html(data.name);
	});

}

</script>