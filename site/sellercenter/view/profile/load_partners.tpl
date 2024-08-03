{if $partners}
<div class="row row-sm">
	{foreach from=$partners item=data}
	<div class="col-md-2" onclick="SetPartner({$data.id});" id="Partner{$data.id}">
		<div class="card text-center">
			<img alt="{$data.name}" src="{$data.logo}" width="100%">
			<div class="card-footer p-1">
				<small>{$data.name}</small>
			</div>
		</div>
	</div>
	{/foreach}
</div>
{else}
<h5>Không tìm được công ty nào phù hợp.</h5>
{/if}