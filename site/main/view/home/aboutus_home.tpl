<section class="main">
	<div class="sliderWrap" style="position: relative;">
		<div class="sliderAbout">
			<div class="item">
				<img src="{$arg.stylesheet}images/banner1.jpg">
			</div>
			<div class="item">
				<img src="{$arg.stylesheet}images/banner2.jpg">
			</div>
		</div>
		<button type="button" class="btn next-slider">
			<i class="fas fa-chevron-right fa-fw"></i>
		</button>
		<button type="button" class="btn prev-slider">
			<i class="fas fa-chevron-left fa-fw"></i>
		</button>
	</div>
	<div class="container">
		<h2 class="text-center mt-5 text-uppercase text-mbig"
			style="font-size: 28px;">
			Chào mừng đến với <a href="#" class="text-danger">Daisan.vn</a>
		</h2>
		<div class="progress w-50 mx-auto" style="height: 1px;">
			<div class="progress-bar bg-danger" role="progressbar"
				style="width: 100%;" aria-valuenow="100" aria-valuemin="0"
				aria-valuemax="100"></div>
		</div>
		<div class="aboutServices my-3">
			<h3 class="my-5 text-uppercase text-big text-mlg">Dịch vụ</h3>
			<div class="row row-nm justify-content-center">
				{foreach from=$a_post_service item=data}
				<div class="col-sm-4 col-4">
					<div class="item mb-5">
						<div class="row row-nm">
							<div class="col-sm-3">
								<div class="border">
									<a href="{$data.description}"><img class="img-fluid "
										src="{$data.avatar}"></a>
								</div>
							</div>
							<div class="col-sm-9 my-auto">
								<h4 class="text-nm-1 text-mnm text-uppercase"><a href="{$data.description}">{$data.name}</a></h4>
							</div>
						</div>
					</div>
				</div>
				{/foreach}
			</div>
		</div>
	</div>
	<div class="aboutWork bg-light">
		<div class="container">
			<div class="row pt-5">
				<div class="col-md-7">
					<div class="card-body">
						<h3 class="font-weight-normal">SÀN TMĐT CHUYÊN BIỆT TRONG LĨNH VỰC XÂY DỰNG VÀ CÔNG NGHIỆP</h3>
						<p class="lead font-weight-normal">Daisan.vn - một công ty thương mại điện tử chuyên về vật
							liệu xây dựng và trang trí nhà cửa. Đây là một hệ thống bán hàng
							kết hợp cả B2B và B2C. Tại đây bạn có thể dễ dàng tạo các gian
							hàng để mua hàng hóa và dịch vụ trực tuyến để hỗ trợ số lượng
							khách hàng tìm kiếm thông tin trực tuyến tối đa về nhiều loại
							hàng hóa và dịch vụ.</p>
						<a href="?site=introduce" class="btn text-nm btn-primary">Xem
							chi tiết</a>
					</div>
				</div>
				<div class="col-sm-5 d-sm-block d-none">
					<img class="img-fluid"
						src="http://sbtechnosoft.com/expert/images/about-us.png">
				</div>
			</div>
		</div>
	</div>
	<div id="homeinfo">
		<div class="container">
			<div class="row">
				<div class="col-md-9">
					<div class="contact_text">
						<h4>
							<i class="fa fa-phone"></i> Gọi ngay tới số <a class="link-brown"
								href="tel:1900 9898 36">1900 9898 36</a> hoặc gửi email tới <a
								class="link-brown" href="mailto:info@daisangroup.vn">info@daisangroup.vn</a>
						</h4>
						<p>Chúng tôi sẵn sàng hỗ trợ tư vấn 24/7 để bạn có trải nghiệm
							dịch vụ tuyệt vời nhất</p>
					</div>
				</div>
				<div class="col-md-3 btn-contact">
					<a href="#" class="btn btn-warning btn-lg">Liên hệ ngay</a>
				</div>
			</div>
		</div>
	</div>
	<div class="mission my-5 text-center">
		<div class="container">
			<h3 class="text-big text-uppercase text-mlg">Sứ mệnh của chúng
				tôi</h3>
			<div class="progress w-25 mx-auto" style="height: 1px;">
				<div class="progress-bar bg-danger" role="progressbar"
					style="width: 100%;" aria-valuenow="100" aria-valuemin="0"
					aria-valuemax="100"></div>
			</div>
			<h4 class="mt-2 text-mlg">Khi doanh nghiệp của bạn thành công,
				chúng tôi thành công</h4>
			<p class="mt-2 text-mnm">Sứ mệnh của chúng tôi là làm cho việc
				kinh doanh trở nên dễ dàng ở bất cứ đâu bằng cách cung cấp cho các
				nhà cung cấp các công cụ cần thiết để tiếp cận đối tượng toàn cầu
				cho sản phẩm của họ và bằng cách giúp người mua tìm kiếm sản phẩm và
				nhà cung cấp một cách nhanh chóng và hiệu quả.</p>
		</div>
	</div>
	<div class="counter py-5" style="background: rgba(2, 27, 69, 0.9);">
		<div class="container">
			<div class="row ">
				<div class="col-sm-3 col-6">
					<div class="counterItem text-center text-white"
						style="font-size: 40px;">
						<i class="far fa-clock"></i>
						<div class="number">
							<span class="text-warning" style="font-weight: 600">5325</span>
							<p class="text-nm-1">Giờ làm việc</p>
						</div>
					</div>
				</div>
				<div class="col-sm-3 col-6">
					<div class="counterItem text-center text-white"
						style="font-size: 40px;">
						<i class="fas fa-user-friends"></i>
						<div class="number">
							<span class="text-warning" style="font-weight: 600">160</span>
							<p class="text-nm-1">Khách hàng hài lòng</p>
						</div>
					</div>
				</div>
				<div class="col-sm-3 col-6">
					<div class="counterItem text-center text-white"
						style="font-size: 40px;">
						<i class="fas fa-laptop"></i>
						<div class="number">
							<span class="text-warning" style="font-weight: 600">530</span>
							<p class="text-nm-1">Dự án đã hoàn thành</p>
						</div>
					</div>
				</div>
				<div class="col-sm-3 col-6">
					<div class="counterItem text-center text-white"
						style="font-size: 40px;">
						<i class="far fa-thumbs-up"></i>
						<div class="number">
							<span class="text-warning" style="font-weight: 600">49</span>
							<p class="text-nm-1">Lượt yêu thích</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="ourteam my-5">
		<div class="container">
			<h3 class="text-center text-uppercase text-big text-mlg">Nhân Sự
			</h3>
			<div class="progress mx-auto" style="height: 1px; width: 15%">
				<div class="progress-bar bg-danger" role="progressbar"
					style="width: 100%;" aria-valuenow="100" aria-valuemin="0"
					aria-valuemax="100"></div>
			</div>
			<div class="card-deck mt-sm-5 mt-3">
				<div class="row row-nm">
					<div class="col-sm-3 col-6">
						<div class="card mx-0" id="ourteam">
							<img class="card-img-top"
								src="http://hrm.hodine.com/site/upload/users/1538189631_9afdb01339ef137ea2f3fb1aa64a9024.jpeg"
								alt="Card image cap">
							<div class="card-body">
								<h5 class="card-title text-uppercase text-mnm-1 text-nm-1">ROBIN
									WILLIAMS</h5>
								<h6 class="text-primary">Founder</h6>
								<p class="card-text text-twoline">Lorem Ipsum is simply
									dummy text of the printing and typesetting industry .</p>
							</div>
						</div>
					</div>
					<div class="col-sm-3 col-6">
						<div class="card mx-0" id="ourteam">
							<img class="card-img-top"
								src="http://hrm.hodine.com/site/upload/users/1538365236_9afdb01339ef137ea2f3fb1aa64a9024.jpeg"
								alt="Card image cap">
							<div class="card-body">
								<h5 class="card-title text-uppercase text-mnm-1 text-nm-1">ROBIN
									WILLIAMS</h5>
								<h6 class="text-primary">Founder</h6>
								<p class="card-text text-twoline">Lorem Ipsum is simply
									dummy text of the printing and typesetting industry .</p>
							</div>
						</div>
					</div>
					<div class="col-sm-3 col-6" id="ourteam">
						<div class="card mx-0">
							<img class="card-img-top"
								src="http://hrm.hodine.com/site/upload/users/1538365155_9afdb01339ef137ea2f3fb1aa64a9024.jpeg"
								alt="Card image cap">
							<div class="card-body">
								<h5 class="card-title text-uppercase text-mnm-1 text-nm-1">ROBIN
									WILLIAMS</h5>
								<h6 class="text-primary">Founder</h6>
								<p class="card-text text-twoline">Lorem Ipsum is simply
									dummy text of the printing and typesetting industry .</p>
							</div>
						</div>
					</div>
					<div class="col-sm-3 col-6" id="ourteam">
						<div class="card mx-0">
							<img class="card-img-top"
								src="http://hrm.hodine.com/site/upload/users/1545357938_9afdb01339ef137ea2f3fb1aa64a9024.jpeg"
								alt="Card image cap">
							<div class="card-body">
								<h5 class="card-title text-uppercase text-mnm-1 text-nm-1">ROBIN
									WILLIAMS</h5>
								<h6 class="text-primary">Founder</h6>
								<p class="card-text text-twoline">Lorem Ipsum is simply
									dummy text of the printing and typesetting industry .</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="ourblog py-5 bg-light">
		<div class="container">
			<h2 class="text-center text-uppercase text-big">Tin tức sự kiện
			</h2>
			<div class="progress w-25 mx-auto" style="height: 1px;">
				<div class="progress-bar bg-danger" role="progressbar"
					style="width: 100%;" aria-valuenow="100" aria-valuemin="0"
					aria-valuemax="100"></div>
			</div>
			<div class="card-deck mt-5" id="about_blog">
				<div class="row row-nm">
					<div class="col-sm-3">
						<div class="card mx-0">
							<div class="row row-nm">
								<div class="col-sm-12 col-4">
									<div class="itemImg">
										<img class="card-img-top"
											src="http://sbtechnosoft.com/expert/images/blog1.jpg"
											alt="Card image cap">
									</div>
								</div>
								<div class="col-sm-12 col-8">
									<div class="card-body">
										<small class="text-muted text-nm d-sm-inline-block d-none"><i
											class="far fa-calendar fa-fw text-warning"></i> 24 dec 2018</small> <small
											class="text-muted text-nm ml-2 d-sm-inline-block d-none"><i
											class="far fa-comments fa-fw text-warning"></i> 30 comments</small>
										<h5 class="card-title text-uppercase text-mnm text-nm-1 my-1">
											<a href="#" class="red">blog post title here</a>
										</h5>
										<p class="card-text text-twoline text-msm">Lorem Ipsum is
											simply dummy text of the printing and typesetting industry .</p>
										<button
											class="btn btn-danger text-nm d-sm-block d-none mt-2 mx-auto">Read
											More</button>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="card mx-0">
							<div class="row row-nm">
								<div class="col-sm-12 col-4">
									<div class="itemImg">
										<img class="card-img-top"
											src="http://sbtechnosoft.com/expert/images/blog2.jpg"
											alt="Card image cap">
									</div>
								</div>
								<div class="col-sm-12 col-8">
									<div class="card-body">
										<small class="text-muted text-nm d-sm-inline-block d-none"><i
											class="far fa-calendar fa-fw text-warning"></i> 24 dec 2018</small> <small
											class="text-muted text-nm ml-2 d-sm-inline-block d-none"><i
											class="far fa-comments fa-fw text-warning"></i> 30 comments</small>
										<h5 class="card-title text-uppercase text-mnm text-nm-1 my-1">
											<a href="#" class="red">blog post title here</a>
										</h5>
										<p class="card-text text-twoline text-msm">Lorem Ipsum is
											simply dummy text of the printing and typesetting industry .</p>
										<button
											class="btn btn-danger text-nm d-sm-block d-none mt-2 mx-auto">Read
											More</button>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="card mx-0">
							<div class="row row-nm">
								<div class="col-sm-12 col-4">
									<div class="itemImg">
										<img class="card-img-top"
											src="http://sbtechnosoft.com/expert/images/blog3.jpg"
											alt="Card image cap">
									</div>
								</div>
								<div class="col-sm-12 col-8">
									<div class="card-body">
										<small class="text-muted text-nm d-sm-inline-block d-none"><i
											class="far fa-calendar fa-fw text-warning"></i> 24 dec 2018</small> <small
											class="text-muted text-nm ml-2 d-sm-inline-block d-none"><i
											class="far fa-comments fa-fw text-warning"></i> 30 comments</small>
										<h5 class="card-title text-uppercase text-mnm text-nm-1 my-1">
											<a href="#" class="red">blog post title here</a>
										</h5>
										<p class="card-text text-twoline text-msm">Lorem Ipsum is
											simply dummy text of the printing and typesetting industry .</p>
										<button
											class="btn btn-danger text-nm d-sm-block d-none mt-2 mx-auto">Read
											More</button>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="card mx-0">
							<div class="row row-nm">
								<div class="col-sm-12 col-4">
									<div class="itemImg">
										<img class="card-img-top"
											src="http://sbtechnosoft.com/expert/images/blog3.jpg"
											alt="Card image cap">
									</div>
								</div>
								<div class="col-sm-12 col-8">
									<div class="card-body">
										<small class="text-muted text-nm d-sm-inline-block d-none"><i
											class="far fa-calendar fa-fw text-warning"></i> 24 dec 2018</small> <small
											class="text-muted text-nm ml-2 d-sm-inline-block d-none"><i
											class="far fa-comments fa-fw text-warning"></i> 30 comments</small>
										<h5 class="card-title text-uppercase text-mnm text-nm-1 my-1">
											<a href="#" class="red">blog post title here</a>
										</h5>
										<p class="card-text text-twoline text-msm">Lorem Ipsum is
											simply dummy text of the printing and typesetting industry .</p>
										<button
											class="btn btn-danger text-nm d-sm-block d-none mt-2 mx-auto">Read
											More</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>