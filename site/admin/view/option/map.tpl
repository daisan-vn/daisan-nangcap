<script type="text/javascript" src="{$arg.stylesheet}js/jquery-ui.js"></script>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBE5k0hhQWLtFsE8Y0YiwisDaj1cLmJ2TU&libraries=places"></script>
<script type="text/javascript" src="{$arg.stylesheet}custom/js/api-map-google.js"></script>
<script>
    jQuery.browser = {};
    (function () {
        jQuery.browser.msie = false;
        jQuery.browser.version = 0;
        if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
            jQuery.browser.msie = true;
            jQuery.browser.version = RegExp.$1;
        }
    })();
</script>
<div class="body-head">
	<h1><i class="fa fa-cog fa-fw"></i> Thiết lập vị trí trên bản đồ</h1>
</div>

<div class="row">
	<div class="col-xs-12">
		<div class="x_panel">
			<div class="x_content">
				<form action="" method="post">
					<br>
					<div class='row text-center'>
						<div class='col-md-8'>
							<div class="form-group">
								<input class="form-control" title="Gõ địa chỉ vào đây để di chuyển bản đồ tới, Di chuyển Marker để làm mịn" id="address" type="text" /> 
								<input id="ProjectMapIp" name="map_id" type="hidden" value="{$values.map_ip|default:''}" class="form-control" />
							</div>
						</div>
						<div class="col-md-2">
							<input type="submit" value="Lưu thông tin"
								class="btn btn-primary" name="frmSubmit">
						</div>
					</div>


					<div id="map_canvas" style="width: 100%; height: 400px; margin: 10px 0 0; border: 1px solid #ccc;"></div>
					<div>
						<label>latitude: </label><input id="latitude" type="text" /><br />
						<label>longitude: </label><input id="longitude" type="text" />
					</div>
					<!-- end project list -->
				</form>
			</div>
		</div>
	</div>
</div>

