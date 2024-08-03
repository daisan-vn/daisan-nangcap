<div class="list-group-item list-group-item-action">
	<i class="far fa-fw fa-circle"></i> Đang chờ quét: <b>{$out.waiting|default:0}</b>
	<i class="far fa-fw fa-dot-circle ml-3"></i> Đã quét: <b id="scanned">{$out.scanned|default:0}</b>
	<i class="far fa-fw fa-dot-circle ml-3"></i> Tìm được: <b id="number">{$out.number|default:0}</b> SP
	<i class="far fa-fw fa-spinner fa-pulse ml-3"></i> Tiến trình: <b>{$out.process|default:0}%</b>
	<i class="far fa-fw fa-clock ml-3"></i> Dự kiến: <b>{$out.estimate|default:0} phút</b>
</div>

{foreach from=$db key=k item=v}
<div class="list-group-item list-group-item-action" id="item_{$k}">
	<div class="line-1">
		<i class="fa fa-fw fa-circle"></i>
		<a href="{$v|default:'#'}" target="_blank">{$v}</a>
	</div>
</div>
{/foreach}