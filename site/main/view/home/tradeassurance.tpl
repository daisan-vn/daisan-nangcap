{if $is_mobile}
<div class="header-mobile cate-mobile fixed">
	<div class="container">
		<div class="row">
			<div class="col-7">
				<span onclick="goBackHistory()"><i class="fa fa-arrow-left"></i></span>
				<span class="title" onclick="showSearch()">Giao dịch đảm bảo</span>
				<span onclick="showSearch()"
					style="position: absolute; right: -45px;"><i
					class="fa fa-search fa-fw"></i></span>
			</div>
			<div class="col-5 text-right">
				<span><i class="fa fa-cloud-download fa-fw"></i></span>
				<div class="dropdown dropdown-tools-right">
					<span class="dropdown-toggle" id="dropdownMenuButton"
						data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i
						class="fa fa-bars"></i></span>
					<div class="dropdown-menu rounded-0"
						aria-labelledby="dropdownMenuButton">
						<a class="dropdown-item" href="#"><i class="fa fa-home"></i>Trang
							chủ</a> <a class="dropdown-item"
							href="?mod=account&amp;site=messages"><i
							class="fa fa-envelope-o"></i>Tin nhắn liên hệ</a> <a
							class="dropdown-item" href="{$arg.url_sourcing}"><i
							class="fa fa-bullhorn"></i>Yêu cầu báo giá</a> <a
							class="dropdown-item" href="?mod=account&site=pagefavorites"><i
							class="fa fa-star"></i>Gian hàng theo dõi</a> <a
							class="dropdown-item" href="?mod=account&site=productfavorites"><i
							class="fa fa-heart-o"></i>Sản phẩm yêu thích</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<section id="content-search">
	<div class="search-bar-header">
		<div class="container">
			<div class="row">
				<div class="col-1" onclick="goBack()">
					<span class="icon-back"><img
						src="http://daisannews.com/site/themes/webroot/images/back.png"
						class="img-fluid"></span>
				</div>
				<div class="col-10">
					<input class="form-control" id="Keyword"
						value="{$filter.key|default:''}"
						placeholder="Nhập vào từ khóa tìm kiếm...">
				</div>
			</div>
			<nav>
				<div class="nav nav-pill" id="pills-tab" role="tablist">
					<a class="nav-item nav-link active" id="nav-home-tab"
						data-toggle="tab" href="#nav-home" role="tab"
						aria-controls="nav-home" aria-selected="true" onclick="SetType(0)">SẢN
						PHẨM</a> <a class="nav-item nav-link" id="nav-profile-tab"
						data-toggle="tab" href="#nav-profile" role="tab"
						aria-controls="nav-profile" onclick="SetType(1)">NHÀ CUNG CẤP</a>
				</div>
			</nav>
		</div>
	</div>
	<div class="search-bar-content">
		<input type="hidden" id="Type" value="0">
		<div class="container">
			<div class="popular-keyword">
				<h3 class="keyword-title">Từ khóa phổ biến</h3>
				<div class="box-tag">
					{foreach from = $keyword.hot item = data} <a
						href="./product?k={$data.name}">{$data.name}</a> {/foreach}
				</div>

				<div class="clearfix"></div>
			</div>
			<div class="history-keyword">
				<h3 class="keyword-title">Lịch sử tìm kiếm:</h3>
				<div class="box-tag">
					{foreach from = $keyword.history item = data} <a
						href="./product?k={$data.name}">{$data.keyword_name}</a>
					{/foreach}
				</div>
			</div>
		</div>
	</div>

</section>

