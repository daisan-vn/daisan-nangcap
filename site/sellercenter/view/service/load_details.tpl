{if $result}
{foreach from=$result key=k item=data}
<div class="form-group row row-sm" id="Detail{$k}">
	<label class="col-sm-3">
		<input type="text" class="form-control" onchange="SetDetail('key', {$k}, this.value);" value="{$data.key|default:''}">
	</label>
	<div class="col-sm-7">
		<input type="text" class="form-control" onchange="SetDetail('value', {$k}, this.value);" value="{$data.value|default:''}">
	</div>
	<div class="col-sm-2 text-right">
		{if $k eq 0}
		<button type="button" class="btn btn-primary btn-sm" disabled><i class="fa fa-arrow-up fa-fw"></i></button>
		{else}
		<button type="button" class="btn btn-primary btn-sm" onclick="SortDetail({$k}, 'up');"><i class="fa fa-arrow-up fa-fw"></i></button>
		{/if}
		{if $k neq ($out.number-1)}
		<button type="button" class="btn btn-primary btn-sm" onclick="SortDetail({$k}, 'down');"><i class="fa fa-arrow-down fa-fw"></i></button>
		{else}
		<button type="button" class="btn btn-primary btn-sm" disabled><i class="fa fa-arrow-down fa-fw"></i></button>
		{/if}
		<button type="button" class="btn btn-danger btn-sm" onclick="DeleteDetail({$k});"><i class="fa fa-trash fa-fw"></i></button>
	</div>
</div>
{/foreach}
{else}
<h5>Chưa có nội dung sẵn có trên hệ thống, vui lòng tạo thêm.</h5>
{/if}