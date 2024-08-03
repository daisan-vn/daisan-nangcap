<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<p id="in_progress" class="pull-right"><i class="fa fa-circle-o-notch fa-spin fa-fw"></i> Đang xử lí</p>
<div class="body-head">
	<h1><i class="fa fa-bars fa-fw"></i> Quản lý ảnh Slider danh mục</h1>
</div>

<div class="row">
	<div class="col-md-8">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="key" placeholder="Từ khóa..." value="{$out.key|default:''}">
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
	</div>
</div>
<div class="table-responsive">
	<table
		class="table table-bordered table-hover table-striped hls_list_table">
		<thead>
			<tr>
				<th class="text-center">Id</th>
				<th>Name</th>
			</tr>
		</thead>
		<tbody>
			{if $result neq NULL} {foreach from=$result item=data}
			<tr id="field{$data.id}">
				<td width="80" class="text-center">{$data.id}</td>
				<td><a href="?mod=slider&site=image&id={$data.id}">{$data.name}</a></td>
			</tr>
			
			{/foreach} {else}
			<tr>
				<td colspan="10">Không có nội dung nào được tìm thấy.</td>
			</tr>
			{/if}
		</tbody>
	</table>
</div>
<div class="paging">{$paging}</div>
<script>
    $('#key,#category').keypress(function( event ){
    if ( event.which == 13 ) filter();
});

function filter(){
    var key = $.trim($("#key").val());
    var url = "?mod=slider&site=index";
    if(key!='') url = url + "&key=" + key;
    window.location.href = url;
}
</script>