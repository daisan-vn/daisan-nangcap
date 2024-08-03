//Useful links:
// http://code.google.com/apis/maps/documentation/javascript/reference.html#Marker
// http://code.google.com/apis/maps/documentation/javascript/services.html#Geocoding
// http://jqueryui.com/demos/autocomplete/#remote-with-cache
      
var geocoder;
var map;
var marker;

function initialize(){
//MAP
  var latlng = new google.maps.LatLng(21.02614714578165,105.85062147030033);
  var options = {
    zoom: 16,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
        
  map = new google.maps.Map(document.getElementById("map_canvas"), options);
        
  //GEOCODER
  geocoder = new google.maps.Geocoder();
        
  marker = new google.maps.Marker({
    map: map,
    draggable: true
  });
  
  //Set position
  var value = $('#ProjectMapIp').attr('value');
  if(value == null || value == ''){
	  var location = new google.maps.LatLng(21.02614714578165,105.85062147030033);
  }
  else{
	  var arr = value.split(',');
	  var arr_0 = parseFloat(arr[0]);
	  var arr_1 = parseFloat(arr[1]);
	  var location = new google.maps.LatLng(arr_0,arr_1);
  }

  marker.setPosition(location);
  map.setCenter(location);
  initMapBylatlong();				
}
		
$(document).ready(function() { 
         
  initialize();
  
  
  $(function() {
    $("#address").autocomplete({
      //This bit uses the geocoder to fetch address values
      source: function(request, response) {
        geocoder.geocode( {'address': request.term }, function(results, status) {
          response($.map(results, function(item) {
            return {
              label:  item.formatted_address,
              value: item.formatted_address,
              latitude: item.geometry.location.lat(),
              longitude: item.geometry.location.lng()
            }
          }));
        })
		 
      },
      //This bit is executed upon selection of an address
      select: function(event, ui) {		
        $("#latitude").val(ui.item.latitude);
        $("#longitude").val(ui.item.longitude);
		$("#ProjectMapIp").val(ui.item.latitude+","+ui.item.longitude);
        var location = new google.maps.LatLng(ui.item.latitude, ui.item.longitude);
        marker.setPosition(location);
        map.setCenter(location);
         
      }	  
    });
	
	
	
  });
  
   $("#setmapcenter").bind("click", function (){
		setMapCenter();
   });
  $("#property-search").bind("click", function (){
	if($('#latitude').val() == ""){
		alert("Please select coordination before searching !");
		return;
	}
	var latitude = "latitude"+$('#latitude').val();
	latitude = latitude.replace(".","v");
	var longitude = "longitude"+$('#longitude').val();
	longitude = longitude.replace(".","v");
	var radius = "radius"+$("#radius").val();
	radius = radius.replace(".","v");
	var banthue = $("#banthue").val();
	if(banthue == 0){
		$text = latitude + " " + longitude + " " + radius;
	}else{
		$text = latitude + " " + longitude + " " + radius + " taxonomy:" + banthue;
	}
	
    parent.window.location = "http://nhadatvideo.vn/property/browse/results/"+$text; 
  });
	
  //Add listener to marker for reverse geocoding
  google.maps.event.addListener(marker, 'drag', function() {
    geocoder.geocode({'latLng': marker.getPosition()}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[0]) {
          $('#address').val(results[0].formatted_address);
          $('#latitude').val(marker.getPosition().lat());
          $('#longitude').val(marker.getPosition().lng());
	   	  $("#ProjectMapIp").val(marker.getPosition().lat()+","+marker.getPosition().lng()); 
	   //callParentScript(marker.getPosition().lng(),marker.getPosition().lat(),results[0].formatted_address);	
        }
      }
    });
  });
  
  //hint
  $('input[title!=""]').hint();
  if ( $.browser.msie ) {
	$("#ProjectMapIp").css("width","200px");
	$('#address').css("width","530px");
  }
});


function initMapBylatlong(){
	var latitude = $('#latitude').val();
	var longitude = $('#longitude').val();
	if(longitude != ""){
		var latlng = new google.maps.LatLng(latitude, longitude);

		geocoder.geocode({'latLng': latlng}, function(results, status) {
		  if (status == google.maps.GeocoderStatus.OK) {
			if (results[0]) {
			  $('#address').val(results[0].formatted_address);
			  $('#latitude').val(latitude);
			  $('#longitude').val(longitude);
			  $("#ProjectMapIp").val(latitude+","+longitude); 
			  //Set position		 
			  marker.setPosition(latlng);
			  map.setCenter(latlng);
			 
			}
		  }
		});
	
	}
		
	

}

function setMapCenter(){
	var latitude = $('#latitude').val();
	var longitude = $('#longitude').val();
	if(longitude != ""){
		var latlng = new google.maps.LatLng(latitude, longitude);		
		//Set position		 
		marker.setPosition(latlng);
		map.setCenter(latlng);			
	}
}


function callParentScript(longtitude,latitude, adress){
  parent.parentHello(longtitude,latitude, adress);
               
}
function getLongitude(){
 return document.getElementById('longitude').value;
}
function getLatitude(){
 return document.getElementById('latitude').value;
}
function getAddress(){
 return document.getElementById('address').value;
}



//Hint
////////////////////////////////////
(function ($) {

$.fn.hint = function (blurClass) {
  if (!blurClass) { 
    blurClass = 'blur';
  }
    
  return this.each(function () {
    // get jQuery version of 'this'
    var $input = $(this),
    
    // capture the rest of the variable to allow for reuse
      title = $input.attr('title'),
      $form = $(this.form),
      $win = $(window);

    function remove() {
      if ($input.val() === title && $input.hasClass(blurClass)) {
        $input.val('').removeClass(blurClass);
      }
    }

    // only apply logic if the element has the attribute
    if (title) { 
      // on blur, set value to title attr if text is blank
      $input.blur(function () {
        if (this.value === '') {
          $input.val(title).addClass(blurClass);
        }
      }).focus(remove).blur(); // now change all inputs to title
      
      // clear the pre-defined text when form is submitted
      $form.submit(remove);
      $win.unload(remove); // handles Firefox's autocomplete
    }
  });
};

})(jQuery);
