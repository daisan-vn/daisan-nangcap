<div class="main-content-wrap">
	<div class="container-fluid container-cate mt-0">
		{include file='../includes/header_shop.tpl'}
		<div class="shop_main">
			<section class="shop_main-productlist px-3 px-sm-0 mt-3">
				<div class="card border-0">
					<table class="company-basicInfo w-100">
						<tbody>
							<tr>
								<td width="30%">Tên công ty:</td>
								<td>{$profile.name}</td>
							</tr>
							<tr>
								<td>Mã số thuế:</td>
								<td>{$profile.code}</td>
							</tr>
							<tr>
								<td>Ngày bắt đầu hoạt động:</td>
								<td>{$profile.date_start|date_format:'%d-%m-%Y'}</td>
							</tr>
							<tr>
								<td>Địa chỉ đăng ký kinh doanh:</td>
								<td>{$profile.address}</td>
							</tr>
						</tbody>
					</table>
				</div>
			</section>
		</div>
	</div>
</div>