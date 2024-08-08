<div class="body-head">
	<div class="row">
		<div class="col-md-8">
<h1><i class="fa fa-bars fa-fw"></i> Quản lý danh sách gian hàng {if $is_pay} trả phí{/if}</h1>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-9">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_keyword}">
	        <select class="left form-control" id="package_id">{$out.filter_package}</select>
	        <select class="left form-control" id="status">{$out.filter_status}</select>
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
	</div>
	<div class="col-md-3">
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
            <th>Tiêu đề</th>
            <th>Gói đăng ký</th>
            <th>Hết hạn</th>
            <th>Admin</th>
            <th>Khởi tạo</th>
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
                    		<div class="col-md-2">
                    			<img class="img" id="img{$data.id}" src="{$data.logo}">
                    		</div>
                    		<div class="col-md-10">
		                        <a href="{$data.url}" class="field_name">[{$data.id}] {$data.name}</a>
                    		</div>
							<br>
							<a class="btn btn-success btn-xs" href="{$data.url_seller}" title="Login"><i
								class="fa fa-sign-in fa-fw"></i>Đăng nhập vào gian hàng</a>
                    	</div>
                    </td>
                    <td>
                    	{$data.package|default:'Free'}
                    	<div><b>{$data.package_price|default:0|number_format}đ</b></div>
                    </td>
                    <td>{$data.package_end}</td>
                    <td>{$data.admin}</td>
                    <td>{$data.created|date_format:'%H:%M %d-%m-%Y'}</td>
                    <td class="text-right">
                        <button class="btn btn-default btn-xs" onclick="LoadPackage({$data.id});"><i class="fa fa-pencil fa-fw"></i> Gia hạn</button>
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
<div class="modal fade" id="SetPackage">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Hiển thị chi tiết bài viết</h4>
            </div>
            <div class="modal-body">
            	<input type="hidden" name="page_id">
				<div class="form-group">
					<label>Chọn gói gian hàng</label> 
					<select name="package_id" class="form-control"></select>
				</div>
				<div class="form-group">
					<label>Ngày hết hạn</label> 
					<input type="text" name="endtime" class="form-control datepicker">
				</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-success" onclick="SavePackage();">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
$('#keyword,#category').keypress(function( event ){
    if ( event.which == 13 ) filter();
});

$(".datepicker").datepicker();

function filter(){
    var key = $.trim($("#keyword").val());
    var status = $("#status").val();
    var package_id = $("#package_id").val();
    var url = "?mod=pages&site=payment";
    if(package_id!=0) url = url+"&package="+package_id;
    if(status!=-1) url = url+"&status="+status;
    if(key!='') url = url+"&key="+key;
    window.location.href = url;
}

function LoadPackage(page_id){
	var data = {};
	data.id = page_id;
	data.ajax_action = 'load_package';
	$.post('?mod=pages&site=index', data).done(function(e){
		$("#SetPackage input[name=page_id]").val(page_id);
		var rt = JSON.parse(e);
		$("#SetPackage select[name=package_id]").html(rt.s_package);
		$("#SetPackage input[name=endtime]").val(rt.endtime);
		$("#SetPackage").modal('show');
	});
}

function SavePackage(){
	var data = {};
	data.page_id = $("#SetPackage input[name=page_id]").val();
	data.package_id = $("#SetPackage select[name=package_id]").val();
	data.endtime = $("#SetPackage input[name=endtime]").val();
	data.ajax_action = 'save_package';
	loading();
	if(data.endtime==''){
		noticeMsg('Message System', 'Vui lòng nhập ngày hết hạn.', 'error');
		$("#SetPackage input[name=endtime]").focus();
		$("#SetPackage").modal('hide');
		endloading();
		return false;
	}
	
	$.post('?mod=pages&site=index', data).done(function(e){
		var rt = JSON.parse(e);
		noticeMsg('Message System', 'Cập nhật thông tin thành công.', 'success');
		setTimeout(function(){
			location.reload();
		}, 500);
	});
}

</script>
{/literal}
