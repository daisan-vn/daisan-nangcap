<div class="body-head">
	<h1><i class="fa fa-bars fa-fw"></i> Quản lý menu</h1>
</div>
<div class="form-group form-inline">
	<label>Chọn một menu để quản lý </label>
	<select class="left form-control" id="taxonomy_id">{$out.menu}</select>
	<button type="button" class="btn btn-default" onclick="SelectMenu();">Chọn menu</button>
	<label>Hoặc</label>&nbsp;
	<a href="#" data-toggle="modal" data-target="#CreateTaxonomy" onclick="LoadTaxonomy();"><i class="fa fa-plus"></i> Tạo mới menu</a> 
	{if $out.position neq 0}
	&nbsp;|&nbsp;
	<a href="#" data-toggle="modal" data-target="#CreateTaxonomy" onclick="LoadTaxonomy('edit');"><i class="fa fa-pencil"></i> Sửa tên menu</a> 
	&nbsp;|&nbsp;
	<a href="javascript:void(0)" onclick="LoadDeleteItem('menu', {$out.position}, 'ajax_delete_menu');"><i class="fa fa-remove"></i> Xóa menu</a>
	&nbsp;|&nbsp;
	<a href="?mod=menu&site=position"><i class="fa fa-cog"></i> Cấu hình vị trí</a>
	{/if}
</div>
<hr>

<div class="row">
	<div class="col-sm-4">
        <h4 id="form_title">Thêm nội dung menu</h4>
        <hr>
		<form id="MenuForm" enctype="multipart/form-data" method="post" action="">
			<div class="form-group">
				<label>Nguồn nội dung menu</label>
				<input type="hidden" class="form-control" name="id">
				<select class="form-control" name="type" onchange="LoadMenuContent(this.value);">
					{$out.types}
				</select>
			</div>
			<div class="form-group" id="menu_content_input">
				<label>Nội dung</label>
				<input type="text" class="form-control" name="menu_object" value="http://">
			</div>
			<div class="form-group" id="menu_content_select">
				<label>Nội dung</label>
				<select class="form-control chosen-select" name="menu_object" onchange="LoadTitleMenu(this);">
					{$out.pages}
				</select>
			</div>
			<div class="form-group">
				<label>Tiêu đề menu</label>
				<input type="text" class="form-control" name="name">
			</div>
			<div class="form-group">
				<label>Mô tả</label>
				<input type="text" class="form-control" name="title">
			</div>
			<div class="form-group">
				<label>Danh mục cha</label>
				<select class="form-control" name="parent">
					{$out.parent}
				</select>
			</div>
			<hr>
			<button type="button" class="btn btn-primary" onclick="SaveMenu();">Lưu nội dung</button>
            <button class="btn btn-default" type="button" onclick="Reset();">Hủy bỏ</button>
		</form>
	</div>

    <div id="main_data">
		<div class="col-sm-8">
			<h4 id="form_title">Danh sách nội dung menu</h4>
		    <div class="table-responsive">
		        <table id="taxonomy_table" class="table table-bordered table-hover table-striped hls_list_table">
		            <thead>
		            <tr>
		                <th class="text-left">Tên danh mục</th>
		                <th class="text-right">Nội dung</th>
		                <th class="text-center">Sắp xếp</th>
		                <th class="text-center">Tác động</th>
		            </tr>
		            </thead>
		            <tbody>
		            <tr><td class="text-center" colspan="10">Danh sách menu</td></tr>
		            </tbody>
		            <tfoot>
		            <tr>
		                <th class="text-left">Tên danh mục</th>
		                <th class="text-right">Nội dung</th>
		                <th class="text-center">Sắp xếp</th>
		                <th class="text-center">Tác động</th>
		            </tr>
		            </tfoot>
		        </table>
		    </div>
		</div>
    
    </div>
</div>

<div class="modal fade" id="CreateTaxonomy">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Thêm menu tùy chỉnh mới</h4>
            </div>
            <div class="form-horizontal">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-md-2">Tên menu</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="name" placeholder="Nhập vào tên menu">
                            <input type="hidden" class="form-control" value="" name="taxonomy_id">
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-info" onclick="SaveTaxonomy();">Lưu menu</button>
            </div>
        </div>
    </div>
</div>

<!-- Confirm Delete Modal -->
<div class="modal fade" id="ConfirmDelete">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Xác nhận xóa</h4>
            </div>
            <div class="modal-body">Bạn chắc chắn muốn xóa mục này chứ?</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-danger" onclick="DeleteItem();" id="DeleteItem">Xóa</button>
            </div>
        </div>
    </div>
</div>

<input type="hidden" value="{$out.position|default:0}" id="position">
<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>

{literal}
<script>
var position = $("#position").val();

$(window).ready(function(){
	$(".chosen-select").chosen({disable_search_threshold: 5});
	$("#main_data").load("?mod=menu&site=ajax_load_menu_content&menu="+position);
	$("#menu_content_select").show();
	$("#menu_content_input").hide();
});

function LoadTaxonomy(type){
	if(type=='edit'){
		var optionSelected = $("#taxonomy_id").find("option:selected");
	    var valueSelected  = optionSelected.val();
	    var textSelected   = optionSelected.text();
		$('#CreateTaxonomy input[name=name]').val(textSelected);
		$('#CreateTaxonomy input[name=taxonomy_id]').val(valueSelected);
	}else{
		$('#CreateTaxonomy input[name=name]').val('');
		$('#CreateTaxonomy input[name=taxonomy_id]').val('');
	}
}

