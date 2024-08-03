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
				<input type="text" name="url" class="form-control" value="https://www.adayroi.com/">
			</div>
			<div class="form-group">
				<button type="button" id="StartAI" class="btn btn-primary btn-lg" onclick="StartAutorun();">
					<i class="fa fa-fw fa-play"></i> Start Autorun
				</button>
				<button type="button" class="btn btn-primary btn-lg" onclick="GetContent();">
					<i class="fa fa-fw fa-search"></i> Get Page Contents
				</button>
				<button type="button" class="btn btn-danger btn-lg" onclick="StopAutorun();">
					<i class="fa fa-fw fa-pause"></i> Stop
				</button>
			</div>
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
	data.url = "https://www.adayroi.com/";
	data.restart = !restart?0:restart;
	loading();
	$.post('?mod=autorun&site=autorun_start',data).done(function(e){
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
			Autorun(rt.url_id);
		}
		endloading();
	});
}

function GetContent(){
	var data = {};
	data.url = $("#FormAutorun input[name=url]").val();
	loading();
	$("#ShowPageContent .modal-body").load('?mod=autorun&site=load_pagecontent', data, function(e){
		$("#ShowPageContent").modal('show');
		endloading();
	});
}


function Autorun(url_id){
	var data = {};
	data.url_id = url_id;
	$("#uid"+url_id+" i").removeClass('fa-link');
	$("#uid"+url_id+" i").addClass('fa-spinner');
	$("#uid"+url_id+" i").addClass('fa-spin');
	$.post('?mod=autorun&site=autorun_handle', data).done(function(e){
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
			Autorun(rt.url_id);
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

</script>
{/literal}