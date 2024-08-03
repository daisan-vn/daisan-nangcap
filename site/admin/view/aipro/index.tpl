<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Quét sản phẩm tự động
			</h1>
		</div>
	</div>
</div>

<div id="FormAutorun">
	<div class="row">
		<div class="col-md-6">
			<div class="form-group">
				<input type="text" name="url" class="form-control" onchange="LoadPrefix(this.value);" placeholder="Nhập url để quét sản phẩm">
			</div>
			<div class="form-group">
				<textarea name="prefix" class="form-control" rows="6" placeholder="Nhập các thông số để lấy nội dung. Ví dụ: name:.product_name&&code:.product_code"></textarea>
			</div>
			<div class="form-group">
				<button type="button" id="StartAI" class="btn btn-primary btn-lg" onclick="StartAutorun();">
					<i class="fa fa-fw fa-play"></i> Start Autorun
				</button>
				<button type="button" class="btn btn-primary btn-lg" onclick="GetContent();">
					<i class="fa fa-fw fa-pause"></i> Get page contents
				</button>
			</div>
		</div>
		<div class="col-md-6">
			<h4>Chức năng chạy sản phẩm</h4>
			<p>- <b>Get Page Contents:</b> để lấy và kiểm tra nội dung lấy về từ url</p>
			<p>- <b>Start Autorun:</b> Bắt đầu chạy tự động để lấy sản phẩm về</p>
			<p>Lưu ý: trước khi bắt đầu chạy, phải nhập link của website muốn lấy và config các thuộc tính để lấy giá trị về.
			Để xem nội dung có chính xác không, bạn có thể kiểm tra bằng nút "Get Page Contents"</p>
			<h4>Hướng dẫn cấu hình</h4>
			<p><b>Các thuộc tính có thể cấu hình:</b></p>
			<p>- code: lấy mã sản phẩm</p>
			<p>- name: lấy tên sản phẩm</p>
			<p>- image: lấy ảnh đại diện sản phẩm</p>
			<p>- a_metas: lấy các thuộc tính sản phẩm</p>
			<p>- content: lấy nội dung sản phẩm</p>
			<p><b>Cách lấy:</b></p>
			<p>- Cấu trúc lấy: code=thuoc_tinh_html_code&&name=thuoc_tinh_html_name</p>
			<p>- Ví dụ:</p>
			<p>+ Url: http://sunhouse.com.vn/sp/bo-noi-inox/bo-noi-inox-5-day-sunhouse-sh780/</p>
			<p>+ Cấu hình: code=.pro-detail-lable span&&a_metas=.p_content td</p>
		</div>
	</div>
</div>

<div id="ShowAutorun"></div>

<div class="modal fade" id="ShowPageContent">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Nội dung lấy về từ url</h4>
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
function StartAutorun(restart){
	var data = {};
	data.url = $("#FormAutorun input[name=url]").val();
	data.prefix = $("#FormAutorun textarea[name=prefix]").val();
	data.restart = !restart?0:restart;
	loading();
	$.post('?mod=aipro&site=autorun_start',data).done(function(e){
		var rt = JSON.parse(e);
		if(rt.number==0){
			noticeMsg('System Message', 'Cập nhật nội dung hoàn tất.', 'success');
			$("#FormAutorun").show();
			$("#ShowAutorun").hide();
		}else{
			endloading();
			$("#FormAutorun").hide();
			$("#ShowAutorun").show();
			$("#ShowAutorun").html(rt.str_links);
			Autorun(rt.url_id, rt.page_id);
		}
		endloading();
	});
}

function Autorun(url_id, page_id){
	var data = {};
	data.url_id = url_id;
	data.page_id = page_id;
	data.prefix = $("#FormAutorun textarea[name=prefix]").val();
	$("#uid"+url_id+" i").removeClass('fa-link');
	$("#uid"+url_id+" i").addClass('fa-spinner');
	$("#uid"+url_id+" i").addClass('fa-spin');
	$.post('?mod=aipro&site=autorun_handle', data).done(function(e){
		var rt = JSON.parse(e);
		$("#uid"+url_id+" i").removeClass('fa-spinner');
		$("#uid"+url_id+" i").removeClass('fa-spin');
		if(rt.code==0){
			$("#uid"+url_id+" i").addClass('fa-close');
			$("#uid"+url_id).addClass('col-danger');
			$("#uid"+url_id+" a").append(" ("+rt.msg+")");
		}else{
			$("#uid"+url_id).addClass('col-success');
			$("#uid"+url_id+" i").addClass('fa-check-square-o');
		}
		if(parseInt(rt.number)>0){
			Autorun(rt.url_id, page_id);
		}else{
			loading();
			noticeMsg('System Message', 'Hệ thống đang chạy để tải thêm nội dung...');
			setTimeout(function(){StartAutorun(1);}, 1000)
		}
		setTimeout(function(){
			$("#uid"+url_id).remove();
		}, 2500);
	});
}

function GetContent(){
	var data = {};
	data.url = $("#FormAutorun input[name=url]").val();
	data.prefix = $("#FormAutorun textarea[name=prefix]").val();
	if(data.url.length < 6){
		noticeMsg('System Message', 'Vui lòng nhập chính xác url lấy nội dung.', 'error');
		$("#FormAutorun input[name=url]").focus();
		return false;
	}
	loading();
	$("#ShowPageContent .modal-body").load('?mod=aipro&site=load_pagecontent', data, function(e){
		$("#ShowPageContent").modal('show');
		endloading();
	});
}

function LoadPrefix(value){
	loading();
	var data = {};
	data.url = value;
	data.ajax_action = 'load_prefix_auto';
	$.post('?mod=aipro&site=index', data).done(function(e){
		$("#FormAutorun textarea[name=prefix]").val(e);
		endloading();
	});
}

</script>
{/literal}