function SaveTaxonomy() {
    var name = $("#CreateTaxonomy input[name=name]").val();
    var taxonomy_id = $("#CreateTaxonomy input[name=taxonomy_id]").val();
    $.post("?mod=menu&site=ajax_handle", {
    	'ajax': 'save_taxonomy_menu', 'name':name, 'taxonomy_id': taxonomy_id
    }).done(function (data) {
        $("#CreateTaxonomy").modal('hide');
        var url = "?mod=menu&site=index&menuObj=" + data;
        window.location.href = url;
        return false;
    });
}

function SelectMenu(){
	var taxonomy_id = $("#taxonomy_id").val();
    var url = "?mod=menu&site=index&menuObj=" + taxonomy_id;
    window.location.href = url;
    return false;
}

function LoadMenuContent(type){
	$('#in_progress').show();
	DisableForm("#MenuForm");
	if(type=='custom'){
		$("#menu_content_select").hide();
		$("#menu_content_input").show();
        $('#in_progress').hide();
        EnableForm("#MenuForm");
	}else{
		$("#menu_content_select").show();
		$("#menu_content_input").hide();
	    $.post("?mod=menu&site=ajax_handle", {
	    	'ajax': 'load_menu_object',
	    	'type':type
	    }).done(function (e) {
	        $('select[name=menu_object]').html(e);
	        $('input[name=name]').val('');
	        $('#in_progress').hide();
	        EnableForm("#MenuForm");
	        $(".chosen-select").trigger("chosen:updated");
	        return false;
	    });
	}
}

function LoadTitleMenu(obj){
	var optionSelected = $(obj).find("option:selected");
    var valueSelected  = optionSelected.val();
    var textSelected   = optionSelected.text();
	$('input[name=name]').val(textSelected);
}

function SaveMenu(){
	var name = $('#MenuForm input[name=name]').val();
	var title = $('#MenuForm input[name=title]').val();
	var id = $('#MenuForm input[name=id]').val();
	var type = $('#MenuForm select[name=type]').val();
	var menu_object = $('#MenuForm select[name=menu_object]').val();
	if(type=='custom')
		menu_object = $('#MenuForm input[name=menu_object]').val();
	var parent = $('#MenuForm select[name=parent]').val();
	if(name=='' || type==0 || menu_object==0){
		noticeMsg('Nhập thiếu nội dung', 'Vui lòng nhập đầy đủ các trường', 'info');
		return false;
	}
	
	loading();
    $.post("?mod=menu&site=ajax_handle", {
    	'ajax': 'save_menu_content',
    	'position':position,
    	'name':name,
    	'title':title,
    	'type':type,
    	'menu_object':menu_object,
    	'parent':parent,
    	'id':id
    }).done(function (e) {
    	noticeMsg('Thành công', 'Bạn vừa lưu thành công menu', 'success');
    	LoadDataForForm(0);
    	$("#main_data").load("?mod=menu&site=ajax_load_menu_content&menu="+position);
    	endloading();
    });
}

function SortMenu(id, type) {
    DisableAll('#main_data');
    $('#save_btn').prop('disabled', true);
    $('#in_progress').show();
    $.post("?mod=menu&site=ajax_handle", {
    	'ajax': 'sort_menu_content',
    	'type':type,
    	'id':id,
    	'position':position
    }).done(function (e) {
    	$("#main_data").load("?mod=menu&site=ajax_load_menu_content&menu="+position);
        $('#in_progress').hide();
    });
}

function LoadDataForForm(id) {
	$('#in_progress').show();
	DisableForm("#MenuForm");
	$("tr").removeClass("active");
	$("#field"+id).addClass("active");
    $.post("?mod=menu&site=ajax_handle", {
    	'ajax': 'load_menu_edit',
    	'id':id,
    	'position':position
    }).done(function (e) {
    	var data = JSON.parse(e);
    	console.log(data);
    	if(data.description=='custom'){
    		$("#menu_content_select").hide();
    		$("#menu_content_input").show();
    		$('input[name=menu_object]').val(data.alias);
    	}else{
    		$("#menu_content_select").show();
    		$("#menu_content_input").hide();
        	$('select[name=menu_object]').html(data._object);
    	}
    	$('input[name=name]').val(data.name);
    	$('input[name=title]').val(data.title);
    	$('input[name=id]').val(data.id);
    	$('select[name=type]').html(data._types);
    	$('select[name=parent]').html(data._parent);
        $('#in_progress').hide();
        EnableForm("#MenuForm");
    	$(".chosen-select").trigger("chosen:updated");
    });
}

function Reset(){
	$('#in_progress').show();
    $.post("?mod=menu&site=ajax_handle", {
    	'ajax': 'reset_menu_content',
    	'position':position
    }).done(function (e) {
    	var data = JSON.parse(e);
    	$('input[name=name]').val('');
    	$('input[name=id]').val('');
    	$('select[name=type]').html(data.types);
    	$('select[name=menu_object]').html(data.pages);
    	$('select[name=parent]').html(data.parent);
        $('#in_progress').hide();
    });

}

</script>
{/literal}