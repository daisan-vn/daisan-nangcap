<h4>Quản lý danh sách sản phẩm yêu thích</h4>
<hr>
<div class="mt-3">
	{foreach from=$result item=data}
	<div class="row row-nm">
		<div class="col-2">
			<a href="{$data.url}"><img class="img-thumbnail" src="{$data.avatar}" width="100%"></a>
		</div>
		<div class="col-10">
			<h5 class="card-title mb-1"><a href="{$data.url}">{$data.name}</a></h5>
			<p class="mb-1">Giá từ: <b class="text-lg">{$data.price|number_format} VND</b></p>
			<p class="mb-2">Gian hàng: <a href="{$data.url_page}">{$data.pagename}</a></p>
			<p class="mb-0">
				<button class="btn btn-sm btn-primary" onclick="Remove({$data.id});">
					<i class="fa fa-remove"></i> Bỏ theo dõi sản phẩm
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
	data['ajax_action'] = 'remove_product_favorite';

	loading();
	$.post('?mod=product&site=ajax_handle', data).done(function(e){
		noticeMsg('System Message', 'Bỏ theo dõi gian hàng thành công.', 'success');
		setTimeout(function(){
			location.reload();
		}, 2000);
	});

}
</script>