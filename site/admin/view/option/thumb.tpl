<div class="body-head">
	<h1><i class="fa fa-cog fa-fw"></i> Thiết lập lưu ảnh thumbnail</h1>
</div>
<div class="item sml">
	<div class="box">
		<form method="post" action="">
			<div class="row">
				<div class="col-xs-4">
					<br>
					<div class="form-group">
						<label>Kích thước thumb</label> 
						<select class="form-control" name="thumbsize">{$out.thumbsize}</select>
					</div>
					<div class="form-group">
						<label>Tỉ lệ thumb</label> 
						<select class="form-control" name="thumbratio">{$out.thumbratio}</select>
					</div>
					<div class="form-group">
						<label>Vị trí thumb</label> 
						<select class="form-control" name="thumbposition">{$out.thumbposition}</select>
					</div>
		
				</div>
				<div class="col-xs-4">
					<br>
					<div class="form-group">
						<label>Dung lượng tối đa (tính bằng Mb)</label> 
						<input type="text" class="form-control" name="image_size" value="{$values.image_size|default:''}">
					</div>
					<div class="form-group">
						<label>Thay đổi kích thước tối đa của ảnh gốc</label> 
						<select class="form-control" name="image_width">{$out.image_width}</select>
					</div>
		
				</div>
			</div>
			<hr>
			<div class="form-group">
				<button type="submit" class="btn btn-primary" name="submit">Lưu thông tin</button>
				<button type="reset" class="btn btn-default">Reset From</button>
			</div>
		</form>
	</div>
</div>
