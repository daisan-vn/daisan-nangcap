{if $services}
<div class="row row-sm">
	{foreach from=$services item=data}
	<div class="col-md-3" onclick="SetService({$data.id});" id="Service{$data.id}">
		<div class="card text-center">
			<img alt="{$data.name}" src="{$data.avatar}" width="100%">
			<div class="p-1">
				<small>{$data.name}</small>
			</div>
		</div>
	</div>
	{/foreach}
</div>
{else}
<h5>Chưa có nội dung sẵn có trên hệ thống, vui lòng tạo thêm.</h5>
{/if}