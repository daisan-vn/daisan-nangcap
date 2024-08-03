<div style="margin:-1.25rem;">
	<div class="card-header">
		<h3>Tin nhắn & Liên hệ</h3>
	</div>
	
	<div class="card-group">
		<div class="card rounded-0 border-top-0 border-left-0 border-bottom-0" style="flex-grow: 0.50">
			<div class="p-3" id="Filter">
	
				<div class="input-group mb-3">
					<input type="text" class="form-control" id="key" placeholder="Tên hoặc nội dung liên hệ...">
					<div class="input-group-append">
						<button class="btn btn-primary" type="button" onclick="Filter();">
							<i class="fa fa-fw fa-search"></i>
						</button>
					</div>
				</div>
				<div class="row row-sm">
					<div class="col-md-6">
						<select class="form-control" id="status">
							{$out.select_status}
						</select>
					</div>
					<div class="col-md-6">
						<select class="form-control" id="type">
							{$out.select_type}
						</select>
					</div>
				</div>
	
			</div>
	
	
			<ul class="list-group list-group-flush">
				{if $parents}
				{foreach from=$parents item=data}
				<li class="list-group-item">
					<div class="row row-sm">
						<div class="col-md-2">
							<img alt="{$data.name}" src="{$data.avatar}" class="w-100 rounded-circle">
						</div>
						<div class="col-md-10">
							<h6 class="mb-1">{$data.name}</h6>
							<p class="text-small text-one-line mb-0"><a href="{$data.url}">{$data.message}</a></p>
							<p class="text-small text-one-line mb-0">{$data.created|date_format:'%H:%M %d/%m/%Y'}</p>
						</div>
					</div>
				</li>
				{/foreach}
				<li class="list-group-item">
					<div class="text-small">
						{$paging}
					</div>
				</li>
				{else}
				<li class="list-group-item">
					<p>Chưa có tin nhắn hoặc liên hệ nào được gửi tới gian hàng của bạn.</p>
					<p>Vui lòng cập nhật đầy đủ thông tin gian hàng, sản phẩm dịch vụ để tăng lượng tương tác tới gian hàng.</p>
				</li>
				{/if}
			</ul>
	
		</div>
	
		<div class="card rounded-0 border-top-0 border-right-0 border-bottom-0">
			{if $info}
			<div class="p-3">
				<div class="row row-sm">
					<div class="col-md-1">
						<img src="{$info.avatar}" class="w-100 rounded-circle">
					</div>
					<div class="col-md-11">
						<p class="my-1"><b>{$info.name}</b> gửi liên hệ tới <b>{$info.page_name}</b></p>
						<p class="text-small">{$info.created|date_format:'%H:%M %d/%m/%Y'}</p>
						{if $info.product_id neq 0}
						<div class="border-dashed p-2">
							<div class="row row-sm">
								<div class="col-md-1">
									<a href="{$info.producturl}"><img src="{$info.productavatar}" class="w-100"></a>
								</div>
								<div class="col-md-11">
									<p><a href="{$info.producturl}">{$info.productname}</a></p>
								</div>
							</div>
						</div>
						{/if}
					</div>
				</div>
			</div>
			<div class="p-3 bg-gray">
				<p class="text-center"><small>This message was sent to you only.</small></p>
				
				<div id="msgbody">
					{foreach from=$contacts key=k item=data}
					{if $data.isreply eq 1}
					<div class="row row-sm msg right">
						<div class="col-md-11">
							<div class="mb-1">
								<b>{$data.name}</b>
								<span class="ml-2">{$data.created|date_format:'%H:%M %d/%m/%Y'}</span>
							</div>
							<div class="content">{$data.message}</div>
						</div>
						<div class="col-md-1">
							<img alt="{$data.name}" src="{$data.avatar}" class="w-100 rounded-circle">
						</div>
					</div>
					{else}
					<div class="row row-sm msg">
						<div class="col-md-1">
							<img alt="{$data.name}" src="{$data.avatar}" class="w-100 rounded-circle">
						</div>
						<div class="col-md-11">
							<div class="mb-1">
								<b>{$data.name}</b>
								<span class="ml-2">{$data.created|date_format:'%H:%M %d/%m/%Y'}</span>
							</div>
							<div class="content">{$data.message}</div>
						</div>
					</div>
					{/if}
					{/foreach}
				</div>
				
				<div class="sendmsg">
					<p class="mb-1 text-small">Nhập nội dung phản hồi liên hệ của khách hàng tại đây (20~1000 ký tự).</p>
					<input type="hidden" name="parent" value="{$out.parent_id}">
					<textarea rows="3" class="form-control rounded-0"></textarea>
					<button class="btn btn-success btn-sm mt-2" onclick="SendMsg();"><i class="fa fa-fw fa-envelope-o"></i> Send message</button>
				</div>
	
			</div>
			{/if}
		</div>
	
	</div>
</div>
<script type="text/javascript">

function SendMsg(){
	var data = {};
	data['parent'] = $(".sendmsg input[name=parent]").val();
	data['message'] = $(".sendmsg textarea").val();
	data['ajax_action'] = 'send_msg';
	
	if(data.message.length<20 || data.message.length>1000){
		noticeMsg('System Message', 'Nội dung phải chứa 20 đến 1000 ký tự', 'error');
		$(".sendmsg textarea").focus();
		return false;
	}
	
	loading();
	$.post('?mod=account&site=messages', data).done(function(e){
		location.reload();
	});
}

function Filter(){
    var key = $.trim($("#Filter #key").val());
    var status=$("#status").val();
    var type = $("#type").val();
    var url = "?mod=contact&site=index";
    if(type!=0) url = url+"&type="+type;
    if(status!=-1) url = url+"&status="+status;
    if(key!='') url = url+"&key="+key;
    location.href = url;
}

</script>