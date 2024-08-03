
<div class="">
	<div class="page-title">
		<div class="title_left">
			<h3>User Profile</h3>
		</div>

		<div class="title_right">
			<div
				class="col-md-5 col-sm-5 col-xs-12 form-group pull-right top_search">
				<div class="input-group">
					<input type="text" class="form-control" placeholder="Search for...">
					<span class="input-group-btn">
						<button class="btn btn-default" type="button">Go!</button>
					</span>
				</div>
			</div>
		</div>
	</div>
	<div class="clearfix"></div>

	<div class="row">
		<div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
				<div class="x_title">
					<h2>
						Thông tin người dùng <small>Activity report</small>
					</h2>
					<ul class="nav navbar-right panel_toolbox">
						<li><a href="#"><i class="fa fa-chevron-up"></i></a></li>
						<li class="dropdown"><a href="#" class="dropdown-toggle"
							data-toggle="dropdown"><i class="fa fa-wrench"></i></a>
							<ul class="dropdown-menu">
								<li><a href="#">Settings 1</a></li>
								<li><a href="#">Settings 2</a></li>
							</ul>
						</li>
						<li><a href="#"><i class="fa fa-close"></i></a></li>
					</ul>
					<div class="clearfix"></div>
				</div>
				<div class="x_content">

					<div class="col-md-3 col-sm-3 col-xs-12 profile_left">

						<div class="profile_img">

							<!-- end of image cropping -->
							<div id="crop-avatar">
								<!-- Current avatar -->
								<div class="avatar-view" title="Thay đổi avatar">
									<img id="avatar_cur" src="{$result.avatar}" alt="Avatar">
								</div>

<!-- Cropping modal -->
<div class="modal fade" id="avatar-modal">
	<div class="modal-dialog modal-lg">
		<div id="avatar_change" class="modal-content">
			<form class="avatar-form" enctype="multipart/form-data" method="post">
				<div class="modal-header">
					<button class="close" data-dismiss="modal" type="button">&times;</button>
					<h4 class="modal-title" id="avatar-modal-label">Thay đổi avatar</h4>
				</div>
				<div class="modal-body" style="background-color: #F7F7F7;">
					<div class="avatar-body">

						<!-- Upload image and data -->

						<!-- Crop and preview -->
						<div class="row">
							<div style="padding-left: 0;" id="avatar_wrap" class="col-md-7 col-sm-7 col-xs-12">
								<div style="position: relative; width: 100%; margin-top: 0;" id="avatar_wrap_child" class="avatar-wrapper">
								    <img id="avatar_image" style="max-width: 100%" src="{$result.avatar}">
								</div>
							</div>
							<div style="padding-right: 0;" class="col-md-5 col-sm-5 col-xs-12">
							    <div class="form-group">
                                    <label for="avatarInput" class="col-md-3 col-sm-12 col-xs-12 control-label" style="padding-left: 0; margin-top: 3px;">Tải lên</label>
                                    <div class="col-md-9 col-sm-12 col-xs-12" style="padding: 0; margin-bottom: 10px;">
                                        <input class="avatar-input" id="avatarInput" name="avatar_file" type="file" onchange="readURL(this);" style="width: 100%;">
                                    </div>
                                </div>
                                
                                <div style="display: block;">
                                    <label style="padding-top: 25px; margin-bottom: 0; display: block;" class="control-label">Xem trước</label>
    								<div style="display: inline-block; width: 214px; height: 214px; border: 1px solid #aaa; margin-top: 10px;" class="avatar-preview preview-lg"></div>
    								<div style="display: inline-block; width: 56px; height: 56px; border: 1px solid #aaa; border-radius: 28px;" class="avatar-preview preview-sm"></div>
								</div>
								
								<br>
								
								<input name="avatar_x" type="hidden">
                                <input name="avatar_y" type="hidden">
                                <input name="avatar_width" type="hidden">
                                <input name="avatar_height" type="hidden">
								
								<div class="text-right" style="margin-top: 10px; display: block;">
								    <button id="del_avt_btn" class="btn btn-danger" name="delete_avatar">Xóa avatar hiện tại</button>
								    <button class="btn btn-default" data-dismiss="modal" type="button">Hủy bỏ</button>
								    <button class="btn btn-primary avatar-save" name="avatar_change" type="submit">Lưu lại</button>
								</div>

							</div>
						</div>
						
					</div>
				</div>
				<!-- <div class="modal-footer">
                </div> -->
			</form>
		</div>
	</div>
