<div class="body-head">
	<h1><i class="fa fa-bars fa-fw"></i> Nội dung website</h1>
</div>
<div class="row">
	<div class="col-md-6">
		<h4>Bảng thống kê</h4>
	    <div class="table-responsive">
	        <table id="taxonomy_table" class="table table-bordered table-hover table-striped hls_list_table">
	            <thead>
	            <tr>
	                <th class="text-left">Tài khoản</th>
	                <th class="text-right">Đăng bài</th>
	            </tr>
	            </thead>
	            <tbody>
	            	{foreach from=$users item=data}
	                <tr id="field{$data.taxonomy_id}">
	                    <td>{$data.name}</td>
	                    <td class="text-right">{$data.number_post}</td>
	                </tr>
	            	{/foreach}
	            </tbody>
	            <tfoot>
	            <tr>
	                <th class="text-left">Tài khoản</th>
	                <th class="text-right">Đăng bài</th>
	            </tr>
	            </tfoot>
	        </table>
	    </div>
	</div>
</div>
<div>
	<a href="?mod=user&site=index" class="btn btn-primary btn-lg">Tạo tài khoản quản trị</a>
</div>