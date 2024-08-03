<div class="card-header">
	<h3>Danh sách các click vào quảng cáo</h3>
</div>

<div class="card-body">
	
	<table class="table table-bordered">
		<tr>
			<th>IP</th>
			<th>User</th>
			<th>Location</th>
			<th>Thời điểm click</th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td>{$data.user_ip}</td>
			<td>{$data.user_name}</td>
			<td>{$data.user_location}</td>
			<td>{$data.created|date_format:"%H:%M:%S %d/%m/%Y"}</td>
		</tr>
		{/foreach}
	</table>

</div>

<div class="modal fade" tabindex="-1" id="Form">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Sản phẩm trong chiến dịch</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<input type="hidden" name="campaign_id" value="{$out.campaign_id}"> 
				<input type="hidden" value="" name="id"> 
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Sản phẩm</label> 
					<div class="col-sm-10">
						<select name="product_id" class="form-control chosen"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Điểm</label> 
					<div class="col-sm-3">
						<input type="number" class="form-control" name="score" value="1"> 
					</div>
					<div class="col-sm-10 offset-sm-2">
						<small class="form-text text-muted">Số điểm cho mỗi click vào quảng cáo. Điểm đặt cao hơn các gian hàng khác thì sẽ được ưu tiên về thứ hạng.</small>
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
	$("#Form input[name=id]").val(id);
	$(".chosen-container").css("width", "100%");
	var data = {};
	data.id = id;
	data.campaign_id = $("#Form input[name=campaign_id]").val();
	data.ajax_action = 'load_form';
	$.post('?mod=ads&site=products', data).done(function(e){
		var rt = JSON.parse(e);
		console.log(rt);
		$("#Form select[name=product_id]").html(rt.s_product);
		$("#Form input[name=score]").val(rt.score);
		$('.chosen').trigger("chosen:updated");
		$("#Form").modal('show');
	});
}

function SaveForm(){
	var data = {};
	data.id = $("#Form input[name=id]").val();
	data.campaign_id = $("#Form input[name=campaign_id]").val();
	data.product_id = $("#Form select[name=product_id]").val();
	data.score = $("#Form input[name=score]").val();
	data.ajax_action = 'save_form';
	
	if(data.product_id==''){
		noticeMsg('Thông báo', 'Vui lòng chọn sản phẩm', 'error');
		return false;
	}else if(data.score==''){
		noticeMsg('Thông báo', 'Vui lòng nhập số điểm click', 'error');
		$("#Form input[name=score]").focus();
		return false;
	}
	
	loading();
	$.post('?mod=ads&site=products', data).done(function(e){
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
