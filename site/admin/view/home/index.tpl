<div class="home-item">
	<h1 style="margin-top: 10px; font-size: 30px;">Chào mừng bạn truy
		cập vào trang quản trị nội dung website !</h1>
	<h5>
		DAISAN,JSC &copy; 2018, truy cập trang chủ của chúng tôi <a href="http://daisan.vn"
			target="_blank">Daisan.vn</a>
	</h5>
	<hr>
	<div class="">
		<div class="package_statistics">
			<div class="row">
				{{foreach from=$package key=k item=data}}
				<div class="col-md-3">
					<div class="package_item color{$k+1}" style="margin-bottom: 1.5rem;">						<div class="panel-body">							<a href="?mod=pages&site=payment&package={$data.id}&status=1">								<div class="details">									<div class="number">										<span data-counter="counterup" data-value="{$data.number}">{$data.number}</span>									</div>									<div class="desc"> {$data.name} </div>									<div>{$data.money|default:0|number_format}đ</div>								</div>							</a>						</div>					</div>
				</div>
				{/foreach}
				<div class="col-md-3">					<div class="package_item color3" style="color: #fff;">						<div class="panel-body">							<div class="details">								<div class="number">									<span data-counter="counterup" data-value="{$count_product.number}">{$out.money|default:0|number_format}đ</span>								</div>								<div class="desc"> Tổng doanh thu gian hàng</div>							</div>						</div>					</div>				</div>				<div class="col-md-3">					<div class="package_item color4">						<div class="panel-body">							<a href="?mod=product&site=ads">								<div class="details">									<div class="number">										<span data-counter="counterup" data-value="{$count_product.number}">{$count_product}</span>									</div>									<div class="desc"> Sản phẩm chạy quảng cáo </div>								</div>							</a>						</div>					</div>				</div>
			</div>
		</div>

		<div class="row">
<!-- 			<div class="col-md-12">
				<h4>
					Thống kê truy cập <a href="./?site=accesslog_ip">theo IP</a> hoặc <a
						href="./?site=accesslog_location">theo
						địa điểm</a>, <a href="./?site=accesslogs">tất cả địa điểm</a>
				</h4>
				<table class="highchart table hidden-lg hidden-md hidden-sm" data-graph-container-before="1"
					data-graph-type="column">
					<thead>
						<tr>
							<th>Date</th>
							<th class="text-right">Member onlines</th>
						</tr>
					</thead>
					<tbody>
					
						{foreach from=$chart item=data}
							
						<tr>
							<td width="70%">{$data.date_log|date_format:"%d/%m"}</td>
							<td class="text-right">{$data.number}</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
			</div> -->
			<div class="col-md-6">
				<div class="panel panel-success">
					<div class="panel-heading"><i class="fa fa-clone fa-fw"></i>Top nhà cung cấp truy cập nhiều</div>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-striped table-sm">
								<thead>
									<tr>
										<th>#ID</th>
										<th>Shop</th>
										<th>Truy cập</th>
									</tr>
								</thead>
								<tbody>
									{foreach from=$pages item=data}
									<tr>
										<td>{$data.id}</td>
										<td><a href="{$data.url_page}" target="_blank">{$data.name}</a></td>
										<td>{$data.number}</td>
									</tr>
									{/foreach}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="panel panel-danger">
					<div class="panel-heading"><i class="fa fa-line-chart fa-fw" aria-hidden="true"></i>Top sản phẩm xem
						nhiều</div>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-striped table-sm">
								<thead>
									<tr>
										<th>#</th>
										<th>Sản phẩm</th>
										<th>Lượt xem</th>
									</tr>
								</thead>
								<tbody>
									{foreach from=$products item=data}
									<tr>
										<td>{$data.id}</td>
										<td><a href="{$data.url}" target="_blank">{$data.name}</a></td>
										<td>{$data.views}</td>
									</tr>
									{/foreach}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="panel panel-danger">
					<div class="panel-heading"><i class="fa fa-line-chart fa-fw" aria-hidden="true"></i>Sản phẩm quảng
						cáo click nhiều</div>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-striped table-sm">
								<thead>
									<tr>
										<th>#</th>
										<th>Sản phẩm</th>
										<th>Lượt xem</th>
									</tr>
								</thead>
								<tbody>
									{foreach from=$products item=data}
									<tr>
										<td>{$data.id}</td>
										<td><a href="{$data.url}" target="_blank">{$data.name}</a></td>
										<td>{$data.views}</td>
									</tr>
									{/foreach}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script src="{$arg.stylesheet}custom/js/highcharts.js"></script>
	<script src="{$arg.stylesheet}custom/js/highchartTable.js"></script>
	<script>
		$(document).ready(function () {
			$('table.highchart').highchartTable();
			$("#PopupLocation").modal({
				show: true,
				backdrop: 'static',
				keyboard: false  // to prevent closing with Esc button (if you want this too)
			});
		});
	</script>