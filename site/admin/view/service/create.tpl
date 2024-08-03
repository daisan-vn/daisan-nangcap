<div class="body-head">
	<h1><i class="fa fa-pencil fa-fw"></i> Cập nhật thông tin dịch vụ</h1>
</div>

<form method="post" onsubmit="return CheckBeforeSave();">
	<div class="item sml">
		<div class="box">
			<input type="hidden" name="id" value="{$service.id|default:0}">
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Danh mục</label>
				<div class="col-sm-4">
					<select name="taxonomy_id" class="form-control">
						{$out.select_category}
					</select>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Tên dịch vụ</label>
				<div class="col-sm-6">
					<input type="text" class="form-control" name="name" value="{$service.name|default:''}">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Ảnh đại diện</label>
				<div class="col-sm-8">
					<div class="row row-small mb-3">
						<div class="col-md-3">
							<span class="border d-block" style="min-height: 122px; display: block;">
								<img src="{$service.avatar}" id="ShowLogo" width="100%" height="122">
							</span>
						</div>
						<div class="col-md-6">
							<input type="file" id="UploadLogo" name="logo">
							<input type="hidden" name="avatar">
							<small class="form-text text-muted"> Kích thước file tối đa 300Mb, hỗ trợ định dạng jpg, png.</small>
							<small class="form-text text-muted"> Tỉ lệ ảnh phù hợp là 4x3. Nên để kích thước 400x300 pixcel.</small>
						</div>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Nội dung mô tả</label>
				<div class="col-sm-6">
					<textarea name="description" rows="5" class="form-control">{$service.description|default:''}</textarea>
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-2"></div>
				<div class="col-sm-10">
					<button type="submit" name="submit" class="btn btn-primary">Lưu thông tin</button>
				</div>
			</div>
		</div>
	</div>

</form>

{literal}
<script>

function CheckBeforeSave() {
    var name = $.trim($('input[name=name]').val());
    var taxonomy_id = $('select[name=taxonomy_id]').val();

    if (name == '') {
        $('input[name=name]').focus();
        noticeMsg('Kiểm tra lại tên dịch vụ', 'Tên dịch vụ không hợp lệ', 'error');
        return false;
    } else if (taxonomy_id==0) {
    	$('select[name=taxonomy_id]').focus();
        noticeMsg('Thông báo', 'Vui lòng chọn danh mục', 'error');
        return false;
    }else return true;
}

$('#UploadLogo').change(function() {
	if(this.files && this.files[0]) {
		var fileImg = this.files[0];
		var fileType = this.files[0]["type"];
		var fileName = this.files[0]["name"];
		var ValidImageTypes = ["image/jpeg", "image/png"];
		if ($.inArray(fileType, ValidImageTypes)>=0) {
			var _URL = window.URL || window.webkitURL;
			var img = new Image();
	        img.onload = function () {
	            if(this.width/this.height<1 || this.width/this.height>1.8){
	            	noticeMsg('Thông báo', 'Kích thước ảnh không đúng tỉ lệ 4x3, vui lòng chọn lại.', 'error');
	            	$("#UploadLogo").val('');
	            	$("#ShowLogo").attr('src', arg.noimg);
	            	$("input[name=avatar]").val('');
	            	return false;
	            }else{
					var reader = new FileReader();
					reader.onload = function(e) {
						$("#ShowLogo").attr('src', e.target.result);
						$("input[name=avatar]").val(e.target.result);
					}
					reader.readAsDataURL(fileImg);
	            }
	        }
	        img.src = _URL.createObjectURL(fileImg);
		}else{
			noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng jpg hoặc png.', 'error');
			$("input[name=avatar]").val('');
			$("#ShowLogo").attr('src', arg.noimg);
		}
	}
	$("#UploadLogo").val('');
});

</script>
{/literal}