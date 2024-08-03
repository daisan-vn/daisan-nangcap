<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Sự kiện khuyến mại</h1>
		</div>
		<div class="col-md-4 text-right">
			<button class="btn btn-primary" onclick="LoadForm(0);"><i class="fa fa-plus fa-fw"></i> Thêm Mới</button>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-8">
	  <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_keyword}">
	        <select class="left form-control" id="event">
	        	<option value="-1">Tất cả danh mục</option>
	        	{$out.filter_category}
	        </select>
	        <select class="left form-control" id="status">{$out.filter_status}</select>
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
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
            <th>Image</th>
            <th>Tiêu đề</th>
            <th class="text-right">Bắt đầu</th>
            <th class="text-right">Kết thúc</th>
            <th class="text-right">Khởi tạo</th>
            <th class="text-center">Sắp xếp</th>
            <th class="text-center">TT</th>
            <th class="text-right" width="100"></th>
        </tr>
        </thead>
        <tbody>
        {if $result neq NULL}
            {foreach from=$result item=data}
                <tr id="field{$data.id}">
                    <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
                    <td width="100"><img src="{$data.avatar}" width="100%"></td>
                    <td class="field_name">{$data.name}
                    <br><span class="text-small"><i class="fa fa-tag"></i><a href="javascript:void(0);" onclick="ChangeCategory({$data.id});"> {$data.category|default:'Chưa chọn mục'} <i class="fa fa-pencil"></i></a></span>
                    </td>
                    <td class="text-right">{$data.date_start|date_format:'%d-%m-%Y'}</td>
                    <td class="text-right">{$data.date_finish|date_format:'%d-%m-%Y'}</td>
                    <td class="text-right">{$data.created|date_format:'%H:%M %d-%m-%Y'}</td>
                    <td><input class="form-control sort_input" type="number" name="sort" value="{$data.sort}" min="0" max="9999" oninput="sortItem('events', {$data.id}, this.value);" /></td>
                    <td class="text-center" id="stt{$data.id}">{$data.status}</td>
                    <td class="text-right" style="min-width:88px">
                        <button class="btn btn-default btn-xs" onclick="LoadForm({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('pages', {$data.id}, 'ajax_delete_package');"><i class="fa fa-trash fa-fw"></i></button>
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
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Sự kiện khuyến mại</h4>
            </div>
            <div class="modal-body">
            	<input type="hidden" name="id">
            	
            	<div class="form-group">
					<img src="" id="ShowBanner" width="100%">
				</div>
				<div class="row row-sm mb-3">
					<label class="col-sm-3">Ảnh banner</label>
					<div class="col-md-9">
						<input type="file" id="UploadBanner" onchange="loadImg(this, '#ShowBanner', '#banner');">
						<input type="hidden" name="banner" id="banner">
						<small class="form-text text-muted"> Kích thước file tối đa 5Mb.</small>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">Sự kiện</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="name">
					</div>
				</div>
				
				<div class="row row-sm mb-3">
					<div class="col-md-3">
						<span class="border d-block">
							<img src="" id="ShowImg" width="100%">
						</span>
					</div>
					<div class="col-md-9">
						<input type="file" id="UploadImg" onchange="LoadImage(this);">
						<input type="hidden" name="image">
						<small class="form-text text-muted"> Kích thước file tối đa 200Mb, hỗ trợ định dạng jpg, png.</small>
						<small class="form-text text-muted"> Tỉ lệ ảnh phù hợp là 3x2. Nên để kích thước 600x400 pixcel.</small>
					</div>
				</div>
				<hr>
				<div class="form-group row">
					<label class="col-sm-3">Url</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="url">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">Mô tả thêm</label>
					<div class="col-sm-9">
						<textarea class="form-control" rows="4" name="description"></textarea>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">Bắt đầu</label>
					<div class="col-sm-6">
						<input type="text" class="form-control datepicker" name="date_start">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">Kết thúc</label>
					<div class="col-sm-6">
						<input type="text" class="form-control datepicker" name="date_finish">
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

<div class="modal fade" id="Category">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">danh mục</h4>
            </div>
            <div class="modal-body">
            	<input type="hidden" name="event_id">
				<div class="form-group">
					<label>Lựa chọn danh mục</label> 
					<select name="taxonomy_id" class="form-control chosen"></select>
				</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-success" onclick="ChangeCategory(0, 'save');">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
$(".datepicker").datepicker();

