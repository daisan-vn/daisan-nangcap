<section class="mainsearch py-5">
    <div class="row justify-content-center ">
        <div class="col-md-6 ">
            <ul class="mainsearch__tab nav justify-content-center ">
                <li class="nav-item ">
                    <a class="nav-link pb-0" href="./">Sản phẩm</a>
                </li>
                <li class="nav-item ">
                    <a class="nav-link active px-0 pb-0" href="./supplier ">Nhà cung cấp</a>
                </li>
            </ul>
            <div class="mainsearch__form input-group my-2 my-lg-0 ">
                <input value="1" id="Type" type="hidden">
                <input class="form-control" type="text" id="key_search" value="{$main_filter.key|default: ''}" placeholder="Nhập từ khóa tìm kiếm ">
                <button class="btn mainsearch__button" type="button " onclick="search(); "><i
                        class="fa fa-search fa-fw "></i>{if !$is_mobile}Tìm kiếm{/if}</button>
            </div>
        </div>
    </div>
</section>

{if !$is_mobile}
<section class="section-main-menu">
    <div class="container-fluid">
        <div class="cate-banner-wrap">
            <div class="nav-main-menu">
                <ul class="main-menu">
                    {foreach from=$a_sup_category key=k item=v} {if $k lt 6}
                    <li class="nav-item dropdown megamenu">
                        <a class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" href="#"><img src="{$v.image}" height="36"><span class="line-2">{$v.name}</span></a>
                        <div class="dropdown-menu sub-menu">
                            <div class="row">
                                {foreach from=$v.sub key=k1 item=sub1} {if $k1 lt 6}
                                <div class="col-2">
                                    <a href="./supplier/search?k={$sub1.name}" class="dropdown-item text-b">{$sub1.name}</a> {foreach from=$sub1.sub key=k2 item=sub2} {if $k2 lt 10}
                                    <a class="dropdown-item" href="./supplier/search?k={$sub2.name}">{$sub2.name}</a> {/if} {/foreach}
                                    <a href="./supplier/search?k={$sub1.name}" class="dropdown-item" style="text-decoration: revert;">Xem thêm</a>
                                </div>
                                {/if} {/foreach}
                            </div>
                            <p class="text-center"><a href="{$v.url}">Xem tất cả sản phẩm trong <b>{$v.name}</b></a></p>
                        </div>
                    </li>
                    {/if}{/foreach}
                    <li class="nav-item">
                        <a class="nav-link" href="./product/allcategory"><span class="line-2">Xem tất cả <br>danh mục<i class="fa fa-chevron-right "></i></span></a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</section>
{/if}

