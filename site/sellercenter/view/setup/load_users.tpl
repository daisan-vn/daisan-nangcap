{if $users}
<div class="row row-sm">
	{foreach from=$users item=data}
	<div class="col-md-2" id="User{$data.id}">
		<div class="card text-center">
			<img alt="{$data.name}" src="{$data.avatar}" width="100%">
			<div class="card-footer p-1">
				<p><small>{$data.name}</small></p>
				<p class="mb-1"><button type="button" class="btn btn-sm btn-primary" onclick="SetUser({$data.id});">Lựa chọn</button></p>
			</div>
		</div>
	</div>
	{/foreach}
</div>
{else}
<h5>Không tìm được người dùng nào phù hợp.</h5>
{/if}