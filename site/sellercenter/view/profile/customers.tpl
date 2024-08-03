<div class="card-header">
	<h3>Nhân viên chăm sóc khách hàng</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<form>
		<div class="card-header mb-3">Thông tin liên hệ công ty</div>
		<div class="form-group row">
			<label for="inputPassword" class="col-sm-2 col-form-label">Ảnh đại diện</label>
			<div class="col-sm-6">
				<div class="row row-sm">
					<div class="col-md-3">
						<span class="border d-block" style="min-height: 120px"></span>
					</div>
					<div class="col-md-9">
						<input type="file" > 
						<small id="passwordHelpBlock" class="form-text text-muted"> Your password must be 8-20
							characters long, contain letters and numbers, and must not contain
							spaces, special characters, or emoji. </small>
					</div>
				</div>
			</div>
		</div>
		<div class="form-group row">
			<label for="inputPassword" class="col-sm-2 col-form-label">Tên liên hệ</label>
			<div class="col-sm-6">
				<input type="text" class="form-control" id="inputPassword" value="{$page.name|default:''}"> 
				<small id="passwordHelpBlock" class="form-text text-muted"> Your password must be 8-20
					characters long, contain letters and numbers, and must not contain
					spaces, special characters, or emoji. </small>
			</div>
		</div>
		<div class="form-group row">
			<label for="inputPassword" class="col-sm-2 col-form-label">Số điện thoại</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" id="inputPassword"> 
			</div>
		</div>
		<div class="form-group row">
			<label for="inputPassword" class="col-sm-2 col-form-label">Email</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" id="inputPassword"> 
			</div>
		</div>
		<div class="form-group row">
			<label for="inputPassword" class="col-sm-2 col-form-label">Skype chat</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" id="inputPassword"> 
			</div>
		</div>
		<div class="form-group row">
			<div class="col-sm-2"></div>
			<div class="col-sm-10">
				<button type="submit" class="btn btn-primary">Lưu thông tin</button>
				<button type="submit" class="btn">Reset</button>
			</div>
		</div>

		<h4 class="mt-5">Tất cả nhân viên hỗ trợ</h4>
		<table class="table">
			<tr>
				<th>Dịch vụ</th>
				<th>Dịch vụ</th>
				<th>Dịch vụ</th>
				<th>Dịch vụ</th>
			</tr>
			<tr>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
			</tr>
			<tr>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
			</tr>
			<tr>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
			</tr>
			<tr>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
			</tr>
			<tr>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
			</tr>
			<tr>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
			</tr>
			<tr>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
			</tr>
			<tr>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
			</tr>
			<tr>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
				<td>Dịch vụ</td>
			</tr>
		</table>

	</form>

</div>

{literal}
<script>
function LoadLocation(Type, Value){
	loading();
	$.post('?mod=help&site=ajax_load_location', {'Type':Type, 'Value':Value}).done(function(e){
		$("#"+Type).html(e);
		if(Type=='district') $("#wards").html('');
		endloading();
	});
}
</script>
{/literal}