<div class="container" style="
background: #F3F3EE;">
	<div class="py-4">
		<div class="row row-nm">
			{foreach from=$tax.menu_top item=data}
			<div class="col-md-3">
				<div class="card mb-3 border-0 rounded-0">
					<div class="card-body service_item">
						<div class="logo_service">
							<a href="{$data.alias}"><img src="{$data.image}"></a>
						</div>
						<h3 class="mt-3"><a href="{$data.alias}">{$data.name}</a></h3>
						<p>{$data.title}</p>
					</div>
				</div>
			</div>
			{/foreach}
		</div>

		<div class="row row-nm">
			{foreach from=$tax.menu_top_right item=c}
			<div class="col-md-4 mb-3">
				<div class="card h-100">
					<div class="card-body">
						<h2 class="h5 text-b">{$c.name}</h2>
						<ul class="a-unordered-list a-nostyle a-vertical">
							{foreach from=$c.submenu item=v}
							<li class="mb-2"><span class="a-list-item"><a href="{$v.url}">{$v.name}</a></span></li>
							{/foreach}
						</ul>
					</div>
				</div>
			</div>
			{/foreach}
		</div>


	</div>
</div>