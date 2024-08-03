<div class="cate-body">
	<div class="cate-head" onclick="showAllCategory({$parent.parent});">
		<h3><i class="fa fa-arrow-left" aria-hidden="true"></i> <span class="ml-2">{$parent.name}</span></h3>
	</div>
	<ul>
		{foreach from=$taxonomy item=data}
		{if $data.hasub}
		<li>
			<a href="javascript:void(0);" onclick="showAllCategory({$data.id});">{$data.name}</a>
			<i class="fa fa-chevron-right" aria-hidden="true"></i>
		</li>
		{else}
		<li><a href="{$data.url}">{$data.name}</a></li>
		{/if}
		$a_main_category
		{/foreach}
		{vardump($data.name)};
	</ul>
</div>