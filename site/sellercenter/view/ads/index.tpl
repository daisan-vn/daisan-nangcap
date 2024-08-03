<div class="card-header">
	<h3>Chiến dịch quảng cáo</h3>
</div>

<div class="card-body">
	
	<div>
		<p class="mb-1">Khi đưa sản phẩm của bạn vào danh sách này, sản phẩm đó sẽ mặc định xuất hiện tại những vị trí quan trọng đối với mỗi từ khóa.</p>
		<p>Số lượt đưa sản phẩm vào danh sách sẽ tùy thuộc vào gói gian hàng VIP của bạn.</p>
		<p>Điểm Quảng cáo trong tháng: <b>{$page.score_ads|number_format}</b>. Số điểm QC còn lại là <b>{$point_left|default:0|number_format}</b> cho tháng này</p>
		
		<p>
			<button class="btn btn-primary btn-sm" onclick="LoadForm(0);"><i class="fa fa-plus"></i> Thêm mới</button>
		</p>
	</div>
	
	<table class="table table-bordered">
		<tr>
			<th>Chiến dịch</th>
			<th>Bắt đầu QC</th>
            <th>Kết thúc QC</th>
			<th>Điểm mỗi ngày</th>
			<th>Điểm chiến dịch</th>
			<th>Click</th>
			<th>Tổng điểm</th>
			<th>Khởi tạo</th>
			<th class="text-center">Active</th>
			<th></th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td><a href="?mod=ads&site=products&campaign_id={$data.id}">{$data.name}</a></td>
			<td>{$data.date_start|date_format:"%d/%m/%Y"}</td>
			<td>{$data.date_finish|date_format:"%d/%m/%Y"}</td>
			<td>{$data.score_daily}</td>
			<td>{$data.score_total}</td>
			<td>{$data.total_click}</td>
			<td>{$data.total_score|default: 0}</td>
			<td>{$data.created|date_format:"%H:%M:%S %d/%m/%Y"}</td>
			<td class="text-center" id="stt{$data.id}">{$data.status}</td>
			<td class="text-right">
				<button type="button" class="btn btn-light btn-sm" onclick="LoadForm({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
				<button type="button" class="btn btn-light btn-sm" onclick="DeleteItem('', {$data.id}, 'ads', 'ajax_delete_camplaign');"><i class="fa fa-trash fa-fw"></i></button>
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
				<h5 class="modal-title">Chiến dịch</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<input type="hidden" value="" name="id">
				<input type="hidden" value="" name="max_score">
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Tên</label> 
					<div class="col-sm-9">
						<input type="text" class="form-control" name="name"> 
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Tổng điểm</label> 
					<div class="col-sm-6">
						<input type="number" class="form-control" name="score_total" value="1"> 
					</div>
					<div class="col-sm-9 offset-sm-3">
						<small class="form-text text-muted">Tổng số điểm cho chiến dịch.</small>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Điểm ngày</label> 
					<div class="col-sm-6">
						<input type="number" class="form-control" name="score_daily" value="1"> 
					</div>
					<div class="col-sm-9 offset-sm-3">
						<small class="form-text text-muted">Số điểm quảng cáo giới hạn mỗi ngày. Điểm số bị trừ với mỗi click từ quảng cáo và khi hết điểm trong ngày nó sẽ tạm dừng.</small>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Bắt đầu</label> 
					<div class="col-sm-4">
						<input type="text" class="form-control datepicker" name="date_start" autocomplete="off"> 
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Kết thúc</label> 
					<div class="col-sm-4">
						<input type="text" class="form-control datepicker" name="date_finish" autocomplete="off"> 
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
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
	$.post('?mod=ads&site=index', data).done(function(e){
		var rt = JSON.parse(e);
		$("#Form input[name=max_score]").val(rt.max_score);
		if(rt.error==1){
			noticeMsg('System Message', rt.msg, 'error');
		}else{
			$("#Form input[name=name]").val(rt.name);
			$("#Form input[name=date_start]").val(rt.date_start);
			$("#Form input[name=date_finish]").val(rt.date_finish);
			$("#Form input[name=score_daily]").val(rt.score_daily);
			$("#Form input[name=score_total]").val(rt.score_total);
			$("#Form").modal('show');
		}
	});
	
}

function vn2enDate(date) {
	return date.split('-').reverse().join('-');
}

function SaveForm(){
	var data = {};
	data.id = $("#Form input[name=id]").val();
	data.name = $("#Form input[name=name]").val();
	data.date_start = $("#Form input[name=date_start]").val();
	data.date_finish = $("#Form input[name=date_finish]").val();
	data.score_daily = $("#Form input[name=score_daily]").val();
	data.score_total = $("#Form input[name=score_total]").val();
	data.max_score = $("#Form input[name=max_score]").val();
	data.ajax_action = 'save_form';
	
	if(data.name==''){
		noticeMsg('Thông báo', 'Vui lòng nhập tên chiến dịch tối thiểu 6 ký tự', 'error');
		$("#Form input[name=name]").focus();
		return false;
	}else if(data.date_start==''){
		noticeMsg('Thông báo', 'Vui lòng nhập ngày bắt đầu', 'error');
		$("#Form input[name=date_start]").focus();
		return false;
	}else if(data.date_finish==''){
		noticeMsg('Thông báo', 'Vui lòng nhập ngày kết thúc', 'error');
		$("#Form input[name=date_finish]").focus();
		return false;
	}
	else if(Date.parse(vn2enDate(data.date_finish)) < Date.parse(vn2enDate(data.date_start))) {
		noticeMsg('Thông báo', 'Thời gian kết thúc phải sau thời gian bắt đầu', 'error');
		return false;
	}
	else if(data.score_daily==''){
		noticeMsg('Thông báo', 'Vui lòng nhập số điểm giới hạn trong một ngày', 'error');
		$("#Form input[name=score_daily]").focus();
		return false;
	}
	else if(data.score_total==''){
		noticeMsg('Thông báo', 'Vui lòng nhập số điểm chiến dịch', 'error');
		$("#Form input[name=score_total]").focus();
		return false;
	}
	else if(parseInt(data.score_total) > parseInt(data.max_score)){
		noticeMsg('Thông báo', 'Số điểm vượt quá gói gian hàng của bạn', 'error');
		$("#Form input[name=score_total]").focus();
		return false;
	}

	loading();
	$.post('?mod=ads&site=index', data).done(function(e){
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