<div class="d-flex cate-banner-wrap cate-banner-wrap-inner rounded-lg">
    <div class="container container-cate p-0">
        <section class="">
            {if $is_mobile}
            <div class="card border-0 rounded-8">
                <div class="card-body">
                    <ul class="nav row row-sm">
                        {foreach from=$a_sup_category key=k item=data}
                        <li class="col-xl-2 col-3 nav-item text-center {if $k ge 7}d-none d-sm-block{/if}">
                            <a class="nav-link" href="{$data.url}">
                                <img src="{$data.image}" class="img-fluid" alt="{$data.name}">
                                <span></span>
                            </a>
                            <p class="text-twoline">{$data.name}</p>
                        </li>
                        {/foreach}
                        <li class="col-xl-2 col-3 nav-item text-center d-block d-sm-none">
                            <a class="nav-link" href="javascript:void(0)" id="collapse_all_category">
                                <img src="{$arg.stylesheet}images/H0e9c53982dc7407f9abc86bb5b2145bf4.webp" class="img-fluid">
                            </a>
                            <p>Tất cả</p>
                        </li>
                    </ul>
                </div>
            </div>
            {/if}
            <div class="row row-nm h-100">
                <div class="col-xl-3">
                    <div class="category-card d-none d-sm-block">
                        <h5 class="p-3 font-weight-bold">Nguồn theo danh mục</h5>
                        <ul class="cate-banner-menu-vertical-title-ul ">
                            {foreach from=$a_sup_category key=k item=v} {if $k lt 6}
                            <li class="mega-menu-has-child " style="padding: 6px 15px 7px 10px;">
                                <a href="{$v.url} "> <span class="icon-cate-banner "> <img
										src="{$arg.stylesheet}images/loading.gif" data-src="{$v.image}" alt="{$v.name}"
										loading="lazy">
								</span> <span class="cate-banner-text text-oneline ">{$v.name}</span> <span class="pull-right cate-banner-chevron "><i class="fa fa-chevron-right "></i></span>
                                </a>
                                <div class="mega-menu-dropdown mega-menu-lg mega-menu-dropdown-header ">
                                    <div class="row ">
                                        {foreach from=$v.sub key=k1 item=sub1}
                                        <div class="col-xl-4 col-md-4 col-sm-4 col-mega-vertical col-cus-padding ">
                                            <h3 class="mega-menu-heading line-1">
                                                <a href="./supplier/search?k={$sub1.name}">{$sub1.name}</a>
                                            </h3>
                                            <ul>
                                                {foreach from=$sub1.sub key=k2 item=sub2} {if $k2 lt 6}
                                                <li><a href="./supplier/search?k={$sub2.name}" class="line-1 ">{$sub2.name}</a></li>
                                                {/if} {/foreach}
                                            </ul>
                                        </div>
                                        {/foreach}
                                    </div>
                                </div>
                            </li> {/if} {/foreach}
                            <li class="mega-menu-has-child ">
                                <a href="./product/allcategory "> <span class="icon-cate-banner " style="padding: 6px; "> <img src="{$arg.stylesheet}images/loading.gif "
										data-src="{$arg.url_img}all-36-36.png " style="width: 20px; " loading="lazy">
								</span> <span class="cate-banner-text text-oneline ">Tất cả danh mục</span><span class="pull-right cate-banner-chevron "><i class="fa fa-chevron-right "></i></span>
                                </a>
                                <ul class="mega-menu-dropdown mega-menu-dropdown-header ">
                                    {foreach from=$a_sup_category key=k item=v} {if $k gt 5}
                                    <li><a href="{$v.url} " class="line-1 ">{$v.name}</a></li> {/if} {/foreach}
                                </ul>
                            </li>
                        </ul>
                    </div>
                    <!-- end cate-banner-menu-vertical -->
                </div>
                <div class="col-xl-3 h-100 d-flex d-sm-block mb-3 mb-sm-0">
                    <div class="middle-card mb-sm-3 mb-0">
                        <div class="card-body">
                            <h3 class="text-nm-1 text-b tmb-4">
                                <a href="./product/toprank" class="text-dark">Top bán chạy</a>
                            </h3>
                            <div class="row row-sm">
                                {foreach from=$a_product_toprank key=k item=v} {if $k lt 2}
                                <div class="col-xl-6 col-6">
                                    <a href="./supplier/toprank" class="box-img">
                                        <img src="{$v.avatar}">
                                    </a>
                                    <p class="text-center mb-0">{$v.price}</p>
                                </div>
                                {/if} {/foreach}
                            </div>
                        </div>
                    </div>
                    <div class="middle-card">
                        <div class="card-body">
                            <h3 class="text-nm-1 text-b tmb-4">
                                <a href="./supplier/oem" class="text-dark">Sản Xuất Theo Yêu Cầu</a>
                            </h3>
                            <div class="row row-sm">
                                {foreach from=$a_product_page_oem key=k item=v} {if $k lt 2}
                                <div class="col-xl-6 col-6">
                                    <a href="./supplier/toprank" class="box-img">
                                        <img src="{$v.avatar}">
                                    </a>
                                    <p class="text-center mb-0">{$v.price}</p>
                                </div>
                                {/if} {/foreach}
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 h-100">
                    <div class="toprank-card">
                        <div class="card-body">
                            <h3 class="text-nm-1 text-b mb-4">
                                <a href="./supplier/toprank" class="text-dark">Nhà cung cấp hàng đầu</a>
                            </h3>
                            <div class="row row-nm m-slider-grid-row">
                                {foreach from=$a_product_page_toprank key=k item=v}
                                <div class="col-xl-6 col-4">
                                    <a href="./supplier/toprank" class="d-block bg-light overflow-hidden">
                                        <img src="{$v.avatar}" class="img-fluid zoom-in">
                                    </a>
                                    <p class="line-1 pt-2">{$v.name}</p>
                                </div>
                                {/foreach}
                            </div>
                        </div>
                    </div>
                </div>
                <div class="user col-xl-3 h-100">
                    <div class="user-info-card mb-3 ">
                        <div class="card-body">
                            <div class="d-none d-sm-block">
                                {if $arg.login eq 0}
                                <div class="user-name">
                                    <div class="media">
                                        <span class="user-info__avatar">
                                        <img src="{$arg.stylesheet}images/icons/user-56-56.png" class="mr-3" alt="..."></span>
                                        <div class="media-body">
                                            <p class="pb-0 mb-0">Chào mừng</p>
                                            <h5 class="mt-0">Khách mới</h5>
                                        </div>
                                    </div>
                                </div>
                                <div class="login d-flex justify-content-between">
                                    <a href="./login" class="btn btn-contact rounded-pill abutton">Đăng nhập</a>
                                    <a href="" class="btn btn-contact rounded-pill abutton">Tham gia miễn phí</a>
                                </div>
                                {else}
                                <div class="user-name">
                                    <div class="media">
                                        <span class="user-info__avatar">
                                        <img src="{$arg.stylesheet}images/icons/user-56-56.png" class="mr-3" alt="..."></span>
                                        <div class="media-body">
                                            <p class="pb-0 mb-0">Xin chào,</p>
                                            <h5 class="mt-0">{$hcache.user.name|truncate:50}</h5>
                                        </div>
                                    </div>
                                </div>
                                <div class="login d-flex justify-content-between">
                                    <a href="./newshop" class="btn btn-contact rounded-pill abutton">Khởi tạo gian hàng</a>
                                </div>
                                {/if}
                            </div>
                            <div class="">
                                <h3 class="text-nm-1 text-b text-dark mb-4">Lịch sử duyệt web của bạn</h3>
                                <div class="row row-sm">
                                    {foreach from=$a_product_views key=k item=v} {if $k lt 3}
                                    <div class="col-xl-4 col-4">
                                        <div class="bg-light">
                                            <a href="{$v.url}">
                                                <img src="{$v.avatar}" class="img-fluid">
                                            </a>
                                        </div>
                                    </div>
                                    {/if} {/foreach}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="user-operate-card mb-3">
                        <div class="card-body">
                            <p class="text-center pt-1">Một yêu cầu, nhiều báo giá</p>
                            <a href="./sourcing" class="btn btn-outline-dark btn-block rounded-pill">Yêu cầu báo giá</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="factory-tab">
            <ul class="nav nav-pills" id="factory-tab">
                <li class="nav-item tab-item" data-tab="tab-0">Tất cả danh mục</li>
                {foreach from=$a_main_category key=k item=v}
                <li class="nav-item tab-item" data-tab="tab-{$v.id}">
                    {$v.name}
                </li>
                {/foreach}
                <li class="nav-item"><a href="javascrip:void(0)" class="btn btn-outline-dark rounded-pill" id="tab-view-more">{if !$is_mobile}Xem thêm{/if}<i class="fa fa-angle-down fa-fw" aria-hidden="true"></i></a>
                </li>

            </ul>
            <!-- Tab panes -->
            <div class="more-content">
                <ul class="nav">
                    <li class="nav-item tab-item" data-tab="tab-0">
                        Tất cả danh mục
                    </li>
                    {foreach from=$a_main_category key=k item=v}
                    <li class="nav-item tab-item" data-tab="tab-{$v.id}">
                        {$v.name}
                    </li>
                    {/foreach}
                </ul>
            </div>
            <div id="factory-sub-tab">
                <ul class="nav">
                    <li class="sub-tab-item nav-item btn btn-outline-dark rounded-pill" data-tab="0">Đã xác minh</li>
                    <li class="sub-tab-item nav-item btn btn-outline-dark rounded-pill" data-tab="0">Đơn vị gia công(OEM)</li>
                    <li class="nav-item"><a href="javascrip:void(0)" class="btn btn-outline-dark rounded-pill d-none" id="tab-view-more">Xem thêm<i class="fa fa-angle-down fa-fw" aria-hidden="true"></i></a>
                    </li>
                </ul>
            </div>
        </section>
        <div class="tab-content">
            {foreach from=$result item=data}
            <div class="supplier-item-info bg-white rounded-8 mt-3">
                <div class="card-body">
                    <div class="media">
                        <div class="logo">
                            <img src="{$data.logo}" class="mr-3 p-2 img-fluid" alt="...">
                        </div>
                        <div class="media-body">
                            <h3 class="text-lg m-0"><a href="{$data.url}">{$data.name}</a></h3>
                            <div class="tag-list py-2">
                                <i class="fa fa-clock-o col-yearexp"></i>
                                <span class="join-year">
                                <b class="value">{$data.yearexp}</b> Năm hoạt động</span> {if $data.package_id ne 0}
                                <i class="fa fa-gg-circle col-gold ml-3"></i>
                                <span>Gold Supplier</span> {/if} {if $data.is_verification ne 0}
                                <i class="fa fa-check col-verify-1 ml-3"></i>
                                <span class="col-verify">Đã xác minh</span> {/if} {if $data.is_oem ne 0}
                                <i class="fa fa-share-alt col-gold ml-3"></i>
                                <span>OEM</span> {/if}
                                <i class="fa fa-map-marker col-yearexp ml-3" aria-hidden="true"></i>
                                <span>{$data.Name}</span>
                            </div>
                        </div>
                        <nav class="nav ml-auto d-none d-sm-block">
                            <a class="btn btn-outline-dark rounded-pill text-b mr-3" href="javascript:void(0)" onclick="SetPageFavorite(24774);"><i class="fa fa-star-o fa-fw" aria-hidden="true"></i>Yêu thích</a>
                            <a href="{$data.url}" class="btn btn-outline-dark rounded-pill mr-3 text-b">Vào gian hàng</a>
                            <a href="{$data.url_contact}" class="btn btn-outline-dark rounded-pill text-b"><i class="fa fa-envelope-o fa-fw "></i>Liên hệ nhà cung cấp</a>
                        </nav>
                    </div>
                    <div class="row row-sm pt-4">
                        <div class="col-xl-4 d-none d-sm-block">
                            <div class="info">
                                <h4>Xếp hạng và đánh giá</h4>
                                <div class="d-flex align-items-center mb-3">
                                    <div class="value ">
                                        <img src="{$arg.stylesheet}images/icons/star-16-16.png">
                                        <img src="{$arg.stylesheet}images/icons/star-16-16.png">
                                        <img src="{$arg.stylesheet}images/icons/star-16-16.png">
                                        <img src="{$arg.stylesheet}images/icons/star-16-16.png">
                                        <img src="{$arg.stylesheet}images/icons/star-16-16.png">
                                    </div>
                                    <div class="title ml-3">(<b>5.0</b>&nbsp;/&nbsp;5)</div>
                                </div>
                                <h4>Năng lực của nhà cung cấp</h4>
                                <ul class="capability">
                                    {if $data.type_name}
                                    <li>
                                        {$data.type_name}
                                    </li>
                                    {/if} {if $data.supply_ability}
                                    <li>{$data.supply_ability}</li>
                                    {/if} {if $data.number_mem_show}
                                    <li>{$data.number_mem_show}</li>
                                    {/if} {if $data.revenue}
                                    <li>{$data.revenue}</li>
                                    {/if}
                                </ul>
                            </div>
                        </div>

                        <div class="col-xl-5">
                            <div class="row row-nm">
                                {foreach from=$data.metas.products key=k item=v} {if $k lt 3}
                                <div class="col-xl-4 col-4">
                                    <a href="{$v.url}" class="rounded-lg d-block overflow-hidden"><img src="{$v.avatar}" class="img-fluid rounded-lg zoom-in"></a>
                                    <p class="line-1 mt-3 mb-0 text-left"><a href="{$v.url}" class="text-nm-1 text-dark text-b">{$v.price}</a></p>
                                </div>
                                {/if} {/foreach}
                            </div>
                        </div>
                        <div class="col-xl-3 d-none d-sm-block">
                            <div class="shop_main-profile">
                                <div class="owl-carousel owl-1">
                                    {foreach from=$data.metas.images key=k item=img}
                                    <div class="item">
                                        <img src="{$img}" alt="">
                                    </div>
                                    {/foreach}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {/foreach}
        </div>
        <!-- <section class="suppier-list">
            {if $paging}
            <div class="filter__search-pagination mb-3">
                <div class="card card-body border-0">
                    {$paging}
                </div>
            </div>
            {/if}
        </section> -->
    </div>
