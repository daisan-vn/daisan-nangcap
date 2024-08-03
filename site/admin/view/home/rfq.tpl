<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý yêu cầu báo giá</h1>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-9">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_keyword|default:''}">
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
            <th>Số lượng</th>
            <th>Địa điểm</th>
            <th>Giá</th>
            <th>Đăng bởi</th>
            <th>Khởi tạo</th>
            <th class="text-center">TT</th>
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
                    			<img class="img w-100" id="img{$data.id}" src="{$data.avatar}">
                    		</div>
                    		<div class="col-md-10">
		                        <a href="{$data.url}" class="field_name">{$data.title}</a>
                    		</div>
                    	</div>
                    </td>
                    <td>{$data.number} {$data.unit}</td>
                    <td>{$data.location}</td>
                    <td>{$data.price|number_format}đ</td>
                    <td>{$data.user_name}</td>
                    <td>{$data.created|date_format:'%H:%M %d-%m-%Y'}</td>
                    <td class="text-center" id="stt{$data.id}">{$data.status}</td>
                    <td class="text-right">
                        <button type="button" class="btn btn-default btn-xs" onclick="ConfirmDelete({$data.id}, 'rfq');"><i class="fa fa-trash fa-fw"></i></button>
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
function filter(){
    var key = $.trim($("#keyword").val());
    var url = "?mod=pages&site=index";
    if(key!='') url = url+"&key="+key;
    window.location.href = url;
}
</script>
{/literal}
