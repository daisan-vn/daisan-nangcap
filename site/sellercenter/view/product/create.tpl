<div class="card-header">
	<h3>Khởi tạo sản phẩm</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	<div class="card mb-3">
		<div class="card-header mb-3"> Quét sản phẩm tự động cho gian hàng từ website
		</div>
		<div class="card-body">
			<p>Tự động quét tất cả các link theo domain website để tìm kiếm và lưu sản phẩm mới cho gian hàng</p>
			<div>
				<i class="fa fa-fw fa-circle"></i> Trang: <b>{$page.name|default:''}</b>
				<i class="fa fa-fw fa-globe mx-3"></i> Domain: <b>{$page.website|default:''}</b>
			</div>
			<hr>
			<a href="?mod=scandb&site=autorun&id={$page.pid|default:''}" class="btn btn-success">
				<i class="fa fa-play fa-fw"></i>Bắt đầu quét dữ liệu
			</a>
		</div>
	</div>
	{if $out.numb_product lt $out.numb_create}
	<p>Số lượng sản phẩm bạn đăng là <b>{$out.numb_create}</b>, đã đạt giới hạn của gói.</p>
	{else if $page.score gt 50}
	<div class="card">
		<div class="card-header mb-3">Tạo mới sản phẩm</div>
		<div class="card-body">
			<input type="hidden" name="id" value="{$out.id|default:0}">
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Danh mục</label>
				<div class="col-sm-4">
					<select class="form-control" onchange="LoadCategory(this.value, 0);">
						{$out.select_category}
					</select>
				</div>
			</div>
			<div class="form-group row" id="Cate1">
				<label class="col-sm-2 col-form-label"></label>
				<div class="col-sm-4">
					<select class="form-control" onchange="LoadCategory(this.value, 1);">
						{$out.select_category_sub1}
					</select>
				</div>
			</div>
			<div class="form-group row" id="Cate2">
				<label class="col-sm-2 col-form-label"></label>
				<div class="col-sm-4">
					<select name="taxonomy_id" class="form-control" onchange="LoadCategory(this.value, 2);">
						{$out.select_category_sub2}
					</select>
				</div>
			</div>

			<div class="form-group row">
				<div class="col-sm-2"></div>
				<div class="col-sm-10">
					<button type="button" onclick="CreateProduct();" class="btn btn-primary">Khởi tạo sản phẩm</button>
				</div>
			</div>
		</div>
	</div>
	{else}
	<h3>Gian hàng bạn đang đạt {$page.score} điểm hoàn thành</h3>
	<p>Vui lòng cập nhật thông tin gian hàng đạt trên <b>70</b> điểm mới thêm được sản phẩm mới.</p>
	<p>
		<a href="?mod=profile&site=index" class="btn btn-primary btn-sm">Cập nhật thông tin gian hàng</a>
	</p>
	{/if}

</div>

<script type="text/javascript">

	function LoadCategory(id, level) {
		var Data = {};
		Data['id'] = id;
		Data['ajax_action'] = "load_category";
		var id_set = level + 1;

		loading();
		$.post('?mod=product&site=create', Data).done(function (e) {
			$("#Cate" + id_set + " select").html(e);
			endloading();
		});
	}


	function CreateProduct() {
		var Data = {};
		Data['taxonomy_id'] = $("select[name=taxonomy_id]").val();
		Data['id'] = $("input[name=id]").val();

		if (Data['taxonomy_id'] == 0 || Data['taxonomy_id'] == '' || Data['taxonomy_id'] == null) {
			noticeMsg('Thông báo', 'Vui lòng chọn danh mục sản phẩm.', 'error');
			$("select[name=taxonomy_id]").focus();
			return false;
		}
		Data['ajax_action'] = "create_product";
		loading();
		$.post('?mod=product&site=create', Data).done(function (e) {
			var rt = JSON.parse(e);
			if (rt.code == 0) {
				noticeMsg('Thông báo', rt.msg, 'error');
				endloading();
			} else {
				noticeMsg('Thông báo', 'Khởi tạo sản phẩm thành công.', 'success');
				setTimeout(function () {
					location.href = "?mod=product&site=editdetail&id=" + rt.code;
				}, 2000);
			}
		});
	}
</script>