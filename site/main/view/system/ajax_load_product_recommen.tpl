<div class="row row-nm">
	{foreach from=$result item=data}
	<div class="col-xl-2 col-lg-3 col-md-3 col-sm-6 col-6 mb-md-3 box_product">
		<div class="card rounded-0 item_product p-md-2">
				<a href="{$data.url}" class="img"><img src="{$data.avatar}" alt="{$data.name}" width="100%" class="img-fluid" ></a>
				<div class="">
					<h2 class="card-title pt-2 mb-1">
						<a href="{$data.url}">{$data.name}</a>
					</h2>
					<div class="card-text price">
						<b>{$data.price}{if $data.pricemax gt 0}-{$data.pricemax|number_format}{/if}</b>
						{if $data.price neq 0}<span class="unit">/ {$data.unit}</span>{/if}
					</div>
					<div class="card-text">{$data.minorder} {$data.unit} (Min.Order)</div>
				</div>
		</div>
	</div>
	{/foreach}
</div>
