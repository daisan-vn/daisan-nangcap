{include file='../includes/bnrfq.tpl'}

<div class="py-4">
	<div class="container">

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
		{if $paging}
		<div class="p-3">{$paging}</div>
		{/if}


		<!-- <div class="card rounded-0">
			<div class="card-header bg-white py-3">Có <b>{$out.number|default:0}</b> yêu cầu đang cần báo giá</div>
			<div class="list-group list-group-flush">
				{foreach from=$rfq item=data}
				<div class="list-group-item rfq-item py-4">
					<div class="row">
						<div class="col-xl-7">
							<div class="media">
								<div class="img-thumbnail mr-3 ">
									<a href="{$data.url}"><img src="{$data.avatar}" width="160"></a>
								</div>
								<div class="media-body">
									<h3 class="mt-0 text-nm-1"><a href="{$data.url}" class="text-dark">{$data.title}</a></h3>
									<div class="rfq-info-other">
										<div class="mr-3">
											<img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png">
											<img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png">
											<img src="//s.alicdn.com/@img/tfs/TB1lpHHdQL0gK0jSZFtXXXQCXXa-16-16.png">
											<span class="col-gray ml-2">Số lượng yêu cầu:</span>
											<span>{$data.number} {$data.unit}</span>
											{if $data.location}
											<span class="col-gray ml-2">Khu vực:</span>
											<span>{$data.location}, Việt Nam</span>
											{/if}
										</div>
									</div>
									<div class="line-2">{$data.description}</div>
									<div class="col-gray">
										<span><i class="fa fa-clock-o"></i> {$data.created|date_format:'%H:%M %d/%m/%Y'}</span>
									</div>
								</div>
							</div>
						</div>
						<div class="col-xl-5">
							<div class="row h-100">
								<div class="col-6 brh-rfq-item__other-info">
									<div class="avatar d-flex align-items-center">
										<img src="{$arg.noimg}" class="rounded-circle" height="25">
										<div class="pl-2">{$data.user}</div>
									</div>

									<div class="mt-2 rfq-tags">
										<span class="text-sm-bo">Đã xác nhận Email</span>
									</div>
								</div>
								<div class="col-6 text-center">
									<a class="btn btn-contact-o" href="{$data.url}">Gửi báo giá ngay</a>
									<p class="pt-2 ">Số báo giá còn lại <font color="#f60">10</font></p>
								</div>
							</div>
						</div>
					</div>
				</div>
				end rfq-item
				{/foreach}
				{if $paging}
				<div class="p-3">{$paging}</div>
				{/if}
			</div>
		</div> -->
	</div>
</div>