{/if}
<section id="List-5" class="List-5 List-4 bg-white">
	<div class="L-1 d-none d-md-block" id="fat">
		<div class="wrapper">
			<div class="tit d-flex text-white ">
				<img src="{$arg.stylesheet}images/ic-8.png" width="35" height="36">
				<span class="font-weight-bold pl-2">Quy chế hoạt động</span>
			</div>
			<div class="tit-1 text-white">Sàn giao dịch TMĐT Vật liệu xây
				dựng & Công nghiệp hàng đầu Việt Nam.</div>
			<div class="tit-2 text-white">DAISAN là Sàn giao dịch thương
				mại điện tử cho phép tổ chức, cá nhân tạo gian hàng để mua bán hàng
				hóa, dịch vụ trực tuyến chuyên về lĩnh vực Vật liệu xây dựng, công
				nghiệp.</div>
			<button class="btn-custom-5 px-4">Xem chi tiết</button>
		</div>
	</div>
	{if !$is_mobile}
	<nav id="navbar-example3"
		class="navbar navbar-light border-bottom navbar-example-1">
		<a class="navbar-brand" href="#"><img
			src="{$arg.stylesheet}images/ic-8.png" width="29" height="30">
			<span class="font-weight-bold">Trade Assurance</span> </a>
		<ul class="nav nav-pills">
			<li class="nav-item"><a class="nav-link active"
				href="{$smarty.server.REQUEST_URI}#fat">Giới thiệu</a></li>
			<li class="nav-item"><a class="nav-link"
				href="{$smarty.server.REQUEST_URI}#fat-7">Features</a></li>
			<li class="nav-item"><a class="nav-link"
				href="{$smarty.server.REQUEST_URI}#fat-4">Get Coverage</a></li>
			<li class="nav-item"><a class="nav-link"
				href="{$smarty.server.REQUEST_URI}#fat-5">Reviews</a></li>
			<li class="nav-item"><a class="nav-link"
				href="{$smarty.server.REQUEST_URI}#fat-6">FAQ</a></li>
		</ul>
	</nav>
	{/if}
	<div data-spy="scroll" data-target="#navbar-example2" data-offset="0">
		<div id="fat-7" class="d-none d-md-block">
			<div class="container">
				<div class="row py-5 d-flex">
					<div class="col-lg-6">
						<img src="{$arg.stylesheet}images/img-15.png" class="w-100 h-100">
					</div>
					<div class="col-lg-6 px-5">
						<div class="SS-1">Giới thiệu về DAISAN</div>
						<div class="SS-2">
							DAISAN mở ra một phương thức mới cho các hoạt động kinh doanh
							lĩnh vực xây dựng, công nghiệp. Hứa hẹn trở thành website quan
							trọng nhất trong các hoạt động quản trị Marketing, kinh doanh của
							các doanh nghiệp trong ngành. Cùng với đó là nền tảng vững chắc
							cho các doanh nghiệp nhỏ và vừa bước đầu tiếp cận, ứng dụng công
							nghệ vào hình thức kinh doanh trực tuyến của doanh nghiệp mình.
							<p>
								<br> <b>Sứ mệnh</b> mà DAISAN hướng tới là sẽ trở thành Sàn
								giao dịch thương mại điện tử tin cậy trong thị trường Thương mại
								điện tử, là cầu nối thương mại, kết nối giữa người bán và người
								mua, giữa doanh nghiệp với doanh nghiệp, 100% sản phẩm là hàng
								chính hãng.
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="">
			<div class="pt-5 d-block d-md-none">
				<div class="p-3 text-center pb-5">
					<span class="font-weight-bold fz-18"><img
						src="{$arg.stylesheet}images/ic-8.png" width="18">Trade
						Assurance</span> <small class="bg-secondary p-1 text-white rounded">It's
						Free!</small> <span class="d-inline-block px-2">Have you
						experienced shipping, quality or other order issues?</span> <span>Start
						your safe journey today !</span> <span class="d-block fz-12 mt-3">
						<img style="filter: grayscale(100%);"
						src="{$arg.stylesheet}images/ic-13.png" width="20" height="20">
						<u>Watch Video</u>
					</span>
				</div>
				<div class="pt-5">
					<img src="{$arg.stylesheet}images/img-39.png" class="w-100 img-1">
				</div>
			</div>
		</div>
		<div id="fat-1" class="bg-light py-5 border-top">
			<div class="container">
				<div class="row">
					<div class="col-lg-6 col-md-12">
						<div class="SS-1">Multiple safe payment options</div>
						<div class="SS-2">
							<span class="d-block mb-4">Secure online payment options
								include e-Checking, credit card and T/T. Your payment is secured
								by Alibaba.com's anti-fraud system.</span> <span>To get Trade
								Assurance coverage, you must make payment to the supplier's
								Citibank account designated by Alibaba.com.</span>
						</div>
						<div class="mt-4 text-center text-md-left">
							<button class="btn-custom-6">Get Started</button>
							<a href=""
								class="text-primary fz-16 d-block d-md-inline-block mt-4 mt-md-0">Payment
								options & transaction fees</a>
						</div>
					</div>
					<div class="col-lg-6 col-md-12">
						<div class="list-img">
							<img src="{$arg.stylesheet}images/img-19.png" class="img-1">
							<img src="{$arg.stylesheet}images/img-20.png" class=" img-2">
							<img src="{$arg.stylesheet}images/img-21.png" class=" img-3">
							<img src="{$arg.stylesheet}images/img-22.png"
								class="img-4 animated fadeIn"> <img
								src="{$arg.stylesheet}images/img-23.png"
								class="img-5 animated zoomIn">
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="fat-2" class="border-top py-5">
			<div class="container">
				<div class="row">
					<div class="SS-1 col-12 text-center">
						CHÍNH SÁCH ĐỔI TRẢ HUỶ ĐƠN HÀNG<span
							class="d-block fz-14 text-muted">CHÍNH SÁCH ĐỔI TRẢ HUỶ
							ĐƠN HÀNG</span>
					</div>
					<div class="col-lg-5">
						<div class="list-img">
							<img src="{$arg.stylesheet}images/img-25.png"
								class="img-6 animated fadeInLeft"> <img
								src="{$arg.stylesheet}images/img-26.png"
								class="img-7 animated fadeInRight"> <img
								src="{$arg.stylesheet}images/img-27.png"
								class="img-8 animated zoomIn">
						</div>
					</div>
					<div class="col-lg-7">
						<div class="row">
							<div
								class="col-lg-6 col-12 mb-4 mb-lg-0 feature-item-1 fadeIn animated">
								<div class="d-flex">
									<img src="{$arg.stylesheet}images/ic-28.png" height="50">
									<div class="pl-2">
										<span class="SS-2 d-block">Chính sách đổi trả</span> <span
											class="d-block">DAISAN không phải là người cung cấp
											sản phẩm/ dịch vụ nên việc đổi trả sản phẩm/ dịch vụ sẽ được
											thực hiện theo chính sách của từng Nhà bán hàng.</span>
									</div>
								</div>
							</div>
							<div
								class="col-lg-6 col-12 mb-4 mb-lg-0 feature-item-2 fadeIn animated">
								<div class="d-flex">
									<img src="{$arg.stylesheet}images/ic-30.png" height="50">
									<div class="pl-2">
										<span class="SS-2 d-block">Shipping protection</span> <span
											class="d-block">DAISAN yêu cầu Nhà bán hàng khi đăng
											tin trên website bán hàng phải đưa đầy đủ thông tin về chính
											sách đổi trả hàng.</span>
									</div>
								</div>
							</div>
							<div
								class="col-lg-6 col-12 mb-4 mb-lg-0 mt-5 feature-item-3 fadeIn animated">
								<div class="d-flex">
									<img src="{$arg.stylesheet}images/ic-31.png" height="50">
									<div class="pl-2">
										<span class="SS-2 d-block">Product-quality protection</span> <span
											class="d-block">Trade Assurance will cover all
											payments made during the ordering process up to 30 days after
											you receive the goods.</span>
									</div>
								</div>
							</div>
							<div
								class="col-lg-6 col-12 mb-4 mb-lg-0 mt-5 feature-item-3 fadeIn animated">
								<div class="d-flex">
									<img src="{$arg.stylesheet}images/ic-32.png" height="50">
									<div class="pl-2">
										<span class="SS-2 d-block">Protection period</span> <span
											class="d-block">Trade Assurance will cover all
											payments made during the ordering process up to 30 days after
											you receive the goods.</span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="fat-3" class="d-none d-md-block">
			<div class="container">
				<div class="title text-white font-weight-bold text-center">
					Start protecting your orders today</div>
				<div class="w-75 text-center text-white m-auto">We've got you
					covered. Start ordering from a Trade Assurance supplier today on
					Alibaba.com and you'll never have to worry again. Start your search
					now...</div>
				<div class="text-center mt-5">
					<form>
						<input type="" name=""
							placeholder="Search for products with Trade Assurance">
						<button>
							<i class="fa fa-search pr-2"></i>Search
						</button>
					</form>
				</div>
			</div>
		</div>
		<div id="fat-4" class="py-5 bg-light text-center d-none d-md-block">
			<div class="container">
				<div class="SS-1 mr-0">Trade Assurance Coverage</div>
				<div class="card w-50 m-auto">
					<div class="card-header ">
						<span class="d-block">Free Order Protection</span>
						<div>
							<span class="price">$0</span> <span>/ Order</span>
						</div>
					</div>
					<ul class="list-group list-group-flush">
						<li class="list-group-item"><span class="font-weight-bold">Step
								1. </span> <span> Order with a Trade Assurance supplier</span></li>
						<li class="list-group-item"><span class="font-weight-bold">Step
								2. </span> <span>Pay to the supplier's Citibank account
								designated by Alibaba.com</span></li>
						<li class="list-group-item"><span class="font-weight-bold">Step
								3. </span> <span>Receive shipment</span></li>
						<li class="list-group-item"><span class="font-weight-bold">Step
								4. </span> <span>Leave feedback about your order and goods</span></li>
					</ul>
				</div>
				<div class="mt-5">
					<button class="btn-custom-6">Get Free Coverage</button>
					<a href="" class="text-muted d-block mt-3"><u>Terms of
							service</u></a>
				</div>
			</div>
		</div>
		<div id="fat-5" class="d-none d-md-block">
			<div class="">
				<div id="carouselExampleControls" class="carousel slide"
					data-ride="carousel">
					<div class="carousel-inner">
						<div class="carousel-item active">
							<div class="row h-100">
								<div class="col-7">
									<div class="list-img">
										<img src="{$arg.stylesheet}images/img-28.png"
											class="img-11 transform-0"> <img
											src="{$arg.stylesheet}images/img-29.png"
											class="img-112 transform-0"> <img
											src="{$arg.stylesheet}images/img-30.png"
											class="img-113 transform-0">
									</div>

								</div>
								<div class="col-5 align-self-center">
									<img src="{$arg.stylesheet}images/img-31.png">
									<div class="name text-white">Neera, New Zealand</div>
									<div class="text-white industry">
										in <span class="font-weight-bold">Home & Garden</span>
									</div>
									<div class="text-white">"Totally worry-free for new
										users.I was truly amazed by this service and felt confident to
										make another purchase which was substantially more expensive."
									</div>
									<button class="btn-custom-5 font-weight-bold mt-5">Share
										Your Own Story</button>
								</div>
							</div>
						</div>
						<div class="carousel-item ">
							<div class="row h-100">
								<div class="col-7">
									<div class="list-img">
										<img src="{$arg.stylesheet}images/img-32.png"
											class="img-114 transform-1"> <img
											src="{$arg.stylesheet}images/img-33.png" class="img-115">
										<img src="{$arg.stylesheet}images/img-34.png"
											class="img-116 transform-1"> <img
											src="{$arg.stylesheet}images/img-36.png"
											class="img-117 transform-2">
									</div>
								</div>
								<div class="col-4 align-self-center">
									<img src="{$arg.stylesheet}images/img-31.png">
									<div class="name text-white">Neera, New Zealand</div>
									<div class="text-white industry">
										in <span class="font-weight-bold">Home & Garden</span>
									</div>
									<div class="text-white">"Totally worry-free for new
										users.I was truly amazed by this service and felt confident to
										make another purchase which was substantially more expensive."
									</div>
									<button class="btn-custom-5 font-weight-bold mt-5">Share
										Your Own Story</button>
								</div>
							</div>
						</div>
					</div>
					<a class="carousel-control-prev" href="#carouselExampleControls"
						role="button" data-slide="prev"> <span
						class="carousel-control-prev-icon" aria-hidden="true"></span> <span
						class="sr-only">Previous</span>
					</a> <a class="carousel-control-next" href="#carouselExampleControls"
						role="button" data-slide="next"> <span
						class="carousel-control-next-icon" aria-hidden="true"></span> <span
						class="sr-only">Next</span>
					</a>
				</div>
			</div>
		</div>
		<div class="text-center d-block d-md-none mt-4">
			<div class="SS-1">Build Your Credibility</div>
			<div class="py-3">Enhance your “Buyer Profile” by placing
				online orders and gain access to premium features (coming soon).</div>
			<div class="pt-5 mt-5">
				<img src="{$arg.stylesheet}images/img-37.png" class="w-100">
			</div>
		</div>
		<div class="text-center d-block d-md-none mt-4">
			<div class="SS-1">
				Using Trade Assurance <br /> is Simple

			</div>
			<div class="fz-18 mt-3">
				<a href="" class="text-primary"> <img
					src="{$arg.stylesheet}images/ic-13.png" width="24" height="24">Watch
					Video
				</a>
			</div>

			<div class="d-flex px-4 ty-3 mt-5">
				<img src="{$arg.stylesheet}images/ic-14.png" width="82" height="82">
				<div class="align-self-center pl-4">
					<span
						class="rounded-circle bg-warning px-2 py-1 font-weight-bold fz-18 mt-1 d-inline-block align-top">1</span>
					<span class="d-inline-block text-left"> Start an order with
						a <br>Trade Assurance supplier
					</span>
				</div>
			</div>
			<div class="d-flex px-4 pt-3 mt-2">
				<img src="{$arg.stylesheet}images/ic-15.png" width="82" height="82">
				<div class="align-self-center pl-4">
					<span
						class="rounded-circle bg-warning px-2 py-1 font-weight-bold fz-18 mt-1 d-inline-block align-top">2</span>
					<span class="d-inline-block text-left"> Start an order with
						a <br>Trade Assurance supplier
					</span>
				</div>
			</div>
			<div class="d-flex px-4 pt-3 mt-2">
				<img src="{$arg.stylesheet}images/ic-16.png" width="82" height="82">
				<div class="align-self-center pl-4">
					<span
						class="rounded-circle bg-warning px-2 py-1 font-weight-bold fz-18 mt-1 d-inline-block align-top">3</span>
					<span class="d-inline-block text-left"> Start an order with
						a <br>Trade Assurance supplier
					</span>
				</div>
			</div>
		</div>
		<div id="fat-6" class="py-5 bg-white text-center pb-5">
			<div class="container">
				<div class="row">
					<div class="col-lg-4 text-left">
						<div class="text-center text-md-left">
							<div class="SS-1 m-0 py-4 py-md-0">FAQ</div>
							<div class="mt-3 d-none d-md-block">You can find all
								Frequently Asked Questions in our</div>
							<a href="" class="text-muted mt-1 d-none d-md-block"><u>Help
									Center</u></a>
						</div>
						<div class="mt-5 d-none d-md-block">
							<div class="SS-1 m-0">Terms</div>
							<div class="mt-3">
								Read the full Trade Assurance <a href="" class="text-muted mt-1"><u>terms
										of service</u></a>
							</div>
						</div>
						<div class="mt-5 d-none d-md-block">
							<div class="SS-1 m-0">Follow</div>
							<a href="" class="text-muted d-inline-block mt-1 mr-2"><i
								class="fa fa-facebook-f"></i></a> <a href=""
								class="text-muted d-inline-block mt-1 mr-2"><i
								class="fa fa-youtube"></i></a>
						</div>
					</div>
					<div class="col-lg-7 text-left fz-16">
						<div>
							<div class="font-weight-bold">Q: Does Trade Assurance
								charge fees?</div>
							<div class="mt-3">No. Trade Assurance order protection is a
								FREE service for buyers. Standard transaction fees still apply.
							</div>
						</div>
						<div class="mt-5">
							<div class="font-weight-bold">Q: Does Trade Assurance
								charge fees?</div>
							<div class="mt-3">No. Trade Assurance order protection is a
								FREE service for buyers. Standard transaction fees still apply.
							</div>
						</div>
						<div class="mt-5">
							<div class="font-weight-bold">Q: Does Trade Assurance
								charge fees?</div>
							<div class="mt-3">No. Trade Assurance order protection is a
								FREE service for buyers. Standard transaction fees still apply.
							</div>
						</div>
						<div class="mt-5">
							<div class="font-weight-bold">Q: Does Trade Assurance
								charge fees?</div>
							<div class="mt-3">No. Trade Assurance order protection is a
								FREE service for buyers. Standard transaction fees still apply.
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
