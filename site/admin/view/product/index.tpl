<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý sản phẩm</h1>
		</div>
		<div class="col-md-4 text-right">
			<button class="btn btn-primary" onclick="LoadNumberSiteMap();">
				<i class="fa fa-plus fa-fw"></i> Export SitemapXML
			</button>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-9">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_keyword}">
	        <input type="hidden" id="page_id" value="{$out.page_id}">
	        <select class="left form-control" id="category" style="width: 200px;">
	        	<option value="-1">Tất cả danh mục</option>
	        	{$out.filter_category}
	        </select>
	        <select class="left form-control" id="status">{$out.filter_status}</select>
	        <select class="left form-control" id="toprank">{$out.filter_toprank}</select>
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
	</div>
	<div class="col-md-3">
	    <div class="form-group form-inline text-right">
	        <select class="left form-control" name="bulk1">
	            <option value="">Chọn tác vụ</option>
	            <option value="0">Xóa nhiều</option>
	            <option value="1">Kích hoạt</option>
	            <option value="2">Hủy kích hoạt</option>
	            <option value="3">Cập nhật danh mục</option>
	            <option value="5">Sao chép</option>
	        </select>
	        <button id="search_btn" type="button" class="btn btn-default" onclick="BulkAction(1);">Áp dụng</button>
        </div>
	</div>
</div>

<div class="table-responsive">
    <table class="table table-bordered table-hover table-striped">
        <thead>
        <tr>
            <th class="text-center"><input type="checkbox" class="SelectAllRows"></th>
            <th>Tiêu đề</th>
			<th>Gian hàng</th>
            <th>Giá bán</th>
            <th>Khởi tạo</th>
            <th>Member</th>
            <th>Admin</th>
            <th class="text-center">TT</th>
            <th class="text-center">Hot</th>
            <th class="text-right"></th>
        </tr>
        </thead>
        <tbody>
        {if $result neq NULL}
            {foreach from=$result item=data}
                <tr id="field{$data.id}">
                    <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
                    <td width="35%">
                    	<div class="row row-small">
                    		<div class="col-md-2 col-sm-2 col-xs-2">
                    			<img class="img" id="img{$data.id}" src="{$data.avatar}">
                    		</div>
                    		<div class="col-md-10">
		                        <a href="{$data.url}" class="field_name" target="_blank">{$data.name}</a><br>
		                        <span class="text-small"><i class="fa fa-tags fa-fw"></i> {$data.code}</span>
		                       <br>
		                        <span class="text-small"><i class="fa fa-folder-open-o fa-fw"></i> {$data.category}</span>
	                    		<p class="text-small">
	                    			<i class="fa fa-cubes fa-fw"></i> Kho hàng: <b id="numb{$data.id}">{$data.number|default:0}</b>
	                    			<a href="javascript:void(0)" onclick="FrmNumber({$data.id}, {$data.number|default:0});"><i class="fa fa-pencil fa-fw"></i></a> | 
	                    			<i class="fa fa-heart-o fa-fw"></i> Khuyến mại tuần: <b id="promo{$data.id}">{$data.promo|default:0}%</b>
	                    			<a href="javascript:void(0)" onclick="FrmPromo({$data.id},{$data.promo|default:10},{$data.price|default:0});">
	                    				<i class="fa fa-pencil fa-fw"></i>
	                    			</a>
	                    		</p>
                    		</div>
                    	</div>
                    </td>
					<td><a href="?mod=pages&site=index&key={$data.page}" target="_blank" title="Xem gian hàng">{$data.page}</a>
						<p><a class="btn btn-success btn-xs" href="{$data.url_seller}" title="Login" target="_blank"><i
							class="fa fa-sign-in fa-fw"></i>Đăng nhập vào gian hàng</a></p>
					</td>
                    <td>Giá từ {$data.price|number_format}đ</td>
                    <td>{$data.created|date_format:'%H:%M:%S %d-%m-%Y'}</td>
                    <td>{$data.user_name}</td>
                    <td>{$data.admin}</td>
                    <td class="text-center" id="stt{$data.id}">{$data.status}</td>
                    <td class="text-center" id="fea{$data.id}">{$data.featured}</td>
                    <td class="text-right" style="min-width:88px">
                    	<a href="{$data.source}" target="_blank" class="btn btn-default btn-xs"><i class="fa fa-link fa-fw"></i></a>
                    	<a href="?mod=product&site=form&id={$data.id}" class="btn btn-default btn-xs"><i class="fa fa-pencil fa-fw"></i></a>
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('product', {$data.id}, 'ajax_delete');"><i class="fa fa-trash fa-fw"></i></button>
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

