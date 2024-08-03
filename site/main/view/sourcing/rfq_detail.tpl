{include file='../includes/bnrfq.tpl'}

<div class="py-4">
	<div class="container">
		<div class="d-flex bd-highlight">
			<div class="flex-grow-1 bd-highlight">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="./">Trang chủ</a></li>
					<li class="breadcrumb-item"><a href="{$arg.url_sourcing}">Yêu cầu báo giá</a></li>
					<li class="breadcrumb-item"><a href="{$arg.url_sourcing}?site=search">Tất cả RFQ </a></li>
					<li class="breadcrumb-item active" aria-current="page"> "{$rfq.title}" </li>
				</ol>
			</nav>
			</div>
			<!-- <a href="#" class="text-dark"><i class="fa fa-share fa-fw" aria-hidden="true"></i>Báo cáo RFQ này</a> -->
		</div>
		<div class="row row-nm">
			<div class="col-xl-9">
				<div class="card shadow mb-3">
					<div class="card-body py-5">
						<h1>
							<a class="text-dark" href="{$rfq.product_url|default:'#'}">{$rfq.title}</a>
						</h1>
						<div class="rfq-info-other">
							<div class="brh-rfq-item__rating mr-3">
								<img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png">
								<img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png">
								<img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png">
								<span class="col-gray ml-2">Số lượng yêu cầu:</span>
								<span class="brh-rfq-item__quantity-num">{$rfq.number} {$rfq.unit}</span>
								{if $rfq.location}
								<span class="col-gray ml-2">Khu vực:</span>
								<span>{$rfq.location}, Việt Nam</span>
								{/if}
								<span class="col-gray ml-2">Ngày đăng:</span>
								<span class="brh-rfq-item__country-flag">
									{$rfq.created|date_format:'%H:%M %Y-%m-%d'}
								</span>
							</div>
						</div>
						
						{if $rfq.description}
						<div class="my-3">
							<div class="label">Nội dung yêu cầu:</div>
							<div class="value">{$rfq.description}</div>
						</div>
						{/if}
						
						<div class="avatar d-flex align-items-center py-3">
							<img src="{$arg.noimg}"
								class="rounded-circle" height="25">
							<div class="pl-2">{$rfq.user|default:"Khách vãng lai"}</div>
						</div>
						<div class="mt-2 rfq-tags">
							<span class="text-sm-bo mr-2">Người mua đang hoạt động</span>
							<span class="text-sm-bo">Đã xác nhận Email</span>
						</div>
					</div>
					<div class="card-footer">
						<div class="d-flex flex-row align-items-center my-4">
							<div class="p-2 bd-highlight"><a href="javascript:void(0)" class="btn btn-contact-o" data-toggle="modal"
								data-target="#FormQuotation">Gửi báo giá ngay</a>
							</div>
							<div class="p-2 bd-highlight">Sẵn có <font color="#f60" class="px-1">{$out.number_quotation}
								</font>
							</div>
							<div class="p-2 bd-highlight">Thời gian còn lại: {$rfq.endtime|date_format:'%H:%M %Y-%m-%d'}
							</div>
						</div>
					</div>
				</div>
				{if count($quotations) gt 0}
				<div class="card shadow rounded-0 mt-3">
					<div class="card-body">
						<h3 class="mb-3">Danh sách báo giá cho yêu cầu này</h3>
						<ul class="list-group">
							{foreach from=$quotations item=data}
							<li class="list-group-item">
								<div class="row row-sm">
									<div class="col-md-1">
										<img alt="{$data.page_name}" src="{$data.page_logo}" class="w-100 img-thumbnail">
									</div>
									<div class="col-md-10">
										<h5 class="my-1">{$data.page_name}</h5>
										<p>{$data.description}</p>
										<p>Gửi lúc: {$data.created|date_format:'%H:%M %Y-%m-%d'}</p>
									</div>
								</div>
							</li>
							{/foreach}
						</ul>
					</div>
				</div>
				{/if}
			</div>
			<div class="col-xl-3">
				<div class="card shadow">
					<div class="card-header">
						<h3>Đề xuất RFQs</h3>
					</div>
					<ul class="list-group list-group-flush">
						{foreach from=$other item=data}
						<li class="list-group-item">
							<p class="mb-1"><a href="{$data.url}" class="text-dark text-b">{$data.title}</a></p>
							<p class="mb-0">
								<span class="col-gray">Cần:</span> <b class="text-success">{$data.number}</b> {$data.unit}
								{if $data.location}
								<span class="col-gray ml-2">Tới:</span> {$data.location}
								{/if}
							</p>
							<p class="mb-0"><span class="text-sm-o">Thời gian đăng: {$data.created|date_format:'%H:%M %Y-%m-%d'}</span></p>
						</li>
						{/foreach}
					</ul>
				</div>
			</div>
		</div>
		
		<h2 class="text-b text-center py-4">Danh sách yêu cầu báo giá mới nhất</h2>
		<div class="row row-nm">
			{foreach from=$other_new item=data}
			<div class="col-md-6">
				<div class="card shadow mb-3">
					<div class="card-body">
						<div class="media mb-3">
							<div class="img-thumbnail mr-2 ">
								<a href="{$data.url}"><img src="{$data.avatar}" width="40"></a>
							</div>
							<div class="media-body">
								<h3 class="mt-1 text-lg">
									<a href="{$data.url}" class="text-dark">{$data.title}</a>
								</h3>
							</div>
						</div>
						<div class="rfq-info-other">
							<div class="mr-3">
								<b class="mr-1">Số lượng cần:</b>
								<span class="mr-3">{$data.number} {$data.unit}</span>
								{if $data.location} 
								<b class="mr-1">Giao tới:</b>
								<span class="mr-2">{$data.location}, Việt Nam</span> 
								{/if}
							</div>
						</div>
						<div class="col-gray mt-3 form-inline">
							<span><i class="fa fa-clock-o"></i> {$data.created|date_format:'%H:%M %d/%m/%Y'}</span>
							<a class="mr-2 ml-auto" href="{$data.url}">Gửi Báo Giá</a>
							<a href="{$data.url}" class="btn btn-contact-o rounded-pill">Xem Chi Tiết</a>
						</div>
					</div>
				</div>
			</div>
			<!--end rfq-item-->
			{/foreach}
		</div>
		
		
	</div>
