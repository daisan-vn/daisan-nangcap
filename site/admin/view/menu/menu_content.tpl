<div class="col-sm-8">
	<h4 id="form_title">Danh sách nội dung menu</h4>
    <div class="table-responsive">
        <table id="taxonomy_table" class="table table-bordered table-hover table-striped hls_list_table">
            <thead>
            <tr>
                <th class="text-left" width="40%">Tiêu đề menu</th>
                <th class="text-right">Nội dung</th>
                <th class="text-center">Sắp xếp</th>
                <th width="100"></th>
            </tr>
            </thead>
            <tbody>
			{if $result neq NULL}
            {foreach from=$result item=data}
                <tr id="field{$data.id}">
                    <td class="text-left form-inline">
                        <img id="avatar{$data.id}" src="{$data.category_avatar|default:NULL}" class="img-rounded" width="24px" height="24px" onclick="LoadMedia({$data.id});">
                        <input type="file" onchange="SetAvatar({$data.id}, this);" style="display: none;">
                        <input type="color" class="form-control" name="tax_color" value="{if $data.color neq null}{$data.color}{else}#ffffff{/if}" title="Thay đổi màu" onchange="SaveColor({$data.id}, this.value);">
                        <span class="field_name">{$data.name}</span>
                    </td>
                    <td class="text-right">{$data.type}</td>
                    <td class="text-center">
                        <button id="down{$data.id}" {if $data.down_unable}disabled{/if} class="btn btn-default btn-xs" title="Di chuyển xuống" onclick="SortMenu({$data.id}, 'down');"><i class="fa fa-arrow-down fa-fw"></i></button>
                        <button id="up{$data.id}" {if $data.up_unable}disabled{/if} class="btn btn-default btn-xs" title="Di chuyển lên" onclick="SortMenu({$data.id}, 'up');"><i class="fa fa-arrow-up fa-fw"></i></button>
                    </td>
                    <td class="text-center" style="min-width:88px">
                        <button type="button" class="btn btn-default btn-xs" title="Sửa" onclick="LoadDataForForm({$data.id});"><i class="fa fa-pencil fa-fw"></i></button>
                        <button type="button" class="btn btn-default btn-xs" title="Xóa" onclick="LoadDeleteItem('menu', {$data.id}, 'ajax_delete_menu_content');"><i class="fa fa-trash fa-fw"></i></button>
                    </td>
                </tr>
            {/foreach}
            {else}
            <tr><td class="text-center" colspan="10">Không tìm thấy menu nào</td></tr>
    		{/if}
            </tbody>
            <tfoot>
            <tr>
                <th class="text-left">Tiêu đề menu</th>
                <th class="text-right">Nội dung</th>
                <th class="text-center">Sắp xếp</th>
                <th class="text-center">Tác động</th>
            </tr>
            </tfoot>
        </table>
    </div>
</div>


{literal}
<script>
    $(".SelectAllRows").click(function () {
        $(".item_checked, .SelectAllRows").prop('checked', $(this).prop('checked'));
    });
    function LoadMedia(taxonomy_id){
    	$('#field'+taxonomy_id+' input[type=file]').click();
    }
    function SaveColor(id, value) {
        $.post("?mod=menu&site=ajax_save_color", {'id': id, 'color': value})
                .done(function(){
                    $('#field'+id+' input[name=tax_color]').val(value);
                });
    }
    function SetAvatar(taxonomy_id, input) {
    	if (input.files && input.files[0]) {
    		var fileImg = input.files[0];
    		var fileType = input.files[0]['type'];
    		var ValidImgTypes = ["image/jpeg", "image/png"];
    		if ($.inArray(fileType, ValidImgTypes)>=0) {
    			var _URL = window.URL || window.webkitURL;
    			var img = new Image();
    	        img.onload = function () {
    	            if(this.width/this.height>5 || this.width/this.height<0.2){
    	            	noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp tỉ lệ, vui lòng chọn lại.', 'error');
    	            	$(input).val('');
    	            	return false;
    	            }else{
    	        		var reader = new FileReader();
    	        		reader.onload = function(e) {
    	        			var data = {};
    	        			data.taxonomy_id = taxonomy_id;
    	        			data.img = e.target.result;
    	        			data.ajax = 'update_avatar';
    						loading();
    						$.post('?mod=taxonomy&site=ajax_handle', data).done(function(e){
    							if(e==0) noticeMsg('Xảy ra lỗi', 'Không thể lưu được ảnh, vui lòng thử lại sau.', 'error');
    							else{
    								$("#avatar"+taxonomy_id).attr('src', e);
    								noticeMsg('Thông báo', 'Thay đổi hình ảnh thành công.', 'success');
    							}
    							endloading();
    						});

    	        		}
    	        		reader.readAsDataURL(fileImg);
    	            }
    	        }
    	        img.src = _URL.createObjectURL(fileImg);
    		}else{
    			noticeMsg('Thông báo', 'Vui lòng chọn ảnh đúng định dạng jpg hoặc png.', 'error');
    			$(input).val('');
    		}
    	}
    }
</script>
{/literal}
