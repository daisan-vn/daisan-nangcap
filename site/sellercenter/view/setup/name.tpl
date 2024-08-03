<div class="card-header">
	<h3>Thông tin cài đặt tên của page trên hệ thống</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	<p>Dưới đây là các thông tin cài đặt cho page của bạn.</p>
	<table class="table">
		<tr class="bg-gray">
			<td>Tên page</td>
			<td>
				<p>Tên của page là tên được hiển thị theo đường dẫn của page trên hệ thống</p>
				<p>http://shops.daisan.vn/<b>{$page.page_name|default:''}</b></p>
				<div>
					<p>Nhập tên thay đổi cho page của bạn</p>
					<form class="form-inline">
						<div class="form-group mr-sm-2 mb-2">
							<input type="text" class="form-control" id="name" placeholder="Tên page" value="{$page.page_name|default:''}">
						</div>
						<button type="button" onclick="saveName();" class="btn btn-primary mb-2">Lưu thay đổi</button>
					</form>
					<div><small>Tên page từ 6 đến 30 ký tự chữ và số, viết liền không dấu. Không chứa các ký tự đặc biệt.</small></div>
				</div>
			</td>
			<td class="text-right"></td>
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
{literal}
<script type="text/javascript">
function saveName(){
	var name = $("input#name").val();
    var patt = /^[a-z\d\-%_]+$/i;
    var check_name = patt.test(name);
    console.log(name);
	if(name.length<6 || name.length>30){
		noticeMsg('Thông báo', 'Vui lòng nhập tên page chứa 6 đến 30 ký tự.', 'error');
		$("#name").focus();
		return false;
	}else if(!check_name){
		noticeMsg('Thông báo', 'Tên page không hợp lệ, vui lòng kiểm tra các ký tự.', 'error');
		$("#name").focus();
		return false;
	}
	loading();
	$.post('?mod=setup&site=name', {'ajax_action':'save_name', 'name':name}).done(function(e){
		var rt = JSON.parse(e);
		if(rt.code==1) noticeMsg('Thông báo', 'Thay đổi tên page thành công.', 'success');
		else{
			noticeMsg('Thông báo', rt.msg, 'error');
			$("#name").focus();
		}
		endloading();
	});
}
</script>
{/literal}