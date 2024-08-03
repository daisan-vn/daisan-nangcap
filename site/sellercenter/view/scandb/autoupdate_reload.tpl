<div class="list-group-item list-group-item-action">
	<i class="far fa-fw fa-circle"></i> Đang chờ quét: <b>{$out.waiting|default:0}</b>
	<i class="far fa-fw fa-dot-circle ml-3"></i> Đã quét: <b id="scanned">{$out.scanned|default:0}</b>
</div>

{foreach from=$db key=k item=v}
<div class="list-group-item list-group-item-action" id="item_{$k}">
	<div class="line-1">
		<i class="fa fa-fw fa-circle"></i>
		<a href="{$v.url|default:'#'}" target="_blank">{$v.url|default:'#'}</a>
	</div>
</div>
{/foreach}