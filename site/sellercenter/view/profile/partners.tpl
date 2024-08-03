<div class="card-header">
	<h3>Đối tác chính của công ty</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<div class="card" id="PartnerFilter">
		<div class="card-header">Lựa chọn đối tác</div>
		<div class="card-body">
			<div class="form-group row">
				<div class="col-sm-6">
					<input type="text" class="form-control" onchange="LoadPartners(this.value);"> 
					<small id="passwordHelpBlock" class="form-text text-muted"> Nhập tên công ty hoặc tên thương hiệu, số điện thoại để tìm đối tác trên hệ thống </small>
				</div>
			</div>
			<div id="LoadPartners" class="border p-2 d-none"></div>
		</div>
	</div>
		
	<form method="post">
		<div class="card d-none" id="PartnerContent">
			<div class="card-header">Lưu thông tin đối tác</div>
			<div class="card-body">
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Đối tác</label>
					<div class="col-sm-8" id="Partner">
						<div class="row row-sm mb-3">
							<div class="col-md-2">
								<span class="border d-block" style="min-height: 105px">
									<img src="{$arg.noimg}" width="100%" height="105">
								</span>
							</div>
							<div class="col-md-4">
								<h5></h5>
								<input type="hidden" name="partner_id">
							</div>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Năm bắt đầu</label>
					<div class="col-sm-2">
						<input type="text" class="form-control" name="year_start"> 
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Năm kết thúc</label>
					<div class="col-sm-2">
						<input type="text" class="form-control" name="year_finish"> 
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Mô tả hợp tác</label>
					<div class="col-sm-6">
						<textarea rows="4" class="form-control" name="description"></textarea>
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-2"></div>
					<div class="col-sm-10">
						<button type="submit" name="submit" class="btn btn-primary">Lưu thông tin</button>
					</div>
				</div>
			</div>
		</div>
	</form>

	<h4 class="mt-5">Tất cả đối tác của công ty</h4>
	<table class="table">
		<tr>
			<th>Đối tác</th>
			<th>Mô tả</th>
			<th></th>
		</tr>
		{foreach from=$partners item=data}
		<tr id="FID{$data.id}">
			<td width="40%">
				<div class="row row-sm">
					<div class="col-md-3">
						<img class="img-thumbnail" src="{$data.logo}" width="100%">
					</div>
					<div class="col-md-9">
						<h6 class="mb-1">{$data.name}</h6>
						<p>Từ {$data.year_start} đến {$data.year_finish}</p>
					</div>
				</div>
			</td>
			<td>{$data.description}</td>
			<td class="text-right">
				<button type="button" class="btn btn-light btn-sm" onclick="DeleteItem('', {$data.id}, 'profile', 'ajax_delete_partner');"><i class="fa fa-trash fa-fw"></i></button>
			</td>
		</tr>
		{/foreach}
	</table>


</div>

{literal}
<script>
function LoadPartners(key){
	loading();
	$('#LoadPartners').load("?mod=profile&site=load_partners", {'key': key}, function(){
		$("input[name=service_id]").val('');
		$("#LoadPartners").removeClass('d-none');
		$("#LoadPartners").addClass('d-block');
		endloading();
	});
}

function SetPartner(id){
	var name = $("#Partner"+id+" small").html();
	var img = $("#Partner"+id+" img").attr('src');
	
	$("#Partner input[name=partner_id]").val(id);
	$("#Partner h5").html(name);
	$("#Partner img").attr('src', img);
	
	//$("#LoadPartners").removeClass('d-block');
	$("#PartnerFilter").addClass('d-none');
	
	$("#PartnerContent").addClass('d-block');
	$("#PartnerContent").removeClass('d-none');

	noticeMsg('Thông báo', 'Chọn '+name+' làm đối tác của công ty.', 'success');

}
</script>
{/literal}