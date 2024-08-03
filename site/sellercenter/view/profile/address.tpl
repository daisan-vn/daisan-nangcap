{literal}
<style>
	/* Always set the map height explicitly to define the size of the div
     * element that contains the map. */
	#map_div {
		height: 100%;
	}
	/* Optional: Makes the sample page fill the window. */
	html, body {
		height: 100%;
		margin: 0;
		padding: 0;
	}
	#floating-panel {
		position: absolute;
		top: 10px;
		left: 25%;
		z-index: 5;
		background-color: #fff;
		padding: 5px;
		border: 1px solid #999;
		text-align: center;
		font-family: 'Roboto','sans-serif';
		line-height: 30px;
		padding-left: 10px;
	}
	#floating-panel {
		background-color: #fff;
		border: 1px solid #999;
		left: 25%;
		padding: 5px;
		position: absolute;
		top: 10px;
		z-index: 5;
	}
	.table-no-border td { border: none !important;}
	.list-online-agents ul { list-style: none; margin: 0; padding: 0; border-top: 1px solid #ddd; height: 90vh; overflow-x: scroll;}
	.list-online-agents ul li {padding: 5px;border: 1px solid #dddd;border-top: none;}
	.list-online-agents ul li:hover { cursor: pointer;}
</style>
{/literal}

<div class="card-header">
	<h3>Thông tin các địa chỉ trụ sở, chi nhánh công ty</h3>
	<hr>
	<div class="alltabs">
		{$page_menu}
	</div>
</div>

<div class="card-body">

	<ul class="nav nav-tabs" role="tablist">
		<li class="nav-item">
			<a class="nav-link active" data-toggle="tab" href="#home">Thêm mới địa chỉ, văn phòng làm việc</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" data-toggle="tab" href="#location">Map</a>
		</li>
	</ul>

	<!-- Tab panes -->
	<div class="tab-content">
		<div id="home" class="tab-pane active"><br>
			<form id="FrmContent" method="post" enctype="multipart/form-data">
				<div class="card rounded-0">
					<div class="card-header mb-3"><h5>Thêm mới địa chỉ, văn phòng làm việc</h5></div>

					<div class="card-body">
						<input type="hidden" name="id">
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Tên trụ sở</label>
							<div class="col-sm-8">
								<input type="text" class="form-control" name="name">
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Địa chỉ</label>
							<div class="col-sm-8">
								<div class="form-row">
									<div class="form-group col-md-4">
										<label for="inputState">Tỉnh thành</label>
										<select name="province_id" class="form-control">{$out.Province}</select>
									</div>
									<div class="form-group col-md-8">
										<label for="inputEmail4">Địa chỉ chi tiết</label>
										<input type="text" class="form-control" name="address">
									</div>
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Chọn Location</label>
							<div class="col-sm-8">
								<input class="form-control" type="text" id="address" value="" maxlength="255" placeholder="Số nhà, đường phố, quận huyện, tỉnh thành">
								<input class="form-control" type="text" id="center_point_lat" name="center_point_lat" value="" maxlength="255" placeholder="Latitude" hidden>
								<input class="form-control" type="text" id="center_point_lng" name="center_point_lng" value="" maxlength="255" placeholder="longitude" hidden>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Thông tin liên hệ</label>
							<div class="col-sm-8">
								<div class="form-row">
									<div class="form-group col-md-6">
										<label for="inputEmail4">Số hotline</label>
										<input type="text" class="form-control" name="phone">
									</div>
									<div class="form-group col-md-6">
										<label for="inputEmail4">Địa chỉ email</label>
										<input type="text" class="form-control" name="email">
									</div>
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label for="inputPassword" class="col-sm-2 col-form-label">Ảnh đại diện</label>
							<div class="col-sm-8">
								<div class="row row-sm">
									<div class="col-md-3">
										<span class="border d-block" style="min-height: 85px">
											<img src="" id="ShowImg" width="100%">
										</span>
									</div>
									<div class="col-md-8">
										<input type="file" id="ImgUpload" name="Image"> 
										<small class="form-text text-muted">Kích thước file 200Mb, hỗ trợ định dạng jpg, png. Tỉ lệ ảnh phù hợp là 1x1. Nên để kích thước 100x100 pixcel.</small>
									</div>
								</div>
							</div>
						</div>
						<div class="form-group row">
							<div class="col-sm-2"></div>
							<div class="col-sm-10">
								<button type="submit" name="submit" class="btn btn-primary">Lưu thông tin</button>
							</div>
						</div>
					</div>
				</div>
			</form>
			<table class="table table-bordered mt-5">
				<tr>
					<th class="text-right" width="40">Stt</th>
					<th>Tên trụ sở/ chi nhánh</th>
					<th width="150">Ảnh cửa hàng</th>
					<th>Địa chỉ</th>
					<th></th>
				</tr>
				{foreach from=$address key=k item=data}
					<tr>
						<td class="text-right">{$k+1}</td>
						<td>{$data.name}</td>
						<td><img src="{$data.image}"  width="150"></td>
						<td>{$data.address}</td>
						<td class="text-right">
							<button type="button" class="btn btn-light btn-sm" onclick="LoadFrm({$data.id});"><i class="fa fa-fw fa-pencil"></i></button>
							<button type="button" class="btn btn-light btn-sm" onclick="DeleteItem('pageaddress', {$data.id}, 'profile', 'ajax_delete_pageaddress');"><i class="fa fa-fw fa-remove"></i></button>
						</td>
					</tr>
				{/foreach}
			</table>
		</div>
		<div id="location" class="tab-pane fade"><br>
			<div class="row">
				<div class="col-sm-2">
					<table class="table table-responsive table-no-border">
					<tr>
						<td class="list-online-agents">
							<ul>
								{foreach from=$address key=k item=data}
									<li id="location-{$data.id}" class="online-location" data-id="{$data.id}" data-lat="{$data.lat}"
										data-lng="{$data.lng}" data-type="3" data-text="#{$data.name}"><span class="text-aqua">
										<i class="fa fa-circle"></i>
									</span><strong>{$data.name}</strong><br><span class="address">{$data.address}</span></li>
								{/foreach}
							</ul>
						</td>
					</tr>
					</table>
				</div>
				<div class="col-sm-10">
					<div class="form-group">
						<label class="control-label">Địa chỉ</label><br>
						<div class="col-sm-10 row">
							<input class="form-control" type="text" id="user_check_address" name="user_check_address" value="" maxlength="255" placeholder="Số nhà, đường phố, quận huyện, tỉnh thành">
						</div>
					</div>
					<div id="map_div" style="height: 500px; width: 100%"></div>
				</div>
			</div>
		</div>
	</div>

</div>
{*<link href="{$arg.stylesheet}css/style.css" rel="stylesheet">*}
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="{$arg.stylesheet}plugins/jquery-autocomplete/jquery.autocomplete.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCryD5oP1LSHLcOmoGPjSYZw7T4iNMz3o0&libraries=places&callback=initMap" async defer></script>

{literal}
<script>
var geocoder;
var center, lat_search, lng_search;
var map;
var lat = 20.9937774;
var lng = 105.8114176;
var radius = 1500000;
var agents = [];
var markers = {};
var locations = [];
var marker;

function initMap() {
	geocoder = new google.maps.Geocoder();
	map = new google.maps.Map(document.getElementById('map_div'), {
		zoom: 15,
		center: {lat: 20.9990, lng: 105.8054},
		mapTypeId: 'roadmap'
	});
	map.addListener('click', function(e) {
		marker = new google.maps.Marker({
			map: map,
			draggable: true,
			animation: google.maps.Animation.DROP,
			position: e.latLng
		});
		marker.addListener('click', toggleBounce);
	});

	searchBox();

	var autocomplete = new google.maps.places.Autocomplete($('[name=user_check_address]').get(0));
	var autocompleteaddress = new google.maps.places.Autocomplete($('[id=address]').get(0));
	var marker = new google.maps.Marker({
		map: map,
		anchorPoint: new google.maps.Point(0, -29)
	});

	autocompleteaddress.addListener('place_changed', function() {
		marker.setVisible(false);
		var place = autocompleteaddress.getPlace();
		if (!place.geometry) {
			// User entered the name of a Place that was not suggested and
			// pressed the Enter key, or the Place Details request failed.
			console.log("No details available for input: '" + place.name + "'");
			return;
		}

		// If the place has a geometry, then present it on a map.
		if (place.geometry.viewport) {
			map.fitBounds(place.geometry.viewport);
		} else {
			map.setCenter(place.geometry.location);
			map.setZoom(17);  // Why 17? Because it looks good.
		}
		marker.setPosition(place.geometry.location);
		marker.setVisible(true);
		// Update lat-lng values
		$('[name=lat_from]').val(place.geometry.location.lat);
		$('[name=lng_from]').val(place.geometry.location.lng);
		$('#center_point_lat').val(place.geometry.location.lat);
		$('#center_point_lng').val(place.geometry.location.lng);
	});
	autocomplete.addListener('place_changed', function() {
		marker.setVisible(false);
		var place = autocomplete.getPlace();
		if (!place.geometry) {
			// User entered the name of a Place that was not suggested and
			// pressed the Enter key, or the Place Details request failed.
			console.log("No details available for input: '" + place.name + "'");
			return;
		}

		// If the place has a geometry, then present it on a map.
		if (place.geometry.viewport) {
			map.fitBounds(place.geometry.viewport);
		} else {
			map.setCenter(place.geometry.location);
			map.setZoom(17);  // Why 17? Because it looks good.
		}
		marker.setPosition(place.geometry.location);
		marker.setVisible(true);

		marker = new google.maps.Marker({
			map: map,
			draggable: false,
			animation: google.maps.Animation.DROP,
			position: {lat: 20.9994, lng: 105.7823},
			title: text,
			label: {
				text: text,
				color: "#0c0909",
				fontWeight: "bold"
			}
		});

	});

	$('body').on('click', '.online-location', function () {
		var agentId = $(this).data("id");
		var lat = Number($(this).data("lat"));
		var lng = Number($(this).data("lng"));
		var text = $(this).data("text");

		markers[agentId] = new google.maps.Marker({
			position: {lat: lat, lng: lng},
			map: map,
			animation: google.maps.Animation.DROP,
			draggable: true,
			title: text,
			label: {
				text: text,
				color: "#0c0909",
				fontWeight: "bold"
			}
		});
		map.setCenter(new google.maps.LatLng(lat, lng));
		map.setZoom(15);
		map.addListener('click', toggleBounce);
	});

}
function toggleBounce() {
	if (marker.getAnimation() !== null) {
		marker.setAnimation(null);
	} else {
		marker.setAnimation(google.maps.Animation.BOUNCE);
	}
}
function searchBox() {
	var searchBox = new google.maps.places.Autocomplete(document.getElementById('pac-input'));
	searchBox.addListener('place_changed', function() {
		var place = searchBox.getPlace();
		// For each place, get the icon, name and location.
		if (place.geometry.viewport) {
			map.fitBounds(place.geometry.viewport);
		} else {
			map.setCenter(place.geometry.location);
			map.setZoom(18);
		}
	});
}
function LoadFrm(id){
	$("#FrmContent input").val('');
	$("#FrmContent input[name=id]").val(id);
	var Data = {};
	Data['id'] = id;
	Data['ajax_action'] = 'load_frm';
	loading();
	$.post('?mod=profile&site=address', Data).done(function(e){
		var data = JSON.parse(e);
		$("#FrmContent input[name=name]").focus();
		$("#FrmContent input[name=name]").val(data.name);
		$("#FrmContent select[name=province_id]").val(data.province_id);
		$("#FrmContent input[name=address]").val(data.address);
		$("#FrmContent input[name=phone]").val(data.phone);
		$("#FrmContent input[name=email]").val(data.email);
		$("#FrmContent #ShowImg").attr('src', data.image);
		endloading();
	});
}
$('#ImgUpload').change(function() {
	readURL(this, '#ShowImg');
});

function readURL(input, imgShow) {
	if (input.files && input.files[0]) {
		var fileImg = input.files[0];
		var _URL = window.URL || window.webkitURL;
		var img = new Image();
        img.onload = function () {
            if(this.width/this.height<1){
            	noticeMsg('Thông báo', 'Kích thước ảnh không phù hợp tỉ lệ 2x1, vui lòng chọn lại.', 'error');
            	$("#ImgUpload").val('');
            	$(imgShow).attr('src', arg.noimg);
            	return false;
            }else{
        		var reader = new FileReader();
        		reader.onload = function(e) {
        			$(imgShow).attr('src', e.target.result);
        		}
        		reader.readAsDataURL(fileImg);
            }
        }
        img.src = _URL.createObjectURL(fileImg);
	}
}
</script>
{/literal}