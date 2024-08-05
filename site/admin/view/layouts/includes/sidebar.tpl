{if $sidebar_type eq 'default' || $sidebar_type eq 'content'}
<ul class="nav nav-sidebar">
	<li><a href="./" class="nav-link nav-toggle">			<i class="fa fa-home"></i>			<span class="title">Dashboard </span>		</a></li>
	<li class="dropdown">		<a href="#" class="dropdown-toggle" data-toggle="dropdown">			<i class="fa fa-star-o fa-fw"></i> Nâng cao <span class="caret pull-right"></span>		</a>		
		<ul class="dropdown-menu">			
			<li><a href="?mod=scandb&site=index">Lấy sp cho gian hàng</a></li>	
			<li><a href="?mod=scandb&site=repeat">Quét tự động liên tục</a></li>	
			<li><a href="?mod=scandb&site=autoupdate">Quét update sản phẩm</a></li>		
			<li><a href="?mod=autorun&site=update_productsearch">Update Product Search</a></li>
			<li><a href="?mod=autorun&site=update_page_metas">Update Page Metas</a></li>
		</ul>
	</li>
	<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-shopping-cart fa-fw"></i>			Đơn hàng			<span class="caret pull-right"></span></a>		<ul class="dropdown-menu">			<li><a href="?mod=product&site=order">Xem đơn hàng</a></li>			<li><a href="?mod=product&site=order">Báo cáo bán hàng</a></li>		</ul>	</li>
	<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-clone fa-fw"></i>
			Nhà cung cấp
			<span class="caret pull-right"></span></a>
		<ul class="dropdown-menu">
			<li><a href="?mod=pages&site=index">Nhà cung cấp</a></li>
			<li><a href="?mod=pages&site=package">Gói sử dụng</a></li>
			<li><a href="?mod=pages&site=contact">Liên hệ</a></li>
			<li><a href="./?site=accesslogusers">Các cuộc gọi</a></li>
			<li><a href="?mod=pages&site=payment">Gian hàng trả phí</a></li>
		</ul>
	</li>
	<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-star-o fa-fw"></i>
			Sản phẩm
			<span class="caret pull-right"></span></a>
		<ul class="dropdown-menu">
			<li><a href="?mod=product&site=index">Tất cả sản phẩm</a></li>
			<li><a href="?mod=product&site=showcase">Sản phẩm showcase</a></li>
			<li><a href="?mod=product&site=toprank">Sản phẩm TopRank</a></li>
			<li><a href="?mod=taxonomy&site=index&type=product">Danh mục
					sản phẩm</a></li>
			<li><a href="?mod=product&site=ads">Quảng cáo sản phẩm</a></li>
			<li><a href="?mod=taxonomy&site=index&type=product_unit">Đơn
					vị sản phẩm</a></li>

		</ul>
	</li>

	<li class="dropdown">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown">
			<i class="fa fa-file-text-o fa-fw"></i> Bài Viết<span class="caret pull-right"></span>
		</a>
		<ul class="dropdown-menu">
			<li><a href="?mod=posts&site=index">Bài viết</a></li>
			<li><a href="?mod=taxonomy&site=index">Danh mục bài viết</a></li>
			<li><a href="?mod=posts&site=index&type=support">Helpcenter</a></li>
			<li><a href="?mod=taxonomy&site=index&type=support">Danh mục Helpcenter</a></li>
			<li><a href="?mod=taxonomy&site=index&type=tag">Tags</a></li>
		</ul>
	</li>

	<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-gift fa-fw"></i> Sự
			kiện KM<span class="caret pull-right"></span></a>
		<ul class="dropdown-menu">
			<li><a href="?mod=event&site=index">Tất cả</a></li>
			<li><a href="?mod=taxonomy&site=index&type=event">Danh mục sự kiện</a></li>
		</ul>
	</li>
	<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user fa-fw"></i>
			Người dùng<span class="caret pull-right"></span></a>
		<ul class="dropdown-menu">
			<li><a href="?mod=user&site=index">Tài khoản</a></li>
			<li><a href="?mod=user&site=report">Thống kê</a></li>
		</ul>
	<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-history fa-fw"></i>
			Từ khóa
			<span class="caret pull-right"></span></a>
		<ul class="dropdown-menu">
			<li><a href="?mod=keyword&site=category">Danh mục từ khóa</a></li>
			<li><a href="?mod=keyword&site=index">Danh sách từ khóa</a></li>
			<li><a href="?mod=keyword&site=history">Lịch sử tìm kiếm</a></li>
		</ul>
	</li>
	<li><a href="?mod=home&site=rfq"><i class="fa fa-check fa-fw"></i> Sourcing</a></li>
</ul>
<ul class="nav nav-sidebar">
	<li><a href="?mod=media&site=index"><i class="fa fa-file-text-o fa-fw"></i> Medias</a></li>
	<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-history fa-fw"></i>
			Hình ảnh
			<span class="caret pull-right"></span></a>
		<ul class="dropdown-menu">
			<li><a href="?mod=posts&site=images">Tất cả Slider</a></li>
			<li><a href="?mod=slider&site=index">Slider Category</a></li>
			<li><a href="?mod=slider&site=banners">Banner In Page</a></li>
		</ul>
	</li>
	<li><a href="?mod=menu&site=index"><i class="fa fa-users fa-fw"></i> Menu</a></li>
	<li><a href="?mod=pages&site=nation"><i class="fa fa-firefox fa-fw"></i> Quốc gia</a></li>
	<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-anchor fa-fw"></i>
			Admin <span class="caret pull-right"></span></a>
		<ul class="dropdown-menu">
			<li><a href="?mod=account&site=index">All Accounts</a></li>
			<li><a href="?mod=account&site=statistics">All Statistics</a></li>
			<li><a href="?mod=account&site=permissions">Permissions</a></li>
			<li><a href="?site=tablechangelogs">Lịch sử cập nhật</a></li>
		</ul>
	</li>
</ul>
{else if $sidebar_type eq 'setting'}
<ul class="nav nav-sidebar">
	<li><a href="?mod=option&site=index"><i class="fa fa-bar-chart fa-fw"></i> Tổng quan</a></li>
	<li><a href="?mod=option&site=contact"><i class="fa fa-list fa-fw"></i> Liên hệ</a></li>
	<li><a href="?mod=option&site=seo"><i class="fa fa-tag fa-fw"></i>
			Thông tin SEO</a></li>
	<li><a href="?mod=option&site=link"><i class="fa fa-link fa-fw"></i> Link liên kết</a></li>
</ul>
<ul class="nav nav-sidebar">
	<li><a href="?mod=option&site=thumb"><i class="fa fa-picture-o fa-fw"></i> Upload ảnh</a></li>
</ul>
{/if}