<div class="body-head">
	<div class="row">
		<div class="col-md-8">
			<h1>
				<i class="fa fa-bars fa-fw"></i> Cập nhật thông tin sản phẩm tự động
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
				<div class="form-group col-md-4 col-12 mb-sm-0">
					<select class="form-control" id="method">{$db.select_method|default:''}</select>
					<input type="hidden" id="page_id" value="{$db.id|default:0}">
					<input type="hidden" id="scan" value="{$db.scan|default:0}">
				</div>
				<div class="form-group col-md-3 col-12 mb-sm-0">
					<button type="button" class="btn btn-primary" id="start" onclick="scan_start({$db.id});"><i class="fa fa-play"></i> Start</button>
					<button type="button" class="btn btn-danger d-none" id="stop" onclick="scan_stop({$db.id});"><i class="fa fa-stop"></i> Stop</button>
				</div>
			</div>
		</div>
		<div class="list-group list-group-flush" id="scancenter"></div>
	</div>
</div>

{literal}
<style>
#scancenter{min-height: 230px;}
#scancenter a{color: #333; font-weight: bold;}
#scancenter .text-warning a, #scancenter .text-warning i{color: orange;}
#scancenter .text-danger a, #scancenter .text-danger i{color: red;}
#scancenter .text-success a, #scancenter .text-success i{color: green;}
</style>
<script>
var scan = $('#scan').val();
var method = $('#method').val();
var is_stop = 0;
/* if(scan==1){
	var page_id = $('#page_id').val();
	scan_start(page_id);
} */

function scan_start(id){
	is_stop = 0;
	var data = {};
	data.id = $('#page_id').val();
	data.action = 'start';
	
	/* if(data.id==0){
		noticeMsg('Thông báo', 'Thông tin không hợp lệ', 'error');
		$('#url').focus();
		return false;
	} */
	
	$('#method').attr('disabled','disabled');
	$('#start').attr('disabled','disabled');
	$('#stop').removeClass('d-none');
	loading();
	$.post('?mod=scandb&site=autoupdate', data).done(function(e){
		$('#scancenter').load('?mod=scandb&site=autoupdate_reload',{'id':id});
		setTimeout(function(){
			scan_run(0, id);
			endloading();
		},1500);
	});
}

function scan_run(k, id){
	var new_k = parseInt(k) + 1;
	var data = {};
	data.id = id;
	data.k = k;
	data.action = 'scan';

	$('#item_'+k).addClass('text-b text-warning');
	$('#item_'+k+' i').removeClass('fa-circle');
	$('#item_'+k+' i').addClass('fa-spinner fa-pulse');
	$.post('?mod=scandb&site=autoupdate', data).done(function(e){
		var rt = JSON.parse(e);
		var scanned = $('#scanned').html();
		$('#scanned').html(parseInt(scanned)+1);
		if(rt.number>0){
			$('#item_'+k).removeClass('text-warning');
			if(rt.code==1) $('#item_'+k).addClass('text-success');
			else $('#item_'+k).addClass('text-danger');
			$('#item_'+k+' i').removeClass('fa-spinner fa-pulse');
			//$('#item_'+k+' i').addClass('fa-check');
			if(rt.code==1) $('#item_'+k+' i').addClass('fa-check');
			else $('#item_'+k+' i').addClass('fa-times');

			
			$('#item_'+new_k).addClass('text-b text-warning');
			$('#item_'+new_k+' i').removeClass('fa-circle');
			$('#item_'+new_k+' i').addClass('fa-spinner fa-pulse');
			
			if(e>=5){
				var rm_k = parseInt(k) - 5;
				$('#item_'+rm_k).hide();
			}
			scan_run(new_k, id);
		}else{
			loading();
			scan_reset(id);
		}
	});
}

function scan_reset(id){
	$.post('?mod=scandb&site=autoupdate', {'action':'reset','id':id}).done(function(e){
		if(e > 0){
			$('#scancenter').load('?mod=scandb&site=autoupdate_reload',{'id':id});
			setTimeout(function(){
				scan_run(0, id);
				endloading();
			},1500);
		}else{
			$('#method').removeAttr('disabled');
			$('#start').removeAttr('disabled');
			$('#stop').addClass('d-none');
			$('#scancenter').html('<div class="list-group-item list-group-item-action">Hoàn thành tiến trình quét sản phẩm</div>');
			endloading();
		}
	});
}

function scan_stop(id){
	loading();
	noticeMsg('Thông báo', 'Ngừng quét tự động', 'info');
	$.post('?mod=scandb&site=autoupdate', {'action':'stop','id':id}).done(function(e){
		is_stop = 1;
		setTimeout(function(){
			$('#method').removeAttr('disabled');
			$('#start').removeAttr('disabled');
			$('#stop').addClass('d-none');
			endloading();
		},5000);
	});
}

</script>
{/literal}
