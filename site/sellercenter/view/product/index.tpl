<div class="card-header">
	<h3>Danh sách sản phẩm</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>
<div class="card-body">
	<div class="form-inline mb-3">
		<div class="form-group mr-2">
			<input type="text" id="filter_key" class="form-control" placeholder="Search" value="{$out.key}">
		</div>
		<div class="form-group mr-2">
			<select id="category" class="form-control">
				{$out.select_category}
			</select>
		</div>
		<div class="form-group mr-2">
			<select id="status" class="form-control">
				{$out.select_status}
			</select>
		</div>
		<button type="button" class="btn btn-primary mr-2" onclick="filter();"><i class="fa fa-fw fa-search"></i>
			Search</button>
	</div>
	<div class="col-sm-12">
		<div class="row mb-3">
			<div class="col-sm-6">
				Mô tả các chức năng:
				<div><i class="fa fa-space-shuttle" aria-hidden="true"></i> Đưa sản phẩm vào khu vực nhập khẩu</div>
				<div><i class="fa fa-star fa-fw"></i> Đưa sản phẩm vào Showcase, Tăng rank trên website</div>
			</div>
			<div class="col-sm-6">
				<div class="form-group mr-2">
					<div> Tổng sản phẩm đẩy top tối đa trong ngày : {$out.limit_push_top}</div>
					<div> Tổng sản phẩm đẩy top trong ngày : {$out.count_product_top}</div>
				</div>
			</div>
		</div>
	</div>
	{* {php} echo get_forecast($zipcode); {/php}*}
	<table class="table table-bordered">
		<tr>
			<th>Sản phẩm</th>
			<th>Giá bán</th>
			<th>Active/Featured</th>
			<th></th>
		</tr>
		{foreach from=$result item=data}
		<tr id="FID{$data.id}">
			<td width="50%">
				<div class="row row-sm">
					<div class="col-2">
						<a href="javascript:void(0);" class="img-thumbnail d-block"><img alt="{$data.name}"
								src="{$data.avatar}" width="100%"></a>
					</div>
					<div class="col-10">
						<p class="mb-1"><a href="{$data.url}">{$data.name}</a></p>
						<p class="mb-0"><small><i class="fa fa-fw fa-tag"></i>{$data.category} &nbsp;|&nbsp; <a
									href="{$data.url_edit_cate}"><i class="fa fa-pencil"></i> sửa</a></small></p>
						<p class="mb-0">
							<small>Views: {$data.views} | Score: {$data.score} | Orders:
								{$data.orders|default:0}</small>
						</p>
					</div>
				</div>
			</td>
			<td>Giá từ: <b>{$data.price|number_format}đ</b></td>
			<td>{$data.status}</td>
			<td class="text-right">
				{if empty($product_id_arr[$data.id])}
				<button type="button" data-toggle="tooltip" data-placement="top" data-page-id=""
					data-product-id="{$data.id}" title="Sản phẩm đẩy top" class="btn btn-light btn-sm"
					onclick="PushTopProduct({$data.id});">
					<i class="fa fa-level-up fa-fw"></i>
				</button>
				{else}
				<button type="button" data-toggle="tooltip" data-placement="top" data-page-id=""
					data-product-id="{$data.id}" title="Sản phẩm đẩy top" class="btn btn-light btn-sm"
					onclick="PushTopProduct({$data.id});">
					<i class="fa fa-level-up fa-fw" style="font-size:30px;color:red"></i>
				</button>
				{/if}
				{if $data.isimport eq 0 && $data.pagetype eq 8}
				<button type="button" class="btn btn-light btn-sm" onclick="SetImportProduct({$data.id});"
					title="Đưa sản phẩm vào khu vực Nhập Khẩu">
					<i class="fa fa-space-shuttle" aria-hidden="true"></i>
				</button>
				{/if}
				{if $data.iswhole eq 0}
				<button type="button" class="btn btn-light btn-sm" onclick="SetWholeProduct({$data.id});"
					title="Là sản phẩm phân phối">
					<i class="fa fa-cloud-upload" aria-hidden="true"></i>
				</button>
				{/if}
				{if $data.ismain eq 0}
				<button type="button" class="btn btn-light btn-sm" onclick="SetMainProduct({$data.id});"
					title="Đưa sản phẩm vào Showcase, tăng rank"><i class="fa fa-star fa-fw"></i></button>
				{/if}
				<button type="button" class="btn btn-light btn-sm" onclick="LoadCopy({$data.id});"><i
						class="fa fa-clone fa-fw"></i></button>
				<a href="{$data.url_edit}" class="btn btn-light btn-sm"><i class="fa fa-pencil fa-fw"></i></a>
				<button type="button" class="btn btn-light btn-sm"
					onclick="DeleteItem('', {$data.id}, 'product', 'ajax_delete');"><i
						class="fa fa-trash fa-fw"></i></button>
			</td>
		</tr>
		{/foreach}
	</table>
	<nav aria-label="Page navigation example">
		{$paging}
	</nav>
