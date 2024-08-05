<div id="preloading">
	<div id="loading-center">
		<div id="loading-center-absolute">
			<div class="object" id="object_four"></div>
			<div class="object" id="object_three"></div>
			<div class="object" id="object_two"></div>
			<div class="object" id="object_one"></div>
			<p class="text-white text-center text-big">Loading...</p>
		</div>
	</div>
</div>
<header>
	<div class="aboutTop text-nm" style="background: #021b45;">
		<div class="container">
			<div class="row">
				<div class="col-sm-7">
					<ul class="nav row mx-0" id="mobile_aboutus_header">
						<li class="nav-item "><a
							class="nav-link text-white pl-0" href="#"> <i
								class="fas fa-envelope fa-fw text-warning"></i>
								Info@daisangroup.vn
						</a></li>
						<li class="nav-item "><a
							class="nav-link text-white " href="tel:+8435 721 9424"><i
								class="fas fa-phone fa-fw text-warning"></i> <span
								class="d-sm-inline-block d-none">CSKH: </span> 1900 9898 36</a></li>
					</ul>
				</div>
				<div class="col-sm-5 ml-auto d-sm-block d-none">
					<ul class="nav justify-content-end ">
						<li class="nav-item"><a class="nav-link text-white orange"
							href="?mod=account&site=register"> <i
								class="fas fa-user-alt fa-fw text-warning"></i> Đăng ký
						</a></li>
						<li class="my-auto"><span class="col-white">|</span></li>
						<li class="nav-item"><a class="nav-link text-white orange"
							href="?mod=account&site=login"><i
								class="fas fa-lock fa-fw text-warning"></i> Đăng nhập</a></li>
						<li class="my-auto"><span class="my-auto col-white">|</span></li>
						<li class="nav-item"><a class="nav-link text-white" href="#"><i
								class="fas fa-shopping-cart fa-fw text-warning"></i></a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="aboutMenu py-2 my-2">
		<div class="container">
			<div class="row">
				<div class="col-sm-3 my-auto col-6">
					<a href="./"><img class="" src="{$arg.logo}" height="30px"></a>
				</div>
				<div class="col-sm-9 col-6" id="about_menu">
					<button
						class="btn d-sm-none d-block my-auto bg-white border-0 text-mbig"
						type="button">
						<span><i class="fas fa-bars"></i></span>
					</button>
					<ul class="nav justify-content-end d-sm-flex d-none text-nm"
						id="listabout">
						<li class="nav-item"><a href="?mod=home&site=aboutus_home"
							class="nav-link active py-1"> <span> Trang chủ</span>
						</a></li>
						<li class="nav-item"><a href="?mod=home&site=introduce"
							class="nav-link ml-1 py-1"> <span> Giới thiệu</span>
						</a></li>
						<li class="nav-item"><a href="?mod=home&site=service"
							class="nav-link ml-1 py-1"> <span> Dịch vụ</span>
						</a></li>
						<li class="nav-item"><a href="?mod=home&site=contact"
							class="nav-link ml-1 py-1"> <span> Liên hệ</span>
						</a></li>
					</ul>
					<script type="text/javascript">
						$(function() {
							var CurrentUrl = document.URL;
							var CurrentUrlEnd = CurrentUrl.split('/').filter(
									Boolean).pop();
							$("#listabout li a").each(
									function() {
										var ThisUrl = $(this).attr('href');
										var ThisUrlEnd = ThisUrl.split('/')
												.filter(Boolean).pop();
										if (ThisUrlEnd == CurrentUrlEnd) {
											$("#listabout li a").removeClass(
													'active');
											$(this).addClass('active');
										}
									});
						});
					</script>
				</div>
			</div>
		</div>
	</div>
</header>
<script>
	$(window).on('load', function() {
		$('#preloading').fadeOut('fast');
	});
	$('.number span').each(function() {
		$(this).prop('Counter', 0).animate({
			Counter : $(this).text()
		}, {
			duration : 3500,
			easing : 'swing',
			step : function(now) {
				$(this).text(Math.ceil(now));
			}
		});
	});
	$('#about_menu button').click(function() {
		$('#aboutmenu_mobile').fadeIn(200);
	});
	$('.exit-menu').click(function() {
		$('#aboutmenu_mobile').fadeOut('fast');
	});
</script>