<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-select@1.13.14/dist/css/bootstrap-select.min.css">

<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<style>
    .badge-info {
        color: #333 !important;
        background-color: #fff !important;
    }
    .btn-e-custom {
        width: 100%;
        display: inline-block;
        padding: 5px 0;
        margin-bottom: 10px;
    }
</style>
<div class="body-head">
    <div class="row">
        <div class="col-md-8">
            <h1><i class="fa fa-bars fa-fw"></i> Thêm thuộc tính nhanh </h1>
        </div>
        <div class="col-md-4 text-right">
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-9">
        <div class="form-group form-inline">
            <input type="search" class="left form-control" id="keyword" placeholder="Từ khóa..."
                value="{$out.filter_keyword}">
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
                <option value="6" selected>Thêm thuộc tính</option>
            </select>
            <button id="search_btn" type="button" class="btn btn-default" onclick="BulkAction(1);">Áp dụng</button>
        </div>
    </div>
</div>

<div class="table-responsive">
    <input type="hidden" name="folder_img" value="{$folder|default:''}">
    <table class="table table-bordered table-hover table-striped">
        <thead>
            <tr>
                <th width="20px" class="text-center"><input type="checkbox" class="SelectAllRows"></th>
                <th width="20%">Tiêu đề</th>
                <th class="text-center">Thuộc tính</th>
                <th width="100px" class="text-right">Hành động</th>
            </tr>
        </thead>
        <tbody>
            {if $result neq NULL}
            {foreach from=$result item=data}
            <tr id="field{$data.id}">
                <td  class="text-center"><input type="checkbox" class="item_checked" value="{$data.id}"></td>
                <td >
                    <div class="row row-small">
                        <div class="col-md-12 col-sm-12 col-xs-12" style="padding: 0 10%;">
                            <a href="?mod=product&site=form&id={$data.id}" class="field_name" target="_blank">#{$data.id}</a><br>
                        </div>
                        <div class="col-md-12 col-sm-12 col-xs-12" style="padding: 10%;">
                            <img class="img" id="img{$data.id}" src="{$data.avatar}">
                        </div>
                        <div class="col-md-12" style="padding: 0 13px;">
                            <a href="{$data.url}" class="field_name" target="_blank">{$data.name}</a><br>
                            <span class="text-small"><i class="fa fa-tags fa-fw"></i> {$data.code}</span> |
                            <span class="text-small"><i class="fa fa-tags fa-fw"></i> {$data.page}</span><br>
                            <span class="text-small"><i class="fa fa-folder-open-o fa-fw"></i> {$data.category}</span>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="row row-small">
                        <div class="col-xs-12">
                            <div class="form-group row">
                                <!-- <label class="col-sm-2 col-form-label">Loại thuộc tính</label> -->
                                <div class="col-sm-10 col-sm-offset-2">
                                    <select name="attribute_id_{$data.id}" class="form-control" onchange="changeAttribute(this.value, {$data.id})" >
                                        <option value="0">Chọn loại thuộc tính</option>
                                        {foreach from=$groupAttr key=k item=v}
                                        <option value="{$v.id}" {if $v.id==$data.groupattributes_id}selected{/if}>{$v.name}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <div class="col-xs-12">
                            <input type="hidden" name="length_attribute_{$data.id}" value="{count($data.arr_contents_attr)}">
                            <div class="class" id="detailAttribute_{$data.id}" >
                                <!-- contents_attr -->
                                {if count($data.arr_contents_attr)>0}
                                
                                {foreach from=$data.arr_contents_attr key=k item=v}
                                
                                <div class="form-group row">
                                    <label class="col-sm-2 col-form-label text-right"><i>{$v.name}</i></label>
                                    <input type="hidden" name="detail_attribute_name_{$k+1}_{$data.id}" id="detail_attribute_name_{$k+1}_{$data.id}" value="{$v.name}">
                                    <input type="hidden" name="length_attribute_child_{$k+1}_{$data.id}" value="{count($v['contents'])}">

                                    <div class="col-sm-10">
                                        <input type="hidden" name="detail_attribute_name_{$k+1}_{$data.id}" id="detail_attribute_name_{$k+1}_{$data.id}" value="{$v.name}">
                                        <input type="hidden" name="length_attribute_child_{$k+1}_{$data.id}" value="{count($v['contents'])}">
                                        <select class="form-control selectpicker" 
                                            id="detail_attribute_content_{$k+1}_{$data.id}" 
                                            name="detail_attribute_content_{$k+1}_{$data.id}[]" 
                                            data-live-search="true"
                                            data-none-selected-text="Chọn" 
                                            data-select-all-text="Chọn tất cả" 
                                            data-deselect-all-text="Bỏ tất cả"
                                            data-actions-box="true" multiple>
                                            
                                            {foreach from=$v['contents'] key=k2 item=v2}
                                        
                                            <option value="{$v2.name}"
                                                data-content="<span class='badge badge-info'>{if $v2.img_name != '' && $v2.img_name != null}<img src='{$folder}{$v2.img_name}' width='30px'style='margin-right: 5px;'>{/if}{$v2.name}</span>"
                                                {if $v2.actived=='true' }selected{/if}>s
                                                {$v2.name}
                                            </option>
                                
                                            {/foreach}
                                
                                        </select>
                                    </div>
                                </div>
                                {/foreach}
                                {else}
                                <div class="form-group row">
                                    <label class="col-sm-2 col-form-label">{$v.name}</label>
                                    <div class="col-sm-8">
                                        <input type="hidden" name="detail_attribute_name_{$k+1}_{$data.id}" value="{$v.key}">
                                        <input type="text" class="form-control" name="detail_attribute_content_{$k+1}_{$data.id}" value="{$v.content}">
                                    </div>
                                </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                </td>
                <td class="text-right" style="min-width:88px">
                    <button type="button" class="btn btn-success btn-xs btn-e-custom" title="Lưu"
                        onclick="SaveOneAttr('{$data.id}')"><i class="fa fa-floppy-o fa-fw"></i>&nbsp; Lưu</button>

                    <a href="?mod=product&site=form&id={$data.id}" target="_blank" class="btn btn-info btn-xs btn-e-custom"><i
                            class="fa fa-wrench fa-fw"></i>&nbsp; Sửa</a>
                    
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
<!-- Attr Modal -->
<div class="modal fade" id="FrmAttr">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title">Cập nhật thuộc tính sản phẩm</h4>
            </div>
            <div class="modal-body">
                <p>Vui lòng chọn thuộc tính cho sản phẩm</p>
                <select name="attribute_id_modal" class="form-control" onchange="changeAttributeOnModal(this.value)">
                    <option value="0">Chọn loại thuộc tính</option>
                    {foreach from=$groupAttr key=k item=v}
                    <option value="{$v.id}">{$v.name}</option>
                    {/foreach}
                </select>
            </div>
            <div class="modal-body">
                <div id="detailAttribute_modal">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-success" onclick="SetAttr();">Lưu thông tin</button>
            </div>
        </div>
    </div>
