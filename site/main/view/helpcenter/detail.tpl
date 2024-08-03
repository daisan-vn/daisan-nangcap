<div class="bg-white py-4 px-3" id="helpcenter">
	<div class="container-fluid">
		<h2 class="text-b mb-3 d-none d-md-block">Trung Tâm Trợ Giúp Khách Hàng</h2>
		
		<div class="row row-nm">
			<div class="col-md-2 d-none d-md-block">
				<div class="card">
					<div class="p-2">
						<a href="{$arg.url_helpcenter}">‹ Tất cả chủ đề trợ giúp</a>
					</div>
					<hr class="my-1">
					<div class="p-2">
						<p>{$info.title}</p>
						{foreach from=$other item=v}
						<p><a href="{$arg.url_helpcenter}display.html?pId={$v.id}">{$v.title}</a></p>
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
					
					<h1>{$info.title}</h1>
					<h3>{$info.description}</h3>
					<hr>
					<div id="hcdetail">{$info.content}</div>
					
					<div class="card mt-3" style="max-width: 60%">
						<div class="card-body">
							<p class="mb-3">Thông tin này có hữu ích với bạn không?</p>
							<button class="btn btn-outline-secondary">Đúng</button>
							<button class="btn btn-outline-secondary">Không</button>
						</div>
					</div>
					
				</div>
			
			</div>
		</div>
		
	</div>
	
</div>