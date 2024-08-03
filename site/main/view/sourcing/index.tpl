<div id="rfq-banner-index">
	<div class="container">
		<div class="text-center col-white">
			<h1 class="text-b">THỊ TRƯỜNG NGUỒN HÀNG TOÀN QUỐC</h1>
			<h3 class="text-b">Nhận báo giá từ các nhà cung cấp phù hợp nhất</h3>
			<div class="mt-5">
				<a href="{$arg.url_sourcing}?site=createRfq" class="btn btn-contact-o btn-lg text-lg rounded-pill mr-3 px-4">Gửi RFQ <i class="fa fa-arrow-circle-right"></i></a>
				<a href="{$arg.url_sourcing}?site=search" class="col-white text-lg">Tôi là nhà cung cấp</a>
			</div>
		</div>
	</div>
</div>

<div class="py-4">
	<div class="container">
		<h2 class="text-center text-b mb-4">Hướng dẫn sử dụng RFQ</h2>
		<div class="card mb-4 shadow">
			<div class="card-body">
				<div class="row">
					<div class="col-md-4 text-center">
						<h3>01- Gửi RFQ</h3>
						<img class="my-3" src="https://img.alicdn.com/tfs/TB107kiwYj1gK0jSZFuXXcrHpXa-530-418.png" style="height: 168px">
						<p class="text-b text-warning text-lg">Nhận nhiều báo giá</p>
					</div>
					<div class="col-md-4 text-center">
						<h3>02- Phân tích báo giá</h3>
						<img class="my-3" src="https://img.alicdn.com/tfs/TB1Mm3cw8v0gK0jSZKbXXbK2FXa-532-410.png" style="height: 168px">
						<p class="text-b text-warning text-lg">Xác định các nhà cung cấp phù hợp</p>
					</div>
					<div class="col-md-4 text-center">
						<h3>03- Giao tiếp thời gian thực</h3>
						<img class="my-3" src="https://img.alicdn.com/tfs/TB1t1Icw7L0gK0jSZFtXXXQCXXa-566-372.png" style="height: 168px">
						<p class="text-b text-warning text-lg">Phát triển quan hệ đối tác với nhà cung cấp</p>
					</div>
				</div>
			</div>
		</div>
		
		<h2 class="text-center text-b mb-4">RFQ gần đây nhất từ ​​các ngành khác nhau</h2>
		<div class="row row-nm">
			{foreach from=$rfq item=data}
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