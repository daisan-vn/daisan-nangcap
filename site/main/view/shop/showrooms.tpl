<div class="main-content-wrap">
	<div class="container-fluid container-cate mt-0">
		{include file='../includes/header_shop.tpl'}
		<div class="shop_main">
			<section class="shop_main-productlist px-3 px-sm-0 mt-3">
				<div class="card border-0 p-3">
					<div class="row">
						<div class="col-sm-8">
							<div id="map_div" style="height: 500px; width: 100%"></div>
						</div>
						<div class="col-sm-4">
							<div class="list_showroom">
								<ul>
									{foreach from=$address key=k item=data}
									<li id="location-{$data.id}" class="online-location" data-id="{$data.id}"
										data-lat="{$data.lat}" data-lng="{$data.lng}" data-type="3"
										data-text="#{$data.name}"><span class="text-aqua">
											<h3>{$k+1}. <i class="fa fa-flag"></i> {$data.name}</h3>
											<p class="address"><i class="fa fa-map-marker fa-fw"
													aria-hidden="true"></i>{$data.address}</p>
											<p class="phone"><i class="fa fa-volume-control-phone fa-fw"
													aria-hidden="true"></i><a href="tel:{$data.phone}">{$data.phone}</a></p>
									</li>
									{/foreach}
								</ul>
							</div>
						</div>
					</div>
				</div>
			</section>
		</div>
	</div>
</div>
<script
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCryD5oP1LSHLcOmoGPjSYZw7T4iNMz3o0&libraries=places&callback=initMap"
	async defer></script>
{literal}
<style>
	.list_showroom ul li{
		border-bottom: 1px dotted #ccc;
		padding:10px 5px;
		cursor: pointer;
	}
	.list_showroom h3{
		font-size: 16px;
		font-weight: bold;
	}
</style>
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
			center: { lat: 20.9990, lng: 105.8054 },
			mapTypeId: 'roadmap'
		});
		map.addListener('click', function (e) {
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

		autocompleteaddress.addListener('place_changed', function () {
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
		autocomplete.addListener('place_changed', function () {
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
				position: { lat: 20.9994, lng: 105.7823 },
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
				position: { lat: lat, lng: lng },
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
		searchBox.addListener('place_changed', function () {
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
</script>
{/literal}