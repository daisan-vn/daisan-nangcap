{if $result}
{foreach from=$result key=k item=data}
<div class="form-group row row-sm" id="Price{$k}">
	<label class="col-sm-4">
		<input type="text" class="form-control" onchange="SetPrice('key', {$k}, this.value);" value="{$data.key|default:''}" placeholder="Nhập mô tả giá">
	</label>
	<div class="col-sm-4">
		<input type="text" class="form-control text-right" onchange="SetPrice('value', {$k}, this.value);" oninput="SetMoney(this);" value="{$data.value|default:''}" placeholder="Nhập giá">
	</div>
	<div class="col-sm-4 text-right">
		{if $k eq 0}
		<button type="button" class="btn btn-primary btn-sm" disabled><i class="fa fa-arrow-up fa-fw"></i></button>
		{else}
		<button type="button" class="btn btn-primary btn-sm" onclick="SortPrice({$k}, 'up');"><i class="fa fa-arrow-up fa-fw"></i></button>
		{/if}
		{if $k neq ($out.number-1)}
		<button type="button" class="btn btn-primary btn-sm" onclick="SortPrice({$k}, 'down');"><i class="fa fa-arrow-down fa-fw"></i></button>
		{else}
		<button type="button" class="btn btn-primary btn-sm" disabled><i class="fa fa-arrow-down fa-fw"></i></button>
		{/if}
		<button type="button" class="btn btn-danger btn-sm" onclick="DeletePrice({$k});"><i class="fa fa-trash fa-fw"></i></button>
	</div>
</div>
{/foreach}
{else}
<h5>Chưa có giá cho sản phẩm, vui lòng tạo thêm.</h5>
{/if}