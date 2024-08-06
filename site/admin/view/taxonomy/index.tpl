<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<p id="in_progress" class="pull-right"><i class="fa fa-circle-o-notch fa-spin fa-fw"></i> Đang xử lí</p>
<div class="body-head">
	<h1><i class="fa fa-bars fa-fw"></i> Quản lý {$out.type_prefix}</h1>
</div>

<div class="row">
	<div class="col-sm-4">
        <h4 id="form_title">Thêm {$out.type_prefix}</h4>
		<form id="taxonomy_form" enctype="multipart/form-data" method="post" action="">
            <input type="hidden" name="id" value="0">
			<div class="form-group">
				<label class="sr-only">Tên danh mục</label>
				<input type="text" class="form-control" name="name" placeholder="Tên danh mục" autofocus oninput="ChangeUrl(this.value, '#alias'); ClearTooltip();">
			</div>
			<div class="form-group">
				<label class="sr-only">Alias</label>
				<input id="alias" type="text" class="form-control" name="alias" placeholder="Alias (chuỗi đường dẫn tĩnh cho {$out.type_prefix})" oninput="ClearTooltip();">
			</div>
			{if !in_array($out.type, $not_show.parent)}
			<div class="form-group">
				<label for="parent">Danh mục cha</label>
				<select id="parent" class="form-control chosen" name="parent">
					{$out.select_parent}
				</select>
			</div>
			{/if}
			{if !in_array($out.type, $not_show.position)}
            <div class="form-group">
                <label for="position">Position</label>
                <select id="position" class="form-control" name="position">
                    {$out.position}
                </select>
            </div>
            {/if}
            <div class="form-group">
				<label for="title">Title</label>
				<textarea class="form-control" rows="2" name="title" placeholder="Tiêu đề của danh mục phục vụ cho seo web"></textarea>
			</div>
            {if !in_array($out.type, $not_show.keyword)}
			<div class="form-group">
				<label for="description">Keyword</label>
				<textarea class="form-control" rows="2" name="keyword" placeholder="Từ khóa của danh mục phục vụ cho seo web"></textarea>
			</div>
			{/if}
			<div class="form-group">
				<label for="description">Description</label>
				<textarea class="form-control" rows="3" name="description" placeholder="Nội dung mô tả danh mục, dùng cho cả seo web"></textarea>
			</div>
			<!-- <div class="checkbox">
				<label> <input type="checkbox" checked name="status"> Kích hoạt {$out.type_prefix} này</label>
			</div> -->
			<button id="save_btn" type="button" class="btn btn-primary" name="submit" onclick="SaveTaxonomy();">Thêm {$out.type_prefix}</button>
            <button id="cancel_btn" class="btn btn-default" type="button" onclick="CancelEdit();">Hủy bỏ</button>
		</form>
	</div>

    <div id="main_data">
        {include $out.file_include}
    </div>
</div>

<!-- Load icon -->
<div class="modal fade  bs-example-modal-lg" id="LoadIcon">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Lựa chọn Icon đại diện cho {$out.type_prefix}</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6 col-md-offset-3">
                        <input type="hidden" id="id">
                        <input type="text" style="border-radius: 20px; margin-bottom:20px"
                               onkeyup="searchicon(this.value);"
                               class="form-control input-lg" placeholder="Tìm kiếm Icon">
                    </div>
                </div>
                <div id="bodyicon"></div>
            </div>
            <div class="modal-footer"></div>
        </div>
    </div>
</div>

<script>
    var cate_type = '{$out.type}';
    var current_page = '{$current_page}';
    var type_prefix = '{$out.type_prefix}'
