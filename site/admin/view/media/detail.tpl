{if $media}
<div class="row">
	<div class="col-md-7 text-right">
		<img alt="{$media.media_title}" src="{$media.avatar}" style="max-width: 100%">
	</div>
	<div class="col-md-5">
		<div class="box">
			<h3>Thông tin ảnh</h3>
			<p><i class="fa fa-image fa-fw"></i> Tên ảnh: {$media.name}</p>
			<p><i class="fa fa-folder-o fa-fw"></i> Thư mục chứa: {$media.folder}</p>
			<p><i class="fa fa-circle-o fa-fw"></i> Kích thước ảnh: {$media.imagesize}px</p>
			<p><i class="fa fa-crop fa-fw"></i> Kích thước ảnh nhỏ: {$media.thumbsize}px</p>
			<p><i class="fa fa-clock-o fa-fw"></i> Khởi tạo: {$media.created|date_format:"%H:%M:%S %d/%m/%Y"}</p>
		</div>
	</div>
</div>
{else}
<div class="row">
	<div class="col-md-3">
		<div class="box"><img alt="" src="{$arg.img_gen}noimg.jpg" style="width: 100%"></div>
	</div>
	<div class="col-md-9">
		<h3>Thông báo từ hệ thống admin</h3>
		<p>Hình ảnh này không tồn tại hoặc đã bị xóa bỏ trước đó trong media.</p>
		<p>Bạn vui lòng kiểm tra lại và chọn ảnh khác để thay thế.</p>
	</div>
</div>

{/if}