<h3>Help Sections</h3>
<ul class="left mt-3">
	{foreach from=$a_main_category item=data}
	<li><a href="?cid={$data.id}">{$data.name} {if $data.sub}<i class="fa fa-angle-down float-right"></i>{/if}</a>
		{if $data.sub}
		<ul class="sub">
			{foreach from=$data.sub item=sub}
			<li><a href="?cid={$sub.id}">{$sub.name}</a></li>
			{/foreach}
		</ul>
		{/if}
	</li>
	{/foreach}
</ul>
