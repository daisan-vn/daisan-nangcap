
<table class="table table-bordered">
	<tr>
		<th>Sản phẩm</th>
		<th>Giá bán</th>
		<th>Active/Featured</th>
		<th></th>
	</tr>
	{foreach from=$products item=data}
	<tr id="FID{$data.id}">
		<td width="50%">
			<div class="row row-sm">
				<div class="col-2">
					<a href="javascript:void(0);" class="img-thumbnail d-block"><img
						alt="{$data.name}" src="{$data.avatar}" width="100%"></a>
				</div>
				<div class="col-10">
					<p class="mb-1">
						<a href="{$data.url}">{$data.name}</a>
					</p>
					<p class="mb-0">
						<small><i class="fa fa-fw fa-tag"></i>{$data.category}
							&nbsp;|&nbsp; <a href="{$data.url_edit_cate}"><i
								class="fa fa-pencil"></i> sửa</a></small>
					</p>
					<p class="mb-0">
						<small>Views: {$data.views} | Score: {$data.score} |
							Orders: {$data.orders|default:0}</small>
					</p>
				</div>
			</div>
		</td>
		<td>Giá từ: <b>{$data.price|number_format}đ</b></td>
		<td>{$data.status}</td>
		<td class="text-right">{if $data.ismain eq 0}
			<button type="button" class="btn btn-light btn-sm"
				onclick="SetMainProduct({$data.id});">
				<i class="fa fa-star fa-fw"></i>
			</button> {/if}
			<button type="button" class="btn btn-light btn-sm"
				onclick="LoadCopy({$data.id});">
				<i class="fa fa-clone fa-fw"></i>
			</button> <a href="{$data.url_edit}" class="btn btn-light btn-sm"><i
				class="fa fa-pencil fa-fw"></i></a>
			<button type="button" class="btn btn-light btn-sm"
				onclick="DeleteItem('', {$data.id}, 'product', 'ajax_delete');">
				<i class="fa fa-trash fa-fw"></i>
			</button>
		</td>
	</tr>
	{/foreach}
</table>
<nav aria-label="Page navigation example">{$paging}</nav>

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
				<button type="button" class="btn btn-primary" onclick="SaveForm();">Lưu
					thông tin</button>
			</div>
		</div>
	</div>
</div>

<link href="{$arg.stylesheet}plugins/chosen/chosen.min.css"
	rel="stylesheet">
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
