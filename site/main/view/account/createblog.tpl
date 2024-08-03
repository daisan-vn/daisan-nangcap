<div class="container">
	<div class="card mb-2">
		<div class="card-body">
			<div class="">
				<h1><i class="fa fa-pied-piper"></i> Viết blog</h1>
				<p>Đăng ký trang để quản lý công việc kinh doanh của bạn một cách dễ dàng và hiệu quả nhất.</p>
			</div>
		</div>
	</div>
	<form method="post" id="FrmCon" onsubmit="return CheckFrm();" enctype="multipart/form-data">
		<div class="row row-sm">
			<div class="col-8">
				<div class="card">
					<div class="card-body">
						<div>
							<div class="form-group">
								<input type="text" class="form-control" name="Title" placeholder="Tiêu đề của blog">
							</div>
							<div class="form-group">
								<textarea name="Content" rows="20" class="form-control" id="Tinymce" placeholder="Nội dung blog tối đa 10000 ký tự"></textarea>
							</div>
							<div class="form-group">
								<input type="text" class="form-control" name="Keyword" placeholder="Từ khóa cho blog (cách nhau bởi dấu ';')">
							</div>
			
						</div>
					</div>
				</div>
			</div>
			<div class="col-4">
				<div class="card">
					<div class="card-body">
						<div class="form-group">
							<select class="form-control" name="TaxonomyId">
								{$out.Taxonomy}
							</select>
						</div>
						<div class="form-group">
							<div class="mb-2 border">
								<img alt="" src="" width="100%" id="ShowImgUpload">
							</div>
							<div class="custom-file">
								<input type="file" class="custom-file-input" name="Image" id="ImgUpload">
								<label class="custom-file-label">Chọn ảnh đại diện cho blog</label>
							</div>
						</div>
						<div class="form-group">
							<label>Blog này là con của</label>
							<select class="form-control" name="Parent">
								<option value="0">Hiển thị với tất cả mọi người</option>
								<option value="1">Chỉ hiển thị với người theo dõi</option>
								<option value="2">Chỉ hiển thị với mình tôi</option>
							</select>
						</div>
		
						<div class="form-group">
							<label>Ai được xem blog này của tôi ?</label>
							<select class="form-control" name="Publish">
								<option value="0">Hiển thị với tất cả mọi người</option>
								<option value="1">Chỉ hiển thị với người theo dõi</option>
								<option value="2">Chỉ hiển thị với mình tôi</option>
							</select>
						</div>
		
						<div class="form-check">
							<input class="form-check-input" name="ShowAuthor" type="radio" value="1" checked id="exampleRadios1"> 
							<label class="form-check-label" for="exampleRadios1"> Công khai thông tin tác giả</label>
						</div>
						<div class="form-check mb-3">
							<input class="form-check-input" type="radio" name="ShowAuthor" value="0" id="exampleRadios2"> 
							<label class="form-check-label" for="exampleRadios2"> Không hiển thị thông tin tác giả</label>
						</div>
		
						<div class="form-check mb-3">
							<input type="checkbox" class="form-check-input" id="exampleCheck1">
							<label class="form-check-label" for="exampleCheck1">Tôi đã xem và đồng ý các <a href="">điều lệ đối với blogs</a> của website.</label>
						</div>
						<hr>
						<div class="form-group">
							<button type="submit" name="Submit" class="btn btn-success btn-lg"><i class="fa fa-fw fa-check"></i> Lưu thông tin</button>
							<button type="button" onclick="SaveBlog();" class="btn btn-success btn-lg">Hủy bỏ</button>
						</div>
							
					</div>
				</div>
			</div>
		</div>
	</form>
</div>
<link href="{$arg.stylesheet}css/pnotify.min.css" rel="stylesheet">
<link href="{$arg.stylesheet}css/animate.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}js/pnotify.min.js"></script>
<script src="{$arg.stylesheet}plugins/tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}plugins/tinymce/tinymce.conf.js"></script>

{literal}
<script>
function CheckFrm(){
	var Data = {};
	Data['Title'] = $("#FrmCon input[name=Title]").val();
	//Data['Content'] = $("#FrmCon textarea[name=Content]").val();
	Data['TaxonomyId'] = $("#FrmCon select[name=TaxonomyId]").val();
	Data['Content'] = tinymce.get('Tinymce').getContent();
	
	console.log(Data);
	
	if(Data['Title']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập tiêu đề blog.', 'error');
		$("#FrmCon input[name=Title]").focus();
		return false;
	}else if(Data['Content']=='' || Data['Content'].length < 500){
		noticeMsg('Thông báo', 'Vui lòng nhập nội dung blog tối thiểu 300 ký tự.', 'error');
		$("#FrmCon textarea[name=Content]").focus();
		return false;
	}else if(Data['TaxonomyId']==0 || Data['TaxonomyId']==''){
		noticeMsg('Thông báo', 'Vui lòng chọn danh mục sản phẩm.', 'error');
		$("#FrmCon select[name=ProvinceId]").focus();
		return false;
	}
}

function LoadLocation(Type, Value){
	loading();
	$.post('?mod=help&site=ajax_load_location', {'Type':Type, 'Value':Value}).done(function(e){
		$("#"+Type).html(e);
		if(Type=='district') $("#wards").html('');
		endloading();
	});
}

$('#ImgUpload').change(function() {
	readURL(this, '#ShowImgUpload');
});

function readURL(input, imgShow) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		reader.onload = function(e) {
			$(imgShow).attr('src', e.target.result);
		}
		reader.readAsDataURL(input.files[0]);
	}
}
</script>
{/literal}