<div class="card rounded-0">
	<div class="card-body">
		
		<h3>Tìm kiếm khách hàng</h3>
		<div class="form-group row row-nm mb-0" id="filter">
			<div class="col-sm-4">
				<input name="key" type="text" class="form-control mb-3" placeholder="Tên, mã, điện thoại hoặc email..." value="{$out.key|default:''}">
			</div>
			<div class="col-sm-3">
				<select name="status" class="form-control mb-3">{$out.select_status}</select>
			</div>
			<div class="col-sm-3">
				<select name="type" class="form-control mb-3">{$out.select_type}</select>
			</div>
			{if $arg.login_role eq 'admin'}
			<div class="col-sm-3">
				<select name="user_id" class="form-control mb-4">{$out.select_user}</select>
			</div>
			{/if}
			<div class="col-sm-2">
				<button type="button" class="btn btn-success btn-block" onclick="filter();"><i class="fa fa-search"></i> Tìm kiếm</button>
			</div>
		</div>


		<table class="table">
			<tr>
				<th width="5%" class="text-right">STT</th>
				<th width="25%">Doanh nghiệp</th>
				<th width="20%">Liên hệ</th>
				<th width="30%">Nội dung cuộc gọi</th>
				<th width="20%"></th>
			</tr>
			{foreach from=$result key=k item=data}
			<tr>
				<td class="text-right">{$k+1}</td>
				<td>
					<a href="{$data.url}" target="_blank">{$data.name}</a>
					<p class="mb-0"><a href="{$data.website}" target="_blank"><i class="fa fa-globe"></i> {$data.website}</a></p>
				</td>
				<td>
					<p class="mb-1"><i class="fa fa-phone"></i> {$data.phone}</p>
					<p class="mb-0"><a href="mailto:{$data.email}"><i class="fa fa-envelope-o"></i> {$data.email}</a></p>
				</td>
				<td>{$data.content}</td>
				<td class="text-right">
					<a href="tel:{$data.phone}" class="btn btn-primary btn-sm"><i class="fa fa-phone fa-fw"></i></a>
					<a href="sms:{$data.phone}" class="btn btn-primary btn-sm"><i class="fa fa-comment-o fa-fw"></i></a>
					<div class="dropdown d-inline">
						<button class="btn btn-secondary btn-sm dropdown-toggle" type="button"
							id="dropdownMenuButton" data-toggle="dropdown"
							aria-haspopup="true" aria-expanded="false">
							<i class="fa fa-fw fa-cog"></i>
						</button>
						<div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenuButton">
							<a class="dropdown-item" href="javascript:void(0);" onclick="loadCallInfo({$data.id});">Cập nhật cuộc gọi</a> 
							<a class="dropdown-item" href="javascript:void(0);" onclick="loadCustomer({$data.page_id});">Cập nhật khách hàng</a> 
						</div>
					</div>

				</td>
			</tr>
			{/foreach}
		</table>
		
		<hr>
		{$paging}
	</div>
</div>

<div class="modal fade" tabindex="-1" id="CallInfo">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Cập nhật thông tin cuộc gọi</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group row row-sm">
					<label class="col-sm-4 col-form-label">Trạng thái cuộc gọi</label> 
					<div class="col-sm-8">
						<input type="hidden" value="" name="id">
						<select name="status" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row row-sm">
					<label class="col-sm-4 col-form-label">Trạng thái khách hàng</label> 
					<div class="col-sm-8">
						<select name="type" class="form-control"></select>
					</div>
				</div>
				<div class="form-group">
					<label class="col-form-label">Mô tả chi tiết cuộc gọi</label>
					<textarea class="form-control" name="content" rows="8"></textarea>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="saveCallInfo();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" tabindex="-1" id="Customer">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Cập nhật thông tin khách hàng</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Tên doanh nghiệp/ cửa hàng</label> 
					<div class="">
						<input type="hidden" value="" name="id"> 
						<input type="text" class="form-control" name="name"> 
					</div>
				</div>
				<div class="form-group">
					<label>Điện thoại</label> 
					<div class="">
						<input type="text" class="form-control" name="phone"> 
					</div>
				</div>
				<div class="form-group">
					<label>Email</label> 
					<div class="">
						<input type="text" class="form-control" name="email"> 
					</div>
				</div>
				<div class="form-group">
					<label>Địa chỉ</label> 
					<div class="">
						<input type="text" class="form-control" name="address"> 
					</div>
				</div>
			
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="saveCustomer();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>


