<div class="body-head">
	<h1><i class="fa fa-pencil fa-fw"></i> Cập nhật thông tin template website</h1>
</div>

<form method="post" onsubmit="return CheckBeforeSave();">
	<div class="item sml">
		<div class="box">
			<input type="hidden" name="id" value="{$theme.id|default:0}">
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Tên dịch vụ</label>
				<div class="col-sm-4">
					<input type="text" class="form-control" name="name" value="{$theme.name|default:''}">
					<small>Tối đa 30 ký tự, viết liền không dấu.</small>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Tiêu đề dịch vụ</label>
				<div class="col-sm-6">
					<input type="text" class="form-control" name="title" value="{$theme.title|default:''}">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Ảnh đại diện</label>
				<div class="col-sm-8">
					<div class="row row-small mb-3">
						<div class="col-md-4">
							<span class="border d-block" style="display: block;">
								<img src="{$theme.avatar}" id="ShowLogo" width="100%">
							</span>
						</div>
						<div class="col-md-6">
							<input type="file" id="UploadLogo" name="logo">
							<input type="hidden" name="avatar">
							<small class="form-text text-muted"> Kích thước file tối đa 500Mb, hỗ trợ định dạng jpg, png.</small>
							<small class="form-text text-muted"> Tỉ lệ ảnh phù hợp là 3x4. Nên để kích thước 600x800 pixcel.</small>
						</div>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Nội dung mô tả</label>
				<div class="col-sm-6">
					<textarea name="description" rows="5" class="form-control">{$theme.description|default:''}</textarea>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Cập nhật lần cuối</label>
				<div class="col-sm-3">
					<input type="text" class="form-control datepicker" name="date_update" value="{$theme.date_update|date_format:'%d-%m-%Y'}">
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
$( ".datepicker" ).datepicker({
	dateFormat: 'dd-mm-yy'
});

function CheckBeforeSave() {
    var name = $.trim($('input[name=name]').val());
    var title = $.trim($('input[name=title]').val());
    var date_update = $.trim($('input[name=date_update]').val());
    var taxonomy_id = $('select[name=taxonomy_id]').val();

    if (name == '') {
        $('input[name=name]').focus();
        noticeMsg('Thông báo', 'Tên dịch vụ không hợp lệ', 'error');
        return false;
    } else if (title=='') {
    	$('input[name=title]').focus();
        noticeMsg('Thông báo', 'Vui lòng nhập tiêu đề template', 'error');
        return false;
    } else if (date_update=='') {
    	$('input[name=date_update]').focus();
        noticeMsg('Thông báo', 'Vui lòng chọn ngày cập nhật lần cuối', 'error');
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
	            if(this.width/this.height<0.5 || this.width/this.height>1){
	            	noticeMsg('Thông báo', 'Kích thước ảnh không đúng tỉ lệ 3x4, vui lòng chọn lại.', 'error');
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