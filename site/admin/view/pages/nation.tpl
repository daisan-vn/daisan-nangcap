<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Hệ thống Quốc Gia</h1>
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
            <th></th>
            <th>Tiêu đề</th>   
            <th class="text-right">Khởi tạo</th>
            <th class="text-center">TT</th>
            <th class="text-right" width="100"></th>
        </tr>
        </thead>
        <tbody>
        {if $result neq NULL}
            {foreach from=$result item=data}
                <tr id="field{$data.Id}">
                    <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.Id}"></td>
                    <td width="100"><img src="{$data.Logo}" width="100%"></td>
                    <td class="field_name">{$data.Name}</td>  
                    <td class="text-right">{$data.Created|date_format:'%H:%M %d-%m-%Y'}</td>
                    <td class="text-center" id="stt{$data.Id}">{$data.Status}</td>
                    <td class="text-right" style="min-width:88px">
                        <button class="btn btn-default btn-xs" onclick="LoadForm({$data.Id});"><i class="fa fa-pencil fa-fw"></i></button>
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('pages', {$data.Id}, 'ajax_delete_nation');"><i class="fa fa-trash fa-fw"></i></button>
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
                <h4 class="modal-title" id="myModalLabel">Thêm mới quốc gia</h4>
            </div>
            <div class="modal-body">
            	<input type="hidden" name="id">
            	<div class="row row-sm mb-3">
					<label class="col-sm-3">&nbsp;</label>
					<div class="col-md-9">
					<img src="" id="ShowBanner">
					</div>
				</div>
				<div class="row row-sm mb-3">
					<label class="col-sm-3">Logo</label>
					<div class="col-md-9">
						<input type="file" id="UploadBanner" onchange="loadImg(this, '#ShowBanner', '#banner');">
						<input type="hidden" name="banner" id="banner">
						<small class="form-text text-muted"> Kích thước file tối đa 5Mb.</small>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3">Quốc gia</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="name">
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
	var data = {};
	data.id = id;
	data.ajax_action = 'load_nation';
	$.post('?mod=pages&site=nation', data).done(function(e){
		$("#Form input[name=id]").val(id);
		var rt = JSON.parse(e);
		$("#Form input[name=name]").val(rt.Name);
		$("#Form textarea[name=description]").val(rt.Description);
		$('#Form #ShowBanner').attr('src', rt.banner);
		$("#Form").modal('show');
	});
}

function SaveForm(){
	var data = {};
	data.id = $("#Form input[name=id]").val();
	data.name = $("#Form input[name=name]").val();
	data.description = $("#Form textarea[name=description]").val();
	data.banner = $("#Form input[name=banner]").val();
	data.ajax_action = 'save_nation';
	
	if(data.name.length < 3){
		noticeMsg('Message System', 'Vui lòng nhập từ khóa tối thiểu 3 ký tự.', 'error');
		$("#Form input[name=name]").focus();
		return false;
	}
	
	$.post('?mod=pages&site=nation', data).done(function(e){
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
            if(this.width/this.height>2 || this.width/this.height<0.5){
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
            if(this.width/this.height>5 || this.width/this.height<0.2){
            	noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp, vui lòng chọn lại.', 'error');
            	$(obj).val('');
            	$(imgShow).attr('src', arg.noimg);
            	$(inputContent).val('');
            	return false;
            }else{
        		var reader = new FileReader();
        		reader.onload = function(e) {
        			$(imgShow).attr('src', e.target.result);
        			$(inputContent).val(e.target.result);
        		}
        		reader.readAsDataURL(fileImg);
            }
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
    else if (bulk == 1) BulkActive('nations', 1);
    else if (bulk == 2) BulkActive('nations', 2);
}
</script>
{/literal}
