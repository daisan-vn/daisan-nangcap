{if $result}
<ul>
	{foreach from=$result key=k item=data}
	<li id="SugId{$k+1}"><a href="{$data.url}">{$data.name}</a></li>
	{/foreach}
</ul>
{/if}