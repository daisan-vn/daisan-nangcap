<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">

<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>

<div class="body-head">

    <div class="row">

        <div class="col-md-8">

            <h1><i class="fa fa-bars fa-fw"></i> Quản lý loại thuộc tính</h1>

        </div>

        <div class="col-md-4 text-right">

        </div>

    </div>

</div>


<!--
<div class="row">

    <div class="col-md-9">

        <div class="form-group form-inline">

            <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..."

                value="">

            <input type="hidden" id="page_id" value="{$out.page_id}">

            <select class="left form-control" id="category">

                <option value="-1">Tất cả danh mục</option>

                {$out.filter_category}

            </select>

            <select class="left form-control" id="status">{$out.filter_status}</select>

            <button type="button" class="btn btn-default" onclick="filter();"><i class="fa fa-search fa-fw"></i> Tìm

                kiếm</button>

        </div>

    </div>

    <div class="col-md-3">

        <div class="form-group form-inline text-right">

            <select class="left form-control" name="bulk1">

                <option value="">Chọn tác vụ</option>

                <option value="0">Xóa nhiều</option>

                <option value="1">Kích hoạt</option>

                <option value="2">Hủy kích hoạt</option>

                <option value="3">Cập nhật danh mục</option>

                <option value="5">Sao chép</option>

            </select>

            <button id="search_btn" type="button" class="btn btn-default" onclick="BulkAction(1);">Áp dụng</button>

        </div>

    </div>

</div>
-->


<div class="table-responsive">

    <table class="table table-bordered table-hover table-striped">

        <thead>

            <tr>

                <th class="text-center">#ID</th>

                <th>Tên loại</th>

                <th>Thuộc tính</th>

                <th>Khởi tạo</th>

                <th>Admin</th>

                

                <th class="text-right">Hành động</th>

            </tr>

        </thead>

        <tbody>

            {if $result neq NULL}

            {foreach from=$result item=data}

            <tr id="field{$data.id}">

                <td class="text-center">

                    <a href="?mod=product&site=attribute&id={$data.id}">#{$data.id}</a>

                </td>

                <td width="20%">

                    {$data.name}

                </td>

                <td width="40%">

                    <span class="text-small">

                    {foreach from=JSON_decode($data.contents) key=k item=v}

                     {$v->name},

                    {/foreach}

                    </span>

                </td>

                <td>{$data.created|date_format:'%H:%M:%S %d-%m-%Y'}</td>

                <td>{$data.admin_id}</td>

                

                <td class="text-right" style="min-width:88px">

                    <a href="?mod=product&site=opt_attribute_img&id={$data.id}" class="btn btn-default btn-xs" title="Thêm và sửa hình ảnh thuộc tính con"><i class="fa fa-photo fa-fw"></i></a>



                    <a href="?mod=product&site=opt_attribute&id={$data.id}" class="btn btn-default btn-xs" title="Thêm và sửa thuộc tính con"><i class="fa fa-list fa-fw"></i></a>



                    <a href="?mod=product&site=attribute&id={$data.id}" class="btn btn-default btn-xs" title="Thêm và sửa thuộc tính"><i class="fa fa-pencil fa-fw"></i></a>

                    

                    <a href="?mod=product&site=delete_attribute&id={$data.id}" class="btn btn-default btn-xs delete-attribute" title="Xóa thuộc tính"><i class="fa fa-trash fa-fw"></i></a>

                    

                </td>

            </tr>

            {/foreach}

            {else}

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



<!-- Content Modal -->

<div class="modal fade" id="FrmCopy">

    <div class="modal-dialog modal-sm">

        <div class="modal-content">

            <div class="modal-header">

                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>

                <h4 class="modal-title">Copy sản phẩm tới gian hàng</h4>

            </div>

            <div class="modal-body">

                <p>Vui lòng nhập mã gian hàng muốn copy sản phẩm tới</p>

                <input type="text" name="page_id" class="form-control">

                <p>Nếu chưa biết mã, vui lòng <a href="?mod=pages&site=index" target="_blank">click vào đây</a> để tìm

                    mã gian hàng</p>

            </div>

            <div class="modal-footer">

                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>

                <button type="button" class="btn btn-success" onclick="CopyProducts();">Lưu thông tin</button>

            </div>

        </div>

    </div>

</div>



