<div class="card-header">
	<h3>Thành viên quản trị của page</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<div class="card" id="UserFilter">
		<div class="card-header"><i class="fa fa-search"></i> Tìm kiếm tài khoản người dùng để thêm vào quản trị</div>
		<div class="card-body">
			<div class="form-group row">
				<div class="col-sm-6">
					<input type="text" class="form-control" onchange="LoadUsers(this.value);" placeholder="Tìm kiếm tài khoản"> 
					<small id="passwordHelpBlock" class="form-text text-muted"> Nhập tên, số điện thoại hoặc email để tìm tài khoản trên hệ thống. </small>
				</div>
			</div>
			<div id="LoadUsers" class="border p-2 d-none"></div>
		</div>
	</div>
		
	<h4 class="mt-5">Danh sách tất cả quản trị viên của page</h4>
	<table class="table">
		<tr>
			<th>Tài khoản</th>
			<th>Quyền quản trị</th>
			<th>Khởi tạo</th>
			<th></th>
		</tr>
		{foreach from=$admin item=data}
		<tr id="FID{$data.id}">
			<td width="40%">
				<div class="row row-sm">
					<div class="col-md-2">
						<img class="img-thumbnail" src="{$data.avatar}" width="100%">
					</div>
					<div class="col-md-10">
						<h6 class="mb-1">{$data.name}</h6>
					</div>
				</div>
			</td>
			<td><i class="fa fa-fw fa-cog"></i> {$data.position}</td>
			<td>{$data.created|date_format:'%H:%M %d-%m-%Y'}</td>
			<td class="text-right">
				{if $data.delete}
				<button type="button" class="btn btn-outline-secondary btn-sm" onclick="SetUser({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
				<button type="button" class="btn btn-outline-secondary btn-sm" onclick="DeleteItem('', {$data.id}, 'setup', 'ajax_delete_admin');"><i class="fa fa-trash fa-fw"></i></button>
				{/if}
			</td>
		</tr>
		{/foreach}
	</table>

</div>

<div class="modal fade" tabindex="-1" id="SetUser">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Cập nhật quản trị viên page</h5>
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
			</div>
			<div class="modal-body">
				<div class="row row-sm">
					<div class="col-md-2"><img src="" class="w-100 img-thumbnail"></div>
					<div class="col-md-10">Người dùng<h5 id="username"></h5></div>
				</div>
				
				<hr>
				<input type="hidden" name="user_id">
				<input type="hidden" name="id"> 
				<div class="form-group row">
					<label class="col-sm-4 col-form-label">Vai trò quản trị</label>
					<div class="col-sm-8">
						<select class="form-control" name="position"></select>
					</div>
				</div>
				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="SaveUserPage();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>


{literal}
<script>
function LoadUsers(key){
	if(key==''){
		noticeMsg('System Message', 'Vui lòng nhập từ khóa.', 'error');
		$("#UserFilter input").focus();
		return false;
	}
	loading();
	$('#LoadUsers').load("?mod=setup&site=load_users", {'key': key}, function(){
		$("input[name=service_id]").val('');
		$("#LoadUsers").removeClass('d-none');
		$("#LoadUsers").addClass('d-block');
		endloading();
	});
}

function SetUser(id){
	var name = $("#User"+id+" small").html();
	var img = $("#User"+id+" img").attr('src');
	$("#SetUser input[name=user_id]").val(id);
	loading();
	$.post('?mod=setup&site=admin', {'ajax_action':'load_pageuser', 'id':id}).done(function(e){
		var data = JSON.parse(e);
		$("#SetUser h5#username").html(data.name+" ("+data.username+")");
		$("#SetUser img").attr('src', data.avatar);
		$("#SetUser select[name=position]").html(data.select_position);
		$("#SetUser input[name=id]").val(data.item_id);
		$("#SetUser").modal('show');
		endloading();
	});
}

function SaveUserPage(){
	var data = {};
	data['id'] = $("#SetUser input[name=id]").val();
	data['user_id'] = $("#SetUser input[name=user_id]").val();
	data['position'] = $("#SetUser select[name=position]").val();
	data['ajax_action'] = 'save_pageuser';
	loading();
	$.post('?mod=setup&site=admin', data).done(function(e){
		$("#SetUser").modal('hide');
		noticeMsg('System Message', 'Lưu thông tin quản trị page thành công.', 'success');
		setTimeout(function(){ location.reload(); }, 2000);
	});

}

</script>
{/literal}