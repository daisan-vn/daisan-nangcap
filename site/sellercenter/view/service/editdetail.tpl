<div class="card-header">
	<h3>Khởi tạo dịch vụ của công ty</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<form method="post">

		<div class="card mb-3">
			<div class="card-header">Thông tin dịch vụ</div>
			<div class="card-body">
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Dịch vụ</label>
					<div class="col-sm-8">
						<h5 class="mt-1">{$service.name|default:''}</h5>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Giới thiệu sơ qua dịch vụ</label>
					<div class="col-sm-8">
						<textarea class="form-control" name="description" rows="4">{$service.description|default:''}</textarea>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Thời gian xử lý</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" name="timework" value="{$service.timework|default:''}">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Bảo hành</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" name="warranty" value="{$service.warranty|default:''}">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Địa điểm cung cấp dịch vụ</label>
					<div class="col-sm-8">
						<select name="places[]" class="form-control chosen" multiple>
							{$out.select_province}
						</select>
					</div>
				</div>
			</div>
		</div>
		
		<div class="card mb-3">
			<div class="card-header">
				<div class="row">
					<div class="col-md-8">Mô tả thêm thông tin</div>
					<div class="col-md-4 text-right">
						<button type="button" class="btn btn-light btn-sm" onclick="AddDetail();"><i class="fa fa-plus fa-fw"></i>Thêm</button>
					</div>
				</div>
			</div>
			<div class="card-body" id="LoadDetail"></div>
		</div>
	
		<div class="card mb-3">
			<div class="card-header">
				<div class="row">
					<div class="col-md-8">Quy trình hoặc đầu mục công việc</div>
					<div class="col-md-4 text-right">
						<button type="button" class="btn btn-light btn-sm" onclick="AddStep();"><i class="fa fa-plus fa-fw"></i>Thêm</button>
					</div>
				</div>
			</div>
			<div class="card-body" id="LoadStep"></div>
		</div>

		<div class="card mb-3">
			<div class="card-header">
				<div class="row">
					<div class="col-md-8">Ưu đãi cho khách hàng</div>
					<div class="col-md-4 text-right">
						<button type="button" class="btn btn-light btn-sm" onclick="AddPromo();"><i class="fa fa-plus fa-fw"></i>Thêm</button>
					</div>
				</div>
			</div>
			<div class="card-body" id="LoadPromo"></div>
		</div>

		<div class="card mb-3">
			<div class="card-header">
				<div class="row">
					<div class="col-md-8">Bảng giá dịch vụ</div>
					<div class="col-md-4 text-right">
						<button type="button" class="btn btn-light btn-sm" onclick="AddPrice();"><i class="fa fa-plus fa-fw"></i>Thêm</button>
					</div>
				</div>
			</div>
			<div class="card-body" id="LoadPrice"></div>
		</div>
		
		<div class="form-group row">
			<div class="col-sm-10">
				<button type="submit" name="submit" class="btn btn-primary btn-lg">Lưu thông tin dịch vụ</button>
			</div>
		</div>

	</form>
	
</div>

<link href="{$arg.stylesheet}plugins/chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}plugins/chosen/chosen.jquery.min.js"></script>
{literal}
<script>
$(".chosen").chosen({disable_search_threshold: 10});
$("#LoadDetail").load('?mod=service&site=load_details');
$("#LoadPrice").load('?mod=service&site=load_prices');
$("#LoadStep").load('?mod=service&site=load_steps');
$("#LoadPromo").load('?mod=service&site=load_promos');

function AddDetail(){
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'add_detail'}).done(function(){
		$("#LoadDetail").load('?mod=service&site=load_details');
	});
}
function SetDetail(type, id, value){
	var Data = {};
	Data['type'] = type;
	Data['id'] = id;
	Data['value'] = value;
	Data['ajax_action'] = 'set_detail';
	$.post('?mod=service&site=ajax_handle', Data).done(function(){
		noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
	});
}
function DeleteDetail(id){
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'delete_detail','id':id}).done(function(){
		$("#LoadDetail").load('?mod=service&site=load_details');
	});
}
function SortDetail(id, type){
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'sort_detail','id':id,'type':type}).done(function(){
		$("#LoadDetail").load('?mod=service&site=load_details');
	});
}

/*-------------------*/
function AddPrice(){
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'add_price'}).done(function(e){
		var data = JSON.parse(e);
		if(data.code==1){
			$("#LoadPrice").load('?mod=service&site=load_prices');
		}else{
			noticeMsg('Thông báo', data.msg, 'error');
		}
	});
}
function SetPrice(type, id, value){
	var Data = {};
	Data['type'] = type;
	Data['id'] = id;
	Data['value'] = value;
	Data['ajax_action'] = 'set_price';
	$.post('?mod=service&site=ajax_handle', Data).done(function(){
		noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
	});
}
function DeletePrice(id){
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'delete_price','id':id}).done(function(){
		$("#LoadPrice").load('?mod=service&site=load_prices');
	});
}
function SortPrice(id, type){
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'sort_price','id':id,'type':type}).done(function(){
		$("#LoadPrice").load('?mod=service&site=load_prices');
	});
}


/*-------------------*/
function AddStep(){
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'add_step'}).done(function(){
		$("#LoadStep").load('?mod=service&site=load_steps');
	});
}
function SetStep(type, id, value){
	var Data = {};
	Data['type'] = type;
	Data['id'] = id;
	Data['value'] = value;
	Data['ajax_action'] = 'set_step';
	$.post('?mod=service&site=ajax_handle', Data).done(function(){
		noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
	});
}
function DeleteStep(id){
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'delete_step','id':id}).done(function(){
		$("#LoadStep").load('?mod=service&site=load_steps');
	});
}
function SortStep(id, type){
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'sort_step','id':id,'type':type}).done(function(){
		$("#LoadStep").load('?mod=service&site=load_steps');
	});
}


/*-------------------*/
function AddPromo(){
	loading();
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'add_promo'}).done(function(){
		$("#LoadPromo").load('?mod=service&site=load_promos');
		endloading();
	});
}
function SetPromo(type, id, value){
	var Data = {};
	Data['type'] = type;
	Data['id'] = id;
	Data['value'] = value;
	Data['ajax_action'] = 'set_promo';
	$.post('?mod=service&site=ajax_handle', Data).done(function(){
		noticeMsg('Thông báo', 'Lưu thông tin thành công.', 'success');
	});
}
function DeletePromo(id){
	loading();
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'delete_promo','id':id}).done(function(){
		$("#LoadPromo").load('?mod=service&site=load_promos');
		endloading();
	});
}
function SortPromo(id, type){
	loading();
	$.post('?mod=service&site=ajax_handle', {'ajax_action':'sort_promo','id':id,'type':type}).done(function(){
		$("#LoadPromo").load('?mod=service&site=load_promos');
		endloading();
	});
}

</script>
{/literal}
