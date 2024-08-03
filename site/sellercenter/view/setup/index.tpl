<div class="card-header">
	<h3>Thông tin cài đặt cho website</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	<p>Dưới đây là các thông tin cài đặt cho page của bạn.</p>
	<table class="table">
		<tr>
			<td>Tên page</td>
			<td>http://shops.daisan.vn/{$page.page_name|default:'pid$page.id'}/</td>
			<td class="text-right"><a href="?mod=setup&site=name">Chỉnh sửa</a></td>
		</tr>
		<tr>
			<td>Website đồng bộ dữ liệu</td>
			<td>http://daisan.vn</td>
			<td class="text-right"><a href="?mod=setup&site=website">Chỉnh sửa</a></td>
		</tr>
		<tr>
			<td>Thông tin SEO page</td>
			<td>
				<p>Tiêu đề: DaiSan</p>
				<p>Mô tả: Sàn TMĐT Chuyên biệt trong lĩnh vực Xây dựng & Công nghiệp.</p>
				<p>Từ khóa: Sàn TMĐT, B2B, B2C</p>
			</td>
			<td class="text-right"><a href="?mod=setup&site=seo">Chỉnh sửa</a></td>
		</tr>
	</table>
</div>