<!-- Content Modal -->
<div class="modal fade" id="FrmCopy">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Copy sản phẩm tới gian hàng</h4>
            </div>
            <div class="modal-body">
            	<p>Vui lòng nhập mã gian hàng muốn copy sản phẩm tới</p>
            	<input type="text" name="page_id" class="form-control">
            	<p>Nếu chưa biết mã, vui lòng <a href="?mod=pages&site=index" target="_blank">click vào đây</a> để tìm mã gian hàng</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-success" onclick="CopyProducts();">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="FrmNumber">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Số lượng sản phẩm trong kho</h4>
            </div>
            <div class="modal-body">
            	<p>Vui lòng nhập số lượng sản phẩm đang có trong kho của bạn</p>
            	<input type="hidden" name="id">
            	<input type="text" name="number" class="form-control">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-success" onclick="SaveNumber();">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="FrmPromo">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Khuyến mại trong tuần</h4>
            </div>
            <div class="modal-body">
            	<p>Vui lòng nhập % khuyến mại tối thiểu 10% và tối đa là 80%</p>
            	<input type="hidden" name="id">
            	<input type="text" name="promo" class="form-control">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-success" onclick="SavePromo();">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="FrmSetCate">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Cập nhật danh mục sản phẩm</h4>
            </div>
            <div class="modal-body">
            	<p>Vui lòng chọn danh mục cho sản phẩm</p>
	            <select class="form-control" name="taxonomy_id">
		        	{$out.filter_category}
		        </select>
            	
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-success" onclick="SetCate();">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>
<!-- Content Modal -->
<div class="modal fade" id="FrmSiteMap">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Number Link</h4>
            </div>
            <div class="modal-body">
            	<p>Nhập số lượng link sp cần xuất</p>
            	<input type="text" name="number" class="form-control">
            	<input type="hidden" name="status" value="{$smarty.get.status|default:-1}">
            	<input type="hidden" name="cat" value="{$smarty.get.cat|default:-1}">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-success" onclick="ExportXML();" id="btnExport">Xuất ngay</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
$(window).ready(function(){
	$("select[name=taxonomy_id]").chosen({width: '100%' });
});
$('#keyword,#category').keypress(function( event ){
    if ( event.which == 13 ) filter();
});

function filter(){
    var key = $.trim($("#keyword").val());
    var page_id = $("#page_id").val();
    var status=$("#status").val();
    var toprank=$("#toprank").val();
    var cat = $("#category").val();
    var url = "?mod=product&site=index";
    if(cat!=-1) url = url+"&cat="+cat;
    if(page_id!=0) url = url+"&page_id="+page_id;
    if(status!=-1) url = url+"&status="+status;
    if(toprank!=-1) url = url+"&toprank="+toprank;
    if(key!='') url = url+"&key="+key;
    window.location.href = url;
}

function BulkAction(pos) {
    PNotify.removeAll();
    var bulk = $('select[name=bulk'+pos+']').val();
	var arr = [];
	$(".item_checked").each(function () {
		if ($(this).is(':checked')) {
			var value = $(this).val();
			arr.push(value);
		}
	});

    if (bulk == '') {
    	noticeMsg('Thông báo', 'Vui lòng chọn một tác vụ.', 'error');
    } else if(arr.length < 1) noticeMsg('Thông báo', 'Vui lòng chọn các sản phẩm cần xử lí', 'warning');
    else if (bulk == 0) BulkDelete('product', 'ajax_delete_multi');
    else if (bulk == 1) BulkActive('products', 1);
    else if (bulk == 2) BulkActive('products', 2);
    else if (bulk == 3) $('#FrmSetCate').modal('show');
    else if (bulk == 5) $('#FrmCopy').modal('show');
}



