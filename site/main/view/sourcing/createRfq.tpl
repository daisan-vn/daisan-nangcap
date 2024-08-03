{include file='../includes/bnrfq.tpl'}
<div class="{if !$is_mobile} container{/if}">
	<div class="card my-0 my-md-4 shadow">
		<div class="card-body">
			<div class="px-md-5 py-md-4" id="RfqForm">
				<h1>Yêu cầu báo giá từ nhiều nhà cung cấp (RFQ)</h1>
				<p class="my-md-4 d-md-block d-none">Nhận báo giá cho yêu cầu mua của bạn. Cho nhà cung cấp biết bạn đang cần gì</p>
				<hr>
				<div class="product-info d-md-block d-none mb-3">
					<h4>Hoàn thành yêu cầu báo giá của bạn</h4>
					<p>Thông tin càng cụ thể chi tiết, yêu cầu của bạn càng được
						đáp ứng nhanh và chính xác nhất.</p>
				</div>


				<div class="form-group row">
					<div class="col-sm-7">
						<input type="hidden" name="user_id" value="{$arg.login}">
						<input type="hidden" name="id" value="{$rfq.id|default:0}">
						<input type="text" class="form-control rounded-0" name="title"
							value="{$rfq.title|default:$out.title}"
							placeholder="Nhập yêu cầu cần báo giá hoặc tên sản phẩm bạn cần">
					</div>
					<label for="inputPassword"
						class="col-sm-5 col-form-label d-none d-md-block">Vui lòng nhập tên sản phẩm.</label>
				</div>
				<div class="form-inline mb-3 {if $is_mobile}d-none d-md-block{/if}">
					<div class="form-group">
						<label class="col-form-label">Chọn danh mục</label>
					</div>
					<div class="form-group mx-sm-2">
						<select class="form-control rounded-0"
							onchange="LoadCategory(this.value, 0);">{$out.select_category}
						</select>
					</div>
					<div class="form-group mx-sm-2" id="Cate1">
						<select class="form-control rounded-0"
							onchange="LoadCategory(this.value, 1);">{$out.select_category_sub1}
						</select>
					</div>
					<div class="form-group mx-sm-2" id="Cate2">
						<select class="form-control rounded-0" name="taxonomy_id">{$out.select_category_sub2}
						</select>
					</div>
				</div>
				<div class="form-group row {if $is_mobile}row-sm{else}row-nm{/if}">
					<div class="col-sm-2 col-4">
						<input type="text" class="form-control rounded-0" name="number"
							value="{$rfq.number|default:$out.number}" placeholder="Số lượng cần">
					</div>
					<div class="col-sm-2 col-3">
						<select class="form-control rounded-0" name="unit">{$out.product_unit}</select>
					</div>
					<label for="inputPassword" class="col-sm-5 col-form-label d-none d-md-block">Vui lòng nhập số lượng và chọn đơn vị.</label>
				</div>
				<div class="form-group row">
					<div class="col-sm-7">
						<textarea class="form-control rounded-0" name="description"
							placeholder="Mô tả chi tiết yêu cầu" rows="4">{$rfq.description|default:''}</textarea>
					</div>
					<label for="inputPassword" class="col-sm-5 col-form-label d-none d-md-block">
						<p>
							<b>Bạn có thể đưa thêm các mô tả về sản phẩm như:</b>
						</p>
						<p>- Màu sắc</p>
						<p>- Kích thước</p>
						<p>- Chất liệu</p>
						<p>- Quy cách đóng gói</p>
						<p class="mb-0">Để các nhà cung cấp hiểu rõ hơn về sản phẩm bạn cần.</p>
					</label>
				</div>
				<div class="row row-sm mb-3">
					<div class="col-md-2 col-4">
						<div class="img-thumbnail rounded-0">
							<img src="{$rfq.avatar|default:$arg.noimg}" class="w-100" id="ShowImg">
						</div>
					</div>
					<div class="col-md-4 col-8">
						<div class="form-group">
							<label for="exampleFormControlFile1" class="mb-2">Đăng lên một hình ảnh mô phỏng sản phẩm bạn muốn</label>
							<input type="file" class="form-control-file" id="ImgUpload" onchange="readURL(this, '#ShowImg');">
							<input type="hidden" name="image">
						</div>
					</div>
				</div>

				<div >
					<h4>Những yêu cầu khác</h4>
					<p class="mb-3">Những thông tin yêu cầu thêm để mô tả rõ hơn cho sản phẩm bạn cần.</p>
					<div class="form-group row row-sm">
						<div class="col-sm-1 col-3">
							<label class="col-form-label">Giá yêu cầu</label>
						</div>
						<div class="col-sm-2 col-5">
							<input type="text" class="form-control rounded-0" name="price" value="{$rfq.price|default:0|number_format}" placeholder="Giá yêu cầu">
						</div>
						<div class="col-sm-2 col-3">
							<select class="form-control rounded-0"><option>VND</option></select>
						</div>
					</div>
					<div class="form-inline mb-md-3">
						<div class="form-group">
							<label class="col-form-label">Thanh toán</label>
						</div>
						<div class="form-group mx-3">
							<select class="form-control rounded-0" name="payment_method">{$out.payment_method}</select>
						</div>
					</div>
					<div class="form-inline mb-md-3">
						<div class="form-group">
							<label class="col-form-label">Sản phẩm chuyển tới</label>
						</div>
						<div class="form-group mx-3">
							<select class="form-control rounded-0" name="location_id">{$out.location}</select>
						</div>
					</div>
				</div>
				<div class="my-4">
					<div>
						<input type="checkbox" aria-checked="true" value="on" checked>
						<span>Tôi đồng ý<span class="text-info"> các điều khoản và điều kiện </span> của Daisan.</span>
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-7">
						<button type="button" onclick="SaveRfq();" class="btn btn-danger btn-lg btn-block btnRfq">Gửi yêu cầu báo giá</button>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
