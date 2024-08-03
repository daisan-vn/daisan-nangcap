<p>Url: {$data.url|default:''}</p>
<div class="row row-sm">
	<div class="col-md-4">
		<img src="{$data.image|default:$arg.noimg}" width="100%" class="thumbnail">
	</div>
	<div class="col-md-8">
		<h3 class="mb-0">{$data.name|default:''}</h3>
		<p class="mb-0">Mã: {$data.sku|default:'none'}</p>
		<p class="mb-0">Thương hiệu: {$data.brand|default:'none'}</p>
		<p class="mb-0">Giá bán: <b>{$data.price|default:0|number_format}đ</b></p>
	</div>
</div>

<table class="table table-bordered">
	{foreach from=$data.a_metas key=k item=cont}
	<tr>
		<td width="25%">{$k}</td>
		<td>{$cont}</td>
	</tr>
	{/foreach}
</table>
{if isset($data.content)}
<div class="row row-sm">
<div class="col-md-12">
{$data.content}
</div>
</div>
{/if}