{literal}
<script type="text/javascript">
function loadCallInfo(id){
	var data = {};
	data.id = id;
	data.action = 'load_callinfo';
	$.post('?site=ajax_form', data).done(function(e){
		var rt = JSON.parse(e);
		$('#CallInfo input[name=id]').val(id);
		$("#CallInfo select[name=type]").html(rt.select_type);
		$("#CallInfo select[name=status]").html(rt.select_status);
		$('#CallInfo textarea[name=content]').val(rt.content);
		$('#CallInfo').modal('show');
	});
}

function saveCallInfo(){
	var data = {};
	data.id = $('#CallInfo input[name=id]').val();
	data.type = $('#CallInfo select[name=type]').val();
	data.status = $('#CallInfo select[name=status]').val();
	data.content = $('#CallInfo textarea[name=content]').val();
	data.action = 'save_callinfo';
	if(data.type==1 && data.content.length < 30){
		noticeMsg('Thông báo', 'Vui lòng nhập nội dung cuộc gọi tối thiểu 30 ký tự');
		$('#CallInfo textarea[name=description]').focus();
		return false;
	}
	loading();
	$.post('?site=ajax_form', data).done(function(e){
		noticeMsg('Thông báo', 'Lưu thông tin cuộc gọi thành công', 'success');
		setTimeout(function(){
			location.reload();
		}, 1200);
	});
}

function loadCustomer(id){
	var data = {};
	data.id = id;
	data.action = 'load_customer';
	$.post('?site=ajax_form', data).done(function(e){
		var rt = JSON.parse(e);
		$('#Customer input[name=id]').val(id);
		$('#Customer input[name=name]').val(rt.name);
		$('#Customer input[name=phone]').val(rt.phone);
		$('#Customer input[name=email]').val(rt.email);
		$('#Customer input[name=address]').val(rt.address);
		$('#Customer').modal('show');
	});
}

function saveCustomer(){
	var data = {};
	data.id = $('#Customer input[name=id]').val();
	data.name = $('#Customer input[name=name]').val();
	data.phone = $('#Customer input[name=phone]').val();
	data.email = $('#Customer input[name=email]').val();
	data.address = $('#Customer input[name=address]').val();
	data.action = 'save_customer';
	if(data.name.length < 3){
		noticeMsg('Thông báo', 'Vui lòng nhập tên doanh nghiệp');
		$('#Customer input[name=name]').focus();
		return false;
	}else if(data.phone.length < 3){
		noticeMsg('Thông báo', 'Vui lòng nhập số điện thoại');
		$('#Customer input[name=phone]').focus();
		return false;
	}else if(data.email.length < 3){
		noticeMsg('Thông báo', 'Vui lòng nhập email');
		$('#Customer input[name=email]').focus();
		return false;
	}else if(data.address.length < 3){
		noticeMsg('Thông báo', 'Vui lòng nhập địa chỉ');
		$('#Customer input[name=address]').focus();
		return false;
	}
	loading();
	$.post('?site=ajax_form', data).done(function(e){
		noticeMsg('Thông báo', 'Lưu thông tin cuộc gọi thành công', 'success');
		setTimeout(function(){
			location.reload();
		}, 1200);
	});
}

function filter(){
	var type = $("#filter select[name=type]").val();
	var status = $("#filter select[name=status]").val();
	var user_id = $("#filter select[name=user_id]").val();
	var key = $("#filter input[name=key]").val();
	
	var url = "./?site=index";
	if(user_id&&user_id!=0) url = url+"&user_id="+user_id;
	if(type&&type!=0) url = url+"&type="+type;
	if(status&&status!=0) url = url+"&status="+status;
	if(key) url = url+"&key="+key;
	window.location.href = url;
	return false;
}

</script>
{/literal}
