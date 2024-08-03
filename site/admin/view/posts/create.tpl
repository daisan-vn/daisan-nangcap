<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<p id="imglist_added" class="pull-right"><i class="fa fa-check-circle fa-fw"></i> Thêm ảnh thành công</p>
<p id="imglist_exist" class="pull-right"><i class="fa fa-info-circle fa-fw"></i> Ảnh này đã được thêm</p>
<div class="body-head">
    <div class="row">
        <div class="col-md-8">
            <h1><i class="fa fa-pencil fa-fw"></i> {$out.Title}</h1>
        </div>
        {if $view_url}
        <div class="col-md-4 text-right">
            <a href="{$view_url}" class="btn btn-primary" target="_blank">Xem bài viết</a>
        </div>
        {/if}
    </div>
    
</div>

<form method="post" onsubmit="return CheckBeforeSave();">
    <div class="item sml">
        <div class="box">
            <div class="row">
                <input type="hidden" name="post_id" class="form-control" value="{$post.post_id|default:0}">
                <div class="col-sm-8">
                    <div class="form-group">
                        <label for="alias">Tiêu đề</label>
                        <input type="text" name="title" oninput="ChangeUrl(this.value, '#alias'); ClearTooltip();" autofocus required class="form-control" value="{$post.title|default:''}">
                    </div>
                    <div class="form-group">
                        <label for="alias">Alias (Chuỗi đường dẫn tĩnh sử dụng cho url)</label>
                        <input id="alias" type="text" value="{$post.alias|default:''}" class="form-control" name="alias">
                        <p class="help-block"></p>
                    </div>
                    <div class="form-group">
                        <label>Nội dung mô tả (Meta description)</label>
                        <textarea name="description" rows="5" class="form-control">{$post.description|default:''}</textarea>
                    </div>
                </div>
                <div class="col-sm-4">
                    {if $out.type neq 'question'}
                    <!-- Categories -->
                    <h1 class="item-header">Chọn danh mục</h1>
                    <div class="ul-list" id="taxonomy">{$out.checkbox_taxonomy}</div>
                    <hr class="short_hr">
                    <a class="add_cate_btn" href="#addCate" data-toggle="collapse">Thêm danh mục</a>

                    <div id="addCate" class="collapse">
                        <div class="form-group">
                            <label class="sr-only">Tên danh mục</label>
                            <input type="text" class="form-control" name="taxonomy_name" placeholder="Tên danh mục" oninput="ClearTooltip();">
                        </div>
                        <div class="form-group">
                            <label class="control-label">Danh mục cha</label>
                            <select class="form-control" name="parent">{$out.select_parent}</select>
                        </div>
                        <button type="button" class="btn btn-info btn-sm" onclick="SaveTaxonomy();">Thêm danh mục</button>
                    </div>
                    {/if}
                </div>
            </div>
            <!-- End Categories -->
        </div>
    </div>

    <div class="item sml">
        <div class="box">
            <div class="row">
                <div class="col-sm-8">
                    <div class="form-group">
                        <label>Từ khóa (Meta keyword)</label>
                        <textarea name="keyword" rows="3" class="form-control" placeholder="Từ khóa dùng cho seo bài viết">{$post.keyword|default:''}</textarea>
                    </div>
                    <div id="Tags">
                        <h3 class="item-header">Chọn tags cho bài viết</h3>
                        <div class="form-group">
                            <select class="form-control chosen-select" name="tags[]" multiple>{$out.tags}</select>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <h3 class="item-header">Ảnh đại diện</h3>
                    <div class="row row-small">
                        <div class="col-md-6">
                            <img src="{$post.avatar}" style="max-width: 100%;" id="PostAvatar">
                        </div>
                        <input id="img_id" name="media_id" type="hidden" value="{$post.media_id|default:0}">
                        <div class="col-md-6">
                            <div class="checkbox">
                                <label>
									<input type="checkbox" name="avatar_status" {if isset($post.avatar_status) && $post.avatar_status eq 1}checked{/if}>
									Hiển thị hình ảnh trong chi tiết bài viết
								</label>
                            </div>
                            <button type="button" class="btn btn-default btn-sm" onclick="LoadMedia('SetPostAvatar');">
								<i class="fa fa-picture-o fa-fw"></i> Chọn ảnh
							</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-8">
            {if $out.type eq 'post' || $out.type eq 'question' || $out.type eq 'project' || $out.type eq 'support'}
            <div class="form-group">
                <textarea id="post_content" rows="20" name="content" class="form-control tinymce">{$post.content|default:''}</textarea>
            </div>
            {else if $out.type eq 'album'}
            <div class="item sml">
                <div class="box">
                    <h1 class="item-header">Danh sách ảnh trong album</h1>
                    <div class="row row-small" id="listImageContent" style="min-height: 100px;">
                        {if isset($album)} {foreach from=$album item=data}
                        <div class="col-md-3" id="col{$data.media_id}">
                            <div class="img_elem">
                                <button type="button" class="btn btn-xs btn-default img_product" onclick="UnsetListImage({$data.media_id})"><i class="fa fa-times"></i></button>
                                <img src="{$data.image}" width="100%">
                            </div>
                        </div>
                        {/foreach} {/if}
                    </div>
                    <hr>
                    <div class="">
                        <button type="button" class="btn btn-default btn-sm" onclick="LoadMedia('SetListImage');">
	                        <i class="fa fa-picture-o fa-fw"></i> Chọn ảnh đưa vào album
	                    </button>
                        <input type="hidden" name="image_list" value="{$post.listImage|default:''}">
                    </div>
                </div>
            </div>
            {else if $out.type eq 'video'}
            <div class="item sml">
                <div class="box">
                    <h3 class="item-header">Nhập nội dung video</h3>
                    <div class="form-group">
                        <input type="text" name="content" required class="form-control" value="{$post.content|default:''}" placeholder="Nhập Url video youtube...">
                        <p class="help-block">Copy link video trên website https://youtube.com/ để sử dụng cho website.</p>
                    </div>
                </div>
            </div>
            {/if}
        </div>
        <div class="col-sm-4">
            <div class="item sml">
                <div class="box">
                    <div class="row row-small">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="alias">Ngày hiển thị</label>
                                <input type="text" name="date_public" class="form-control datepicker" value="{$post.date_public|date_format:'%d-%m-%Y'|default:''}">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="alias">Ngày kết thúc</label>
                                <input type="text" name="date_expire" class="form-control datepicker" value="{$post.date_expire|date_format:'%d-%m-%Y'|default:''}">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label">Vị trí hiển thị</label>
                        <select class="form-control" name="position">{$out.select_position}</select>
                    </div>
                    <div class="checkbox" style="margin-top:0">
                        <label><input type="checkbox" name="status" {if (!isset($post.status)) || (isset($post.status) && $post.status eq 1)}checked{/if}> Kích hoạt / khóa bài viết</label>
                    </div>
                    <div class="checkbox" style="margin-top:0">
                        <label><input type="checkbox" name="featured" {if (isset($post.featured) && $post.featured eq 1)}checked{/if}> Đánh dấu bài viết nổi bật</label>
                    </div>
                    <hr>
                    <button type="submit" class="btn btn-success" name="submit"><i class="fa fa-check fa-fw"></i> Lưu thông tin</button>
                    <a href="" class="btn btn-default">Hủy bỏ</a>
                </div>
            </div>
        </div>
    </div>
