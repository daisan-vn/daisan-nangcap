<div class="bg-white py-3 py-md-5" id="helpcenter">
	<div class="container d-none d-md-block">
		<h1 class="">Trung Tâm Trợ Giúp Daisan</h1>
		<h3>Chúng tôi sẽ hướng dẫn bạn cách khắc phục hầu hết mọi thứ tại đây hoặc kết nối bạn với ai đó nếu bạn cần thêm trợ giúp.</h3>
	</div>
	<hr class="my-5 d-none d-md-block" style="height: 0px; box-shadow: 0 6px 16px 0 #666;">
	<div class="container">
		<h3 class="text-b d-none d-md-block">Tìm kiếm trong thư viện trợ giúp. <i>Nhập nội dung như "câu hỏi về khoản phí"</i></h3>
	
		<div class="input-group input-group-lg mb-3 mb-md-5">
			<div class="input-group-prepend">
				<span class="input-group-text" id="basic-addon1"><i class="fa fa-search fa-fw"></i></span>
			</div>
			<input type="text" class="form-control" id="filter_key" placeholder="Tìm nội dung trợ giúp" onchange="filter_helpcenter();">
		</div>
		
		<h2 class="d-none d-md-block">Nội dung trợ giúp theo các chủ đề</h2>
		<div class="card-group" id="hctopic">
			<div class="card hccate">
				<div class="card-body">
					<div class="nav flex-column nav-pills d-none d-md-block" id="v-pills-tab" role="tablist" aria-orientation="vertical">
						{foreach from=$category key=k item=v}
						<a class="nav-link {if $k eq 0}active{/if}" id="v-{$v.id}-tab" data-toggle="pill" href="#v-{$v.id}" role="tab">{$v.name}</a>
						{/foreach}
					</div>
					<div class="nav flex-column nav-pills d-block d-md-none">
						{foreach from=$category key=k item=v}
						<a class="nav-link {if $k eq 0}active{/if}" href="{$arg.url_helpcenter}search.html?cId={$v.id}">{$v.name}</a>
						{/foreach}
					</div>
				</div>
			</div>
			<div class="card d-none d-md-block">
				<div class="card-body">
					<div class="tab-content" id="v-pills-tabContent">
						{foreach from=$category key=k item=v}
						<div class="tab-pane fade {if $k eq 0}show active{/if}" id="v-{$v.id}" role="tabpanel" aria-labelledby="v-{$v.id}-tab">
							<ul>
								<li><h3 class="text-b">{$v.name}</h3></li>
								{foreach from=$v.posts item=db}
								<li><a href="{$arg.url_helpcenter}display.html?pId={$db.id}">{$db.title}</a></li>
								{/foreach}
								<li class="mt-3"><a href="">› Nhiều hơn về {$v.name}</a></li>
							</ul>
						</div>
						{/foreach}
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
{literal}
<script type="text/javascript">
</script>
{/literal}