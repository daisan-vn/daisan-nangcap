<div class="col-sm-8">
    <div id="cover_data"></div>
	<div class="row">
		<div class="col-md-6">
			<div class="form-group form-inline">
				<div class="input-group">
					<input type="search" class="left form-control" id="key" placeholder="Tên danh mục" value="{$out.key|default:NULL}">
					<span class="input-group-btn">
						<button id="search_btn" type="button" class="btn btn-default" onclick="filter();">Tìm kiếm</button>
					</span>
				</div>
			</div>
		</div>
		<div class="col-md-6 text-right">
			<div class="form-group form-inline">
				<select class="left form-control" name="bulk1">
					<option value="">Chọn tác vụ</option>
					<option value="0">Xóa</option>
					<option value="1">Kích hoạt</option>
					<option value="2">Hủy kích hoạt</option>
				</select>
				<button id="search_btn" type="button" class="btn btn-default" onclick="BulkAction(1);">Áp dụng</button>
			</div>
		</div>
	</div>

    <div class="table-responsive">
        <table id="taxonomy_table" class="table table-bordered table-hover table-striped hls_list_table">
            <thead>
            <tr>
                <th class="text-center"><input type="checkbox" class="SelectAllRows"></th>
                <th class="text-left">Tên danh mục</th>
                <th class="text-center">Sắp xếp</th>
                <th class="text-center">Nổi bật</th>
                <th class="text-center">Kích hoạt</th>
                <th width="100"></th>
            </tr>
            </thead>
            <tbody>
            {foreach from=$result item=data}
                <tr id="field{$data.taxonomy_id}">
                    <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.taxonomy_id}"></td>
                    <td class="text-left">
                        <button class="btn btn-default btn-xs" title="{if $data.icon eq ''}Thêm icon{else}Đổi icon{/if}" type="button" data-toggle="modal" onclick="geticon({$data.taxonomy_id});" data-target="#LoadIcon" id="icon{$data.taxonomy_id}">
                            <i class="fa {if $data.icon eq ''}fa-plus{else}{$data.icon}{/if} fa-fw" aria-hidden="true"></i>
                        </button>
                        <span class="field_name">{$data.name}</span>
                    </td>
                    <td class="text-center">
                        <button id="down{$data.taxonomy_id}" {if $data.down_unable}disabled{/if} class="btn btn-default btn-xs" title="Di chuyển xuống" onclick="ChangeOrder({$data.taxonomy_id}, 'down');"><i class="fa fa-arrow-down fa-fw"></i></button>
                        <button id="up{$data.taxonomy_id}" {if $data.up_unable}disabled{/if} class="btn btn-default btn-xs" title="Di chuyển lên" onclick="ChangeOrder({$data.taxonomy_id}, 'up');"><i class="fa fa-arrow-up fa-fw"></i></button>
                    </td>
                    <td id="featured{$data.taxonomy_id}" class="text-center">{$data.btn_featured}</td>
                    <td id="stt{$data.taxonomy_id}" class="field_status text-center">{$data.btn_status}</td>
                    <td class="text-center" style="min-width:88px">
                    	{if $data.featured neq 1}
                        <button type="button" class="btn btn-default btn-xs" title="Sửa" data-toggle="modal" data-target="#UpdateFrom" onclick="LoadDataForForm({$data.Id});"><i class="fa fa-pencil fa-fw"></i></button>
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('taxonomy', {$data.Id}, 'ajax_delete');"><i class="fa fa-trash fa-fw"></i></button>
                    	{/if}
                    </td>
                </tr>
            {/foreach}
            <tr style="display: none" id="non_item"><td class="text-center" colspan="10">Không tìm thấy danh mục nào</td></tr>
            </tbody>
        </table>
    </div>
    <div class="paging">{$paging}</div>
</div>

{literal}
<script>
    $(".SelectAllRows").click(function () {
        $(".item_checked, .SelectAllRows").prop('checked', $(this).prop('checked'));
    });
</script>
{/literal}