</form>

{include '../media/media_modal.tpl'}

<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<script src="{$arg.stylesheet}custom/tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}custom/tinymce/tinymce.conf.js"></script>
<script>
    var post_id = '{$post.post_id|default:0}';
    var imglist_str = '{$imglist_arr|default:NULL}';
    var imglist_arr = imglist_str.split('-');
    var default_type = '{$post.type|default:NULL}';

    var listimg_str = '{$post.listImage|default:NULL}';
    var listimg_arr = listimg_str.split('-');
</script>
{literal}
<script>
    $(function() {
        BindImgClear();
    });
    $(".chosen-select").chosen({
        disable_search_threshold: 10
    });
    $(".datepicker").datepicker({
        dateFormat: 'dd-mm-yy'
    });

    function BindImgClear() {
        $(".img_elem").mouseenter(function() {
            $(this).children("button").css("visibility", "visible");
        });
        $(".img_elem").mouseleave(function() {
            $(this).children("button").css("visibility", "hidden");
        });
    }

    function SetListImage(id) {
        var imgid = id.toString();
        if (listimg_arr.indexOf(imgid) == -1) {
            listimg_arr.push(imgid);
            $.post('?mod=media&site=ajax_get_image', {
                'id': id,
                'thumb': 1
            }).done(function(e) {
                var data = JSON.parse(e);
                var newimg = '<div class="col-md-3" id="col' + id + '"><div class="img_elem"><button type="button" class="btn btn-xs btn-default img_product" onclick="UnsetListImage(' + id + ');"><i class="fa fa-times"></i></button><img src="' + decodeURIComponent(data.avatar) + '" width="100%"></div></div>';
                $("#listImageContent").append(newimg);
                BindImgClear();
            });
            listimg_str = listimg_arr.join('-');
            $('input[name=image_list]').val(listimg_str);
            $('#imglist_added').show();
            setTimeout(function() {
                $('#imglist_added').fadeOut();
            }, 1000);
        } else {
            $('#imglist_exist').show();
            setTimeout(function() {
                $('#imglist_exist').fadeOut();
            }, 1000);
        }
    }

    function UnsetListImage(id) {
        var imgid = id.toString();
        var index_unset = listimg_arr.indexOf(imgid);
        if (index_unset > -1) {
            listimg_arr.splice(index_unset, 1);
            listimg_str = listimg_arr.join('-');
            $('input[name=image_list]').val(listimg_str);
            $("#col" + id).remove();
        }
    }

    function CheckBeforeSave() {
        var input_test = $.trim($('input[name=title]').val());
        var patt = /[\\'"`{}]/;
        var test_input = patt.test(input_test);
        var alias_test = $.trim($('input[name=alias]').val());
        var patt_alias = /^[a-z\d\-%_]+$/i;
        var test_alias = patt_alias.test(alias_test);

        if (input_test == '' || test_input) {
            $('input[name=title]').focus();
            noticeMsg('Kiểm tra lại tên bài viết', 'Tên bài viết không hợp lệ', 'error');
            return false;
        } else if (!test_alias) {
            $('input[name=alias]').focus();
            noticeMsg('Kiểm tra lại alias', 'Alias không hợp lệ', 'error');
            return false;
        } else return true;
    }

    $('#addCate').on('shown.bs.collapse', function() {
        $('input[name=taxonomy_name]').focus();
    });

    $('input[name=taxonomy_name], select[name=parent]').keypress(function(event) {
        if (event.which == 13) {
            SaveTaxonomy();
        }
    });

    function ClearTooltip() {
        $("input[name=taxonomy_name]").tooltip('destroy');
    }

    function SaveTaxonomy() {
        var input_test = $.trim($('input[name=taxonomy_name]').val());
        var patt = /[\\'"`{}]/;
        var test_input = patt.test(input_test);

        if (input_test == "") {
            $('input[name=taxonomy_name]').focus().tooltip({
                'trigger': 'manual',
                'title': 'Vui lòng nhập tên danh mục',
                'placement': 'top',
                'delay': {
                    "show": 500,
                    "hide": 0
                }
            }).tooltip('show');
        } else if (test_input) {
            $('input[name=taxonomy_name]').focus().tooltip({
                'trigger': 'manual',
                'title': 'Tên danh mục không hợp lệ',
                'placement': 'top',
                'delay': {
                    "show": 500,
                    "hide": 0
                }
            }).tooltip('show');
        } else {
            DisableForm("#addCate");
            var $form = $('#addCate'),
                url = '?mod=taxonomy&site=ajax_handle';
            var name = $form.find("input[name=taxonomy_name]").val();
            var parent = $form.find("select[name=parent]").val();
            var posting = $.post(url, {
                ajax: 'save_taxonomy_content',
                name: name,
                alias: get_alias(name),
                parent: parent,
                taxonomy_id: 0,
                type: 'category',
                auto: 1
            }).done(function(data) {
                var data = JSON.parse(data);
                var new_cate = '<div id="TaxId' + data.insert_id + '"><div class="checkbox"><label><input name="category[]" value="' + data.insert_id + '" type="checkbox" checked> ' + name + '</label></div></div>';
                //console.log(new_cate);
                if (parent == 0) $('#taxonomy .check_level:first').prepend(new_cate);
                else if (parent != 0) {
                    if ($('#taxonomy div[id=TaxId' + parent + '] .check_level:first').length == 0) {
                        $('#taxonomy div[id=TaxId' + parent + ']').append('<div class="check_level">' + new_cate + '</div>');
                    } else {
                        $('#taxonomy div[id=TaxId' + parent + '] .check_level:first').prepend(new_cate);
                    }
                }
                noticeMsg('Thêm danh mục thành công', 'Đã thêm danh mục <b>' + name + '</b>', 'success');
                $('#TaxId' + data.insert_id).css({
                    'color': '#468847',
                    'font-style': 'italic'
                });
                setTimeout(function() {
                    $('#TaxId' + data.insert_id).css({
                        'color': '#333',
                        'font-style': 'normal'
                    });
                }, 1800);
                EnableForm("#addCate");
                $('select[name=parent]').html(data.new_select_parent);
                $('input[name=taxonomy_name]').val('').focus();
            });
        }
    }
</script>
{/literal}