function CopyProducts(){
	var arr = [];
	$(".item_checked").each(function () {
		if ($(this).is(':checked')) {
			var value = $(this).val();
			arr.push(value);
		}
	});
	var data = {};
	data.page_id = $('#FrmCopy input[name=page_id]').val();
	data.ids = arr;
	if (arr.length < 1) {
		noticeMsg('Chọn mục xử lí', 'Vui lòng chọn các mục cần xử lí', 'warning');
		return false;
	}else if(data.page_id==''){
		noticeMsg('Thông báo', 'Vui lòng nhập mã gian hàng', 'warning');
		$('#FrmCopy input[name=page_id]').focus();
		return false;
	}
	loading();
	$.post("?mod=product&site=ajax_copy_product", data).done(function (rt) {
		rt = JSON.parse(rt);
		if (rt.code == '0') noticeMsg('Thông báo', rt.msg, 'error');
		else noticeMsg('Thông báo', rt.msg, 'success');
		endloading();
		setTimeout(function () {
			location.reload();
		}, 2000);
	});
}

function SetCate(){
	var data = {};
	data.ids = [];
	$(".item_checked").each(function () {
		if($(this).is(':checked')) data.ids.push($(this).val());
	});
	data.taxonomy_id = $('#FrmSetCate select[name=taxonomy_id]').val();
	if (data.ids.length < 1) {
		noticeMsg('Chọn mục xử lí', 'Vui lòng chọn các mục cần xử lí', 'warning');
		return false;
	}else if(data.taxonomy_id==0){
		noticeMsg('Thông báo', 'Vui lòng chọn danh mục sản phẩm', 'warning');
		$('#FrmSetCate select[name=taxonomy_id]').focus();
		return false;
	}
	data.ajax_action = 'set_taxonomy_multi_product';
	loading();
	$.post("?mod=product&site=ajax_handle", data).done(function (rt) {
		endloading();
		setTimeout(function () {
			location.reload();
		}, 1200);
	});
}
function LoadNumberSiteMap(){
	$('#FrmSiteMap input[name=number]').val();
	$('#FrmSiteMap').modal('show');
}

function ExportXML(){
	var data = {};
	data.number = $('#FrmSiteMap input[name=number]').val();
	data.status = $('#FrmSiteMap input[name=status]').val();
	data.cat = $('#FrmSiteMap input[name=cat]').val();
	loading();
    $.post("?mod=product&site=export_file_xml",data).done(function (e) {
    	noticeMsg('Thông báo', 'Export thành công', 'success');
    	endloading();
    });
}

function FrmNumber(id, number){
	$('#FrmNumber input[name=id]').val(id);
	$('#FrmNumber input[name=number]').val(number);
	$('#FrmNumber').modal('show');
}

function SaveNumber(){
	var data = {};
	data.id = $('#FrmNumber input[name=id]').val();
	data.number = $('#FrmNumber input[name=number]').val();
	data.ajax_action = 'update_number';
	loading();
    $.post("?mod=product&site=ajax_handle",data).done(function (e) {
    	$('#numb'+data.id).html(data.number);
    	noticeMsg('Thông báo', 'Cập nhật số lượng thành công', 'success');
    	$('#FrmNumber').modal('hide');
    	endloading();
    });
}

function FrmPromo(id, promo, price){
	if(price == 0){
		noticeMsg('Thông báo', 'Vui lòng nhập giá sản phẩm trước khi nhập khuyến mại', 'error');
		return false;
	}
	$('#FrmPromo input[name=id]').val(id);
	$('#FrmPromo input[name=promo]').val(promo);
	$('#FrmPromo').modal('show');
}

function SavePromo(){
	var data = {};
	data.id = $('#FrmPromo input[name=id]').val();
	data.promo = $('#FrmPromo input[name=promo]').val();
	data.ajax_action = 'update_promo';
	loading();
    $.post("?mod=product&site=ajax_handle",data).done(function (e) {
    	$('#promo'+data.id).html(data.promo+'%');
    	noticeMsg('Thông báo', 'Cập nhật số lượng thành công', 'success');
    	$('#FrmPromo').modal('hide');
    	endloading();
    });
}
</script>
{/literal}