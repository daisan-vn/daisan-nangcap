<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Chuẩn hóa lại toàn bộ sản phẩm
			</h1>
		</div>
	</div>
</div>


<div class="">
	<div class="card shadow">
		<div class="card-body py-4">
			<p>Tự động quét các sản phẩm đã lưu trên hệ thống để update lại thông tin và giá bán của sản phẩm</p>
			<p>Hệ thống sẽ tự động lấy và cập nhật các sản phẩm đã lưu theo sắp xếp cũ nhất để cập nhật thông tin</p>
			<hr>
			<div class="row row-sm" id="filter">
				<div class="form-group col-md-2 col-12 mb-sm-0">
					<input type="text" class="form-control" id="scan_id" value="1">
				</div>
				<div class="form-group col-md-6 col-12 mb-sm-0">
					<button type="button" class="btn btn-primary" id="start" onclick="scan_run(1);"><i class="fa fa-play"></i> Start</button>
					<button type="button" class="btn btn-danger d-none" id="stop" onclick="scan_stop();"><i class="fa fa-stop"></i> Stop</button>
				</div>
			</div>
		</div>
		<div class="list-group list-group-flush" id="scancenter"></div>
	</div>
</div>

<input type="hidden" id="page" value="{$db.page|default:1}">
{literal}
<style>
#scancenter{min-height: 230px;}
#scancenter a{color: #333; font-weight: bold;}
#scancenter .text-warning a, #scancenter .text-warning i{color: orange;}
#scancenter .text-danger a, #scancenter .text-danger i{color: red;}
#scancenter .text-success a, #scancenter .text-success i{color: green;}
</style>
<script>
var is_stop = 0;

function scan_run(id){
	var data = {};
	data.id = id;
	data.action = 'scan';

	$.post('?mod=scandb&site=reset', data).done(function(e){
		var number = parseInt(e);
		var scanned = $('#scan_id').val(number);
		if(number>0){
			scan_run(number);
		}else{
			scan_stop();
		}
	});
}

function scan_stop(){
	loading();
	noticeMsg('Thông báo', 'Ngừng quét tự động', 'info');
	is_stop = 1;
	setTimeout(function(){
		$('#method').removeAttr('disabled');
		$('#start').removeAttr('disabled');
		$('#stop').addClass('d-none');
		endloading();
	},5000);
}

</script>
{/literal}
