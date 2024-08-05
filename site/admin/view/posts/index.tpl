<p id="in_progress" class="pull-right"><i class="fa fa-circle-o-notch fa-spin fa-fw"></i> Đang xử lí</p>
<input type="hidden" id="PostIdUpdate">

<div class="body-head">
    <div class="row">
        <div class="col-md-8">
            <h1><i class="fa fa-bars fa-fw"></i> Quản lý {$out.Title}</h1>
        </div>
        <div class="col-md-4 text-right">
            <a href="{$out.url_create}" class="btn btn-primary"><i class="fa fa-plus fa-fw"></i> Thêm Mới</a>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-8">
        <div class="form-group form-inline">
            <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..." value="{$out.filter_keyword}">
            <select class="left form-control" id="category" title="Danh mục">{$out.filter_category}</select>
            <select class="left form-control" id="position" title="Position">{$out.filter_position}</select>
            <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm kiếm</button>
        </div>
    </div>
    <div class="col-md-4">
        <div class="form-group form-inline text-right">
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
    <table class="table table-bordered table-hover table-striped hls_list_table">
        <thead>
            <tr>
                <th class="text-center"><input type="checkbox" class="SelectAllRows"></th>
                <th>Tiêu đề</th>
                <th>Vị trí</th>
                <th>Sắp xếp</th>
                <th class="text-center">Nổi bật</th>
                <th class="text-center">TT</th>
                <th class="text-right"></th>
            </tr>
        </thead>
        <tbody>
            {if $result neq NULL} {foreach from=$result item=data}
            <tr id="field{$data.id}">
                <td class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
                <td width="50%">
                    <div class="row row-small">
                        <div class="col-md-2">
                            <img class="img" id="img{$data.id}" src="{$data.avatar}" onclick="ViewImage({$data.id},{$data.media_id});">
                        </div>
                        <div class="col-md-10">
                            <a href="{$data.url}" class="field_name" target="_blank">{$data.title}</a> {if $data.categories neq NULL}<br><span class="text-small"><i class="fa fa-folder-open-o fa-fw"></i> {$data.categories}</span>{/if}
                        </div>
                    </div>
                </td>
                <td style="max-width: 160px;">{$data.position}</td>
                <td><input class="form-control sort_input" type="number" name="sort" value="{$data.sort}" min="0" max="9999" oninput="sortItem('posts', {$data.id}, this.value);" /></td>
                <td class="text-center" id="featured{$data.id}">{$data.featured}</td>
                <td class="text-center" id="stt{$data.id}">{$data.status}</td>
                <td class="text-right" style="min-width:88px">
                    {if $out.type eq 'post'}
                    <button class="btn btn-xs btn-default" onclick="GetContent({$data.id});"><i class="fa fa-eye fa-fw"></i></button> {/if}
                    <a href="{$data.url_edit}" class="btn btn-default btn-xs" title="Sửa"><i class="fa fa-pencil fa-fw"></i></a>
                    <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('posts', {$data.id}, 'ajax_delete');"><i class="fa fa-trash fa-fw"></i></button>
                </td>
            </tr>
            {/foreach} {else}
            <tr>
                <td class="text-center" colspan="10"><br>Không có nội dung nào được tìm thấy<br><br></td>
            </tr>
            {/if}
        </tbody>
    </table>
</div>

<div class="paging">{$paging}</div>

<!-- Content Modal -->
<div class="modal fade" id="ContentPost">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Hiển thị chi tiết bài viết</h4>
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- View Image Modal -->
<div class="modal fade" id="ViewImage">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="MediaName">Hiển thị hình ảnh</h4>
            </div>
            <div class="modal-body">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="BtnChange">Thay đổi ảnh</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

{include '../media/media_modal.tpl'}

<script>
    var type = '{$out.type}';
</script>
{literal}
<script>
    $('#keyword,#category').keypress(function(event) {
        if (event.which == 13) filter();
    });

    function filter() {
        var key = $.trim($("#keyword").val());
        var position = $("#position").val();
        var cat = $("#category").val();
        var url = "?mod=posts&site=index&type=" + type;
        if (cat != 0) url = url + "&cat=" + cat;
        if (position != 0) url = url + "&position=" + position;
        if (key != '') url = url + "&key=" + key;
        window.location.href = url;
    }

    function BulkAction(pos) {
        PNotify.removeAll();
        var bulk = $('select[name=bulk' + pos + ']').val();
        if (bulk == '') {
            var notice = new PNotify({
                title: 'Chọn tác vụ',
                text: 'Vui lòng chọn 1 tác vụ',
                type: 'info',
                mouse_reset: false,
                buttons: {
                    sticker: false
                },
                animate: {
                    animate: true,
                    in_class: 'fadeInDown',
                    out_class: 'fadeOutRight'
                }
            });
            notice.get().click(function() {
                notice.remove();
            });
        } else if (bulk == 0) BulkDelete('posts', 'ajax_bulk_delete');
        else if (bulk == 1) BulkActive('posts', 1);
        else if (bulk == 2) BulkActive('posts', 0);
    }

    function ViewImage(id, media_id) {
        loading();
        $("#ViewImage .modal-body").load('?mod=media&site=detail', {
            'media_id': media_id
        }, function(data) {
            $("#ViewImage").modal('show');
            $('#ViewImage #BtnChange').attr('onclick', "LoadMedia('ChangeImage');");
            $('#PostIdUpdate').val(id);
            endloading();
        });

    }

    function ChangeImage(media_id) {
        loading();
        var id = $('#PostIdUpdate').val();
        $.post("?mod=posts&site=images", {
            'ajax': 'save_image_update',
            'media_id': media_id,
            'id': id
        }).done(function(e) {
            $("#img" + id).attr("src", e);
            $("#LoadMedia").modal('hide');
            endloading();
        });
    }
</script>
{/literal}