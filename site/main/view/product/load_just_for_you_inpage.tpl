{foreach from=$result item=data}
<div class="producr-item">
	<a href="{$data.url}" class="border d-block"><img src="{$data.avatar}" class="img-fluid"></a>
	<p class="py-2"><a href="{$data.url}" class="text-dark">{$data.name}</a></p>
</div>
{/foreach}