</div>
<!-- /.modal -->

								<!-- Loading state -->
								<div class="loading" tabindex="-1"></div>
							</div>
							<!-- end of image cropping -->

						</div>
						<h3>{$result.name}</h3>

						<ul class="list-unstyled user_data">
							<li><i style="width: 14px;" class="fa fa-at"></i>&ensp;{$result.username}</li>

							<li><i style="width: 14px;" class="fa fa-briefcase"></i>&ensp;Kĩ sư phần mềm</li>

							<li class="m-top-xs"><i style="width: 14px;" class="fa fa-envelope"></i>&ensp;<a href="mailto:{$result.email}" target="_blank">{$result.email}</a>
							</li>
						</ul>

					<a class="btn btn-success" data-toggle="modal" data-target="#myModal"><i class="fa fa-edit m-right-xs"></i>Edit Profile</a>
					<a class="btn btn-primary" data-toggle="modal" data-target="#password"><i class="fa fa-edit m-right-xs"></i>Edit Pass</a>

						<!-- start skills -->
						<h4>Skills</h4>
						<ul class="list-unstyled user_data">
							<li>
								<p>Web Applications</p>
								<div class="progress progress_sm">
									<div class="progress-bar bg-green" data-transitiongoal="50"></div>
								</div>
							</li>
							<li>
								<p>Website Design</p>
								<div class="progress progress_sm">
									<div class="progress-bar bg-green" data-transitiongoal="70"></div>
								</div>
							</li>
							<li>
								<p>Automation - Testing</p>
								<div class="progress progress_sm">
									<div class="progress-bar bg-green" data-transitiongoal="30"></div>
								</div>
							</li>
							<li>
								<p>UI / UX</p>
								<div class="progress progress_sm">
									<div class="progress-bar bg-green" data-transitiongoal="50"></div>
								</div>
							</li>
						</ul>
						<!-- end of skills -->

					</div>
					<div class="col-md-9 col-sm-9 col-xs-12">

						<div class="profile_title">
							<div class="col-md-6">
								<h2>User Activity Report</h2>
							</div>
							<div class="col-md-6">
								<div id="reportrange" class="pull-right"
									style="margin-top: 5px; background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #E6E9ED">
									<i class="glyphicon glyphicon-calendar fa fa-calendar"></i> <span>December
										30, 2014 - January 28, 2015</span> <b class="caret"></b>
								</div>
							</div>
						</div>
						<!-- start of user-activity-graph -->
						<div id="graph_bar" style="width: 100%; height: 280px;"></div>
						<!-- end of user-activity-graph -->

						<div class="" data-example-id="togglable-tabs">
							<ul id="myTab" class="nav nav-tabs bar_tabs">
								<li class="active"><a
									href="#tab_content1" id="home-tab" data-toggle="tab">Recent Activity</a></li>
								<li><a href="#tab_content2" id="profile-tab" data-toggle="tab">Projects Worked on</a></li>
								<li><a href="#tab_content3" id="profile-tab2" data-toggle="tab">Profile</a></li>
							</ul>
							<div id="myTabContent" class="tab-content">
								<div class="tab-pane fade active in" id="tab_content1">

									<!-- start recent activity -->
									<ul class="messages">
										<li><img src="{$arg.stylesheet}images/img.jpg" class="avatar" alt="Avatar">
											<div class="message_date">
												<h3 class="date text-info">24</h3>
												<p class="month">May</p>
											</div>
											<div class="message_wrapper">
												<h4 class="heading">Desmond Davison</h4>
												<blockquote class="message">Raw denim you
													probably haven't heard of them jean shorts Austin. Nesciunt
													tofu stumptown aliqua butcher retro keffiyeh dreamcatcher
													synth.</blockquote>
												<br />
												<p class="url">
													<span class="fs1 text-info" data-icon=""></span> <a href="#"><i
														class="fa fa-paperclip"></i> User Acceptance Test.doc </a>
												</p>
											</div></li>
										<li><img src="{$arg.stylesheet}images/img.jpg" class="avatar" alt="Avatar">
											<div class="message_date">
												<h3 class="date text-error">21</h3>
												<p class="month">May</p>
											</div>
											<div class="message_wrapper">
												<h4 class="heading">Brian Michaels</h4>
												<blockquote class="message">Raw denim you
													probably haven't heard of them jean shorts Austin. Nesciunt
													tofu stumptown aliqua butcher retro keffiyeh dreamcatcher
													synth.</blockquote>
												<br />
												<p class="url">
													<span class="fs1" data-icon=""></span>
													<a href="#" data-original-title="">Download</a>
												</p>
											</div></li>
										<li><img src="{$arg.stylesheet}images/img.jpg" class="avatar" alt="Avatar">
											<div class="message_date">
												<h3 class="date text-info">24</h3>
												<p class="month">May</p>
											</div>
											<div class="message_wrapper">
												<h4 class="heading">Desmond Davison</h4>
												<blockquote class="message">Raw denim you
													probably haven't heard of them jean shorts Austin. Nesciunt
													tofu stumptown aliqua butcher retro keffiyeh dreamcatcher
													synth.</blockquote>
												<br />
												<p class="url">
													<span class="fs1 text-info" data-icon=""></span> <a href="#"><i
														class="fa fa-paperclip"></i> User Acceptance Test.doc </a>
												</p>
											</div></li>
										<li><img src="{$arg.stylesheet}images/img.jpg" class="avatar" alt="Avatar">
											<div class="message_date">
												<h3 class="date text-error">21</h3>
												<p class="month">May</p>
											</div>
											<div class="message_wrapper">
												<h4 class="heading">Brian Michaels</h4>
												<blockquote class="message">Raw denim you
													probably haven't heard of them jean shorts Austin. Nesciunt
													tofu stumptown aliqua butcher retro keffiyeh dreamcatcher
													synth.</blockquote>
												<br />
												<p class="url">
													<span class="fs1" data-icon=""></span>
													<a href="#" data-original-title="">Download</a>
												</p>
											</div></li>

									</ul>
									<!-- end recent activity -->

								</div>
								<div class="tab-pane fade" id="tab_content2">

									<!-- start user projects -->
									<table class="data table table-striped no-margin">
										<thead>
											<tr>
												<th>#</th>
												<th>Project Name</th>
												<th>Client Company</th>
												<th class="hidden-phone">Hours Spent</th>
												<th>Contribution</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>1</td>
												<td>New Company Takeover Review</td>
												<td>Deveint Inc</td>
												<td class="hidden-phone">18</td>
												<td class="vertical-align-mid">
													<div class="progress">
														<div class="progress-bar progress-bar-success"
															data-transitiongoal="35"></div>
													</div>
												</td>
											</tr>
											<tr>
												<td>2</td>
												<td>New Partner Contracts Consultanci</td>
												<td>Deveint Inc</td>
												<td class="hidden-phone">13</td>
												<td class="vertical-align-mid">
													<div class="progress">
														<div class="progress-bar progress-bar-danger"
															data-transitiongoal="15"></div>
													</div>
												</td>
											</tr>
											<tr>
												<td>3</td>
												<td>Partners and Inverstors report</td>
												<td>Deveint Inc</td>
												<td class="hidden-phone">30</td>
												<td class="vertical-align-mid">
													<div class="progress">
														<div class="progress-bar progress-bar-success"
															data-transitiongoal="45"></div>
													</div>
												</td>
											</tr>
											<tr>
												<td>4</td>
												<td>New Company Takeover Review</td>
												<td>Deveint Inc</td>
												<td class="hidden-phone">28</td>
												<td class="vertical-align-mid">
													<div class="progress">
														<div class="progress-bar progress-bar-success"
															data-transitiongoal="75"></div>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
									<!-- end user projects -->

								</div>
								<div class="tab-pane fade" id="tab_content3">
									<p>xxFood truck fixie locavore, accusamus mcsweeney's marfa
										nulla single-origin coffee squid. Exercitation +1 labore
										velit, blog sartorial PBR leggings next level wes anderson
										artisan four loko farm-to-table craft beer twee. Qui photo
										booth letterpress, commodo enim craft beer mlkshk</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>