</div>
<div class="modal fade" tabindex="-1" id="CopyProduct">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Sao chép sản phẩm</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Tên sản phẩm</label>
					<input type="hidden" value="" name="id">
					<input type="text" class="form-control" name="name">
					<small class="form-text text-muted">Nhập tên sản phẩm mới bạn đang cần copy từ sản phẩm
						trên.</small>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
				<button type="button" class="btn btn-primary" onclick="Copy();">Lưu thông tin</button>
			</div>
		</div>
	</div>
</div>
{literal}
<script>
	function PushTopProduct(id) {
		var data = {};
		data['product_id'] = id;
		data['ajax_action'] = 'push_top_product';
		loading();
		$.post('?mod=product&site=mains', data).done(function (e) {
			data = JSON.parse(e);
			if (data.code == 0) {
				noticeMsg('Thông báo', data.msg, 'error');
				endloading();
			} else {
				noticeMsg('Thông báo', data.msg, 'success');
				setTimeout(function () {
					location.reload();
				}, 1000);
			}
		});
	}
	function filter() {
		var key = $("#filter_key").val();
		var status = $("#status").val();
		var category = $("#category").val();
		var url = "?mod=product&site=index";
		if (key != '') url = url + "&key=" + key;
		if (status != -1) url = url + "&status=" + status;
		if (category != 0) url = url + "&category=" + category;
		location.href = url;
	}
	function LoadCopy(id) {
		$("#CopyProduct input").val('');
		$("#CopyProduct input[name=id]").val(id);
		$("#CopyProduct").modal('show');
	}
	function Copy() {
		var data = {};
		data['id'] = $("#CopyProduct input[name=id]").val();
		data['name'] = $("#CopyProduct input[name=name]").val();
		data['ajax_action'] = 'copy_product';
		if (data['name'] == '') {
			noticeMsg('Thông báo', 'Vui lòng nhập tên sản phẩm copy', 'error');
			$("#CopyProduct input[name=name]").focus();
			return false;
		}
		loading();
		$.post('?mod=product&site=index', data).done(function (e) {
			if (e == 0) {
				noticeMsg('Thông báo', 'Không thể copy sản phẩm, gặp vấn đề về hệ thống', 'error');
			} else {
				noticeMsg('Thông báo', 'Copy sản phẩm thành công', 'success');
				location.reload();
			}
			endloading();
		});
	}

	function SetMainProduct(id) {
		var data = {};
		data['id'] = id;
		data['ajax_action'] = 'set_main_product';
		loading();
		$.post('?mod=product&site=mains', data).done(function (e) {
			data = JSON.parse(e);
			if (data.code == 0) {
				noticeMsg('Thông báo', data.msg, 'error');
				endloading();
			} else {
				noticeMsg('Thông báo', data.msg, 'success');
				setTimeout(function () {
					location.reload();
				}, 1000);
			}
		});
	}
	function SetImportProduct(id) {
		var data = {};
		data['id'] = id;
		data['ajax_action'] = 'set_import_product';
		loading();
		$.post('?mod=product&site=mains', data).done(function (e) {
			data = JSON.parse(e);
			if (data.code == 0) {
				noticeMsg('Thông báo', data.msg, 'error');
				endloading();
			} else {
				noticeMsg('Thông báo', data.msg, 'success');
				setTimeout(function () {
					location.reload();
				}, 1000);
			}
		});
	}
	function SetWholeProduct(id) {
		var data = {};
		data['id'] = id;
		data['ajax_action'] = 'set_whole_product';
		loading();
		$.post('?mod=product&site=mains', data).done(function (e) {
			data = JSON.parse(e);
			if (data.code == 0) {
				noticeMsg('Thông báo', data.msg, 'error');
				endloading();
			} else {
				noticeMsg('Thông báo', data.msg, 'success');
				setTimeout(function () {
					location.reload();
				}, 1000);
			}
		});
	}

</script>
{/literal}