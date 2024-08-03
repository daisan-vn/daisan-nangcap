<div class="card-header">
	<h3>Khởi tạo dịch vụ của công ty</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	
	<form>
		<div class="card-header mb-3">Thông tin tuyển dụng</div>
		<input type="hidden" class="form-control" name="id" value="{$post.id|default:0}">
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Tiêu đề</label>
			<div class="col-sm-6">
				<input type="text" class="form-control" name="title" value="{$post.title|default:''}" placeholder="Vd: Tuyển 4 nhân viên lập trình PHP">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Cấp bậc</label>
			<div class="col-sm-4">
				<select name="position" class="form-control">
					{$out.select_position}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Ngành nghề</label>
			<div class="col-sm-8">
				<select id="category" name="category[]" class="form-control chosen" multiple="multiple">
					{$out.select_category}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Địa điểm làm việc</label>
			<div class="col-sm-8">
				<select id="place" name="place[]" class="form-control chosen" multiple="multiple">
					{$out.select_place}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Hình thức làm việc</label>
			<div class="col-sm-4">
				<select name="worktype" class="form-control">
					{$out.select_worktype}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Mức lương</label>
			<div class="col-sm-3">
				<select name="salary" class="form-control">
					{$out.select_salary}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Thời gian thử việc</label>
			<div class="col-sm-3">
				<select name="timetry" class="form-control">
					{$out.select_timetry}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Số lượng cần tuyển</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" name="number" value="{$post.number|default:0}">
			</div>
		</div>

		<div class="card-header mb-3">Thông tin yêu cầu</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Yêu cầu kinh nghiệm</label>
			<div class="col-sm-4">
				<select name="exp" class="form-control">
					{$out.select_exp}
				</select>
			</div>
		</div>
		
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Yêu cầu bằng cấp</label>
			<div class="col-sm-4">
				<select name="degree" class="form-control">
					{$out.select_degree}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Yêu cầu giới tính</label>
			<div class="col-sm-4">
				<select name="gender" class="form-control">
					{$out.select_gender}
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Yêu cầu độ tuổi</label>
			<div class="col-sm-4">
				<select name="age" class="form-control">
					{$out.select_age}
				</select>
			</div>
		</div>

		<div class="card-header mb-3">Thông tin mô tả thêm</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Mô tả công việc</label>
			<div class="col-sm-8">
				<textarea class="form-control" name="description" rows="5">{$post.description|default:''}</textarea>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Quyền lợi được hưởng</label>
			<div class="col-sm-8">
				<textarea class="form-control" name="content" rows="5">{$post.content|default:''}</textarea>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Yêu cầu khác</label>
			<div class="col-sm-8">
				<textarea class="form-control" name="requirement" rows="5">{$post.requirement|default:''}</textarea>
			</div>
		</div>
		
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Hạn nộp hồ sơ</label>
			<div class="col-sm-3">
				<input type="text" class="form-control datepicker" name="date_finish" value="{$post.date_finish|date_format:'%d-%m-%Y'}">
			</div>
		</div>
		<div class="form-group row">
			<div class="col-sm-2"></div>
			<div class="col-sm-10">
				<div class="form-check">
					<input class="form-check-input" type="checkbox" id="gridCheck1" checked>
					<label class="form-check-label" for="gridCheck1"> Xác nhận những thông tin được đăng là chính xác. </label>
				</div>
			</div>
		</div>
		<div class="form-group row">
			<div class="col-sm-2"></div>
			<div class="col-sm-10">
				<button type="button" onclick="SavePost();" class="btn btn-primary">Đăng tin tuyển dụng</button>
			</div>
		</div>
	</form>
</div>

<link href="{$arg.stylesheet}plugins/chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}plugins/chosen/chosen.jquery.min.js"></script>

{literal}
<script type="text/javascript">
$(".chosen").chosen({disable_search_threshold: 10});
$( ".datepicker" ).datepicker({
	dateFormat: 'dd-mm-yy'
});

function SavePost(){
	var Data = {};
	Data['title'] = $("input[name=title]").val();
	Data['position'] = $("select[name=position]").val();
	Data['category'] = $("select#category").val();
	Data['place'] = $("select#place").val();
	Data['worktype'] = $("select[name=worktype]").val();
	Data['salary'] = $("select[name=salary]").val();
	Data['timetry'] = $("select[name=timetry]").val();
	Data['number'] = $("input[name=number]").val();
	
	Data['exp'] = $("select[name=exp]").val();
	Data['degree'] = $("select[name=degree]").val();
	Data['gender'] = $("select[name=gender]").val();
	Data['age'] = $("select[name=age]").val();
	
	Data['description'] = $("textarea[name=description]").val();
	Data['content'] = $("textarea[name=content]").val();
	Data['requirement'] = $("textarea[name=requirement]").val();
	Data['date_finish'] = $("input[name=date_finish]").val();
	Data['ajax_action'] = 'create_jobpost';
	console.log(Data);
	
	if(Data['title']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập tiêu đề tin tuyển dụng.', 'error');
		$("input[name=title]").focus();
		return false;
	}else if(Data['position']==0){
		noticeMsg('Thông báo', 'Vui lòng chọn cấp bậc của nhân viên cần tuyển dụng.', 'error');
		$("select[name=position]").focus();
		return false;
	}else if(Data['category']==null || Data['category'].length==0){
		noticeMsg('Thông báo', 'Vui lòng chọn danh mục ngành nghề.', 'error');
		return false;
	}else if(Data['place']==null || Data['place'].length==0){
		noticeMsg('Thông báo', 'Vui lòng chọn địa điểm làm việc.', 'error');
		return false;
	}else if(Data['number']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập số lượng nhân viên cần tuyển dụng.', 'error');
		$("input[name=number]").focus();
		return false;
	}else if(Data['description']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập mô tả cho công việc.', 'error');
		$("textarea[name=description]").focus();
		return false;
	}else if(Data['content']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập quyền lợi được hưởng.', 'error');
		$("textarea[name=content]").focus();
		return false;
	}else if(Data['requirement']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập yêu cầu cho công việc.', 'error');
		$("textarea[name=requirement]").focus();
		return false;
	}else if(Data['date_finish']==''){
		noticeMsg('Thông báo', 'Vui lòng nhập hạn nộp hồ sơ.', 'error');
		$("input[name=date_finish]").focus();
		return false;
	}
	loading();
	$.post('?mod=jobpost&site=create', Data).done(function(e){
		noticeMsg('Thông báo', 'Lưu tin đăng tuyển dụng thành công.', 'success');
		setTimeout(function(){
			location.href = "?mod=jobpost&site=index";
		}, 2000);
	});
}
</script>
{/literal}