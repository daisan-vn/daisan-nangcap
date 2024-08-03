<div class="card-header">
	<h3>Cài đặt thông tin seo default cho website</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	<p>Dưới đây là các thông tin cài đặt cho page của bạn.</p>
	<table class="table">
		<tr>
			<td width="23%">Tên page</td>
			<td>http://shops.daisan.vn/{$page.page_name|default:'pid$page.id'}/</td>
			<td width="12%" class="text-right"><a href="?mod=setup&site=name">Chỉnh sửa</a></td>
		</tr>
		<tr>
			<td>Website đồng bộ dữ liệu</td>
			<td>http://daisan.vn</td>
			<td class="text-right"><a href="?mod=setup&site=website">Chỉnh sửa</a></td>
		</tr>
		<tr class="bg-gray">
			<td>Thông tin SEO page</td>
			<td>
			
				<form method="post">
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">Meta Title</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" name="meta_title" value="{$page.meta_title|default:''}">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">Meta Keyword</label>
						<div class="col-sm-10">
							<textarea class="form-control" name="meta_keyword" rows="3">{$page.meta_keyword|default:''}</textarea>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">Meta Description</label>
						<div class="col-sm-10">
							<textarea class="form-control" name="meta_description" rows="3">{$page.meta_description|default:''}</textarea>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2 col-form-label"></label>
						<div class="col-sm-10">
							<button type="submit" name="submit" class="btn btn-primary mb-2">Lưu thay đổi</button>
						</div>
					</div>
				</form>

			</td>
			<td class="text-right"></td>
		</tr>
	</table>
</div>