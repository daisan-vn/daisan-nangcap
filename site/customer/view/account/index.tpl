<div class="text-center mt-4">
	<h1>Kiểm soát, bảo vệ và bảo mật tài khoản của bạn</h1>
	<h5>Tài khoản Google của bạn cho phép bạn truy cập nhanh vào cài đặt và công cụ cho phép bạn bảo vệ dữ liệu, bảo vệ quyền riêng tư và quyết định cách thông tin của bạn có thể làm cho các dịch vụ của Google hoạt động tốt hơn cho bạn.</h5>
</div>

<div class="card-columns my-4">
	<div class="card">
		<div class="card-body">
			<h3 class="card-title"><i class="fa fa-power-off"></i> Tài khoản và bảo mật</h3>
			<p class="card-text">This is a longer card with supporting text
				below as a natural lead-in to additional content. This content is a
				little bit longer.</p>
		</div>
		<div class="list-group list-group-flush">
			<a href="?mod=account&site=avatar" class="list-group-item">Thay đổi ảnh đại diện</a> 
			<a href="?mod=account&site=password" class="list-group-item">Thay đổi mật khẩu</a> 
			<a href="?mod=account&site=history" class="list-group-item">Lịch sử đăng nhập</a> 
			<a href="?mod=account&site=info" class="list-group-item">Cài đặt thông tin cá nhân</a> 
			<a href="?mod=account&site=security" class="list-group-item">Cài đặt bảo mật</a> 
		</div>
	</div>
	<div class="card">
		<div class="card-body">
			<h5 class="card-title">Card title</h5>
			<p class="card-text">This is another card with title and
				supporting text below. This card has some additional content to make
				it slightly taller overall.</p>
			<p class="card-text">
				<small class="text-muted">Last updated 3 mins ago</small>
			</p>
		</div>
	</div>
	<div class="card">
		<div class="card-body">
			<h3 class="card-title"><i class="fa fa-user-circle-o"></i> Cá nhân</h3>
			<p class="card-text">This is a longer card with supporting text
				below as a natural lead-in to additional content. This content is a
				little bit longer.</p>
		</div>
		<div class="list-group list-group-flush">
			<a href="#" class="list-group-item">Danh sách page đang theo dõi</a> 
			<a href="#" class="list-group-item">Danh sách sản phẩm đang quan tâm</a> 
			<a href="#" class="list-group-item">Tin nhắn liên hệ</a> 
			<a href="#" class="list-group-item">Quản lý hoạt động của Hodine</a> 
			<a href="#" class="list-group-item">Kiểm soát nội dung hiển thị</a> 
		</div>
	</div>
	<div class="card">
		<div class="card-body">
			<h3 class="card-title"><i class="fa fa-shopping-basket"></i> Thông tin mua hàng</h3>
			<p class="card-text">This is a longer card with supporting text
				below as a natural lead-in to additional content. This content is a
				little bit longer.</p>
		</div>
		<div class="list-group list-group-flush">
			<a href="#" class="list-group-item">Cài đặt thông tin cá nhân</a> 
			<a href="#" class="list-group-item">Thay đổi ảnh đại diện</a> 
			<a href="#" class="list-group-item">Quản lý hoạt động của Hodine</a> 
			<a href="#" class="list-group-item">Kiểm soát nội dung hiển thị</a> 
		</div>
	</div>
	<div class="card">
		<div class="card-body">
			<h3 class="card-title"><i class="fa fa-clone"></i> Hodine Page</h3>
			<p class="card-text">This is a longer card with supporting text
				below as a natural lead-in to additional content. This content is a
				little bit longer.</p>
		</div>

		<ul class="list-group list-group-flush">
			{foreach from=$out.page_list item=data}
			<li class="list-group-item">
				<div class="row row-sm">
					<div class="col-2"><a href="{$data.url}" class="col-black"><img class="img-thumbnail" src="{$data.logo}" width="100%"></a></div>
					<div class="col-10"><a href="{$data.url}" class="col-black">{$data.name}</a></div>
				</div>
			</li>
			{/foreach}
		</ul>
		<div class="card-body"><a href="?mod=page&site=create"><i class="fa fa-plus"></i> Tạo Page mới</a></div>
		<div class="list-group list-group-flush">
			<a href="?mod=page&site=index" class="list-group-item">Danh sách Page đang quản lý</a> 
			<a href="#" class="list-group-item">Các thông số thống kê của Page</a> 
		</div>
	</div>
</div>