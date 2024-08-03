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
                <th class="text-left">Category Name</th>
                <th class="text-center">Featured/Active</th>
                <th class="text-center">Sort</th>
                <th width="100"></th>
            </tr>
            </thead>
            <tbody>
            {foreach from=$result item=data}
                <tr id="field{$data.id}">
                    <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
                    <td class="text-left">
                    	<img id="avatar{$data.id}" src="{$data.category_avatar|default:NULL}" title="Thay đổi ảnh đại diện" alt="" class="img-rounded" width="24px" height="24px" onclick="LoadMedia('SetTaxAvatar', {$data.id});">
                        <button class="btn btn-default btn-xs" title="{if $data.icon eq ''}Thêm icon{else}Đổi icon{/if}" type="button" data-toggle="modal" onclick="geticon({$data.id});" data-target="#LoadIcon" id="icon{$data.id}">
                            <i class="fa {if $data.icon eq ''}fa-plus{else}{$data.icon}{/if} fa-fw"></i>
                        </button>
                        <span class="field_name"><a href="?mod=taxonomy&site=index&type=product&id={$data.id}">{$data.name}</a></span>
                    </td>
                    <td class="text-center">
                    	<span id="fea{$data.id}">{$data.btn_featured}</span>
                    	<span id="stt{$data.id}" class="field_status">{$data.btn_status}</span>
                    </td>
                    <td class="text-center">
                        <button id="down{$data.id}" {if $data.down_unable}disabled{/if} class="btn btn-default btn-xs" title="Di chuyển xuống" onclick="ChangeOrder({$data.id}, 'down');"><i class="fa fa-arrow-down fa-fw"></i></button>
                        <button id="up{$data.id}" {if $data.up_unable}disabled{/if} class="btn btn-default btn-xs" title="Di chuyển lên" onclick="ChangeOrder({$data.id}, 'up');"><i class="fa fa-arrow-up fa-fw"></i></button>
                    </td>
                    <td class="text-center" style="min-width:88px">
                        <button type="button" class="btn btn-default btn-xs" title="Sửa" data-toggle="modal" data-target="#UpdateFrom" onclick="LoadDataForForm({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('taxonomy', {$data.id}, 'ajax_delete');"><i class="fa fa-trash fa-fw"></i></button>
                    </td>
                </tr>
            {/foreach}
            <tr style="display: none" id="non_item"><td class="text-center" colspan="10">Không tìm thấy danh mục nào</td></tr>
            </tbody>
        </table>
    </div>
    <div class="paging">{$paging}</div>
</div>

<input type="hidden" id="TaxId">
{include '../media/media_modal.tpl'}

{literal}
<script>
$(".SelectAllRows").click(function () {
    $(".item_checked, .SelectAllRows").prop('checked', $(this).prop('checked'));
});

function SetTaxAvatar(media_id) {
    $('#LoadMedia').modal('hide');
    loading();
    var tax_id = $('#TaxId').val();
    $.post("?mod=taxonomy&site=ajax_handle", {
    	'ajax': 'ajax_update_avatar',
    	'media_id':media_id, 
    	'tax_id':tax_id
    }).done(function(e){
        endloading();
        $('#avatar'+tax_id).attr('src', decodeURIComponent(e));
        console.log(e);
    });
}

</script>
{/literal}