<p id="in_progress" class="pull-right"><i class="fa fa-circle-o-notch fa-spin fa-fw"></i> Đang xử lí</p>
<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý danh sách hình ảnh trên website</h1>
		</div>
		<div class="col-md-4 text-right">
	        <div class="btn-group">
	            <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	                <i class="fa fa-plus fa-fw"></i> Thêm mới ảnh &nbsp;<span class="caret"></span>
	            </button>
	            <ul class="dropdown-menu min127">
	                {foreach from=$out.a_category key=k item=cate}
	                <li><a href="javascript:void(0);" onclick="LoadMedia('SetImgRls', {$k});">{$cate}</a></li>
	                {/foreach}
	            </ul>
	        </div>
	        <input type="hidden" id="DataImgCate" name="img_cate">
	        <input type="hidden" id="PostIdUpdate">
		</div>
	</div>
</div>
<div class="h_content">
	<div class="form-group form-inline">
        <select class="left form-control" id="category" title="Danh mục">{$out.filter_category}</select>
        <select class="left form-control" id="position" title="Danh mục">{$out.filter_position}</select>
        <select class="left form-control" id="display" title="Danh mục">{$out.filter_display}</select>
	    <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
    </div>
</div>


<div class="table-responsive">
    <table class="table table-bordered table-hover table-striped hls_list_table">
        <thead>
            <tr>
                <th class="text-center" width="120">Hình ảnh</th>
                <th width="45%">Nội dung</th>
                <th>Danh mục</th>
                <th>Vị trí</th>
                <th>Sắp xếp</th>
                <th class="text-center">TT</th>
                <th width="120"></th>
            </tr>
        </thead>
        <tbody id="body_img">
        	{if $result neq NULL}
            {foreach from=$result item=data}
                <tr id="field{$data.id}">
                    <td class="text-center">
                    	<img class="imgrls" id="img{$data.id}" src="{$data.avatar}" onclick="ViewImage('{$data.media_id}', {$data.id});">
                    </td>
                    <td>
                    	{if $data.title}<p>{$data.title}</p>{/if}
                    	{if $data.alias}<p class="text-small"><span><i class="fa fa-link fa-fw"></i> {$data.alias}</span></p>{/if}
                    </td>
                    <td>{$data.taxonomy}</td>
                    <td>{$data.position}</td>
                    <td><input class="form-control sort_input" type="number" name="sort" value="{$data.sort}" min="0" max="9999" oninput="sortItem('posts', {$data.id}, this.value);" /></td>
                    <td class="text-center" id="stt{$data.id}">{$data.status}</td>
                    <td class="text-right">
                        <button type="button" class="btn btn-default btn-xs" onclick="LoadFormImage({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('posts', {$data.id}, 'ajax_delete');"><i class="fa fa-trash fa-fw"></i></button>
                    </td>
                </tr>
            {/foreach}
            {else}
            <tr><td colspan="10">Không tìm thấy mục nào</td></tr>
            {/if}
        </tbody>
    </table>
</div>

<!-- Confirm Delete Modal -->
<div class="modal fade" id="FormImage">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Cập nhật thông tin</h4>
            </div>
            <div class="modal-body">
				<form>
					<div class="form-group">
						<label>Tiêu đề ảnh</label> 
						<input type="text" name="title" class="form-control">
						<input type="hidden" name="id" class="form-control">
					</div>
					<div class="form-group">
						<label>Chèn link cho ảnh</label> 
						<input type="text" name="alias" class="form-control">
					</div>
					<div class="form-group">
						<label>Vị trí</label> 
						<select class="form-control" name="position"></select>
					</div>
					<div class="form-group">
						<label>Chọn trang hiển thị</label> 
						<select class="form-control" name="position"></select>
					</div>
					<div class="form-group">
						<label>Mô tả ảnh</label> 
						<textarea name="description" class="form-control" rows="5"></textarea>
					</div>
				</form>
			</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-success" onclick="SaveImage();">Lưu thông tin</button>
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
                <h4 class="modal-title" id="myModalLabel">Xóa mục này?</h4>
            </div>
            <div class="modal-body">Bạn chắc chắn muốn xóa vĩnh viễn mục này chứ?</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-danger" onclick="DeleteItem();" id="DeleteItem">Xóa</button>
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

<div class="paging">{$paging}</div>
{literal}
<script>
$('#keyword,#category').keypress(function( event ){
    if ( event.which == 13 ) {
        filter();
    }
});

function LoadFormImage(id){
    $.post("?mod=posts&site=images",{
    	'ajax':'load_image',
    	'id':id
    }).done(function (e) {
    	var data = JSON.parse(e);
    	$("#FormImage input[name=id]").val(id);
    	$("#FormImage input[name=alias]").val(data.alias);
    	$("#FormImage input[name=title]").val(data.title);
    	$("#FormImage select[name=position]").html(data.select_position);
    	$("#FormImage textarea[name=description]").val(data.description);
    	$('#FormImage').modal('show');
    });
}

function SaveImage(){
	var id = $("#FormImage input[name=id]").val();
	var alias = $("#FormImage input[name=alias]").val();
	var title = $("#FormImage input[name=title]").val();
	var position = $("#FormImage select[name=position]").val();
	var description = $("#FormImage textarea[name=description]").val();
	$.post("?mod=posts&site=images",{
		'ajax':'update_image',
		'id':id,
		'alias':alias,
		'title':title,
		'position':position,
		'description':description
	}).done(function (e) {
		window.location.reload();
		return false;
	});
}

function ViewImage(media_id, PostId) {
	loading();
    $("#ViewImage .modal-body").load('?mod=media&site=detail',{'media_id':media_id}, function (data) {
        $("#ViewImage").modal('show');
        $('#ImgModalLoading').hide();
        $("#PostIdUpdate").val(PostId);
        $('#ViewImage #BtnChange').attr('onclick', "LoadMedia('ChangeImage');");
        endloading();
    });
    return false;
}

function SetImgRls(media_id) {
    PNotify.removeAll();
    $('#in_progress').show();
    var taxonomy_id = $('#DataImgCate').val();
    $.post("?mod=posts&site=images", {
    	'ajax': 'save_image', 'media_id':media_id, 'taxonomy_id':taxonomy_id
    }).done(function (e) {
    	var data = JSON.parse(e);
        $('#in_progress').hide();
        if (data.msg == 1) {
            noticeMsg('Ảnh đã được thêm', 'Ảnh này đã được thêm vào danh mục mà bạn chọn', 'info');
            return false;
        }
        $('#body_img').prepend(data.inserted);
        $('#LoadMedia').modal('hide');
        LoadFormImage(data.id);
    });
}

function ChangeImage(media_id) {
	loading();
    var id = $('#PostIdUpdate').val();
    $.post("?mod=posts&site=images", {
    	'ajax': 'save_image_update', 'media_id':media_id, 'id':id
    }).done(function (e) {
    	$("#img"+id).attr("src",e);
    	$("#LoadMedia").modal('hide');
    	endloading();
    });
}

function filter(){
	var cat = $("#category").val();
	var position = $("#position").val();
	var display = $("#display").val();
	window.location.href = "?mod=posts&site=images" + "&cat=" + cat + "&position=" + position+ "&display=" + display;
}

</script>
{/literal}