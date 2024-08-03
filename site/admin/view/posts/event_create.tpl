<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<p id="imglist_added" class="pull-right"><i class="fa fa-check-circle fa-fw"></i> Thêm ảnh thành công</p>
<p id="imglist_exist" class="pull-right"><i class="fa fa-info-circle fa-fw"></i> Ảnh này đã được thêm</p>
<div class="body-head">
	<h1><i class="fa fa-pencil fa-fw"></i> Quản lý nội dung sự kiện</h1>
</div>

<form method="post" onsubmit="return CheckBeforeSave();">

	<div class="row">
        <div class="col-sm-8">
			<div class="form-group">
				<label>Tiêu đề sự kiện</label> 
				<input type="text" name="title" autofocus required class="form-control" value="{$post.title|default:''}">
			</div>
			<div class="row">
				<div class="col-sm-4">
					<div class="form-group">
						<label>Ngày bắt đầu</label> 
						<input type="text" name="start_date" class="form-control datepicker" value="{$post.time_start|default:''|date_format:'%d-%m-%Y'}">
					</div>
				</div>
				<div class="col-sm-3">
					<div class="form-group">
						<label>Thời gian bắt đầu</label> 
						<input type="text" name="start_time" class="form-control" value="{$post.time_start|default:''|date_format:'%H:%M'}" placeholder="00:00">
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-4">
					<div class="form-group">
						<label>Ngày kết thúc</label> 
						<input type="text" name="finish_date" class="form-control datepicker" value="{$post.time_finish|default:''|date_format:'%d-%m-%Y'}">
					</div>
				</div>
				<div class="col-sm-3">
					<div class="form-group">
						<label>Thời gian kết thúc</label> 
						<input type="text" name="finish_time" class="form-control" value="{$post.time_finish|default:''|date_format:'%H:%M'}" placeholder="22:00">
					</div>
				</div>
			</div>
			<div class="form-group">
				<label>Từ khóa (Meta keyword)</label>
				<textarea name="keyword" rows="3" class="form-control" placeholder="Từ khóa dùng cho seo bài viết">{$post.keyword|default:''}</textarea>
			</div>
			<div class="form-group">
				<label>Nội dung mô tả (Meta description)</label>
				<textarea name="description" rows="5" class="form-control">{$post.description|default:''}</textarea>
			</div>
            <div class="form-group">
                <textarea id="post_content" rows="20" name="content" class="form-control">{$post.content|default:''}</textarea>
            </div>
        </div>
        <div class="col-sm-4">
            <div class="item sml">
                <div class="box">
					<h3 class="item-header">Ảnh đại diện</h3>
					<div class="row row-small">
						<div class="col-md-6">
							<img src="{$post.avatar}" style="max-width: 100%;" id="AvatarShowImg">
						</div>
						<div class="col-md-6">
							<p>Chọn ảnh đại diện cho sự kiện</p>
							<input type="file" onchange="ImgUpload(this, 'Avatar')">
							<input id="Avatar" name="avatar" type="hidden"> 
						</div>
					</div>
					<br>
					<h3 class="item-header">Ảnh banner</h3>
					<div class="">
						<img src="{$post.banner}" style="width: 100%;" id="BannerShowImg">
					</div>
					<p>Chọn ảnh</p>
					<input type="file" onchange="ImgUpload(this, 'Banner')">
					<input id="Banner" name="banner" type="hidden"> 
					<br>
                    <div class="form-group">
                        <label class="control-label">Danh mục</label>
                        <select class="form-control" name="taxonomy_id">{$out.select_taxonomy}</select>
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

<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce-config.js"></script>
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
$(function () {
    BindImgClear();
});
$(".chosen-select").chosen({disable_search_threshold: 10});
$( ".datepicker" ).datepicker({dateFormat: 'dd-mm-yy'});

function BindImgClear() {
    $(".img_elem").mouseenter(function () {
        $(this).children("button").css("visibility", "visible");
    });
    $(".img_elem").mouseleave(function () {
        $(this).children("button").css("visibility", "hidden");
    });
}

function CheckBeforeSave() {
    var input_test = $.trim($('input[name=title]').val());
    var start_date = $.trim($('input[name=start_date]').val());
    var start_time = $.trim($('input[name=start_time]').val());
    var finish_date = $.trim($('input[name=finish_date]').val());
    var finish_time = $.trim($('input[name=finish_time]').val());
    var patt = /[\\'"`{}]/;
    var test_input = patt.test(input_test);

    if (input_test == '' || test_input) {
        $('input[name=title]').focus();
        noticeMsg('Kiểm tra lại tên bài viết', 'Tên bài viết không hợp lệ', 'error');
        return false;
    }else if (start_date == '') {
        $('input[name=start_date]').focus();
        noticeMsg('Thông báo', 'Chọn ngày bắt đầu', 'error');
        return false;
    }else if (start_time == '') {
        $('input[name=start_time]').focus();
        noticeMsg('Thông báo', 'Chọn thời gian bắt đầu', 'error');
        return false;
    }else if (finish_date == '') {
        $('input[name=finish_date]').focus();
        noticeMsg('Thông báo', 'Chọn ngày bắt đầu', 'error');
        return false;
    }else if (finish_time == '') {
        $('input[name=finish_time]').focus();
        noticeMsg('Thông báo', 'Chọn thời gian bắt đầu', 'error');
        return false;
    }else return true;
}

$('#addCate').on('shown.bs.collapse', function () {
    $('input[name=taxonomy_name]').focus();
});

$('input[name=taxonomy_name], select[name=parent]').keypress(function (event) {
    if (event.which == 13) {
        SaveTaxonomy();
    }
});

function ClearTooltip() {
    $("input[name=taxonomy_name]").tooltip('destroy');
}
</script>
{/literal}