</div>
<div class="filter fcategory d-block d-sm-none">
    <div class="d-flex justify-content-start bd-highlight p-3 border-bottom">
        <div class="bd-highlight">
            <a href=""><img src="{$arg.stylesheet}images/arrow-l.png"></a>
        </div>
        <div class="bd-highlight text-nm-1 text-b pl-2">Tất cả danh mục</div>
        <div class="bd-highlight">&nbsp;</div>
    </div>
    <div class="row row-no">
        <div class="col-4">
            <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                {foreach from=$a_sup_category key=k item=data}
                <a class="nav-link {if $k eq 0}active{/if}" id="v-pills-home-tab" data-toggle="pill" href="#vtax{$data.id}" role="tab" aria-controls="v-pills-home" aria-selected="true">{$data.name}</a> {/foreach}
            </div>
        </div>
        <div class="col-8">
            <div class="tab-content" id="v-pills-tabContent">
                {foreach from=$a_sup_category key=k item=data}
                <div class="tab-pane fade {if $k eq 0}show active{/if}" id="vtax{$data.id}" role="tabpanel" aria-labelledby="v-pills-home-tab">
                    <div class="d-flex justify-content-between bd-highlight px-3 pb-3">
                        <div class="bd-highlight text-nm text-b"><a href="{$data.url}" class="text-dark">{$data.name}</a></div>
                        <div class="bd-highlight">
                            <a href=""><img data-src="{$arg.stylesheet}images/TB11Qn9uGL7gK0jSZFBXXXZZpXa-16-24.webp" height="12" loading="lazy"></a>
                        </div>
                    </div>
                    <ul class="nav flex-column">
                        {foreach from=$data.sub item=sub}
                        <li class="nav-item">
                            <a href="./supplier/search?k={$sub.name}" class="nav-link text-dark">{$sub.name}</a>
                        </li>
                        {/foreach}
                    </ul>
                </div>
                {/foreach}
            </div>
        </div>
    </div>
