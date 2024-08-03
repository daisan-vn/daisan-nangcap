<div class="card rounded-0">
	<div class="card-body">
		
		<h3>Tìm kiếm khách hàng</h3>
		<div class="form-group row row-nm mb-0" id="filter">
			<div class="col-sm-3">
				<input name="key" type="text" class="form-control mb-3" placeholder="Tên, mã, điện thoại hoặc email..." value="{$out.key|default:''}">
			</div>
			<div class="col-sm-3">
				<select name="type" class="form-control mb-3">{$out.select_type}</select>
			</div>
			<div class="col-sm-2">
				<button type="button" class="btn btn-success btn-block" onclick="filter();"><i class="fa fa-search"></i> Search</button>
			</div>
			<div class="col text-right">
				<button type="button" class="btn btn-primary" onclick="loadAssign();"><i class="fa fa-user-plus"></i> Phân việc</button>
			</div>
		</div>


		<table class="table">
			<tr>
				<th><input type="checkbox" class="SelectAllRows"></th>
				<th class="text-right">STT</th>
				<th>Doanh nghiệp</th>
				<th>Điện thoại</th>
				<th>Email</th>
				<th>Địa chỉ</th>
			</tr>
			{foreach from=$result key=k item=data}
			<tr>
				<td><input type="checkbox" class="item_checked" value="{$data.id}"></td>
				<td class="text-right">{$k+1}</td>
				<td>{$data.name}</td>
				<td>{$data.phone}</td>
				<td>{$data.email}</td>
				<td>{$data.address}</td>
			</tr>
			{/foreach}
		</table>
		
		<div class="text-center">{$paging}</div>
		
	</div>
</div>

<div class="modal fade" tabindex="-1" id="AssignToUser">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Log work for this task</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">

				<div class="form-group row row-sm">
					<label class="col-sm-4 col-form-label">Phân cho ai</label> 
					<div class="col-sm-8">
						<select name="user_id" class="form-control">{$out.select_user}</select>
					</div>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="AssignToUser();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>

{literal}
<script type="text/javascript">
$(".SelectAllRows").click(function () {
	$(".item_checked, .SelectAllRows").prop('checked', $(this).prop('checked'));
});

function loadAssign(){
	var arr = [];
	$(".item_checked").each(function () {
		if ($(this).is(':checked')) {
			var value = $(this).val();
			arr.push(value);
		}
	});
	if (arr.length < 1) {
		noticeMsg('Thông báo', 'Vui lòng chọn các mục cần xử lí', 'error');
		return false;
	}else{
		$('#AssignToUser').modal('show');
	}

}

function AssignToUser(){
	var data = {};
	data.user_id = $('#AssignToUser select[name=user_id]').val();
	data.ids = [];
	$(".item_checked").each(function () {
		if($(this).is(':checked')) data.ids.push($(this).val());
	});
	data.action = 'save_for_telesale';
	
	if(data.ids.length < 1){
		noticeMsg('Thông báo', 'Vui lòng chọn các mục cần xử lí', 'error');
		return false;
	}else if(data.user_id==0){
		noticeMsg('Thông báo', 'Vui lòng chọn nhân viên Telesale', 'error');
		return false;
	}else{
		loading();
		$.post('?site=allcustomer', data).done(function(e){
			if(e==0){
				noticeMsg('Thông báo', 'Phân khách hàng thất bại, vui lòng kiểm tra lại.', 'error');
				endloading();
				return false;
			}
			location.reload();
		});
	}
}


function filter(){
	var type = $("#filter select[name=type]").val();
	var status = $("#filter select[name=status]").val();
	var key = $("#filter input[name=key]").val();
	
	var url = "./?site=allcustomer";
	if(type&&type!=0) url = url+"&type="+type;
	if(status&&status!=0) url = url+"&status="+status;
	if(key) url = url+"&key="+key;
	window.location.href = url;
	return false;
}
</script>
{/literal}