</div>
<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce-config.js"></script>
<!-- Latest compiled and minified JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap-select@1.13.14/dist/js/bootstrap-select.min.js"></script>

{literal}
<script>
    $(window).ready(function () {
        $("select[name=taxonomy_id]").chosen({ width: '100%' });
    });
    $('#keyword,#category').keypress(function (event) {
        if (event.which == 13) filter();
    });
    var FolderImg = $("input[name=folder_img]").val();

    function SaveOneAttr($id){
        var length_attribute = $("input[name=length_attribute_"+$id+"]").val();
        var attribute_id = $("select[name=attribute_id_" + $id + "]").val();

        if (length_attribute > 0) {
            var data = [];
            for (let i = 1; i <= length_attribute; i++) {
                var $detail_attr = $("#detail_attribute_content_"+i+"_"+$id);
                var $name_attr = $("#detail_attribute_name_" + i + "_" + $id);
                var detail_attr = $detail_attr.val() || [];
                var name_attr = $name_attr.val();
                var arr_push = {
                    "name" : name_attr,
                    "contents" : detail_attr
                };
                data.push(arr_push);
            } 
            // ajax
            var Data = {};
            Data['id'] = $id;
            Data['attribute_id'] = attribute_id;
            Data['attr'] = data;
            Data['ajax_action'] = "add_fast_one";
            loading();
            $.post("?mod=product&site=ajax_handle", Data).done(function (e) {
                endloading();
            });
        }
        
        console.log("length_attribute : " + length_attribute);
        console.log("attribute_id : " + attribute_id);
        console.log(data);
    }

    function changeAttribute($value, $id) {

        var Data = {};
        Data['id'] = $value;
        Data['ajax_action'] = "load_detail_attribute";

        loading();
        $.post('?mod=product&site=ajax_handle', Data).done(function (e) {
            if (e.length > 0) {
                var $data = JSON.parse(e);
                var data = JSON.parse($data);
                var xhtml = "";

                data.forEach((element, index) => {
                    var i = index + 1;
                    var data_contents = element.contents;
                    
                    if (data_contents.length > 0) {
                        var yhtml = `<select class="form-control selectpicker" 
                                id="detail_attribute_content_` + i + `_` + $id +`" 
                                name="detail_attribute_content_` + i + `_`+ $id +`[]" 
                                data-live-search="true" 
                                data-none-selected-text="Chọn" 
                                data-select-all-text="Chọn tất cả" 
                                data-deselect-all-text="Bỏ tất cả" 
                                data-actions-box="true" 
                                multiple>`;
                        var zhtml = "";
                        data_contents.forEach((v, k) => {
                            var ahtml = "";
                            if (v.img_name != '' && v.img_name != null) {
                                ahtml = `<img src='` + FolderImg + v.img_name + `' width='30px' style='margin-right: 5px;'>`;
                            }
                            zhtml += `<option value="` + v.name + `" data-content="<span class='badge badge-info'>` + ahtml + v.name + `</span>">` + v.name + `</option>`;
                        });

                        yhtml += zhtml + `</select>`;
                    } else {
                        var yhtml = `<input type="text" class="form-control" name="detail_attribute_content_` + i + `_` + $id + `">`;
                    }

                    xhtml +=    `<div class="form-group row">
                                    <label class="col-sm-2 col-form-label">`+ element.name + `</label>
                                    <div class="col-sm-10">
                                        <input type="hidden" name="detail_attribute_name_`+ i + `_` + $id +`" id="detail_attribute_name_` + i + `_` + $id +`" value="` + element.name + `">
                                        `+ yhtml + `
                                    </div>
                                </div>`;
                });
                
                $("#detailAttribute_"+$id).html(xhtml);
                
                var length_attribute = $("input[name=length_attribute_" + $id + "]").val(data.length);
                
                // console.log($data.length);
                // lenght_attribute
                endloading();
                $('.selectpicker').selectpicker();
            }
            endloading();
        });
    }

    function filter() {
        var key = $.trim($("#keyword").val());
        var page_id = $("#page_id").val();
        var status = $("#status").val();
        var cat = $("#category").val();
        var url = "?mod=product&site=add_fast";
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
        else if (bulk == 6) $('#FrmAttr').modal('show');
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

    function changeAttributeOnModal($id) {
        var Data = {};
        Data['id'] = $id;
        Data['ajax_action'] = "load_detail_attribute";

        loading();
        $.post('?mod=product&site=ajax_handle', Data).done(function (e) {
            if (e.length > 0) {
                var $data = JSON.parse(e);
                var data = JSON.parse($data);

                var xhtml = `<input type="hidden" name="length_attribute_modal" value="` + data.length + `">`;

                data.forEach((element, index) => {
                    var i = index + 1;
                    var data_contents = element.contents;

                    if (data_contents.length > 0) {
                        var yhtml = `<input type="hidden" name="length_attribute_modal_child_` + i + `" value="` + data_contents.length + `">
                    <select class="form-control selectpicker" 
                        id="detail_attribute_content_modal_` + i + `" 
                        name="detail_attribute_content_modal_` + i + `[]" 
                        data-live-search="true" 
                        data-none-selected-text="Chọn" 
                        data-select-all-text="Chọn tất cả" 
                        data-deselect-all-text="Bỏ tất cả" 
                        data-actions-box="true" 
                        multiple>`;
                        var zhtml = "";
                        data_contents.forEach((v, k) => {
                            var ahtml = "";
                            if (v.img_name != '' && v.img_name != null) {
                                ahtml = `<img src='` + FolderImg + v.img_name + `' width='30px' style='margin-right: 5px;'>`;
                            }
                            zhtml += `<option value="` + v.name + `" data-content="<span class='badge badge-info'>` + ahtml + v.name + `</span>">` + v.name + `</option>`;
                        });

                        yhtml += zhtml + `</select>`;
                    } else {
                        var yhtml = ``;
                    }

                    xhtml += `<div class="form-group row">
                            <label class="col-sm-2 col-form-label" id="detail_attribute_name_modal_`+ i + `">` + element.name + `</label>
                            <div class="col-sm-10">
                                `+ yhtml + `
                            </div>
                        </div>`;
                });

                $("#detailAttribute_modal").html(xhtml);
                // console.log($data.length);
                endloading();
                $('.selectpicker').selectpicker();
            }
            endloading();
        });
    }
    
    function SetAttr(){
        var data = {};
        data.ids = [];
        $(".item_checked").each(function () {
            if ($(this).is(':checked')) data.ids.push($(this).val());
        });

        var lenght_attribute = $('input[name=length_attribute_modal]').val();
        var attribute_id = $('select[name=attribute_id_modal]').val();
        
        var data_contents = [];
        for (let i = 1; i <= parseInt(lenght_attribute); i++) {
            var $name_attr = $("#detail_attribute_name_modal_" + i);
            var name_attr = $name_attr.text();

            var $detail_attr = $("#detail_attribute_content_modal_" + i);
            var detail_attr = $detail_attr.val() || [];
            
            var arr_push = {
                "name": name_attr,
                "contents": detail_attr
            };
            data_contents.push(arr_push);
        }

        // ajax
    
        data['attribute_id'] = attribute_id;
        data['attr'] = data_contents;
        data['ajax_action'] = "add_fast_select";
        data['url'] = window.location.href;
        loading();
        $.post("?mod=product&site=ajax_handle", data).done(function (e) {
            window.location.href = e;
            endloading();
        });
        
        console.log(data.ids);
        console.log("lenght_attribute : " + lenght_attribute);
        console.log("attribute_id : " + attribute_id);
        console.log(data_contents);
        console.log(data);
    }
</script>
{/literal}