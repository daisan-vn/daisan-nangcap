<div id="rfq-banner">
	<div class="container">
		<div class="rfq-filter">
			
			<div class="card shadow py-4">
				<div class="card-body text-center">
					<h1 class="text-b mb-4">TÌM KIẾM NỘI DUNG TRÊN RFQ</h1>
					<div class="form-inline justify-content-center mb-3">
						<div class="form-group">
							<select class="form-control form-control-lg" id="location">{$out.location}</select>
						</div>
						<div class="form-group ml-2">
							<input type="text" class="form-control form-control-lg" id="filter_key"
								placeholder="Từ khóa" value="{$out.min_number|default:''}" style="width: 200px;">
						</div>
						<div class="form-group ml-2">
							<input type="text" class="form-control form-control-lg" id="min_number"
								placeholder="Min" value="{$out.min_number|default:''}" style="width: 80px;">
						</div>
						<div class="form-group ml-2">
							<input type="text" class="form-control form-control-lg" id="max_number"
								placeholder="Max" value="{$out.max_number|default:''}" style="width: 80px;">
						</div>
						<div class="form-group ml-2">
							<button type="button" class="btn btn-primary btn-lg ml-2" onclick="filter();"><i class="fa fa-search"></i> Tìm yêu cầu</button>
						</div>
					</div>
					<a href="{$arg.url_sourcing}" class="btn btn-outline-secondary rounded-pill text-lg"><i class="fa fa-arrow-left"></i> Về Trang Chủ RFQ</a>
					<a href="{$arg.url_sourcing}?site=createRfq" class="btn btn-contact-o rounded-pill ml-2 text-lg">Gửi RFQ <i class="fa fa-arrow-right"></i> </a>
				</div>
			</div>
		</div>
	</div>
</div>			

<script type="text/javascript">
	function Setintime(number) {
		$("#intime").val(number);
		filter();
	}

	// function filter() {
	// 	var key = $.trim($("#keyword").val());
	// 	var location = $("#location").val();
	// 	var intime = $("#intime").val();
	// 	var min_number = $("#min_number").val();
	// 	var max_number = $("#max_number").val();
	// 	var cat_level_0 = $("#Cate0 select").val();
	// 	var cat_level_1 = $("#Cate1 select").val();
	// 	var cat_level_2 = $("#Cate2 select").val();
	// 	var url = arg.url_sourcing+'?site=search';
	// 	if (cat_level_0 != 0)
	// 		url = url + "&cat_level_0=" + cat_level_0;
	// 	if (cat_level_1 != 0)
	// 		url = url + "&cat_level_1=" + cat_level_1;
	// 	if (cat_level_2 != 0)
	// 		url = url + "&cat_level_2=" + cat_level_2;
	// 	if (intime != 0)
	// 		url = url + "&intime=" + intime;
	// 	if (location != 0)
	// 		url = url + "&location=" + location;
	// 	if (min_number != '')
	// 		url = url + "&min_number=" + min_number;
	// 	if (max_number != '')
	// 		url = url + "&max_number=" + max_number;
	// 	if (key != '')
	// 		url = url + "&key=" + key;
	// 	window.location.href = url;
	// }

	function filter() {
		var key = $.trim($("#filter_key").val());
		var location = $("#location").val();
		var min_number = $("#min_number").val();
		var max_number = $("#max_number").val();
		var url = arg.url_sourcing+'?site=search';
		if (location != 0)
			url = url + "&location=" + location;
		if (min_number != '')
			url = url + "&min_number=" + min_number;
		if (max_number != '')
			url = url + "&max_number=" + max_number;
		if (key != '')
			url = url + "&k=" + key;
		window.location.href = url;
	}
</script>