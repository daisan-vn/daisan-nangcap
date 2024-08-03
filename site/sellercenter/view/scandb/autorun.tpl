<div class="card-header">
	<h3>Quét sản phẩm tự động</h3>
</div>

<div class="card shadow">
	<div class="card-body py-4">
		<p>Tự động quét tất cả các link theo domain website để tìm kiếm và lưu sản phẩm mới cho gian hàng</p>
		<div>
			<i class="fa fa-fw fa-circle"></i> Trang: <b>{$db.name|default:''}</b>
			<i class="fa fa-fw fa-globe mx-3"></i> Domain: <b>{$db.website|default:''}</b>
		</div>
		<hr>
		<div class="row row-sm" id="filter">
			<input type="hidden" id="page_id" value="{$db.id|default:0}">
			<input type="hidden" id="scan" value="{$db.scan|default:0}">
			<div class="form-group col-md-3 col-12 mb-sm-0">
				<select class="form-control" id="method" onchange="set_conf()">{$db.select_method|default:''}</select>
			</div>
			<div class="form-group col-md-2 col-12 mb-sm-0">
				<select class="form-control" id="limit" onchange="set_conf()">{$db.select_limit|default:''}</select>
			</div>
			<div class="form-group col-md-3 col-12 mb-sm-0">
				<button type="button" class="btn btn-success" id="start" onclick="scan_start({$db.id});"><i class="fa fa-play"></i> Bắt đầu quét dữ liệu</button>
				<button type="button" class="btn btn-danger d-none" id="stop" onclick="scan_stop({$db.id});"><i class="fa fa-stop"></i> STOP</button>
			</div>
		</div>
	</div>
	<div class="list-group list-group-flush" id="scancenter"></div>

</div>

{literal}
<script>
var scan = $('#scan').val();
var method = $('#method').val();
var limit = $('#limit').val();
var is_stop = 0;
if(scan==1){
	var page_id = $('#page_id').val();
	scan_start(page_id);
	setTimeout(function(){window.location.reload();}, 300000);
}

function set_conf(){
	method = $('#method').val();
	limit = $('#limit').val();
}


function scan_start(id){
	is_stop = 0;
	var data = {};
	data.id = $('#page_id').val();
	data.method = method;
	data.limit = limit;
	data.action = 'start';
	
	if(data.id==0){
		noticeMsg('Thông báo', 'Thông tin không hợp lệ', 'error');
		$('#url').focus();
		return false;
	}
	
	$('#method').attr('disabled','disabled');
	$('#limit').attr('disabled','disabled');
	$('#start').attr('disabled','disabled');
	$('#stop').removeClass('d-none');
	loading();
	$.post('?mod=scandb&site=autorun', data).done(function(e){
		setTimeout(function(){
			if(e==0){
				scan_stop(id);
				/* $.post('?mod=scandb&site=autorun', {'action':'load_new_id','id':id,'limit':limit}).done(function(new_id){
					if(new_id > 0){
						scan_reset(id);
					}else{
						scan_start(1);
						endloading();
					}
				}); */
			}else{
				$('#scancenter').load('?mod=scandb&site=autorun_reload',{'id':id});
				scan_run(0, id);
				endloading();
			}
		},1500);
	});
}

function scan_run(k, id){
	var new_k = parseInt(k) + 1;
	var data = {};
	data.id = id;
	data.k = k;
	data.method = method;
	data.limit = limit;
	data.action = 'scan';
	
	$('#item_'+k).addClass('text-b text-warning');
	$('#item_'+k+' i').removeClass('fa-circle');
	$('#item_'+k+' i').addClass('fa-spinner fa-pulse');
	$.post('?mod=scandb&site=autorun', data).done(function(e){
		var rt = JSON.parse(e);

		var scanned = $('#scanned').html();
		$('#scanned').html(parseInt(scanned)+1);
		if(rt.number > 0){
			$('#item_'+k).removeClass('text-warning');
			if(rt.code==1){
				$('#item_'+k).addClass('text-success');
				var numb_prod = $('#number').html();
				$('#number').html(parseInt(numb_prod)+1);
			}else $('#item_'+k).addClass('text-danger');
			$('#item_'+k+' i').removeClass('fa-spinner fa-pulse');
			
			//$('#item_'+k+' i').addClass('fa-check');
			if(rt.code==1) $('#item_'+k+' i').addClass('fa-check');
			else $('#item_'+k+' i').addClass('fa-times');
			$("#item_"+k+" a").append(" (" + rt.msg + ")");

			$('#item_'+new_k).addClass('text-b text-warning');
			$('#item_'+new_k+' i').removeClass('fa-circle');
			$('#item_'+new_k+' i').addClass('fa-spinner fa-pulse');
			if(rt.number>=5){
				var rm_k = parseInt(k) - 5;
				$('#item_'+rm_k).hide();
			}
			scan_run(new_k, id);
		}else{
			loading();
			scan_reset(id);
		}
		console.log(rt);
	});
}

function scan_reset(id){
	var data = {};
	data.id = id;
	data.method = method;
	data.limit = limit;
	data.action = 'reset';
	$.post('?mod=scandb&site=autorun', data).done(function(e){
		if(e > 0){
			$('#scancenter').load('?mod=scandb&site=autorun_reload',{'id':id});
			setTimeout(function(){
				scan_run(0, id);
				endloading();
			},1500);
		}else{
			$('#method').removeAttr('disabled');
			$('#limit').removeAttr('disabled');
			$('#start').removeAttr('disabled');
			$('#stop').addClass('d-none');
			$('#scancenter').html('<div class="list-group-item list-group-item-action">Hoàn thành tiến trình quét sản phẩm</div>');
			if(is_stop==0){
				$.post('?mod=scandb&site=autorun', {'action':'load_new_id','id':id,'limit':limit}).done(function(e){
					if(e > 0){
						location.href = '?mod=scandb&site=autorun&id='+e+'&method='+method+'&limit='+limit+'&scan=1';
					}else{
						endloading();
					}
				});
			}else{
				endloading();
			}
		}
	});
}

function scan_stop(id){
	loading();
	noticeMsg('Thông báo', 'Ngừng quét tự động', 'info');
	$.post('?mod=scandb&site=autorun', {'action':'stop','id':id}).done(function(e){
		is_stop = 1;
		setTimeout(function(){
			$('#method').removeAttr('disabled');
			$('#limit').removeAttr('disabled');
			$('#start').removeAttr('disabled');
			$('#stop').addClass('d-none');
			endloading();
		},5000);
	});
}

</script>
<style>
#scancenter{min-height: 230px;}
#scancenter a{color: #333; font-weight: bold;}
#scancenter .text-warning a, #scancenter .text-warning i{color: orange;}
#scancenter .text-danger a, #scancenter .text-danger i{color: red;}
#scancenter .text-success a, #scancenter .text-success i{color: green;}
</style>
{/literal}