</div>
<!--end main-content-->
<input type="hidden" value="" id="catId">
<input type="hidden" value="{$out.url}" id="filter_url">
<script type="text/javascript">
    $('#collapse_all_category').on('click', function() {
        $(".filter").addClass("active");
        $('.overlay').fadeIn();
    });
</script>
<script>
    $(document).ready(function() {
        $('#tab-view-more').on('click', function() {
            $('.more-content').toggle();
        });
        $('.more-content').on('click', 'li', function() {
            $('.more-content').toggle();
        });
        // Mở tab đầu tiên mặc định
        $("#tab-0").show();
        $("li[data-tab='tab-0']").addClass("active");
        // Xử lý sự kiện khi nhấp vào nút tab
        $(".more-content .tab-item").click(function() {
            var tabId = $(this).data("tab");
            var titleEle = $("#factory-tab li[data-tab=" + tabId + "]");
            if (titleEle) titleEle.insertAfter($("#factory-tab li:nth-child(1)"));
            $(this).insertAfter($(".more-content li:nth-child(1)"));
            // Xóa lớp "active" từ tất cả các nút tab
            $(".tab-item").removeClass("active");
            // Thêm lớp "active" cho nút tab được chọn
            $(this).addClass("active");
            titleEle.addClass("active");
        });

        $(".nav-pills .tab-item").click(function() {
            // Lấy dữ liệu tab được chọn
            var tabId = $(this).data("tab");
            // Di chuyển tab được chọn lên đầu danh sách
            //$(this).prependTo("#factory-tab");
            $(this).insertAfter($("#factory-tab li:nth-child(1)"));
            var contEle = $(".more-content li[data-tab=" + tabId + "]");
            if (contEle) contEle.insertAfter($(".more-content li:nth-child(1)"));
            // Xóa lớp "active" từ tất cả các nút tab
            $(".tab-item").removeClass("active");
            // Thêm lớp "active" cho nút tab được chọn
            $(this).addClass("active");
            contEle.addClass("active");
        });
        $("#factory-sub-tab .sub-tab-item").click(function() {
            // $(".sub-tab-item").removeClass("active");
            $(this).toggleClass("active");
            loadData1();
        });
    });