</div>
<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body text-center">
				<h3>Nhận 5 RFQ miễn phí</h3>
				<p>Chỉ những người bán được chọn mới đủ điều kiện nhận quyền truy cập RFQ miễn phí sau khi họ đã gửi
					thông tin doanh nghiệp và vượt qua xác nhận qua điện thoại. </p>
				<button type="button" class="btn btn-primary">Save changes</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" tabindex="-1" role="dialog" id="FormQuotation">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Gửi báo giá cho yêu cầu</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<input type="hidden" name="rfq_id" value="{$rfq.id}">
				<div class="form-group">
					<label class="col-form-label">Báo giá với tư cách:</label>
					<select class="form-control" name="page_id"
						onchange="SetProducts(this.value);">{$out.s_pages}</select>
				</div>
				<div class="row row-sm mb-3">
					<div class="col-md-4">
						<span class="border d-block">
							<img src="{$arg.noimg}" id="ShowImg" width="100%">
						</span>
					</div>
					<div class="col-md-8">
						<input type="file" id="UploadImg" onchange="LoadImage(this);">
						<input type="hidden" name="image">
						<small class="form-text text-muted"> Kích thước file tối đa 2Mb, hỗ trợ định dạng jpg,
							png.</small>
					</div>
				</div>
				<div class="form-group">
					<textarea class="form-control" name="description" rows="4"
						placeholder="Nội dung báo giá"></textarea>
				</div>

				<div class="form-group row">
					<label for="staticEmail" class="col-sm-2 col-form-label">Giá báo</label>
					<div class="col-sm-6">
						<input type="text" class="form-control" name="price">
					</div>
				</div>

				<div class="form-group">
					<label class="col-form-label">Sản phẩm đính kèm theo báo giá</label>
					<select class="form-control" name="product_id">{$out.s_products}</select>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
				<button type="button" class="btn btn-primary" onclick="SaveQuotation();">Lưu báo giá</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	function SaveQuotation() {
		var data = {};
		data.rfq_id = $("#FormQuotation input[name=rfq_id]").val();
		data.page_id = $("#FormQuotation select[name=page_id]").val();
		data.product_id = $("#FormQuotation select[name=product_id]").val();
		data.description = $("#FormQuotation textarea[name=description]").val();
		data.price = $("#FormQuotation input[name=price]").val();
		data.image = $("#FormQuotation input[name=image]").val();
		if (data.description.length < 10 || data.description.length > 1000) {
			noticeMsg('System Message', 'Vui lòng nhập nội dung báo giá có 10~1000 ký tự.', 'error');
			$("#FormQuotation textarea[name=description]").focus();
			return false;
		}
		//console.log(data);
		data.ajax_action = 'save_quotation';
		loading();
		$.post(arg.url_sourcing+'?site=ajax_handle', data).done(function (e) {
			var rt = JSON.parse(e);
			if (rt.code == 0) {
				noticeMsg('System Message', rt.msg, 'error');
				endloading();
			} else {
				noticeMsg('System Message', rt.msg, 'success');
				setTimeout(function () {
					location.reload();
				}, 1500);
			}
		});
	}

	function SetProducts(page_id) {
		loading();
		var data = {};
		data.page_id = page_id;
		data.ajax_action = 'load_page_products';
		$.post(arg.url_sourcing+'?site=ajax_handle', data).done(function (e) {
			$("#FormQuotation select[name=product_id]").html(e);
			endloading();
		});
	}

	function LoadImage(input) {
		loading();
		if (input.files && input.files[0]) {
			var fileImg = input.files[0];
			var _URL = window.URL || window.webkitURL;
			var img = new Image();
			img.onload = function () {
				if (this.width / this.height > 5 || this.width / this.height < 0.2) {
					noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp vui lòng chọn lại.', 'error');
					$("#UploadImg").val('');
					$("#FormQuotation input[name=image]").val('');
					$("#ShowImg").attr('src', arg.noimg);
					return false;
				} else {
					var reader = new FileReader();
					reader.onload = function (e) {
						$("#ShowImg").attr('src', e.target.result);
						$("#FormQuotation input[name=image]").val(e.target.result);
					}
					reader.readAsDataURL(fileImg);
				}
			}
			img.src = _URL.createObjectURL(fileImg);
			endloading();
		}
	}

</script>