function filter(){
    var key = $.trim($("#keyword").val());
    var status=$("#status").val();
    var event = $("#event").val();
    var url = "?mod=event&site=index";
    if(event!=-1) url = url+"&event_id="+event;
    if(status!=-1) url = url+"&status="+status;
    if(key!='') url = url+"&key="+key;
    window.location.href = url;
}
function ChangeCategory(event_id, type){
	if(type=='save'){
		var data = {};
		data.event_id = $('#Category input[name=event_id]').val();
		data.taxonomy_id = $('#Category select[name=taxonomy_id]').val();
		data.ajax_action = 'save_category';
		loading();
		$.post('?mod=event&site=index', data).done(function(e){
			$('#Category').modal('hide');
			location.reload();
			endloading();
		});
	}else{
		var data = {};
		data.event_id = event_id;
		data.ajax_action = 'load_category';
		loading();
		$.post('?mod=event&site=index', data).done(function(e){
			$('#Category input[name=event_id]').val(event_id);
			$('#Category select[name=taxonomy_id]').html(e);
			$('#Category .chosen').trigger("chosen:updated");
			$("#Category .chosen-container").css("width", "100%");
			$('#Category').modal('show');
			endloading();
		});
	}
}
function LoadForm(id){
	var data = {};
	data.id = id;
	data.ajax_action = 'load_event';
	$.post('?mod=event&site=index', data).done(function(e){
		$("#Form input[name=id]").val(id);
		var rt = JSON.parse(e);
		$("#Form input[name=name]").val(rt.name);
		$("#Form input[name=price]").val(rt.price);
		$("#Form textarea[name=description]").val(rt.description);
		$("#Form input[name=date_start]").val(rt.date_start);
		$("#Form input[name=date_finish]").val(rt.date_finish);
		$("#Form input[name=sort]").val(rt.sort);
		$('#Form #ShowImg').attr('src', rt.avatar);
		$('#Form #ShowBanner').attr('src', rt.banner);
		$('#Form input[name=url]').val(rt.url);
		$("#Form").modal('show');
	});
}

function SaveForm(){
	var data = {};
	data.id = $("#Form input[name=id]").val();
	data.name = $("#Form input[name=name]").val();
	data.description = $("#Form textarea[name=description]").val();
	data.date_start = $("#Form input[name=date_start]").val();
	data.date_finish = $("#Form input[name=date_finish]").val();
	data.sort = $("#Form input[name=sort]").val();
	data.image = $("#Form input[name=image]").val();
	data.banner = $("#Form input[name=banner]").val();
	data.url = $("#Form input[name=url]").val();
	data.ajax_action = 'save_event';
	
	if(data.name.length < 3){
		noticeMsg('Message System', 'Vui lòng nhập từ khóa tối thiểu 3 ký tự.', 'error');
		$("#Form input[name=name]").focus();
		return false;
	}
	
	$.post('?mod=event&site=index', data).done(function(e){
		var rt = JSON.parse(e);
		noticeMsg('Message System', 'Cập nhật thông tin thành công.', 'success');
		$("#Form").modal('hide');
		if(data.id==0){
			setTimeout(function(){
				location.reload();
			}, 1000);
		}else $("#field"+data.id+" .field_name").html(data.name);
	});
}

function LoadImage(input) {
	loading();
	if (input.files && input.files[0]) {
		var fileImg = input.files[0];
		var _URL = window.URL || window.webkitURL;
		var img = new Image();
        img.onload = function () {
            if(this.width/this.height>5 || this.width/this.height<0.5){
            	noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp tỉ lệ 1x1, vui lòng chọn lại.', 'error');
            	$(input).val('');
            	$("#Form input[name=image]").val('');
            	$("#ShowImg").attr('src', arg.noimg);
            	return false;
            }else{
        		var reader = new FileReader();
        		reader.onload = function(e) {
        			$("#ShowImg").attr('src', e.target.result);
        			$("#Form input[name=image]").val(e.target.result);
        		}
        		reader.readAsDataURL(fileImg);
            }
        }
        img.src = _URL.createObjectURL(fileImg);
        endloading();
	}
}

function loadImg(obj, imgShow, inputContent) {
	loading();
	if (obj.files && obj.files[0]) {
		var fileImg = obj.files[0];
		var _URL = window.URL || window.webkitURL;
		var img = new Image();
        img.onload = function () {
           /* if(this.width/this.height>5 || this.width/this.height<0.2){
            	noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp, vui lòng chọn lại.', 'error');
            	$(obj).val('');
            	$(imgShow).attr('src', arg.noimg);
            	$(inputContent).val('');
            	return false;
            }else{*/
        		var reader = new FileReader();
        		reader.onload = function(e) {
        			$(imgShow).attr('src', e.target.result);
        			$(inputContent).val(e.target.result);
        		}
        		reader.readAsDataURL(fileImg);
           /* }*/
        }
        img.src = _URL.createObjectURL(fileImg);
        endloading();
        return false;
	}
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
function sortItem(table, id, sort) {
	$('#in_progress').show();
	$('input[name=sort]').keyup(function () {
		var sort_val = $(this).val();
		var positive_num = sort_val.match(/^\d+$/);
		if (positive_num === null) {
			$(this).val(0);
			sortItem(table, id, 0);
		}
	});
	$.post("?mod=event&site=ajax_sort", {'table': table, 'id': id, 'sort': sort}).done(function(){
		console.log(id);
		$('#in_progress').hide();
	});
}
</script>
{/literal}