<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1><i class="fa fa-bars fa-fw"></i> Thêm hình ảnh cho từ khóa</h1>
		</div>
		<div class="col-md-4 text-right">
		</div>
	</div>
</div>
<form method="post" enctype="multipart/form-data">
	<input type="hidden" name="folder" value="{$folder|default:''}">
	<div class="panel panel-primary">
		<div class="panel-heading">
			<div class="row">
				<div class="col-md-4">
					<a href="?mod=keyword&site=category" class="btn btn-primary btn-sm">
						<i class="fa fa-list fa-fw"></i>
						Danh mục 
					</a>
				</div>
				<div class="col-md-8 text-right">
					<a href="?mod=keyword&site=keyword_category&id={$smarty.get.id}" class="btn btn-success btn-sm">
						<i class="fa fa-plus fa-fw"></i>
						Thêm từ khóa mới
					</a>
					
				</div>
			</div>
		</div>
		<div class="panel-body">
			<div class="table-responsive">
				<table class="table table-bordered table-hover table-striped">
					<thead>
						<tr>
							<th class="text-center" width="20%">Từ khóa</th>
							<th>Hình ảnh</th>
							
						</tr>
					</thead>
					<tbody>
						{if count($result)>0}
						{foreach from=$result key=k item=v}
						<tr>
							<td class="text-left">
								{$v.name}
								<input class="form-control" type="hidden" name="name_{$k}" value="{$v.name}">
							</td>
							<td>
								<div class="row">
									<div class="col-md-4">
										<div id="ShowImg">
											{if $v.img_name != ''}
												{$imgName = $v.img_name}
												{$url_img = "$folder$imgName"}
											{else}
												{$imgName = "default.png"}
												{$url_img = "$folder$imgName"}
											{/if}
											<input type="hidden" name="imgName_{$k}" id="imgName_{$k}" value="{$v.img_name}">
											<input type="hidden" name="imgID_{$k}" id="imgID_{$k}" value="{$v.img_id}">
											<img class="img-fluid" id="img_{$k}" src="{$url_img}" alt="">
											<input type="file" name="fileName_{$k}" id="fileName_{$k}" onclick="AjaxUploadImg('{$k}')">
										</div>
									</div>
									<div class="col-md-4 text-right">
										<button type="button" class="btn btn-default btn-danger"  onclick="RemoveImgAttr('{$k}');">
											<i class="fa fa-trash fa-fw"></i>
											Xóa hình
										</button>
									</div>
									
								</div>
								
							</td>
						</tr>
						{/foreach}
						{/if}
						
					</tbody>
				</table>
			</div>

			<hr>

			
		</div>
		<div class="panel-body">
			<div class="form-group row">
				<div class="col-sm-10">
					<input type="hidden" name="lenght_attribute" value="{count($result)}">
					<input type="hidden" name="folder_url" id="folder_url" value="{$folder}">
					<button type="submit" name="submit" class="btn btn-primary btn-lg">Lưu thông tin</button>
				</div>
			</div>
		</div>
	</div>
</form>

<link href="{$arg.stylesheet}chosen/chosen.min.css" rel="stylesheet">
<script src="{$arg.stylesheet}chosen/chosen.jquery.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce.min.js"></script>
<script src="{$arg.stylesheet}tinymce/tinymce-config.js"></script>

{literal}
<script>

    function AjaxUploadImg($key){
        // var str_fileName = "#fileName_"+ $key;
        // var file_data = $(str_fileName).prop('files')[0];
        // var type = file_data.type;
        // var match = ["image/gif", "image/png", "image/jpg",];
        // var form_data = new FormData();
        // Data['ajax_action'] = 'remove_images';
        // form_data.append('file', file_data);

        
        // loading();
        // $.post('?mod=product&site=ajax_handle&id=' + id, form_data).done(function (e) {

        //     endloading();
        // });
        console.log($key);
    }
</script>
{/literal}