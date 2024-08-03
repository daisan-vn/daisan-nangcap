<h5>Giải pháp nhanh</h5>

{foreach from=$menu_help item=v}
<div class="mb-2">
	<div class="row row-sm">
		<div class="col-4">
			<img class="w-100" src="{$v.image}">
		</div>
		<div class="col-8">
			<p><a href="{$v.url}">{$v.name}</a></p>
			<p class="text-sm col-gray">{$v.title}</p>
		</div>
	</div>
</div>
{/foreach}