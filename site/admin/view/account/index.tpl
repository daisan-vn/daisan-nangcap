<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Quản lý tài khoản quản trị
			</h1>
		</div>
		<div class="col-md-4 text-right">
			<button type="button" class="btn btn-primary" onclick="LoadForm(0);">
				<i class="fa fa-plus fa-fw"></i> Thêm mới
			</button>
		</div>
	</div>
</div>


<div class="row">
	<div class="col-md-8">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="key" placeholder="Từ khóa..." value="{$out.key|default:''}">
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
	</div>
	<div class="col-md-4">
	    <div class="form-group form-inline text-right">
	        <select class="left form-control" name="bulk1">
	            <option value="">Chọn tác vụ</option>
	            <option value="0">Xóa</option>
	            <option value="1">Kích hoạt</option>
	            <option value="2">Hủy kích hoạt</option>
	        </select>
	        <button id="search_btn" type="button" class="btn btn-default" onclick="BulkAction(1);">Áp dụng</button>
        </div>
	</div>
</div>

<div class="table-responsive">
	<table
		class="table table-bordered table-hover table-striped hls_list_table">
		<thead>
			<tr>
				<th class="text-center" style="width: 3%"><input type="checkbox" class="SelectAllRows"></th>
				<th>Tài khoản</th>
				<th>Họ tên</th>
				<th>Thể loại</th>
				<th class="">Cập nhật</th>
				<th class="text-center">Trạng thái</th>
				<th class="text-right" width="150"></th>
			</tr>
		</thead>
		<tbody>
			{if $result neq NULL} {foreach from=$result item=data}
			<tr id="field{$data.id}">
				<td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
				<td class="field_name">{$data.username}</td>
				<td>{$data.name}</td>
				<td>{$data.type}</td>
				<td class="">{$data.created|date_format:'%d-%m-%Y'}</td>
				<td class="text-center" id="stt{$data.id}">{$data.status}</td>
				<td class="text-right">
					<button type="button" class="btn btn-default btn-xs" onclick="LoadDataContent({$data.id});">
						<i class="fa fa-warning fa-fw"></i>
					</button>
					<button type="button" class="btn btn-default btn-xs" onclick="LoadForm({$data.id});">
						<i class="fa fa-pencil fa-fw"></i>
					</button>
					<button type="button" class="btn btn-default btn-xs" onclick="ConfirmDelete({$data.id}, 'useradmin', 'user');">
						<i class="fa fa-trash fa-fw"></i>
					</button>
				</td>
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


<div class="modal fade" tabindex="-1" id="UpdateFrom">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
				<h4 class="modal-title">Tài khoản quản trị</h4>
			</div>
			<div class="modal-body">
				<div class="form-horizontal">
					<div class="form-group row-small">
						<div class="col-md-12 col-sm-12 col-xs-12">
							<input type="hidden" name="id">
						</div>
					</div>
					<div class="form-group row-small">
						<label class="control-label col-md-3">Tên người dùng</label>
						<div class="col-md-6">
							<input type="text" name="name" required="required"
								class="form-control" placeholder="Name...">
						</div>
					</div>
					<div class="form-group row-small">
						<label class="control-label col-md-3">Tài khoản</label>
						<div class="col-md-6">
							<input type="text" name="username" class="form-control"
								placeholder="Account...">
						</div>
					</div>
					<div class="form-group row-small">
						<label class="control-label col-md-3">Mật khẩu</label>
						<div class="col-md-6">
							<input type="text" name="password" class="form-control">
						</div>
					</div>
					<div class="form-group row-small">
						<label class="control-label col-md-3">Thể loại</label>
						<div class="col-md-6 col-sm-9 col-xs-12">
							<select class="form-control" name="type"></select>
						</div>
					</div>
					<div class="form-group row-small">
						<label class="control-label col-md-3">Level</label>
						<div class="col-md-4 col-sm-6 col-xs-12">
							<select class="form-control" name="level"></select>
						</div>
					</div>
					<div class="form-group row-small">
						<label class="control-label col-md-3">Trạng thái</label>
						<div class="col-md-9 col-sm-9 col-xs-12">
							<div class="checkbox">
								<label> <input type="checkbox" name="status" value="1">
									Kích hoạt/ khóa người dùng này
								</label>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
				<button type="button" class="btn btn-primary" onclick="SaveForm();">Lưu thông tin</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<!-- Modal Content Item -->
<div class="modal fade" id="ContentModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<form action="" method="post">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Phân quyền cho người dùng</h4>
				</div>
				<div class="modal-body form-inline form"></div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
					<button type="submit" class="btn btn-primary" name="savePermission">Lưu thông tin</button>
				</div>
			</form>
		</div>
	</div>
</div>

{literal}
<script>
function LoadForm(id) {
	$("#UpdateFrom input[type=text]").val('');
	loading();
	$.post("?mod=account&site=index", {'action':'load_user', 'id':id}).done(function(data) {
		var data = JSON.parse(data);
		console.log(data);
		if (data.id == undefined) {
			$("#UpdateFrom input[name=id]").val(0);
			$("#UpdateFrom input[name=status]").prop('checked', true);
			$("#UpdateFrom input[name=username]").removeAttr("disabled","disabled");
		} else {
			$("#UpdateFrom input[name=id]").val(data.id);
			$("#UpdateFrom input[name=name]").val(data.name);
			$("#UpdateFrom input[name=username]").val(data.username);
			$("#UpdateFrom input[name=username]").attr("disabled","disabled");
			if (data.status=='1') $("#UpdateFrom input[name=status]").prop('checked', true);
			else $("#UpdateFrom input[name=status]").prop('checked', false);
		}
		$("#UpdateFrom select[name=level]").html(data.select_level);
		$("#UpdateFrom select[name=type]").html(data.select_type);
		$("#UpdateFrom").modal('show');
		endloading();
	});
}

function SaveForm(){
	var Data = {};
	Data['id'] = $("#UpdateFrom input[name=id]").val();
	Data['name'] = $("#UpdateFrom input[name=name]").val();
	Data['username'] = $("#UpdateFrom input[name=username]").val();
	Data['password'] = $("#UpdateFrom input[name=password]").val();
	Data['level'] = $("#UpdateFrom select[name=level]").val();
	Data['type'] = $("#UpdateFrom select[name=type]").val();
	Data['status'] = $("#UpdateFrom input[name=status]").prop("checked") ? 1 : 0;
	console.log(Data);
	//return false;
	if(Data['name']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập tên quản trị viên', 'error');
		$('#UpdateFrom input[name=name]').focus();
		return false;
	}else if(Data['username']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập tài khoản quản trị viên', 'error');
		$('#UpdateFrom input[name=username]').focus();
		return false;
	}else{
		loading();
		Data['action'] = 'save_useradmin';
		$.post("?mod=account&site=index", Data).done(function(e){
			var data = JSON.parse(e);
			if(data.code == 1){
				noticeMsg('Thông báo', data.msg, 'success');
				$("#UpdateFrom").modal('hide');
				setTimeout(function(){
					window.location.reload();
				}, 2000);
			}else{
				noticeMsg('Thông báo', data.msg, 'error');
				endloading();
			}
		});
	}
}

function LoadDataContent(id){
	$.post("?mod=account&site=load_user_permission", {'id':id} )
	.done(function(data){
		$("#ContentModal .modal-body").html(data);
		$("#ContentModal").modal('show');
	});
}


function filter(){
    var key = $.trim($("#key").val());
    var url = "?mod=account&site=index";
    if(key!='') url = url + "&key=" + key;
    window.location.href = url;
}

</script>
{/literal}
