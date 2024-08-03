<div class="card-header">
	<h3>Danh sách sản phẩm trong chiến dịch quảng cáo</h3>
	<p>Khi đưa sản phẩm của bạn vào danh sách này, sản phẩm đó sẽ mặc định xuất hiện tại những vị trí quan trọng đối với mỗi từ khóa.</p>
</div>

<div class="card-body">
	
	<div>
		<p>
			<button class="btn btn-primary btn-sm" onclick="LoadForm(0);"><i class="fa fa-plus"></i> Thêm sản phẩm</button>
		</p>
	</div>
	
	<table class="table table-bordered">
		<tr>
			<th>Sản phẩm</th>
			<th>Điểm/click</th>
			<th>Lượt click</th>
			<th>Khởi tạo</th>
			<th class="text-center">Active</th>
			<th></th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td>
				<div class="row row-sm">
					<div class="col-2">
						<a href="javascript:void(0);" class="img-thumbnail d-block"><img alt="{$data.name}"
								src="{$data.avatar}" width="100%"></a>
					</div>
					<div class="col-10">
						<p class="mb-1"><a href="?mod=ads&site=clicks&adsproduct_id={$data.id}">{$data.name}</a></p>
						</p>
					</div>
				</div>
			</td>
			<td>{$data.score}</td>
			<td>{$data.number_click}</td>
			<td>{$data.created|date_format:"%H:%M:%S %d/%m/%Y"}</td>
			<td class="text-center" id="stt{$data.id}">{$data.status}</td>
			<td class="text-right">
				<button type="button" class="btn btn-light btn-sm" onclick="LoadForm({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
				<button type="button" class="btn btn-light btn-sm" onclick="DeleteItem('', {$data.id}, 'ads', 'ajax_delete_product');"><i class="fa fa-trash fa-fw"></i></button>
			</td>
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
					<label class="col-sm-2 col-form-label">Từ khóa</label> 
					<div class="col-sm-10">
						<textarea class="form-control" name="keyword"></textarea>
					</div>
					<div class="col-sm-10 offset-sm-2">
						<small class="form-text text-muted">Từ khóa để khi khách tìm kiếm sẽ thấy sản phẩm của bạn. Các từ khóa phân cách nhau bằng dấu ';', tối đa 5 từ khóa.</small>
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
		$("#Form textarea[name=keyword]").val(rt.keyword);
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
	data.keyword = $("#Form textarea[name=keyword]").val();
	data.ajax_action = 'save_form';
	
	if(data.product_id==''){
		noticeMsg('Thông báo', 'Vui lòng chọn sản phẩm', 'error');
		return false;
	}else if(data.keyword.length<10){
		noticeMsg('Thông báo', 'Vui lòng nhập từ khóa tối thiểu 10 ký tự', 'error');
		$("#Form textarea[name=keyword]").focus();
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

$('#Form select[name=product_id]').change(function(){
	var key = $('#Form select[name=product_id] option').filter(':selected').text();
	$("#Form textarea[name=keyword]").val(key);
	console.log(key);
});

</script>
{/literal}
