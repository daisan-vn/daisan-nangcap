{foreach from=$result key=k item=data}
<div class="card oem-recommend">
	<div class="card-body">
		<div class="row">
			<div class="col-xl-2 d-none d-sm-block factory-cover">
				<a href="{$data.url}"><img src="{$data.logo}" class="mr-3 w-100 shadow" alt="{$data.name}"></a>
			</div>
			<div class="col-xl-10">
				<div class="factory-content">
					<div class="media mb-2">
						<div class="media-body">
							<h3 class="mt-0 text-oneline factory-intro-title"><a href="{$data.url}">{$data.name}</a></h3>
							<i class="fa fa-clock-o col-yearexp"></i> <b class="number">6</b> năm kinh nghiệm 
							{if $data.package_id ne 0} <i class="fa fa-gg-circle col-gold ml-3"></i> <span>Gold Supplier</span> {/if} 
							{if $data.is_verification ne 0} <i class="fa fa-check col-verify-1 ml-3"></i> <span class="col-verify">Đã xác minh</span> {/if} 
							<i class="fa fa-map-marker ml-3"></i> <span>{$data.province|default:'Đang cập nhật'}</span>
						</div>
						<a href="{$data.url_contact}" class="btn rounded-pill btn-contact">Liên Hệ Nhà Cung Cấp</a>
					</div>
					<div class="factory-contact">
						<div class="row row-nm">
							<div class="col-xl-4">
								<div class="content-message">
									<div class="message-bar">Triển khai kinh doanh</div>
									<div class="content-tag">
										<ul class="nav">
											<li class="nav-item"><a class="nav-link" href="{$data.url}">Kinh doanh Toàn quốc</a></li>
											<li class="nav-item"><a class="nav-link" href="{$data.url}">Kinh doanh Quốc tế</a></li>
										</ul>
									</div>
								</div>
							</div>
							<div class="col-xl-8">
								<div class="row row-nm">
									{foreach from=$data.metas item=product}
									<div class="col-xl-3 col-3">
										<a href="{$product.url}"><img src="{$product.avatar}" class="img-fluid"></a>
									</div>
									{/foreach}
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
{/foreach}
