<div class="body-head">
	<h1><i class="fa fa-bars fa-fw"></i> Cài đặt vị trí cho Menu</h1>
</div>
<div class="row">
	<div class="col-md-6">
		<h4>Cài đặt vị trí hiển thị của menu ngoài trang chính</h4>
		<p>Chọn menu tương ứng với từng vị trí trong bảng</p><br>
		<form class="form-horizontal" method="post">
			{foreach from=$result key=k item=data}
			<div class="form-group">
				<div class="col-sm-5">
					<input type="text" disabled="disabled" class="form-control" value="{$data.name}">
				</div>
				<div class="col-sm-7">
					<select class="form-control" name="{$k}">{$data.position}</select>
				</div>
			</div>
			{/foreach}
			<hr>
			<div class="form-group">
				<div class="col-sm-12 text-right">
					<button type="submit" class="btn btn-primary" name="submit">Lưu nội dung</button>
		            <button class="btn btn-default" type="reset">Hủy bỏ</button>
				</div>
			</div>
		</form>
	</div>
</div>
