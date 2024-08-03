<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Thêm loại thuộc tính</h1>
		</div>
		<div class="col-md-4 text-right">
		</div>
	</div>
</div>

<form method="POST">
	<div class="panel panel-primary">
		<div class="panel-heading">
			<div class="row">
				<div class="col-md-8">Mô tả thêm thông tin</div>
				<div class="col-md-4 text-right">
					
				</div>
			</div>
		</div>
		<div class="panel-body">
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Tên loại thuộc tính</label>
				<div class="col-sm-7">
					<input type="text" class="form-control" name="name" value="{$result.name}">
				</div>
				
			</div>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Các thuộc tính</label>
				<div class="col-sm-7">
					<textarea class="form-control" name="attribute" rows="8" placeholder="Thuộc tính 1 <enter>
Thuộc tính 2">{$result.content}</textarea>
				</div>
				
			</div>
			
		</div>
	</div>

	<div class="form-group row">
		<div class="col-sm-10">
			<button type="submit" name="submit" class="btn btn-primary btn-lg">Lưu thuộc tính</button>
		</div>
	</div>
</form>

<input type="hidden" name="json_keywords" value='{$json_keywords}'>

<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce-config.js"></script>
{literal}
<script>
	var json_keywords = JSON.parse($("input[name=json_keywords]").val());
	$(window).ready(function () {
		$(".keyword").autocomplete({
			source: json_keywords
		});
	});
	var result = confirm("Want to delete?");
	// document.getElementById("formAttr").action = window.location.href;
</script>
{/literal}