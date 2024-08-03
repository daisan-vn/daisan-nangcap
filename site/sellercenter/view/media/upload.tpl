<div class="body-head">
	<h1><i class="fa fa-bars fa-fw"></i> Upload Hình Ảnh Lên Thư Viện Media</h1>
</div>

<form id="uploadFile" method="post" enctype="multipart/form-data">
	<h4><i class="fa fa-hand-o-right fa-fw"></i> Lưu ý: chọn ảnh đúng định dạng *.png, *.jpg, *.jpeg, *.gif, kích thước không được vượt quá 4MB</h4>
	<br>
	<div class="row">
		<div class="col-xs-4">
			<div class="form-group">
				<label>Chọn file ảnh</label>
				<input type="file" required name="images[]" multiple="multiple" id="UploadMedia">
				<p class="help-block">Có thể chọn nhiều ảnh để upload cùng một lúc.</p>
			</div>
			<div class="form-group">
				<label>Thư mục chứa ảnh upload</label>
				<select class="form-control col-md-9" name="taxonomy_id">{$out.select_folder}</select>
			</div>
		</div>
		<div class="col-xs-4">
			<p>Các thông số cấu hình cho ảnh upload mặc định được cấu hình trong mục cấu hình hoặc có thể thay đổi tùy chỉnh bên dưới đây cho phù hợp từng ảnh.</p>
			<div class="form-group">
				<label>Kích thước ảnh thumbnail</label> 
				<select class="form-control" name="thumbsize">{$out.thumbsize}</select>
			</div>
			<div class="form-group">
				<label>Tỉ lệ ảnh thumbnail</label> 
				<select class="form-control" name="thumbratio">{$out.thumbratio}</select>
			</div>
			<div class="form-group">
				<label>Kích thước tối đa của ảnh gốc</label> 
				<select class="form-control" name="image_width">{$out.image_width}</select>
			</div>
		</div>
	</div>
	<hr>
	<div class="form-group">
		<button class="btn btn-primary" type="submit">
			<i class="fa fa-cloud-upload fa-fw"></i> Tải ảnh lên thư viện
		</button>
		<button type="reset" class="btn btn-default">Reset From</button>
	</div>
</form>
