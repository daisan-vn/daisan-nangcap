<div class="body-head">
	<h1><i class="fa fa-cog fa-fw"></i> Cấu hình thông tin liên hệ</h1>
</div>
<div class="item sml">
	<div class="box">
		<form method="post" action="">
			<div class="row">
				<div class="col-xs-6">
					<div class="form-group">
						<label>Tên website/ Doanh nghiệp</label> 
						<input type="text" class="form-control" name="name" value="{$values.name|default:''}">
					</div>
					<div class="form-group">
						<label>Tên viết tắt/ thay thế</label> 
						<input type="text" class="form-control" name="name_short" value="{$values.name_short|default:''}">
					</div>
					<div class="form-group">
						<label>Slogan website</label> 
						<input type="text" class="form-control" name="slogan" value="{$values.slogan|default:''}">
					</div>
					<div class="form-group">
						<label>Giới thiệu</label>
						<textarea rows="3" class="form-control" name="description">{$values.description|default:''}</textarea>
					</div>
				</div>
				<div class="col-xs-5">
					<div class="form-group">
						<label>Điện thoại</label> 
						<input type="text" class="form-control" name="phone" value="{$values.phone|default:''}">
					</div>
					<div class="form-group">
						<label>Thời gian mở cửa</label> 
						<input type="text" class="form-control" name="opentime" value="{$values.opentime|default:''}">
					</div>
					<div class="form-group">
						<label>Email</label> 
						<input type="text" class="form-control" name="email" value="{$values.email|default:''}">
					</div>
					<div class="form-group">
						<label>Địa chỉ</label>
						<textarea rows="3" class="form-control" name="address">{$values.address|default:''}</textarea>
					</div>
				</div>
			</div>
			<hr>
			<button type="submit" class="btn btn-primary" name="submit">Lưu Thông Tin</button>
			<button type="reset" class="btn btn-default">Reset From</button>
		</form>
	</div>
</div>
