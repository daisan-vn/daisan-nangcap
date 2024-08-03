<div class="card-header">
	<h3>Nhân viên chăm sóc khách hàng</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">
	{foreach from=$themes item=data}
	<div class="card rounded-0 mb-3">
		<div class="row">
			<div class="col-md-2">
				<img alt="{$data.name}" src="{$data.avatar}" width="100%">
			</div>
			<div class="col-md-6">
				<h4 class="mt-3">{$data.title}</h4>
				<p>Theme: {$data.name}</p>
				<p>Updated: {$data.date_update|date_format:'%d/%m/%Y'}</p>
			</div>
			<div class="col-md-4">
				<div class="p-3 text-right">
					{if $data.status eq 1}
					<button type="button" class="btn btn-success"><i class="fa fa-check fa-fw"></i> Đang sử dụng</button>
					{else}
					<button type="button" onclick="ActiveTheme('{$data.id}');" class="btn btn-success"><i class="fa fa-cog fa-fw"></i> Kích hoạt</button>
					{/if}
					<a href="{$data.url_demo}" target="_blank" class="btn btn-primary">Xem Demo</a>
				</div>
			</div>
		</div>
	</div>
	{/foreach}
</div>

<script type="text/javascript">
function ActiveTheme(id){
	var Data = {};
	Data['ajax_action'] = "active_theme";
	Data['id'] = id;
	loading();
	$.post('?mod=theme&site=index', Data).done(function(e){
		endloading();
		location.reload();
	});
}
</script>