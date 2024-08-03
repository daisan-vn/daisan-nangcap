<div class="body-head">
	<h1><i class="fa fa-bars fa-fw"></i> Quản lý danh sách liên hệ</h1>
</div>
<div class="table-responsive">
	<table class="table table-bordered table-hover table-striped hls_list_table">
		<thead>
            <tr>
                <th width="30%">Người liên hệ</th>
                <th width="45%">Nội dung</th>
                <th class="text-right">Thời gian</th>
                <th class="text-right"></th>
            </tr>
		</thead>
		<tbody>
		{if $result neq NULL}
		{foreach from=$result item=data}
			<tr id="field{$data.id}">
				<td>
					<span class="field_name">{$data.name}</span>
					<p class="text-small">
						<span><i class="fa fa-fw fa-phone"></i> {$data.phone}</span>
						<span><i class="fa fa-fw fa-envelope-o"></i> {$data.email}</span>
					</p>
				</td>
				<td>{$data.description}</td>
				<td class="text-right">{$data.created}</td>
				<td class="text-right">
					<button class="btn btn-default btn-xs" data-toggle="modal" data-target="#ContactModal" onclick="GetContactDetail({$data.id});"><i class="fa fa-eye fa-fw"></i></button>
					<button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('home', {$data.id}, 'ajax_delete_contact');"><i class="fa fa-trash fa-fw"></i></button>
				</td>
			</tr>
		{/foreach}
		{else}
		<tr><td colspan="10">Không tìm thấy liên hệ nào</td></tr>
		{/if}
		</tbody>
	</table>
</div>
<div class="paging">{$paging}</div>

<div class="modal fade" id="ContactModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Chi tiết liên hệ</h4>
            </div>
            <div class="modal-body">
                <dl id="ContactDetail" class="dl-horizontal"></dl>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
function GetContactDetail(id) {
    $.post("?mod=home&site=ajax_get_contact", {'id': id}).done(function (data) {
        console.log(data);
        var new_data = JSON.parse(data);
        $("#ContactDetail").html(new_data);
    });
}
</script>
{/literal}