<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Thay đổi thông tin chung</h4>
      </div>
      <div class="modal-body">
        <form id="edit-profile" method="post" class="form-horizontal">
				<fieldset>
					
					<div class="row form-group">
						<div class="col-lg-2"><label class="control-label" for="firstname">Tên đầy đủ</label></div>
						<div class="col-lg-10"><div class="controls">
							<input type="text" class="form-control" name="name" id="firstname" value="{$result.name}">
						</div></div>
						<!-- /controls -->
					</div>
					<div class="row form-group">
							<div class="col-lg-2"><label class="control-label" for="selectError3">Sinh nhật</label></div>
							<div class="col-lg-3">
								<select id="" name="day" class="form-control required">
									{$out.birthday.day}
								</select>
							</div>
							<div class="col-lg-3">
								<select id="" name="month" class="form-control required">
									{$out.birthday.month}
								</select>
								</div>
								<div class="col-lg-4">
								<select id="" name="year" class="form-control required">
									{$out.birthday.year}
								</select>
								</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2">
						<label class="control-label" for="selectError3">Giới tính</label>
						</div>
						<div class="col-lg-10">
							<select id="" name="gender" class="form-control required">
								{$out.gender}
							</select>
						</div>
					</div>
					<div class="row form-group">
						<div class="col-lg-2">
							<label class="control-label" for="firstname">Địa chỉ</label>
						</div>
						<div class="col-lg-10">
								<textarea type="text" class="form-control" name="address" id="firstname" value="{$result.address}"></textarea>
						</div>
					</div>

					<div class=" row form-group">
						<div class="col-lg-2"><label class="control-label" for="firstname">Email</label></div>
						<div class="col-lg-10">
							<input type="text" class="form-control" name="email" id="firstname" value="{$result.email}">
						</div>
						<!-- /controls -->
					</div>
					<!-- /control-group -->

					<div class="row form-group">
						<div class="col-lg-2"><label class="control-label" for="firstname">Điện thoại</label></div>
						<div class="col-lg-10 controls">
							<input type="text" class="form-control" name="phone" id="firstname" value="{$result.phone}">
						</div>
						<!-- /controls -->
					</div>
					<!-- /control-group -->
					<br /> <br />


					<div class=" row form-group">
						<center><button type="submit" class="btn btn-primary" name="submit">Lưu lại</button>
						<button type="reset" class="btn">Hủy bỏ</button></center>
					</div>
					<!-- /form-actions -->
				</fieldset>
			</form>
      </div>
    </div>
  </div>