</script>
<!--load more on click tab-->
<script>
    var a_tab = {};
    a_tab.page = 1;
    a_tab.data = {
        id: 0,
        oem: 0,
        verify: 0
    };

    $('.tab-item').click(function() {
        var h = $(this).data("tab");
        var a_h = h.split('-');
        a_tab.data.id = a_h[1];
        loadData1();
        a_tab.page = 1;
    });

    function loadData1() {
        var subTab = $("#factory-sub-tab .sub-tab-item");
        a_tab.data.oem = subTab.get(1).classList.contains('active') ? 1 : 0;
        a_tab.data.verify = subTab.get(0).classList.contains('active') ? 1 : 0;
        // $("#catId").val(a_tab.data.id);
        $('.tab-content').load('?mod=page&site=load_more_index', a_tab.data);
    }
</script>
<!--scroll load more-->
<script>
    $(document).ready(function() {
        var isLoading = false;
        var page = 2;
        var totalPages = 5; // Tổng số trang

        $(window).on('scroll', function() {
            if (!isLoading && page <= totalPages) {
                if ($(window).scrollTop() + $(window).height() >= $(document).height() - 800) {
                    isLoading = true;
                    // var catId = $("#catId").val();
                    // console.log(a_tab.data);
                    loadMoreContent(a_tab.data);
                }
            }
        });

        function loadMoreContent(data) {
            setTimeout(function() {
                loadPageContent(page, data);
                page++;
                isLoading = false;
                if (page > totalPages) {
                    $('#load-more-button').hide();
                    $('#alert-more-product').html("Bạn đã tải hết sản phẩm");
                }
            }, 1000); // Giả lập thời gian tải dữ liệu
        }

        function loadPageContent(page, _data) {
            let data = Object.assign({}, _data);
            data.page = page;
            console.log(data);
            $.post("?mod=page&site=load_more_index", data).done(function(e) {
                $('.tab-content').append(e);
            });
        }
    });
