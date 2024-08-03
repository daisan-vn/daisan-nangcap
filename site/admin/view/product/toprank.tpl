<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý sản phẩm showcase</h1>
		</div>
		<div class="col-md-4 text-right">
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-9">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_keyword}">
	        <input type="hidden" id="page_id" value="{$out.page_id}">
	        <select class="left form-control" id="category">
	        	<option value="-1">Tất cả danh mục</option>
	        	{$out.filter_category}
	        </select>
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
	</div>
	<div class="col-md-3">
	    <div class="form-group form-inline text-right">
	        <select class="left form-control" name="bulk1">
	            <option value="">Chọn tác vụ</option>
	            <option value="0">Xóa showcase</option>
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
            <th>Sắp xếp</th>
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
                    			<img class="img" id="img{$data.id}" src="{$data.avatar}">
                    		</div>
                    		<div class="col-md-10">
		                        <a href="{$data.url}" class="field_name" target="_blank">{$data.name}</a><br>
		                        <span class="text-small"><i class="fa fa-tags fa-fw"></i> {$data.code}</span> |
		                        <span class="text-small"><i class="fa fa-folder-open-o fa-fw"></i> {$data.category}</span>
                    		</div>
                    	</div>
                    </td>
                    <td>{$data.page}</td>
                    <td>Giá từ {$data.price|number_format}đ</td>
                    <td><input type="number" class="form-control" onchange="UpdateSort({$data.id},this.value);" value="{$data.score|default:0}" style="width: 100px;"></td>
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
	console.log(1);
    var key = $.trim($("#keyword").val());
    var cat = $("#category").val();
    var url = "?mod=product&site=toprank";
    if(cat!=-1) url = url+"&cat="+cat;
    if(key!='') url = url+"&key="+key;
    location.href = url;
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
    else if (bulk == 0) BulkDelete('product', 'ajax_delete_showcase');
}

function UpdateSort(id,v){
	if(v<=0) v=1;
	else if(v>=21) v=20;
	data = {};
	data.id = id;
	data.score = v;
	data.ajax_action = 'update_score';
	loading();
	$.post("?mod=product&site=ajax_handle", data).done(function (rt) {
		rt = JSON.parse(rt);
		if (rt.code == '0'){
			noticeMsg('Thông báo', rt.msg, 'error');
			endloading();
		}else{
			noticeMsg('Thông báo', rt.msg, 'success');
			setTimeout(function () {
				location.reload();
			}, 600);
		}
		
	});

}

</script>
{/literal}