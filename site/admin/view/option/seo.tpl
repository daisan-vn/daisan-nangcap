<div class="body-head">
	<h1><i class="fa fa-cog fa-fw"></i> Cấu hình thông tin mặc định SEO cho website</h1>
</div>
<div class="item sml">
	<div class="box">
		<form method="post" action="">
			<div class="row">
				<div class="col-md-9">
					<div class="form-group">
						<label>Meta Title (Hiển thị tiêu đề website)</label> 
						<input type="text" class="form-control" name="title" value="{$values.title|default:''}">
					</div>
					<div class="form-group">
						<label>Meta Keyword (Các từ khóa trọng tâm cho website)</label>
						<textarea rows="4" class="form-control" name="keyword">{$values.keyword|default:''}</textarea>
					</div>
					<div class="form-group">
						<label>Meta Description (Mô tả nội dung tổng quan website)</label>
						<textarea rows="5" class="form-control" name="description">{$values.description|default:''}</textarea>
					</div>
					<hr>
				</div>
			</div>
			<div class="form-group">
				<button type="submit" class="btn btn-primary" name="submit">Lưu Thông Tin</button>
				<button type="reset" class="btn btn-default">Reset From</button>
			</div>
		</form>
	</div>
</div>