<div class="modal fade" id="FrmSetCate">

    <div class="modal-dialog">

        <div class="modal-content">

            <div class="modal-header">

                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>

                <h4 class="modal-title">Cập nhật danh mục sản phẩm</h4>

            </div>

            <div class="modal-body">

                <p>Vui lòng chọn danh mục cho sản phẩm</p>

                <select class="form-control" name="taxonomy_id">

                    {$out.filter_category}

                </select>



            </div>

            <div class="modal-footer">

                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>

                <button type="button" class="btn btn-success" onclick="SetCate();">Lưu thông tin</button>

            </div>

        </div>

    </div>

</div>





{literal}

<script>

    $(window).ready(function () {

        $("select[name=taxonomy_id]").chosen({ width: '100%' });

    });

    $('#keyword,#category').keypress(function (event) {

        if (event.which == 13) filter();

    });



    $('.delete-attribute').on('click', function(){

        var result = confirm("Want to delete?");

        if (result) {

            //Logic to delete the item

        }

    });

    function filter() {

        var key = $.trim($("#keyword").val());

        var page_id = $("#page_id").val();

        var status = $("#status").val();

        var cat = $("#category").val();

        var url = "?mod=product&site=index";

        if (cat != -1) url = url + "&cat=" + cat;

        if (page_id != 0) url = url + "&page_id=" + page_id;

        if (status != -1) url = url + "&status=" + status;

        if (key != '') url = url + "&key=" + key;

        window.location.href = url;

    }



    function BulkAction(pos) {

        PNotify.removeAll();

        var bulk = $('select[name=bulk' + pos + ']').val();

        var arr = [];

        $(".item_checked").each(function () {

            if ($(this).is(':checked')) {

                var value = $(this).val();

                arr.push(value);

            }

        });



        if (bulk == '') {

            noticeMsg('Thông báo', 'Vui lòng chọn một tác vụ.', 'error');

        } else if (arr.length < 1) noticeMsg('Thông báo', 'Vui lòng chọn các sản phẩm cần xử lí', 'warning');

        else if (bulk == 0) BulkDelete('product', 'ajax_delete_multi');

        else if (bulk == 1) BulkActive('products', 1);

        else if (bulk == 2) BulkActive('products', 2);

        else if (bulk == 3) $('#FrmSetCate').modal('show');

        else if (bulk == 5) $('#FrmCopy').modal('show');

    }







    function CopyProducts() {

        var arr = [];

        $(".item_checked").each(function () {

            if ($(this).is(':checked')) {

                var value = $(this).val();

                arr.push(value);

            }

        });

        var data = {};

        data.page_id = $('#FrmCopy input[name=page_id]').val();

        data.ids = arr;

        if (arr.length < 1) {

            noticeMsg('Chọn mục xử lí', 'Vui lòng chọn các mục cần xử lí', 'warning');

            return false;

        } else if (data.page_id == '') {

            noticeMsg('Thông báo', 'Vui lòng nhập mã gian hàng', 'warning');

            $('#FrmCopy input[name=page_id]').focus();

            return false;

        }

        loading();

        $.post("?mod=product&site=ajax_copy_product", data).done(function (rt) {

            rt = JSON.parse(rt);

            if (rt.code == '0') noticeMsg('Thông báo', rt.msg, 'error');

            else noticeMsg('Thông báo', rt.msg, 'success');

            endloading();

            setTimeout(function () {

                location.reload();

            }, 2000);

        });

    }



    function SetCate() {

        var data = {};

        data.ids = [];

        $(".item_checked").each(function () {

            if ($(this).is(':checked')) data.ids.push($(this).val());

        });

        data.taxonomy_id = $('#FrmSetCate select[name=taxonomy_id]').val();

        if (data.ids.length < 1) {

            noticeMsg('Chọn mục xử lí', 'Vui lòng chọn các mục cần xử lí', 'warning');

            return false;

        } else if (data.taxonomy_id == 0) {

            noticeMsg('Thông báo', 'Vui lòng chọn danh mục sản phẩm', 'warning');

            $('#FrmSetCate select[name=taxonomy_id]').focus();

            return false;

        }

        data.ajax_action = 'set_taxonomy_multi_product';

        loading();

        $.post("?mod=product&site=ajax_handle", data).done(function (rt) {

            endloading();

            setTimeout(function () {

                location.reload();

            }, 1200);

        });

    }



</script>

{/literal}