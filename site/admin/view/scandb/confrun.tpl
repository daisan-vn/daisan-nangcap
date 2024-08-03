<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Quét sản phẩm tự động
			</h1>
		</div>
	</div>
</div>

<div id="FormAutorun">
	<div class="row">
		<div class="col-md-5">
			<h1>{$page.name}</h1>
			<hr>
			<input type="hidden" name="id" value="{$page.id|default:''}">
			<div class="form-group">
				<input type="text" name="url" class="form-control" placeholder="Nhập url để quét sản phẩm" value="{$prefix.url|default:''}">
			</div>
			<div class="form-group row">
				<div class="col-sm-6">
					<input type="text" name="name" class="form-control" placeholder="Lấy tên" value="{$prefix.name|default:''}">
				</div>
				<div class="col-sm-6">
					<input type="text" name="image" class="form-control" placeholder="Lấy ảnh" value="{$prefix.image|default:''}">
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-6">
					<input type="text" name="price" class="form-control" placeholder="Lấy giá" value="{$prefix.price|default:''}">
				</div>
				<div class="col-sm-6">
					<input type="text" name="code" class="form-control" placeholder="Lấy mã" value="{$prefix.code|default:''}">
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-6">
					<input type="text" name="content" class="form-control" placeholder="Lấy nội dung" value="{$prefix.content|default:''}">
				</div>
				<div class="col-sm-6">
					<input type="text" name="metas" class="form-control" placeholder="Lấy thuộc tính" value="{$prefix.metas|default:''}">
				</div>
			</div>
			<!-- <div class="form-group">
				<textarea name="prefix" class="form-control" rows="5" placeholder="Nhập các thông số để lấy nội dung. Ví dụ: name:.product_name&&code:.product_code">{$page.prefix_auto|default:''}</textarea>
			</div> -->
			<div class="form-group">
				<input type="text" name="insite_check" class="form-control" placeholder="Nhận biết sản phẩm" value="{$prefix.insite_check|default:''}">
			</div>
			<div class="form-group">
				<button type="button" class="btn btn-primary btn-lg" onclick="Save();">
					<i class="fa fa-save"></i> Save
				</button>
				<a href="?mod=scandb&site=autorun&id={$page.id|default:''}" class="btn btn-success btn-lg">
					<i class="fa fa-play"></i> Quét sản phẩm mới
				</a>
				<a href="?mod=scandb&site=autoupdate&id={$page.id|default:''}" class="btn btn-success btn-lg">
					<i class="fa fa-fresh"></i> Update sản phẩm đã lưu
				</a>
			</div>
			<hr>
			<div class="">
				<p>Lưu ý: trước khi bắt đầu chạy, phải nhập link của website muốn lấy và config các thuộc tính để lấy giá trị về.
				Để xem nội dung có chính xác không, bạn có thể kiểm tra thông tin bên phải.</p>
				<h4>Hướng dẫn cấu hình:</h4>
				<p>- Đầu tiên truy cập vào trang cần lấy nội dung và kiểm tra phần tử của trang với công cụ trình duyệt</p>
				<p>- Xác định phần tử cần lấy nội dung và nhập vào phần cấu hình</p>
				<p>- Ví dụ: muốn lấy giá sản phẩm nằm trong thẻ div có id="product-price", bạn có thể nhập vào cấu hình là <b>#product-price hoặc [id=product-price]</b></p>
				<p>- Ví dụ khác với nội dung nằm trong div id="info-name" class="product-name" có thể cấu hình là <b>#info-name</b> hoặc <b>.product-name</b></p>
				<p>- Nếu thấy khó khăn khi cấu hình bạn cần tìm hiểu thêm về kiến thức html.</p>
			</div>
		</div>
		<div class="col-md-6">
			{if count($info) gt 0}
			<p>Url: {$info.url|default:''}</p>
			<div class="row row-sm">
				<div class="col-md-4">
					<img src="{$info.image|default:$arg.noimg}" width="100%" class="thumbnail">
				</div>
				<div class="col-md-8">
					<h3 class="mb-0">{$info.name|default:''}</h3>
					<p class="mb-0">Mã: {$info.sku|default:'none'}</p>
					<p class="mb-0">Thương hiệu: {$info.brand|default:'none'}</p>
					<p class="mb-0">Giá bán: <b>{$info.price|default:0|number_format}đ</b></p>
					<span style="border: 1px solid #ddd; padding: .75rem;">Check: {if $info.is_product eq 0}not product{else}is product{/if}</span>
				</div>
			</div>
			
			{if isset($info.a_metas) AND count($info.a_metas) gt 0}
			<table class="table table-bordered">
				{foreach from=$info.a_metas key=k item=cont}
				<tr>
					<td width="25%">{$k}</td>
					<td>{$cont}</td>
				</tr>
				{/foreach}
			</table>
			{/if}
			
			{if isset($info.content)}
			<div class="card" style="border: 1px solid #ddd; padding: .75rem;">
				<div class="card-body">
				{$info.content}
				</div>
			</div>
			{/if}
			{/if}
		</div>
	</div>
</div>

<div id="ShowAutorun"></div>

<div class="modal fade" id="ShowPageContent">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Nội dung lấy về từ url</h4>
            </div>
            <div class="modal-body"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
function Save(){
	var data = {};
	data.id = $("#FormAutorun input[name=id]").val();
	data.url = $("#FormAutorun input[name=url]").val();
	data.name = $("#FormAutorun input[name=name]").val();
	data.image = $("#FormAutorun input[name=image]").val();
	data.price = $("#FormAutorun input[name=price]").val();
	data.code = $("#FormAutorun input[name=code]").val();
	data.content = $("#FormAutorun input[name=content]").val();
	data.metas = $("#FormAutorun input[name=metas]").val();
	data.insite_check = $("#FormAutorun [name=insite_check]").val();
	data.action = 'save_autorun';
	if(data.url.length < 6){
		noticeMsg('System Message', 'Vui lòng nhập chính xác url lấy nội dung.', 'error');
		$("#FormAutorun input[name=url]").focus();
		return false;
	}
	loading();
	$.post('?mod=scandb&site=confrun', data).done(function(e){
		noticeMsg('System Message', 'Cập nhật nội dung thành công.', 'success');
		endloading();
	});
}
</script>
{/literal}