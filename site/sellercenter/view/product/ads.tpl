<div class="card-header">
	<h3>Danh sách quảng cáo sản phẩm</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<p class="mb-1">Khi đưa sản phẩm của bạn vào danh sách này, sản phẩm đó sẽ mặc định xuất hiện tại những vị trí quan trọng đối với mỗi từ khóa.</p>
	<p>Số lượt đưa sản phẩm vào danh sách sẽ tùy thuộc vào gói gian hàng VIP của bạn.</p>
	<p>
		<button class="btn btn-primary btn-sm" onclick="LoadForm(0);"><i class="fa fa-plus"></i> Thêm mới</button>
	</p>
	<table class="table table-bordered">
		<tr>
			<th>Sản phẩm</th>
			<th>Từ khóa</th>
            <th>Vị trí</th>
			<th>Bắt đầu QC</th>
			<th>Khởi tạo</th>
			<th>Active</th>
			<th></th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td width="35%">
				<div class="row row-sm">
					<div class="col-2">
						<a href="javascript:void(0);" class="img-thumbnail d-block"><img alt="{$data.name}" src="{$data.avatar}" width="100%"></a>
					</div>
					<div class="col-10">
						<p class="mb-1">{$data.name}</p>
					</div>
				</div>
			</td>
			<td>{$data.keyword}</td>
            <td>{$data.position}</td>
			<td>{$data.started|date_format:"%d/%m/%Y"}</td>
			<td>{$data.created|date_format:"%H:%M:%S %d/%m/%Y"}</td>
			<td>{$data.status}</td>
			<td class="text-right">
				<button type="button" class="btn btn-light btn-sm" onclick="LoadForm({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
				<button type="button" class="btn btn-light btn-sm" onclick="DeleteItem('', {$data.id}, 'product', 'ajax_delete_ads');"><i class="fa fa-trash fa-fw"></i></button>
			</td>
		</tr>
		{/foreach}
	</table>

	<nav aria-label="Page navigation example">
		{$paging}
	</nav>
</div>

<div class="modal fade" tabindex="-1" id="Form">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Sao chép sản phẩm</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<input type="hidden" value="" name="id"> 
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Vị trí</label> 
					<div class="col-sm-6">
						<select name="position" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Bắt đầu</label> 
					<div class="col-sm-4">
						<input type="text" class="form-control datepicker" name="started"> 
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Từ khóa</label> 
					<div class="col-sm-8">
						<input type="text" class="form-control" name="keyword"> 
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Sản phẩm</label> 
					<div class="col-sm-10">
						<select name="product_id" class="form-control chosen"></select>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="SaveForm();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>

<link href="{$arg.stylesheet}plugins/chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}plugins/chosen/chosen.jquery.min.js"></script>

{literal}
<script>
$(window).ready(function(){
	$(".chosen").chosen({disable_search_threshold: 10});
	$( ".datepicker" ).datepicker({
		dateFormat: 'dd-mm-yy',
		minDate: '0'
	});
});

function filter(){
	var key = $("#filter_key").val();
	var status = $("#status").val();
	var category = $("#category").val();
	var url = "?mod=product&site=index";
	if(key!='') url = url+"&key="+key;
	if(status!=-1) url = url+"&status="+status;
	if(category!=0) url = url+"&category="+category;
	location.href =  url;
}

function LoadForm(id){
	$("#Form input").val('');
	$("#Form input[name=id]").val(id);
	var data = {};
	data.id = id;
	data.ajax_action = 'load_form';
	$.post('?mod=product&site=ads', data).done(function(e){
		var rt = JSON.parse(e);
		$("#Form select[name=position]").html(rt.s_position);
		$("#Form select[name=product_id]").html(rt.s_product);
		$("#Form input[name=keyword]").val(rt.keyword);
		$("#Form input[name=started]").val(rt.started);
		$('.chosen').trigger("chosen:updated");
		$(".chosen-container").css("width", "100%");
		$("#Form").modal('show');
	});
	
}

function SaveForm(){
	var data = {};
	data.id = $("#Form input[name=id]").val();
	data.position = $("#Form select[name=position]").val();
	data.started = $("#Form input[name=started]").val();
	data.keyword = $("#Form input[name=keyword]").val();
	data.product_id = $("#Form select[name=product_id]").val();
	data.ajax_action = 'save_form';
	
	if(data.keyword.length<6){
		noticeMsg('Thông báo', 'Vui lòng nhập từ khóa tối thiểu 6 ký tự', 'error');
		$("#Form input[name=keyword]").focus();
		return false;
	}
	
	loading();
	$.post('?mod=product&site=ads', data).done(function(e){
		var rt = JSON.parse(e);
		if(rt.code==0) noticeMsg('Thông báo', rt.msg, 'error');
		else {
			noticeMsg('Thông báo', 'Lưu thông tin quảng cáo sản phẩm thành công', 'success');
			location.reload();
		}
		endloading();
	});
}

</script>
{/literal}
