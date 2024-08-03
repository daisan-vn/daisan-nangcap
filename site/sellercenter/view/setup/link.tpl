<div class="card-header">
	<h3>Quản lý các link liên kết trên website</h3>
	<hr>
	<div class="alltabs">{$page_menu}</div>
</div>

<div class="card-body">
	
	<p>Bạn có thể đưa thêm các link liên kết vào website/page của mình tại các vị trí chân trang.</p>


	<div class="form-inline mb-3">
		<button type="button" class="btn btn-primary btn-sm" onclick="LoadForm();"><i class="fa fa-fw fa-plus"></i> Thêm mới</button>
	</div>


	<table class="table table-bordered">
		<tr>
			<th class="text-right">STT</th>
			<th>Tiêu đề</th>
			<th>Đường dẫn</th>
			<th>Cập nhật</th>
			<th></th>
		</tr>
		{foreach from=$result key=k item=data}
		<tr id="FID{$data.id}">
			<td class="text-right">{$k+1}</td>
			<td>{$data.title}</td>
			<td>{$data.link}</td>
			<td>{$data.created|date_format:"%H:%M %d-%m-%Y"}</td>
			<td class="text-right">
				<button type="button" class="btn btn-light btn-sm" onclick="LoadForm({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
				<button type="button" class="btn btn-light btn-sm" onclick="DeleteItem('', {$data.id}, 'setup', 'ajax_delete_link');"><i class="fa fa-trash fa-fw"></i></button>
			</td>
		</tr>
		{/foreach}
	</table>

</div>


<div class="modal fade" tabindex="-1" id="LoadForm">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Cập nhật thông tin</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">

				<input type="hidden" value="" name="id"> 
				<div class="form-group row">
					<label class="col-sm-3 col-form-label">Tiêu đề link</label>
					<div class="col-sm-9">
						<input type="text" class="form-control" name="title">
					</div>
				</div>
				<div class="form-group">
					<label>Đường dẫn chi tiết</label> 
					<textarea rows="3" class="form-control" name="link"></textarea>
					<small class="form-text text-muted">Nhập chính xác đường dẫn mà bạn muốn trỏ đến.</small>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="SaveForm();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>


<script type="text/javascript">
function LoadForm(id){
	var data = {};
	data['id'] = id;
	data['ajax_action'] = 'load_content';
	loading();
	$.post('?mod=setup&site=link', data).done(function(e){
		var data = JSON.parse(e);
		$("#LoadForm input[name=id]").val(id);
		$("#LoadForm input[name=title]").val(data.title);
		$("#LoadForm textarea[name=link]").val(data.link);
		$("#LoadForm").modal('show');
		endloading();
	});
}

function SaveForm(){
	var data = {};
	data['id'] = $("#LoadForm input[name=id]").val();
	data['title'] = $("#LoadForm input[name=title]").val();
	data['link'] = $("#LoadForm textarea[name=link]").val();
	data['ajax_action'] = 'save_content';
	loading();
	$.post('?mod=setup&site=link', data).done(function(e){
		noticeMsg('System Message', 'Lưu thông tin thành công.');
		setTimeout(function(){
			location.reload();
		}, 2000);
	});
}
</script>