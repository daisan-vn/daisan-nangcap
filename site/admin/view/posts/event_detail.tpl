<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Quản lý sự kiện</h1>
		</div>
		<div class="col-md-4 text-right">
			<a href="?mod=pages&site=index" class="btn btn-primary">
				<i class="fa fa-arrow-left fa-fw"></i> Danh sách gian hàng
			</a>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-md-2">
		<img src="{$value.avatar}" width="100%" class="img-thumbnail">
	</div>
	<div class="col-md-10">
		<h3>{$value.title}</h3>
		<p class="mb-1">Bắt đầu: {$value.time_start|date_format:'%d-%m-%Y'}</p>
		<p>Kết thúc: {$value.time_finish|date_format:'%d-%m-%Y'}</p>
	</div>
</div>
<hr>
<div class="row">
	<div class="col-md-8">
	    <div class="form-group form-inline">
	        <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.key}">
	        <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
	    </div>
	</div>
	<div class="col-md-4 text-right">
	     <button type="button" class="btn btn-primary" onclick="LoadPageFrm(0);"><i class="fa fa-plus"></i>Thêm đơn vị vào sự kiện</button>	
	</div>
</div>
<hr>
<div class="table-responsive">
	<h4>Danh sách <font color="red">{$number}</font> đơn vị tham gia sự kiện</h4>
    <table class="table table-bordered table-hover table-striped">
        <thead>
        <tr>
            <th class="text-center"><input type="checkbox" class="SelectAllRows"></th>
            <th>Tiêu đề</th>
            <th>Sản phẩm</th>
            <th>Gói đăng ký</th>
            <th>Điểm QC</th>
            <th>Khởi tạo</th>
            <th class="text-right"></th>
        </tr>
        </thead>
        <tbody>
        {if $result neq NULL}
           {foreach from=$result item=data}
			<tr id="field{$data.id}">
				<td class="text-center"><input type="checkbox"
					class="item_checked" value="{$data.id}"></td>
				<td width="35%">
					<div class="row row-small">
						<div class="col-md-2">
							<img class="img" id="img{$data.id}" src="{$data.logo}">
						</div>
						<div class="col-md-10">
							<a href="javascript:void(0)" onclick="LoadNation({$data.id});"><img
								src="{$data.nation_logo}" width="30"></a>&nbsp;&nbsp;<a
								href="{$data.url}" class="field_name" target="_blank">[{$data.id}]
								{$data.name}</a> <br>
							<span class="text-small"><i class="fa fa-map-marker fa-fw"></i>
								{$data.address}</span> <br>
							<span class="text-small"><i class="fa fa-globe"></i><a
								href="{$data.website}" target="_blank"> {$data.website}</a></span> <br>
						</div>
					</div>
				</td>
				 <td class="text-right"><a href="?mod=product&site=index&page_id={$data.page_id}" target="">{$data.products_active}/{$data.products}</a></td>
				<td>
					<p>
						<button class="btn btn-default btn-xs"
							onclick="LoadPackage({$data.id});">
							<i class="fa fa-pencil fa-fw"></i>
						</button>
						{$data.package|default:'Free'}
					</p> <small>{$data.package_end}</small>
				</td>
				<td>{$data.score_ads}</td>
				<td>{$data.created|date_format:'%H:%M %d-%m-%Y'}</td>
				<td class="text-right" style="min-width:88px">
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="DeleteItem('posts', 'ajax_delete_page',{$data.id}, '');"><i class="fa fa-trash fa-fw"></i></button>
                 </td>
			</tr>
			{/foreach} {else}
			<tr>
				<td class="text-center" colspan="10"><br>Không có nội dung
					nào được tìm thấy<br>
				<br></td>
			</tr>
			{/if}
        </tbody>
    </table>
</div>

<div class="paging">{$paging}</div>

<div class="modal fade" tabindex="-1" id="UpdateFrom">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
				<h4 class="modal-title">Thêm đơn vị vào sự kiện</h4>
			</div>
			<div class="modal-body">
				<div class="form-horizontal">
					<div class="form-group row-small">
						<div class="col-md-12 col-sm-12 col-xs-12">
							<input type="hidden" name="post_id" value="{$value.id}">
						</div>
					</div>
					<div class="form-group row-small">
						<label class="control-label col-md-3">Chọn gian hàng</label>
						<div class="col-md-9">
							<select class="form-control chosen" name="page_id" id="page_id"></select>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Hủy bỏ</button>
				<button type="button" class="btn btn-primary" onclick="SavePageFrm();">Lưu thông tin</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->
<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
{literal}
<script>
$(window).ready(function(){
	$(".chosen").chosen();
});
$('#keyword,#category').keypress(function( event ){
    if ( event.which == 13 ) filter();
});

