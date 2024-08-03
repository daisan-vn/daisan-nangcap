<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Quét sản phẩm tự động cho gian hàng
			</h1>
		</div>
	</div>
</div>

<div id="FormAutorun">
	<div class="row">
		<div class="col-md-8">
			<div class="form-group">
				<input type="text" class="form-control" onchange="LoadPrefix(this.value);" placeholder="Tìm gian hàng" value="{$out.key}">
			</div>
			
			
			<div class="">
			    <table class="table table-bordered table-hover table-striped">
			        <thead>
			        <tr>
			            <th>Gian hàng</th>
			            <th class="text-right">Sản phẩm</th>
			            <th class="text-right">Xử lý</th>
			        </tr>
			        </thead>
			        <tbody>
			        {if $result neq NULL}
		            {foreach from=$result item=data}
		                <tr id="field{$data.id}">
		                    <td width="65%">
		                    	<div class="row row-small">
		                    		<div class="col-md-2 col-sm-2 col-xs-2">
		                    			<img class="img border" id="img{$data.id}" src="{$data.logo}">
		                    		</div>
		                    		<div class="col-md-10">
				                        <a href="{$data.url}" target="_blank"><b>{$data.name}</b></a><br>
				                        <span class="text-small"><i class="fa fa-link"></i> {$data.website}</span>
		                    		</div>
		                    	</div>
		                    </td>
		                    <td class="text-right" style="min-width:88px">
		                    	{$data.products|default:0}
		                    </td>
		                    <td class="text-right" style="min-width:88px">
		                    	<a href="?mod=scandb&site=confrun&id={$data.id}" class="btn btn-default btn-xs"><i class="fa fa-pencil fa-fw"></i> Cấu hình</a>
		                    	<a href="?mod=scandb&site=autorun&id={$data.id}" class="btn btn-default btn-xs"><i class="fa fa-cog fa-fw"></i> Quét</a>
		                    </td>
		                </tr>
		            {/foreach}
			        {else}
			            <tr><td class="text-center" colspan="10"><br>Không có nội dung nào được tìm thấy<br><br></td></tr>
			        {/if}
			        </tbody>
			    </table>
			</div>
			
			
		</div>
		<div class="col-md-3">
           	<a href="?mod=scandb&site=repeat" class="btn btn-default btn-lg btn-block"><i class="fa fa-cog fa-fw"></i> Quét sản phẩm tự động</a>
           	<a href="?mod=scandb&site=autoupdate" class="btn btn-primary btn-lg btn-block"><i class="fa fa-pencil fa-fw"></i> Quét update sản phẩm</a>
           	<a href="?mod=scandb&site=reset" class="btn btn-primary btn-lg btn-block"><i class="fa fa-pencil fa-fw"></i> Quét chuẩn hóa sản phẩm</a>
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
	var url = '?mod=scandb&site=index';
	if(value!='') url += '&key='+btoa(value);
	loading();
	location.href = url;
}

</script>
{/literal}