</script>
{literal}
<script>
$(window).ready(function(){
	$(".chosen").chosen({});
});
    function ClearTooltip() {
        $("input[name=name]").tooltip('destroy');
        $("input[name=alias]").tooltip('destroy');
    }

    function SaveTaxonomy() {
        PNotify.removeAll();
        var input_test = $.trim($('input[name=name]').val());
        var patt = /[\\'"`{}]/;
        var test_input = patt.test(input_test);

        var alias_test = $.trim($('input[name=alias]').val());
        var patt_alias = /^[a-z\d\-%_]+$/i;
        var test_alias = patt_alias.test(alias_test);

        if (input_test == "") {
            $('input[name=name]').focus().tooltip({
                'trigger':'manual',
                'title': 'Vui lòng nhập tên '+type_prefix,
                'placement': 'top',
                'delay': { "show": 500, "hide": 0 }
            }).tooltip('show');
        }else if (test_input) {
            $('input[name=name]').focus().tooltip({
                'trigger':'manual',
                'title': 'Tên '+type_prefix+' không hợp lệ',
                'placement': 'top',
                'delay': { "show": 500, "hide": 0 }
            }).tooltip('show');
        }else if (!test_alias) {
            $('input[name=alias]').focus().tooltip({
                'trigger':'manual',
                'title': 'Alias không hợp lệ',
                'placement': 'top',
                'delay': { "show": 500, "hide": 0 }
            }).tooltip('show');
        }else {
            loading();
            var $form = $('#taxonomy_form'), url = '?mod=taxonomy&site=ajax_handle', data={};
            data['id'] = $form.find("input[name=id]").val();
            data['type'] = cate_type;
            data['name'] = $.trim($form.find("input[name=name]").val());
            data['alias'] = $.trim($form.find("input[name=alias]").val());
            data['parent'] = $form.find("select[name=parent]").val();
            data['title'] = $form.find("textarea[name=title]").val();
            data['keyword'] = $form.find("textarea[name=keyword]").val();
            data['description'] = $form.find("textarea[name=description]").val();
            data['position'] = $form.find("select[name=position]").val();
            data['status'] = 0;
            if ($form.find("input[name=status]").is(":checked")) data['status'] = 1;
            data['ajax'] = 'save_taxonomy_content';
            var posting = $.post(url, data).done(function (e) {
                
                if (data.exist == 1) {
                    noticeMsg('Alias đã tồn tại', 'Vui lòng nhập 1 alias khác', 'error');
                    endloading();
                }else {
                    $.post("?mod=taxonomy&site=refresh_data",{'refresh':cate_type}).done(function (data) {
                        $('#main_data').html(data);
                        if (id == 0) {
                            noticeMsg('Thêm '+type_prefix+' thành công', 'Đã thêm '+type_prefix+' <b>' + name + '</b>', 'success');
                        }else {
                            noticeMsg('Sửa '+type_prefix+' thành công', 'Đã sửa '+type_prefix+' <b>' + name + '</b>', 'success');
                            $("#form_title").html('Thêm '+type_prefix);
                            $("#save_btn").html('Thêm '+type_prefix);
                            $('#cancel_btn').hide();
                        }
                        endloading();
                    });
                    $('#taxonomy_form')[0].reset();
                    $("input[name=id]").val(0);
                    $("input[name=status]").attr("checked", "checked").prop('checked', true);
                    $('select[name=parent]').html(data.select_parent).trigger('chosen:updated');
                    $('select[name=position]').val('');
                    $('input[name=name]').focus();
                }
            });
        }
    }

    function LoadDataForForm(id) {
        ClearTooltip();
        loading();
        $('tbody tr').css({'color':'#333','font-style':'normal'});
        $('tbody tr input').css('color', '#555');
        $('#taxonomy_form')[0].reset();

        $.post("?mod=taxonomy&site=ajax_handle", {
        	'ajax':'load_taxonomy_content',
        	'id': id, 
        	'type':cate_type
        }).done(function (data1) {
            var data = JSON.parse(data1);
            endloading();
            $("#form_title").html('Sửa '+type_prefix);
            $("#taxonomy_form input[name=id]").val(data.id);
            $("#taxonomy_form input[name=name]").val(data.name).focus();
            $("#taxonomy_form input[name=alias]").val(data.alias);
            $("#taxonomy_form select[name=parent]").html(data.select_parent).trigger('chosen:updated');
            $("#taxonomy_form select[name=position]").html(data.position);
            $("#taxonomy_form textarea[name=title]").val(data.title);
            $("#taxonomy_form textarea[name=keyword]").val(data.keyword);
            $("#taxonomy_form textarea[name=description]").val(data.description);
            if (data.status == '1') {
                $("#taxonomy_form input[name=status]").attr("checked", "checked").prop('checked', true);
            } else {
                $("#taxonomy_form input[name=status]").removeAttr("checked").prop('checked', false);
            }
            $("#save_btn").html('Sửa '+type_prefix);
            $('#field' + id).css({'color':'#337ab7','font-style':'italic'});
            $('#field' + id + ' input').css('color', '#337ab7');
            $('#cancel_btn').show();
        });
    }
    
    function CancelEdit() {
        ClearTooltip();
        $('#taxonomy_form')[0].reset();
        $("input[name=id]").val("0");
        $("input[name=status]").attr("checked", "checked").prop('checked', true);
        $("#form_title").html('Thêm '+type_prefix);
        $("#save_btn").html('Thêm '+type_prefix);
        $('input[name=name]').focus();
        $('#cancel_btn').hide();
        $('tbody tr').css({'color':'#333','font-style':'normal'});
        $('tbody tr input').css('color', '#555');
        $('select[name=parent]').val(0);
        $('select[name=position]').val('');
    }

    function filter() {
        var key = $.trim($("#key").val());
        var url = "?mod=taxonomy&site=index&type="+cate_type;
        if (key != '') url += "&key=" + key;
        window.location.href = url;
    }

    $('#key').keypress(function( event ){
        if ( event.which == 13 ) filter();
    });

    $('input[name=name], input[name=alias], select[name=parent], input[name=status]').keypress(function( event ){
        if ( event.which == 13 ) {
            SaveTaxonomy();
        }
    });

    function BulkAction(pos) {
        PNotify.removeAll();
        var bulk = $('select[name=bulk'+pos+']').val();
        if (bulk == '') {
            noticeMsg('Chọn tác vụ', 'Vui lòng chọn 1 tác vụ','info');
        }
        else if (bulk == 0) {
            BulkDelete('taxonomy', 'ajax_bulk_delete');
        }
        else if (bulk == 1) {
            BulkActive('taxonomy', 1);
        }
        else if (bulk == 2) {
            BulkActive('taxonomy', 0);
        }
    }

    function geticon(id) {
        $.post("?mod=taxonomy&site=get_ajax_icon",{'id':id}).done(function(data){
            $("#bodyicon").html(data);
            $("#id").val(id);
        });
    }

    function saveicon(value, id) {
        $.post("?mod=taxonomy&site=ajax_handle",{
        	'ajax':'save_taxonomy_icon',
        	'value':value,
        	'id':id
        }).done(function(data){
            $("#icon"+id).html(data).attr('title', 'Đổi icon');
            $("#LoadIcon").modal('hide');
        });
    }

    function searchicon(value) {
        var id = $("#id").val();
        $.post("?mod=taxonomy&site=get_ajax_icon",{'id':id, 'value':value}).done(function(data){
            $("#bodyicon").html(data);
        });
    }
    
    function ChangeOrder(id, sort_type) {
        $('#save_btn').prop('disabled', true);
        $('#in_progress').show();
        $.post("?mod=taxonomy&site=ajax_handle", {
        	'ajax':'sort_taxonomy',
        	'id':id,
        	'sort_type':sort_type, 
        	'type':cate_type
        }).done(function () {
            $.post("?mod=taxonomy&site=refresh_data",{'refresh':cate_type}).done(function (data) {
                $('#main_data').html(data);
                $('#in_progress').hide();
                $('#save_btn').prop('disabled', false);
            });
        });
    }

    function ChangeType(type) {
        window.location.href = '?mod=taxonomy&site=index&type='+type;
    }
</script>
{/literal}