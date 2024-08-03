<div class="card-header">
	<h3>Đơn đặt hàng</h3>
</div>

<div class="card-body">
	
	<p>Danh sách đơn đặt hàng tới gian hàng, bạn có thể sử dụng bộ lọc để tìm kiếm đơn hàng.</p>


	<div class="form-inline mb-3">
		<div class="form-group">
			<input type="text" id="filter_key" class="form-control" placeholder="Search" value="{$out.key}">
		</div>
		<div class="form-group mx-sm-2">
			<select id="status" class="form-control">
				{$out.select_status}
			</select>
		</div>
		<button type="button" class="btn btn-primary" onclick="filter();"><i class="fa fa-fw fa-search"></i> Search</button>
	</div>
	<table class="table table-bordered">
		<tr>
		    <th>ID</th>
			<th>Đơn hàng</th>
			<th>Thông tin giao hàng</th>
			<th>Thông tin nhà bán</th>
			<th>Cập nhật</th>
			<th class="text-right">Trạng thái</th>
			<th></th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
		    <td>{$data.id}</td>
			<td>
				<p class="mb-1 text-bold">{$data.code}</p>
				<p class="mb-0">{$data.totalmoney|number_format}đ</p>
			</td>
			<td>
				<p class="mb-1">{$data.customer}</p>
				<small><i class="fa fa-phone fa-flip-horizontal"></i> {$data.phone}</small>
				<small class="ml-2"><i class="fa fa-map-marker"></i> {$data.address}</small>
				{if $data.description ne NULL}<div class="mt-1">Mô tả: {$data.description}</div>{/if}
			</td>
			<td>
				<p>	<a class="btn btn-success btn-xs" href="{$data.url_seller}" title="Login"><i
					class="fa fa-sign-in fa-fw"></i>Đăng nhập vào gian hàng</a></p>
				<p class="mb-1">{$data.page_name}</p>
				<small><i class="fa fa-phone fa-flip-horizontal"></i> {$data.page_phone}</small>
				<small class="ml-2"><i class="fa fa-map-marker"></i> {$data.page_address}</small>
			</td>
			<td>
				<p class="mb-1">{$data.updated|date_format:"%H:%M %d-%m-%Y"}</p>
				<small><i class="fa fa-clock-o"></i> {$data.created|date_format:"%H:%M %d-%m-%Y"}</small>
			</td>
			<td class="text-right">{$data.status_btn}</td>
			<td class="text-right">
				{if $data.status eq 0 or $data.status eq 1}
				<button type="button" class="btn btn-light btn-sm" onclick="LoadForm({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
				{/if}
				<button type="button" class="btn btn-light btn-sm" onclick="LoadDetail({$data.id});"><i class="fa fa-search-plus fa-flip-horizontal fa-fw"></i></button>
			</td>
		</tr>
		{/foreach}
	</table>

	<nav aria-label="Page navigation example">
		{$paging}
	</nav>
</div>


<div class="modal fade" tabindex="-1" id="LoadDetail">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Chi tiết đơn hàng</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" tabindex="-1" id="LoadForm">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Cập nhật thông tin</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">

				<input type="hidden" value="" name="id"> 
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Họ tên</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="customer">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Điện thoại</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="phone">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Email</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="email">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Địa chỉ</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="address">
					</div>
				</div>
				<div class="form-group">
					<label>Mô tả thêm</label> 
					<textarea rows="4" class="form-control" name="description"></textarea>
					<small class="form-text text-muted">Nhập những lưu ý đặc biệt cho đơn hàng của bạn.</small>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="SaveForm();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>


<script type="text/javascript">
function filter(){
	var key = $("#filter_key").val();
	var status = $("#status").val();
	var url = "?mod=product&site=order";
	if(key!='') url = url+"&key="+key;
	if(status!=-1) url = url+"&status="+status;
	location.href =  url;
}

function LoadDetail(id){
	var data = {};
	data['id'] = id;
	loading();
	$.post('?mod=product&site=order_detail', data).done(function(e){
		$("#LoadDetail .modal-body").html(e);
		$("#LoadDetail").modal('show');
		endloading();
	});
}

function LoadForm(id){
	var data = {};
	data['id'] = id;
	data['ajax_action'] = 'load_content';
	loading();
	$.post('?mod=product&site=order', data).done(function(e){
		var data = JSON.parse(e);
		$("#LoadForm input[name=id]").val(data.id);
		$("#LoadForm input[name=customer]").val(data.customer);
		$("#LoadForm input[name=phone]").val(data.phone);
		$("#LoadForm input[name=email]").val(data.email);
		$("#LoadForm input[name=address]").val(data.address);
		$("#LoadForm textarea[name=description]").val(data.description);
		$("#LoadForm").modal('show');
		endloading();
	});
}

function SaveForm(){
	var data = {};
	data['id'] = $("#LoadForm input[name=id]").val();
	data['customer'] = $("#LoadForm input[name=customer]").val();
	data['phone'] = $("#LoadForm input[name=phone]").val();
	data['email'] = $("#LoadForm input[name=email]").val();
	data['address'] = $("#LoadForm input[name=address]").val();
	data['description'] = $("#LoadForm textarea[name=description]").val();
	data['ajax_action'] = 'save_content';
	loading();
	$.post('?mod=product&site=order', data).done(function(e){
		noticeMsg('System Message', 'Cập nhật đơn hàng thành công.');
		setTimeout(function(){
			location.reload();
		}, 2000);
	});
}

function ChangeStatus(id, status){
	var data = {};
	data['id'] = id;
	data['status'] = status;
	data['ajax_action'] = 'change_status';
	loading();
	$.post('?mod=product&site=order', data).done(function(e){
		data = JSON.parse(e);
		noticeMsg('System Message', data.msg);
		setTimeout(function(){
			location.reload();
		}, 2000);
	});
}

</script>