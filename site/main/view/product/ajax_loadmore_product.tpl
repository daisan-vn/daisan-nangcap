{foreach from=$a_product key=k item=data}
<li class="col-5th"><a href="{$data.url}" class="d-block"> <img
		class="d-block w-100" data-src="{$data.avatar}" alt="{$data.name}">
</a>
	<div class="prod-info">
		<div class="title">
			<span class="kind">Gian hàng tiêu chuẩn</span>
			<h3>
				<a href="{$data.url}">{$data.name}</a>
			</h3>
		</div>
		<div class="price">{$data.price}{if $data.pricemax gt
			0}-{$data.pricemax|number_format}{/if}</div>
		<div class="moq">Tối thiểu: {$data.minorder} {$data.unit}</div>
	</div></li>
{/foreach}