function filter(){
    var key = $.trim($("#keyword").val());
    var post_id =  $("#UpdateFrom input[name=post_id]").val();
    var url = "?mod=posts&site=event_detail";
    if(post_id!=-1) url = url+"&post_id="+post_id;
    if(key!='') url = url+"&key="+key;
    window.location.href = url;
}

function LoadForm(id) {
	$("#UpdateFrom input[type=text]").val('');
	loading();
	$("#UpdateFrom input[name=id]").val(id);
	$("#UpdateFrom input[name=price]").val($('#field'+id+' .price').html());
	$("#UpdateFrom input[name=promo]").val($('#field'+id+' .promo').html());
	$("#UpdateFrom input[name=source]").val($('#field'+id+' .source').html());
	$("#UpdateFrom input[name=minorder]").val($('#field'+id+' .minorder').html());
	$('#UpdateFrom #content').html($('#field'+id+' .content').html());
	$("#UpdateFrom").modal('show');
	endloading();
}

function SaveForm(){
	var Data = {};
	Data['id'] = $("#UpdateFrom input[name=id]").val();
	Data['page_id'] = $("#page_id").val();
	Data['price'] = Number($("#UpdateFrom input[name=price]").val().replace(/[^0-9.-]+/g,""));
	Data['promo'] = Number($("#UpdateFrom input[name=promo]").val().replace(/[^0-9.-]+/g,""));
	Data['source'] = Number($("#UpdateFrom input[name=source]").val().replace(/[^0-9.-]+/g,""));
	Data['minorder'] = $("#UpdateFrom input[name=minorder]").val();
	Data['status'] = $("#UpdateFrom input[name=status]").prop("checked") ? 1 : 0;
	
	if(Data.price<1000){
		noticeMsg('Thông báo', 'Vui lòng nhập giá bán tối thiểu 1000', 'error');
		$('#UpdateFrom input[name=price]').focus();
		return false;
	}else if(Data.promo>0 && Data.promo>Data.price){
		noticeMsg('Thông báo', 'Giá khuyến mại phải nhỏ hơn giá bán', 'error');
		$('#UpdateFrom input[name=promo]').focus();
		return false;
	}else if(Data.source<1000){
		noticeMsg('Thông báo', 'Vui lòng nhập giá nhập tối thiểu 1000', 'error');
		$('#UpdateFrom input[name=source]').focus();
		return false;
	}else if(Data.price<Data.source){
		noticeMsg('Thông báo', 'Giá nhập phải nhỏ hơn giá bán hoặc giá khuyến mại', 'error');
		$('#UpdateFrom input[name=source]').focus();
		return false;
	}else if(Data.minorder<1){
		noticeMsg('Thông báo', 'Số lượng đặt hàng tối thiểu là 1', 'error');
		$('#UpdateFrom input[name=minorder]').focus();
		return false;
	}else{
		loading();
		Data['action'] = 'save_pageproduct';
		$.post("?mod=pages&site=addproduct", Data).done(function(e){
			var data = JSON.parse(e);
			if(data.code == 1){
				noticeMsg('Thông báo', data.msg, 'success');
				$("#UpdateFrom").modal('hide');
				setTimeout(function(){
					window.location.reload();
				}, 1200);
			}else{
				noticeMsg('Thông báo', data.msg, 'error');
				endloading();
			}
		});
	}
}

function LoadPageFrm(id) {
	$(".chosen-container").css("width", "100%");
	var data = {};
	data.post_id = $("#UpdateFrom input[name=post_id]").val();
	data.action = 'load_page';
	loading();
	$.post("?mod=posts&site=event_detail", data).done(function(e){
		var rt = JSON.parse(e);
		$("#UpdateFrom select[name=page_id]").html(rt.select_page);
		$('.chosen').trigger("chosen:updated");
	});
	$("#UpdateFrom").modal('show');
	endloading();
}

function SavePageFrm(){
	var data = {};
	data.post_id = $("#UpdateFrom input[name=post_id]").val();
	data.page_id = $("#UpdateFrom select[name=page_id]").val();
	data.action = 'save_page';
	console.log(data);
	if(data.page_id==0){
		noticeMsg('Thông báo', 'Vui lòng chọn gian hàng', 'error');
		$('#UpdateFrom select[name=page_id]').focus();
		return false;
	}else{
		loading();
		$.post("?mod=posts&site=event_detail", data).done(function(e){
			var data = JSON.parse(e);
			if(data.code == 1){
				noticeMsg('Thông báo', data.msg, 'success');
				$("#UpdateFrom").modal('hide');
				setTimeout(function(){
					window.location.reload();
				}, 1200);
			}else{
				noticeMsg('Thông báo', data.msg, 'error');
				endloading();
			}
		});
	}
}
</script>
{/literal}