</div>
 
 
 <!-- Modal mật khẩu -->
 <div class="modal fade" id="password" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
        <form method="post" class="form-horizontal">
		  <div class="row form-group">
		    <div class="col-lg-3"><label for="exampleInputEmail1">Nhập mật khẩu cũ</label></div>
		  	<div class="col-lg-9"> <input type="password" name="pass_old"class="form-control" id="exampleInputEmail1" placeholder="Mật khẩu cũ"></div>
		  </div>
		  <div class="form-group row">
		    <div class="col-lg-3"><label for="exampleInputPassword1">Nhập mật khẩu mới</label></div>
		   <div class="col-lg-9"> <input type="password" name="password"class="form-control" id="exampleInputPassword1" placeholder="Mật khẩu mới"></div>
		  </div>
		  <div class=" row form-group">
		    <div class="col-lg-3"><label for="exampleInputPassword1">Xác nhận mật khẩu</label></div>
		    <div class="col-lg-9"> <input type="password" name="Re_password"class="form-control" id="exampleInputPassword1" placeholder="Nhập lại mật khẩu"></div>
		  </div>
		 <center><button type="submit" name="pass" class="btn btn-primary">Submit</button></center> 
		</form>
      </div>
    </div>
  </div>
</div>
<!-- image cropping -->
  <script src="{$arg.stylesheet}js/cropping/cropper.min.js"></script>
  <script src="{$arg.stylesheet}js/cropping/avatar.js"></script>
  <!--<script src="{$arg.stylesheet}js/cropping/main.js"></script>-->
  

