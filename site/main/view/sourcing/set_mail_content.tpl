<h1 style="font-size: 24px; margin-bottom: 10px;">{$data.title}</h1>
<div>{$data.description|nl2br}</div>
<div style="margin-bottom: 15px;">
	<span><span>Số lượng yêu cầu:</span> <b>{$data.number}</b> {$data.unit}</span>
	<span style="margin-left: 1rem;"><span>Giá đề xuất:</span> <b>{$data.price|number_format}</b>đ</span>
	<span  style="margin-left: 1rem;"><span>Thời gian đăng:</span> {$data.created|date_format:'%H:%M %Y-%m-%d'}</span>
</div>
<div>
	<p>
		<span>Người đăng: <b>{$data.user}</b></span>
		<span style="border: 1px solid #ddd; padding: 3px 6px; margin-left: 5px; color: #999;">Email đã xác nhận</span>
		<span style="border: 1px solid #ddd; padding: 3px 6px; margin-left: 5px; color: #999;">Người mua đang hoạt động</span>
	</p>
	<p><span>Địa điểm yêu cầu:</span> {$data.location}, Việt Nam</p>
</div>
<p><a href="{$data.url}">Xem thông tin chi tiết</a></p>