function SaveRfq(){
	var data = {};
	data['id'] = $("#RfqForm input[name=id]").val();
	data['user_id'] = $("#RfqForm input[name=user_id]").val();
	data['title'] = $("#RfqForm input[name=title]").val();
	data['number'] = $("#RfqForm input[name=number]").val();
	data['unit'] = $("#RfqForm select[name=unit]").val();
	data['user_id'] = $("#RfqForm input[name=user_id]").val();
	data['description'] = $("#RfqForm textarea[name=description]").val();
	data['price'] = $("#RfqForm input[name=price]").val();
	data['image'] = $("#RfqForm input[name=image]").val();
	data['location_id'] = $("#RfqForm select[name=location_id]").val();
	data['taxonomy_id'] = $("#RfqForm select[name=taxonomy_id]").val();
	data['payment_method'] = $("#RfqForm select[name=payment_method]").val();
	
	data['ajax_action'] = 'save_rfq';
	
	console.log(data);
	//return false;
	
	if(data.title.length < 5){
		noticeMsg('System Message', 'Vui lòng nhập yêu cầu tối thiểu 5 ký tự', 'error');
		$("#RfqForm input[name=title]").focus();
		return false;
	}else if(!$.isNumeric(data.number)){
		noticeMsg('System Message', 'Vui lòng nhập chính xác số lượng', 'error');
		$("#RfqForm input[name=number]").focus();
		return false;
	}
	
	loading();
	$.post('?mod=sourcing&site=createRfq', data).done(function(e){
		var rt = JSON.parse(e);
		if(rt.code==0){
			noticeMsg('System Message', rt.msg, 'error');
			endloading();
		}else{
			noticeMsg('System Message', rt.msg, 'success');
			$("#RfqForm input[name=title]").val('');
			$("#RfqForm input[name=number]").val('');
			setTimeout(function(e){
				location.href = arg.url_sourcing;
			}, 1500)
		}
	});
}

function readURL(input, imgShow) {
	if (input.files && input.files[0]) {
		var fileImg = input.files[0];
		var _URL = window.URL || window.webkitURL;
		var img = new Image();
        img.onload = function () {
            if(this.width/this.height>5 || this.width/this.height<0.2){
            	noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp tỉ lệ 3x4, vui lòng chọn lại.', 'error');
            	$("#ImgUpload").val('');
            	$("#RfqForm input[name=image]").val('');
            	$(imgShow).attr('src', arg.noimg);
            	return false;
            }else{
        		var reader = new FileReader();
        		reader.onload = function(e) {
        			$(imgShow).attr('src', e.target.result);
        			$("#RfqForm input[name=image]").val(e.target.result);
        		}
        		reader.readAsDataURL(fileImg);
            }
        }
        img.src = _URL.createObjectURL(fileImg);
	}
}

</script>