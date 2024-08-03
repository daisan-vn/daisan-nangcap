<div class="main-content-wrap" style="background:#f4f4f4;">
	<div class="container container-cate">
		<div class="row row-nm">
			<div class="col-xl-9">
				<!--
				<div class="card border-0 rounded-8 mb-3">
					<div class="card-body text-center" onclick="add_new_address()">
						<i class="fa fa-plus fa-2x"></i>
						<div class="alpha-7">Add New Address</div>
					</div>
				</div>-->
				{foreach from=$cart key=pageid item=page}
				{if count($page.products) gt 0}
				<div class="card border-0 rounded-8 mb-3">
					<div class="card-body">
						<h2 class="text-nm-1"><img src="{$arg.stylesheet}images/supplier-cart.png" height="18"
								class="pr-2">{$page.pagename}
						</h2>
						<div class="dropdown-divider pt-2"></div>
						<table class="table-cart border-bottom">
							<thead>
								<tr>
									<th class="product-image"></th>
									<th class="product-name">Sản phẩm</th>
									<th class="product-price d-none d-lg-table-cell">Giá bán</th>
									<th class="product-quanity d-none d-md-table-cell">Số lượng</th>
									<th class="product-total">Tổng</th>
									<th class="product-remove"></th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$page.products key=k item=data}
								<tr class="cart-item" id="item_id{$k}">
									<td class="product-image">
										<a href="{$data.url}" class="mr-3">
											<img src="{$data.avatar}" width="60">
										</a>
									</td>
									<td class="product-name" style="width: 30%;">
										<span class="pr-4 d-block">{$data.name}</span>
									</td>
									<td class="product-price d-none d-lg-table-cell">
										<span class="pr-3 d-block">{$data.price|number_format}</span>
									</td>
									<td class="product-quantity d-none d-md-table-cell">
										<div class="input-group input-group--style-2 pr-4" style="width: 130px;">
											<span class="input-group-btn">
												<button class="btn btn-number" type="button" onclick="ChangeNumber({$data.number-1},{$k},{$pageid});">
													<i class="fa fa-minus" aria-hidden="true"></i>
												</button>
											</span>
											<input type="text" class="form-control input-number" value="{$data.number|default:0}" height="100%" min="1"
												onchange="ChangeNumber(this.value,{$k},{$pageid});">
											<span class="input-group-btn">
												<button class="btn btn-number" type="button" onclick="ChangeNumber({$data.number+1},{$k},{$pageid});">
													<i class="fa fa-plus" aria-hidden="true"></i>
												</button>
											</span>
										</div>
									</td>
									<td class="product-total">
										<span>{($data.price*$data.number)|number_format}đ</span>
									</td>
									<td class="product-remove">
										<a href="javascript:void(0)" onclick="DeleteProduct({$k}, {$pageid});" class="text-right pl-4">
											<i class="fa fa-trash-o" aria-hidden="true"></i>
										</a>
									</td>
								</tr>
								{/foreach}

							</tbody>
						</table>
						<div class="row align-items-center pt-4">
							<div class="col-md-6">
								<a href="#" class="text-dark">
									<i class="fa fa-reply" aria-hidden="true"></i>
									Vào Shop
								</a>
							</div>
							<div class="col-md-6 text-right">
								Thành Tiền: <b>{$page.total|number_format}đ</b>
							</div>
						</div>
					</div>
				</div>
				{/if}
				{/foreach}
			</div>
			<div class="col-xl-3">
				<div class="card border-0 rounded-8">
					<div class="card-body">

						<h5 class="mb-3">Thông tin thanh toán</h5>
						<hr>
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
							<li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 mb-3">
								<div>
									<strong>Tổng tiền đơn hàng</strong>
									<strong>
										<p class="mb-0">(Đã bao gồm VAT)</p>
									</strong>
								</div>
								<span><strong>{$out.total|number_format}đ</strong></span>
							</li>
						</ul>

						<a href="?mod=product&site=payment" class="btn btn-block btn-contact-o rounded-pill">
							Tiến hành đặt hàng</a>

					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!--Modal-->
<div class="modal fade" id="new-address-modal" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-zoom" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h6 class="modal-title" id="exampleModalLabel">New Address</h6>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<form class="form-default" role="form" action="" method="POST">
				<input type="hidden" name="_token" value="">
				<div class="modal-body">
					<div class="p-3">
						<div class="row">
							<div class="col-md-2">
								<label>Address</label>
							</div>
							<div class="col-md-10">
								<textarea class="form-control textarea-autogrow mb-3" placeholder="Your Address"
									rows="1" name="address" required></textarea>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2">
								<label>Country</label>
							</div>
							<div class="col-md-10">
								<div class="mb-3">
									<select class="form-control mb-3 selectpicker"
										data-placeholder="Select your country" name="country" required>
										<option value="Afghanistan">Afghanistan</option>
										<option value="Albania">Albania</option>
										<option value="Algeria">Algeria</option>
										<option value="American Samoa">American Samoa</option>
										<option value="Andorra">Andorra</option>
										<option value="Angola">Angola</option>
										<option value="Anguilla">Anguilla</option>
										<option value="Antarctica">Antarctica</option>
									</select>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2">
								<label>City</label>
							</div>
							<div class="col-md-10">
								<input type="text" class="form-control mb-3" placeholder="Your City" name="city"
									value="" required>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2">
								<label>Postal code</label>
							</div>
							<div class="col-md-10">
								<input type="text" class="form-control mb-3" placeholder="Your Postal Code"
									name="postal_code" value="" required>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2">
								<label>Phone</label>
							</div>
							<div class="col-md-10">
								<input type="text" class="form-control mb-3" placeholder="+880" name="phone" value=""
									required>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-contact text-white">Save</button>
				</div>
			</form>
		</div>
	</div>
</div>
<!--end modal-->
{literal}
<script type="text/javascript">
	function add_new_address() {
		$('#new-address-modal').modal('show');
	}
</script>
{/literal}
{literal}
<script type="text/javascript">
	function DeleteProduct(id, page_id) {
		var data = {};
		data['id'] = id;
		data['page_id'] = page_id;
		data['ajax_action'] = "delete_product";
		loading();
		$.post('?mod=product&site=ajax_handle', data).done(function () {
			noticeMsg('System Message', 'Xóa sản phẩm trong giỏ hàng thành công.', 'success');
			location.reload();
		});
	}

	function ChangeNumber(number, id, page_id) {
		var data = {};
		data['id'] = id;
		data['number'] = number;
		data['page_id'] = page_id;
		data['ajax_action'] = "change_number_product";

		if (number < 1) {
			noticeMsg('System Message', 'Số lượng sản phẩm tối thiểu là 1.', 'error');
			$("#Numb" + id).focus();
			return false;
		}

		loading();
		$.post('?mod=product&site=ajax_handle', data).done(function () {
			noticeMsg('System Message', 'Cập nhật giỏ hàng thành công.', 'success');
			location.reload();
		});
	}


	function DeleteCart() {
		loading();
		$.post('?mod=product&site=ajax_handle', { 'ajax_action': 'delete_cart' }).done(function () {
			noticeMsg('System Message', 'Xóa giỏ hàng thành công.', 'success');
			location.reload();
		});
	}
</script>
{/literal}