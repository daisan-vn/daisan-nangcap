<section class="accessibility">
	<div class="helpdesk-online rounded-circle">
		<a href="tel:+8498 846 7025"
			class="btn btn-outline-success rounded-circle w-100"
			title="+8498 846 7025"><span
			class="text-center text-lg text-mnm"><i class="fas fa-phone"></i></span></a>
		<div></div>
		<div></div>
	</div>
	<div class="back-to-top mt-3 rounded-circle">
		<button type="button"
			class="btn btn-secondary w-100 rounded-circle btn-outline-danger"
			data-original-title="" title="">
			<span class="text-center text-lg text-mnm"><i
				class="fas fa-arrow-up"></i></span>
		</button>
	</div>
</section>
<footer class="bg-dark text-white py-3">
	<div class="container text-center">
		<img class="" src="{$arg.logo.image}" height="50px">
		<p class="child-company mb-2 mt-3">{$option.contact.name} -
			{$option.contact.slogan}</p>
		<p class="text-nm mb-1 mx-2">{$option.contact.description}</p>
		<p class="text-nm mx-2">
			Copyright © 2017-2019 <a href="./" class="text-primary">DaisanExpress.Com</a>.
			All rights reserved.
		</p>
	</div>
</footer>
<section class="menu-mobile" id="menu-top">
		<section class="head-mobile">
			<div class="account-mobile py-3">
				<div class="container">
					<span class="account-icon"><img class="img-fluid"
						src="{$arg.img_gen}icon/account.png"></span>
					<button class="exit-menu float-right">
						<span><i class="fas fa-times"></i></span>
					</button>
					<div class="sign-in-or-join pt-2">
						<a href="#">Đăng nhập</a> | <a href="#">Đăng ký</a>
					</div>
				</div>
			</div>
		</section>
		<section class="menu-list-mobile">
			<div class="menu-category-mobile">
				<ul class="nav flex-column">
					<li class="nav-item"><a class="nav-link active" href="./"><i
							class="fas fa-home fa-fw"></i> Trang chủ</a></li>
					<li class="nav-item"><a class="nav-link" href="?mod=product"><i
							class="fas fa-truck fa-fw"></i> Nhà cung cấp</a></li>
					<li class="nav-item"><a class="nav-link"
						href="?mod=product&amp;site=category"><i
							class="fas fa-bars fa-fw"></i> Danh mục sản phẩm</a></li>
					<li class="nav-item"><a class="nav-link" href="?mod=rfq"><i
							class="far fa-envelope fa-fw"></i> RFQ</a></li>
					<li class="nav-item"><a class="nav-link" href="?mod=event"><i
							class="fas fa-users fa-fw"></i> Sự kiện</a></li>
					<li class="nav-item"><a class="nav-link" href="#"><i
							class="fas fa-chart-line fa-fw"></i> Buy Trade Leads </a></li>
					<li class="nav-item"><a class="nav-link" href="#"><i
							class="fas fa-chart-area fa-fw"></i> Trade Shows </a></li>
					<li class="nav-item"><a class="nav-link" href="#"><i
							class="fas fa-clipboard fa-fw"></i> Feedback </a></li>
					<li class="nav-item getApp mt-2 border-top"><a href="#"
						class="nav-link"><i class="fas fa-download fa-fw"></i> Get App</a></li>
				</ul>
			</div>
		</section>
	</section>
{literal}
<script type="text/javascript">
		$(window).on('load', function() {
			$('#preloading').fadeOut('fast');
		});
		$('#about_menu').click(function() {
			$('#menu-top').fadeIn("100");
		});
		$('.exit-menu').click(function() {
			$('#menu-top').fadeOut();
		});
		$(".datepicker").datepicker({dateFormat: 'dd-mm-yy'});
		function filter(){
			url = '?mod=event&site=search';
			var taxonomy_id = $('#event-search select[name=taxonomy_id]').val();
			var date_start = $('#event-search input[name=date_start]').val();
			var date_finish = $('#event-search input[name=date_finish]').val();
			var key = $('#event-search input[name=key]').val();
			if(taxonomy_id && taxonomy_id!=0) url += '&location='+taxonomy_id;
			if(date_start && date_start!='') url += '&date_start='+date_start;
			if(date_finish && date_finish!='') url += '&date_finish='+date_finish;
			if(key && key!='') url += '&key='+key;
			location.href = url;
		}
	</script>
<script type="text/javascript">
	$(window).scroll(function() {
		if ($(this).scrollTop() > 100) {
			$('.back-to-top').fadeIn();
		} else {
			$('.back-to-top').fadeOut();
		};
	});
</script>
<script>
	$(document).ready(function() {
		$('.back_to_top_mobile button').click(function() {
			$('html, body').animate({
				scrollTop : 0
			}, 500);
		});
	});
</script>
<script type="text/javascript">
	$(document).ready(function() {
		$('.back-to-top button').click(function() {
			$('html, body').animate({
				scrollTop : 0
			}, 500);
		});
		$('.accessibility button').tooltip();
	});
</script>
{/literal}