<div class="card-header">
	<h3>Danh sách quảng cáo sản phẩm</h3>
	<hr>
	<div class="alltabs">{$page_menu}</div>
</div>

<div class="card-body">
	<div id="AllProduct">
		<input type="text" class="form-control" placeholder="" value=""
			onchange="LoadProduct(this.value)">
		<div id="LoadProduct"></div>
	</div>
</div>
<link href="{$arg.stylesheet}plugins/chosen/chosen.min.css"
	rel="stylesheet">
<script src="{$arg.stylesheet}plugins/chosen/chosen.jquery.min.js"></script>

{literal}
<script>
	$(window).ready(function() {
		$(".chosen").chosen({
			disable_search_threshold : 10
		});
		$(".datepicker").datepicker({
			dateFormat : 'dd-mm-yy',
			minDate : '0'
		});
	});

	function filter() {
		var key = $("#filter_key").val();
		var status = $("#status").val();
		var category = $("#category").val();
		var url = "?mod=product&site=index";
		if (key != '')
			url = url + "&key=" + key;
		if (status != -1)
			url = url + "&status=" + status;
		if (category != 0)
			url = url + "&category=" + category;
		location.href = url;
	}

	function LoadForm(id) {
		$("#Form input").val('');
		$("#Form input[name=id]").val(id);
		var data = {};
		data.id = id;
		data.ajax_action = 'load_form';
		$.post('?mod=product&site=ads', data).done(function(e) {
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

	function SaveForm() {
		var data = {};
		data.id = $("#Form input[name=id]").val();
		data.position = $("#Form select[name=position]").val();
		data.started = $("#Form input[name=started]").val();
		data.keyword = $("#Form input[name=keyword]").val();
		data.product_id = $("#Form select[name=product_id]").val();
		data.ajax_action = 'save_form';

		if (data.keyword.length < 6) {
			noticeMsg('Thông báo', 'Vui lòng nhập từ khóa tối thiểu 6 ký tự',
					'error');
			$("#Form input[name=keyword]").focus();
			return false;
		}

		loading();
		$.post('?mod=product&site=ads', data).done(
				function(e) {
					var rt = JSON.parse(e);
					if (rt.code == 0)
						noticeMsg('Thông báo', rt.msg, 'error');
					else {
						noticeMsg('Thông báo',
								'Lưu thông tin quảng cáo sản phẩm thành công',
								'success');
						location.reload();
					}
					endloading();
				});
	}
	function LoadProduct(key) {
		if (key == '') {
			noticeMsg('System Message', 'Vui lòng nhập từ khóa.', 'error');
			$("#AllProduct input").focus();
			return false;
		}
		loading();
		$('#LoadProduct').load("?mod=product&site=load_products", {
			'key' : key
		}, function() {
			$("input[name=service_id]").val('');
			$("#LoadUsers").removeClass('d-none');
			$("#LoadUsers").addClass('d-block');
			endloading();
		});
	}
</script>
{/literal}
