<div class="main-content-wrap">
	<div class="container container-cate">
		<div class="row row-nm">
			<div class="col-xl-8">
				<div class="card border-0">

					<div class="card-body" id="FrmCont">
						<div class="border">
							<div class="card-header border-0">
								<h3 class="py-3">Thông tin đặt hàng</h3>
							</div>
							<div class="card-body col-xl-10">
								<div class="form-group">
									<label>Họ tên</label>
									<input type="text" class="form-control" name="name" value="{$out.user.name|default:''}">
								</div>
								<div class="form-group">
									<label>Số điện thoại</label>
									<input type="text" class="form-control" name="phone" value="{$out.user.phone|default:''}">
								</div>
								<div class="form-group">
									<label>Địa chỉ nhận hàng</label>
									<input type="text" class="form-control" name="address" value="{$out.user.address|default:''}">
								</div>
								<div class="form-group">
									<label>Mô tả thêm</label>
									<textarea class="form-control" name="description" rows="4"></textarea>
								</div>

								<div class="form-group">
									<div class="form-check">
										<input class="form-check-input" type="radio" name="pay_method" id="r1" value="1" checked>
										<label class="form-check-label" for="r1"> Thanh toán bằng tiền mặt khi nhận hàng </label>
									</div>
								</div>
								<div class="form-group">
									<div class="form-check">
										<input class="form-check-input" type="radio" name="pay_method" id="r2" value="2">
										<label class="form-check-label" for="r2"> Thanh toán chuyển khoản qua ngân hàng </label>
									</div>
								</div>

								<div class="form-group">
									<div class="form-check">
										<input class="form-check-input" type="checkbox" name="update_user" value="1" id="c1" checked> 
										<label class="form-check-label" for="c1"> Cập nhật thông tin thanh toán vào hồ sơ cá nhân</label>
									</div>
								</div>
								<button type="button" onclick="Payment();" class="btn btn-block btn-contact-o btn-lg rounded-pill">Đặt Hàng Ngay</button>
								
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-xl-4">
				<div class="card border-0">
					<div class="card-body">
						{foreach from=$cart item=page}
						<div class="card-header">
							<p class="mb-3"><a href="{$page.url}">{$page.pagename}</a></p>
							<ul class="list-unstyled">
								{foreach from=$page.products item=data}
								<li class="media mb-2">
									<img src="{$data.avatar}" class="mr-3" alt="..." height="60">
									<div class="media-body">
										<h3 class="mt-0 mb-1 text-sm">{$data.name}</h3>
										<p>{$data.price|number_format}đ x {$data.number} =
											<b>{($data.number*$data.price)|number_format}đ</b></p>
									</div>
								</li>
								{/foreach}
							</ul>
						</div>
						{/foreach}
						<ul class="list-group list-group-flush">
							<li
								class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pb-0">
								Tổng tiền
								<span>{$out.total|number_format}đ</span>
							</li>
							<li class="list-group-item d-flex justify-content-between align-items-center px-0">
								Phí vận chuyển
								<span>Free</span>
							</li>
							<li
								class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 mb-3">
								<div>
									<strong>Tổng tiền đơn hàng</strong>
									<strong>
										<p class="mb-0">(Đã bao gồm VAT)</p>
									</strong>
								</div>
								<span class="payment_total">{$out.total|number_format}đ</span>
							</li>
						</ul>
						<a href="?mod=product&site=cart" class="btn btn-outline-secondary btn-block rounded-pill shadow">Cập nhật đơn hàng</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

{literal}
<script type="text/javascript">
	function Payment() {
		var data = {};
		data['name'] = $("#FrmCont input[name=name]").val();
		data['phone'] = $("#FrmCont input[name=phone]").val();
		data['email'] = $("#FrmCont input[name=email]").val();
		data['address'] = $("#FrmCont input[name=address]").val();
		data['description'] = $("#FrmCont textarea[name=description]").val();
		data['update_user'] = $("#FrmCont input[name=update_user]").prop("checked") ? 1 : 0;
		data['ajax_action'] = "payment";

		if (data.name.length < 6) {
			noticeMsg('System Message', 'Vui lòng nhập tên người mua tối thiểu 6 ký tự.');
			$("#FrmCont input[name=name]").focus();
			return false;
		} else if (data.phone.length < 10) {
			noticeMsg('System Message', 'Vui lòng nhập chính xác số điện thoại liên hệ của bạn.');
			$("#FrmCont input[name=phone]").focus();
			return false;
		} else if (data.address.length < 10) {
			noticeMsg('System Message', 'Vui lòng nhập chính xác địa chỉ nhận hàng.');
			$("#FrmCont input[name=address]").focus();
			return false;
		}

		loading();
		$.post('?mod=product&site=payment', data).done(function (e) {
			noticeMsg('System Message', 'Đặt mua đơn hàng thành công.', 'success');
			location.href = "?mod=product&site=order_confirm&oId="+e;
		});
	}
</script>
{/literal}