<div class="bg-white py-4 px-3" id="helpcenter">
	<div class="container-fluid">
		<h2 class="text-b mb-3 d-none d-md-block">Trung Tâm Trợ Giúp Khách Hàng</h2>
		
		<div class="row row-nm">
			<div class="col-md-2 d-none d-md-block">
				<div class="card">
					<div class="p-2 bartoppic">
						<h3 class="mb-3">Mục nội dung</h3>
						{foreach from=$category item=v}
						<p><a href="{$arg.url_helpcenter}search.html?cId={$v.id}">{$v.name}</a></p>
						{/foreach}
					</div>
				</div>
				<div class="card mt-3">
					<div class="p-2">
						{include file='../includes/sbhelpcenter.tpl'}
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="pl-md-4 py-md-5">
					<h3 class="text-b d-none d-md-block">Tìm thêm giải pháp hỗ trợ</h3>
					<div class="input-group input-group-lg mb-3 mb-md-5">
						<div class="input-group-prepend">
							<span class="input-group-text" id="basic-addon1"><i class="fa fa-search fa-fw"></i></span>
						</div>
						<input type="text" class="form-control" id="filter_key" placeholder="Tìm nội dung trợ giúp" onchange="filter_helpcenter();">
					</div>
					<div class="d-block d-md-none mb-3" id="hcback">
						<a href="{$arg.url_helpcenter}"><i class="fa fa-chevron-left"></i> Quay trở về trang đầu</a>
					</div>
					
					<h1>Kết quả tìm kiếm từ trung tâm trợ giúp</h1>
					{if $out.number gt 0}
					<h3>{$out.number} kết quả được tìm thấy cho "{$out.key|default:''}"</h3>
					<hr class="my-4">
					{else}
					<h3>Không tìm được kết quả phù hợp cho "{$out.key|default:''}". Hãy thử lại với từ khóa khác xem sao.</h3>
					{/if}
					{foreach from=$posts item=v}
					<div>
						<h3 class="text-b"><a href="{$arg.url_helpcenter}display.html?pId={$v.id}">{$v.title}</a></h3>
						<p>{$v.description}</p>
					</div>
					<hr class="my-4">
					{/foreach}
					
					<div>{$paging}</div>
					
				</div>
			
			</div>
		</div>
		
	</div>
	
</div>