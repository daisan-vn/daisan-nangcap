<h4>Quản lý danh sách gian hàng theo dõi</h4>
<hr>
<div class="mt-3">
	{foreach from=$pages item=data}
	<div class="row row-nm">
		<div class="col-2">
			<a href="{$data.url_page}"><img class="img-thumbnail" src="{$data.logo}" width="100%"></a>
		</div>
		<div class="col-10">
			<h5 class="card-title mb-3"><a href="{$data.url_page}">{$data.name}</a></h5>
			<p class="mb-0">
				<button class="btn btn-sm btn-primary" onclick="Remove({$data.id});">
					<i class="fa fa-remove"></i> Bỏ theo dõi
				</button>
			</p>
		</div>
	</div>
	<hr>
	{/foreach}
</div>

<script type="text/javascript">
function Remove(id){
	var data = {};
	data['id'] = id;
	data['ajax_action'] = 'remove_page_favorite';

	loading();
	$.post('?mod=page&site=ajax_handle', data).done(function(e){
		noticeMsg('System Message', 'Bỏ theo dõi gian hàng thành công.', 'success');
		setTimeout(function(){
			location.reload();
		}, 2000);
	});

}
</script>