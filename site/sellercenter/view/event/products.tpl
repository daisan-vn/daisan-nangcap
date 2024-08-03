<div class="card-header">
	<h3>Sản phẩm trong chương trình khuyến mại</h3>
</div>

<div class="card-body">
	
	<div class="row">
		<div class="col-md-2">
			<img alt="" src="{$event.avatar}" class="w-100">
		</div>
		<div class="col-md-8">
			<h3 class="mb-2">{$event.name}</h3>
			<p class="mb-1">Bắt đầu: {$event.date_start|date_format:'%d-%m-%Y'}</p>
			<p>Kết thúc: {$event.date_finish|date_format:'%d-%m-%Y'}</p>
		</div>
	</div>
	
	{if $out.modify}
	<p class="mt-4">
		<button class="btn btn-primary btn-sm" onclick="LoadForm(0);"><i class="fa fa-plus"></i> Thêm sản phẩm</button>
	</p>
	{/if}
	
	<table class="table table-bordered">
		<tr>
			<th>Sản phẩm</th>
			<th>Giá</th>
			<th>Khuyến mại</th>
			<th>SL</th>
			<th>Lượt click</th>
			<th>Khởi tạo</th>
			{if $out.modify}
			<th class="text-center">Active</th>
			<th></th>
			{/if}
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td><a href="?mod=ads&site=clicks&adsproduct_id={$data.id}">{$data.name}</a></td>
			<td>{$data.price|number_format}</td>
			<td>{$data.promo|number_format}</td>
			<td>{$data.number}</td>
			<td>{$data.number_click}</td>
			<td>{$data.created|date_format:"%H:%M:%S %d/%m/%Y"}</td>
			{if $out.modify}
			<td class="text-center" id="stt{$data.id}">{$data.status}</td>
			<td class="text-right">
				<button type="button" class="btn btn-light btn-sm" onclick="LoadForm({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
				<button type="button" class="btn btn-light btn-sm" onclick="DeleteItem('', {$data.id}, 'event', 'ajax_delete_product');"><i class="fa fa-trash fa-fw"></i></button>
			</td>
			{/if}
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
				<input type="hidden" name="event_id" value="{$out.event_id}"> 
				<input type="hidden" value="" name="id"> 
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Sản phẩm</label> 
					<div class="col-sm-9">
						<select name="product_id" class="form-control chosen"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Giá bán</label> 
					<div class="col-sm-6">
						<input type="text" class="form-control" name="price"> 
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Khuyến mại</label> 
					<div class="col-sm-6">
						<input type="text" class="form-control" name="promo"> 
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Số lượng</label> 
					<div class="col-sm-3">
						<input type="number" class="form-control" name="number" value="1"> 
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

function LoadForm(id){
	$("#Form input[name=id]").val(id);
	$(".chosen-container").css("width", "100%");
	var data = {};
	data.id = id;
	data.event_id = $("#Form input[name=event_id]").val();
	data.ajax_action = 'load_form';
	$.post('?mod=event&site=products', data).done(function(e){
		var rt = JSON.parse(e);
		if(rt.error==1){
			noticeMsg('System Message', rt.msg, 'error');
		}else{
			console.log(rt);
			$("#Form select[name=product_id]").html(rt.s_product);
			$("#Form input[name=price]").val(rt.price);
			$("#Form input[name=promo]").val(rt.promo);
			$("#Form input[name=number]").val(rt.number);
			$('.chosen').trigger("chosen:updated");
			$("#Form").modal('show');
		}
	});
}

function SaveForm(){
	var data = {};
	data.id = $("#Form input[name=id]").val();
	data.event_id = $("#Form input[name=event_id]").val();
	data.product_id = $("#Form select[name=product_id]").val();
	data.price = $("#Form input[name=price]").val();
	data.promo = $("#Form input[name=promo]").val();
	data.number = $("#Form input[name=number]").val();
	data.ajax_action = 'save_form';
	
	if(data.product_id==''){
		noticeMsg('Thông báo', 'Vui lòng chọn sản phẩm', 'error');
		return false;
	}else if(data.price==''){
		noticeMsg('Thông báo', 'Vui lòng nhập số điểm click', 'error');
		$("#Form input[name=price]").focus();
		return false;
	}else if(data.promo==''){
		noticeMsg('Thông báo', 'Vui lòng nhập số điểm click', 'error');
		$("#Form input[name=promo]").focus();
		return false;
	}else if(data.number==''){
		noticeMsg('Thông báo', 'Vui lòng nhập số điểm click', 'error');
		$("#Form input[name=number]").focus();
		return false;
	}
	
	loading();
	$.post('?mod=event&site=products', data).done(function(e){
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