</script>
<!-- <script>
    var page = 2;
    var stop = 0;
    $(window).scroll(function() {
        if (parseInt($(window).scrollTop()) == parseInt($(document).height() - $(window).height())) {
            LoadMore();
        }
    });

    function LoadMore() {
        console.log(page);
        if (!page || page <= 1) page = 2;
        if (stop == 1) {
            return false;
        }
        data = {};
        data.page = page;
        $.post("?mod=page&site=load_more_index", data).done(function(e) {
            if (e) {
                $('#post-lists').append(e);
                $('#showmore').attr('onclick', 'LoadMore(' + (page + 1) + ');');
            } else {
                $('#showmore').addClass('d-none');
                stop = 1;
            }
            page = page + 1;
        });
    }
</script> -->
<script type="text/javascript ">
    $(window).ready(function() {
        setTimeout(function() {
            $('#page_product_justforyou').load('?mod=product&site=load_just_for_you&limit=10&action=for_page&location=' + arg.id_location);
        }, 600);
        $(".memnumber input[type=checkbox] ").click(function() {
            var arr = [];
            $(".memnumber input[type=checkbox] ").each(function() {
                if ($(this).is(':checked')) {
                    var value = $(this).val();
                    arr.push(value);
                }
            });

            var filter_checkbox = arr.toString();
            var url = set_filter();
            url = (filter_checkbox != '') ? url + "&memnumber=" + filter_checkbox : url;
            location.href = url;
        });

        $(" .revenue input[type=checkbox] ").click(function() {
            var arr = [];
            $(".revenue input[type=checkbox] ").each(function() {
                if ($(this).is(':checked')) {
                    var value = $(this).val();
                    arr.push(value);
                }
            });

            var filter_checkbox = arr.toString();
            var url = set_filter();
            url = (filter_checkbox != '') ? url + "&revenue=" + filter_checkbox : url;
            location.href = url;
        });

        $(" #Province input[type=checkbox] ").click(function() {
            var arr = [];
            $("#Province input[type=checkbox] ").each(function() {
                if ($(this).is(':checked')) {
                    var value = $(this).val();
                    arr.push(value);
                }
            });

            var filter_checkbox = arr.toString();
            var url = set_filter();
            url = (filter_checkbox != '') ? url + "&location=" + filter_checkbox : url;
            location.href = url;
        });
    });

    function filter() {
        var url = set_filter();
        location.href = url;
    }

    function set_filter() {
        var url = $("#filter_url").val();
        var gold = ($('#gold').is(':checked')) ? 1 : 0;
        var verify = ($('#verify').is(':checked')) ? 1 : 0;
        var oem = ($('#oem').is(':checked')) ? 1 : 0;
        var k = $("#key_search").val();

        url = url + "?type=search";
        if (gold == 1) url += '&gold=1';
        if (verify == 1) url += '&verify=1';
        if (oem == 1) url += '&oem=1';
        url = (k != '') ? url + "&k=" + k : url;
        return url;
    }

    function SetPageFavorite(id) {
        if (arg.login == 0) {
            noticeMsg('System Message', 'Vui lòng đăng nhập trước khi thực hiện chức năng này.', 'warning');
            return false;
        }
        var data = {};
        data['id'] = id;
        data['ajax_action'] = 'set_page_favorite';
        loading();
        $.post('?mod=page&site=ajax_handle', data).done(function(e) {
            data = JSON.parse(e);
            if (data.code == 1) {
                $(" #BtnFavorite " + id).remove();
                noticeMsg('System Message', data.msg, 'success');
            } else noticeMsg('System Message', data.msg, 'error');

            endloading();
        });
    }
</script>
{literal}
<script>
    $('.owl-1').owlCarousel({
        loop: true,
        thumbsPrerendered: true,
        items: 1,
        nav: true,
        thumbs: true,
        autoplay: true,
        autoplayTimeout: 5000,
        navText: ["<i class='fa fa-chevron-left'></i >", "<i class ='fa fa-chevron-right'></i >"]
    });
</script>
{/literal}