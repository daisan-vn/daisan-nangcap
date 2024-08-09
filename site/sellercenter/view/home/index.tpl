<div class="card-header">Thông tin tổng quan</div>

<div class="card-body">
	<div class="card rounded-0 mb-3">
		<div class="card-body">
			<div class="row">
				<div class="col-md-2">
					<div class="">
						<img alt="{$page.name}" src="{$page.logo_img}" width="100%">
					</div>
				</div>
				<div class="col-md-10">
					<h4 class="mt-3 mb-2">{$page.name}</h4>
					<p class="mb-1">Gói gian hàng: <b>{$page.package}</b> {if $page.package_id neq 0}(Hết hạn: {$page.package_end|date_format:'%d-%m-%Y'}){/if}</p>
					<p class="mb-0">Đạt <b>{$page.score}</b> điểm hoàn thành. cập nhật thêm thông tin gian hàng để hoàn thành tối đa 100 điểm.</p>
				</div>
			</div>
		</div>
	</div>

	<div class="card-group mb-3" id="home-stat">
		<div class="card rounded-0">
			<div class="card-body">
				<div class="text-center">
					<div><i class="fa fa-fw fa-shopping-cart fa-3x"></i></div>
					<p class="title">Đơn hàng mới</p>
					<p class="value mb-0">{$page.neworders|default:0}</p>
				</div>
			</div>
		</div>
		<div class="card rounded-0">
			<div class="card-body">
				<div class="text-center">
					<div><i class="fa fa-fw fa-line-chart fa-3x"></i></div>
					<p class="title">Đơn hàng / tháng</p>
					<p class="value mb-0">{$out.order_month|default:0}</p>
				</div>
			</div>
		</div>
		<div class="card rounded-0">
			<div class="card-body">
				<div class="text-center">
					<div><i class="fa fa-fw fa-envelope-o fa-3x"></i></div>
					<p class="title">Tin liên hệ</p>
					<p class="value mb-0">{$page.newcontact|default:0}</p>
				</div>
			</div>
		</div>
		<div class="card rounded-0">
			<div class="card-body">
				<div class="text-center">
					<div><i class="fa fa-fw fa-bar-chart fa-3x"></i></div>
					<p class="title">Truy cập / tháng</p>
					<p class="value mb-0">{$out.access_month|default:0}</p>
				</div>
			</div>
		</div>
		<div class="card rounded-0">
			<div class="card-body">
				<div class="text-center">
					<div><i class="fa fa-fw fa-user-o fa-3x"></i></div>
					<p class="title">Người theo dõi</p>
					<p class="value mb-0">{$out.favorites|default:0}</p>
				</div>
			</div>
		</div>
	</div>


	<div class="card rounded-0">
		<div class="card-body">
			<h5>Thông tin sử dụng của gói gian hàng VIP</h5>
			<p>Với mỗi gói sẽ có các giới hạn sử dụng hàng tháng khác nhau. Sản phẩm showcase cho phép tăng rank sản phẩm của bạn lên đáng kể, Quảng cáo giúp khách hàng tiếp cận sản phẩm của bạn dễ dàng nhất.</p>
			<p>
				<span class="mr-3">Sản phẩm showcase: <b>{$package.numb_showcase_used|default:0}/{$package.numb_showcase|default:0}</b></span><br/>
				<span>Điểm quảng cáo sản phẩm: <b>{$package.numb_ads|default:0}</b></span>
			</p>
			{if $page.package_id gt 0}
			{if $out.show_active_homelogo}
			<p class="mb-1">Bạn đang có <b>{$package.numb_homelogo} ngày</b> để active logo gian hàng trên trang chủ.</p>
			<p><button type="button" class="btn btn-sm btn-primary" onclick="ActiveHomeLogo();"><i class="fa fa-check"></i> Active ngay</button></p>
			{else if $package gt 0}
			<p>Hiển thị logo trên trang chủ hết hạn vào ngày <b>{$page.package_homelogo|date_format:'%d/%m/%Y'}</b></p>
			{/if}
			{/if}
		</div>
	</div>

</div>

<div class="card-body">
</div>

{literal}
<script type="text/javascript">
function ActiveHomeLogo(){
	var data = {};
	data.action = 'active_homelogo';
	$.post('?mod=home&site=ajax_handle', data).done(function(e){
		var rt = JSON.parse(e);
		if(rt.code==0){
			noticeMsg('System Message', rt.msg, 'error');
		}else{
			noticeMsg('System Message', rt.msg, 'success');
			setTimeout(function(){
				location.reload();
			}, 1000);
		}
	});
}
</script>
{/literal}