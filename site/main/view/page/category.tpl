<div class="main-content-wrap">
    <div class="category-slide">
        <div class="owl-carousel owl-category">
            {foreach from=$a_slider item=data}
            <div class="item">
                <a href="{$data.alias}"><img src="{$data.image}" alt="" height="200"></a>
            </div>
            {/foreach}
        </div>
    </div>
    <div class="container container-cate position-100">
        {if !$is_mobile}
        <section class="cate-section">
            <div class="card border-0">
                <div class="card-body">
                    <div class="section-title">
                        <h2 class="title-not-line">Sản phẩm theo danh mục</h2>
                    </div>
                    <div class="swiper-container swiper-cate">
                        <div class="swiper-wrapper">
                            {foreach from=$a_category_all item=v}
                            <div class="swiper-slide">
                                <div class="cate-item is-slider text-center" data-id="{$v.id}">
                                    <a class="cate-item-img-field" href="./supplier/search?k={$v.name}">
                                        <span class="cate-item-img-field-inner">
                                                    <img class="cate-item-img" src="{$v.image}"
                                                     alt="{$v.name}" height="60">
                                                </span>
                                    </a>
                                    <div class="cate-item-body">
                                        <a href="./supplier/search?k={$v.name}" class="cate-item-title text-dark text-twoline">
                                                    {$v.name}</a>
                                    </div>
                                </div>
                            </div>
                            {/foreach}
                        </div>
                        <!-- If we need navigation buttons -->
                        <div class="swiper-button swiper-button-prev"></div>
                        <div class="swiper-button swiper-button-next"></div>
                    </div>
                </div>
            </div>
            <div class="sub-cate" id="sub-cate">
                <nav class="nav">
                </nav>
            </div>
        </section>
        {/if}
        <!--end cate-banner-slide-->
        {if $is_mobile}
        <div class="card border-0 rounded-8 categoty-bottom-slider">
            <div class="card-body">
                <ul class="nav row row-sm">
                    {foreach from=$a_category_all key=k item=data}
                    <li class="col-xl-2 col-3 nav-item text-center {if $k ge 7}d-none d-sm-block{/if}">
                        <a class="nav-link" href="{$data.url}">
                            <img src="{$data.image}" class="img-fluid" alt="{$data.name}">
                            <span></span>
                        </a>
                        <p>{$data.name}</p>
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
        <section class="section-product-rated">
            <div class="section-title">
                <h2 class="title-not-line">Top Sản Phẩm</h2>
            </div>
            <div class="rounded-8 product-rated">
                <div class="row row-nm m-slider-grid-row">
                    {foreach from=$db.product_hot key=k item=v}
                    <div class="col-xl-2 mb-2 m-slider-grid-col">
                        <div class="p-0 p-sm-3 bg-white">
                            <div class="rank-index offericon">{$k+1}</div>
                            <a href="{$v.url}" class="texr-dark"><img src="{$v.avatar}" class="rounded-8 img-fluid">
                                <h3 class="text-twoline title-h3 text-center">{$v.name}</h3>
                            </a>
                        </div>
                    </div>
                    {/foreach}
                </div>
            </div>
        </section>

        <section class="supplier-section">
            <div class="section-title">
                <h2 class="title-not-line">Top nhà cung cấp hàng đầu</h2>
            </div>
            <div class="swiper-container swiper-supplier">
                <div class="swiper-wrapper">
                    {foreach from=$db.page_top item=v}
                    <div class="swiper-slide">
                        <div class="supplier-item is-slider text-center">
                            <a class="supplier-item__img-field" href="{$v.url}">
                                <span class="supplier-item__img-field--inner">
                                                    <img class="supplier-item__img img-fluid" src="https://s.alicdn.com/@img/imgextra/i1/O1CN01I3L7cd1nab9bjvjEo_!!6000000005106-2-tps-784-440.png"
                                                     alt="{$v.name}">
                                                </span>
                            </a>
                            <div class="supplier-item__description">{$v.name}</div>
                            <div class="supplier-item__product">
                                {foreach from=$v.products key=kp item=p}
                                <a href="{$p.url}" class="product__img-field"><img src="{$p.avatar}" class="img-fluid"></a>
                                {/foreach}
                            </div>

                        </div>
                    </div>
                    {/foreach}
                </div>
                <!-- If we need navigation buttons -->
                <div class="swiper-button swiper-button-prev"></div>
                <div class="swiper-button swiper-button-next"></div>
            </div>
        </section>

        <section class="section-product-recommend">
            <div class="section-title">
                <h2 class="title-not-line">Gợi ý cho bạn</h2>
            </div>
            <div>
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
                {/foreach}</div>
            <div class="text-center py-3">
                <div id="load-more-button">Đang tải thêm...</div>
                <p id="alert-more-product" class="text-nm-1 text-muted"></p>
            </div>
        </section>
    </div>
</div>
<div class="filter fcategory d-block d-sm-none">
    <div class="d-flex justify-content-start bd-highlight p-3 border-bottom">
        <div class="bd-highlight">
            <a href=""><img src="{$arg.stylesheet}images/arrow-l.png"></a>
        </div>
        <div class="bd-highlight text-nm-1 text-b pl-2">Xây dựng & bất động sản</div>
        <div class="bd-highlight">&nbsp;</div>
    </div>
    <div class="row row-no">
        <div class="col-4">
            <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                {foreach from=$a_category_all key=k item=data}
                <a class="nav-link {if $k eq 0}active{/if}" id="v-pills-home-tab" data-toggle="pill" href="#vtax{$data.id}" role="tab" aria-controls="v-pills-home" aria-selected="true">{$data.name}</a> {/foreach}
            </div>
        </div>
        <div class="col-8">
            <div class="tab-content" id="v-pills-tabContent">
                {foreach from=$a_category_all key=k item=data}
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
                            <a href="{$sub.url}" class="nav-link text-dark">{$sub.name}</a>
                        </li>
                        {/foreach}
                    </ul>
                </div>
                {/foreach}
            </div>
        </div>
    </div>
</div>
<input type="hidden" value="{$out.id}" id="catId">
<script type="text/javascript">
    $('#collapse_all_category').on('click', function() {
        $(".filter").addClass("active");
        $('.overlay').fadeIn();
    });
</script>

<script>
    $(document).ready(function() {
        $('.cate-item').hover(function() {
            // Hiển thị submenu khi di chuột vào phần tử
            data = {};
            data.id = $(this).data('id');
            $.post("?mod=page&site=load_child_cate", data).done(function(e) {
                $('#sub-cate').html(e);
            });
            $('.sub-cate').addClass('visible');
            $('.overlay').addClass('show');
        }, function() {
            // Ẩn submenu khi di chuột ra khỏi phần tử
            // $('.sub-cate').removeClass('visible');
        });
        $('.overlay').hover(function() {
            $('.overlay').removeClass('show');
            $('.sub-cate').removeClass('visible');
        });
    });
    var Swipes = new Swiper('.swiper-cate', {
        loop: false,
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        breakpoints: {
            // when window width is >= 320px
            320: {
                slidesPerView: 3,
                spaceBetween: 10
            },
            // when window width is >= 480px
            480: {
                slidesPerView: 4,
                spaceBetween: 20
            },
            // when window width is >= 640px
            640: {
                slidesPerView: 8,
                spaceBetween: 15
            }
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
    });
    var Swipes = new Swiper('.swiper-supplier', {
        loop: false,
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        breakpoints: {
            // when window width is >= 320px
            320: {
                slidesPerView: 2,
                spaceBetween: 10
            },
            // when window width is >= 480px
            480: {
                slidesPerView: 3,
                spaceBetween: 20
            },
            // when window width is >= 640px
            640: {
                slidesPerView: 3,
                spaceBetween: 15
            }
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
    });
</script>
<script>
    $(document).ready(function() {
        var isLoading = false;
        var currentPage = 2;
        var totalPages = 5; // Tổng số trang

        // Xử lý sự kiện scroll
        $(window).on('scroll', function() {
            if (!isLoading && currentPage <= totalPages) {
                if ($(window).scrollTop() + $(window).height() >= $(document).height() - 800) {
                    isLoading = true;
                    loadMoreContent();
                }
            }
        });

        // Hàm tải nội dung thêm
        function loadMoreContent() {
            // Simulate loading data from the server
            setTimeout(function() {
                // Gọi hàm để tải nội dung từ trang currentPage
                loadPageContent(currentPage);
                currentPage++;
                isLoading = false;
                if (currentPage > totalPages) {
                    $('#load-more-button').hide();
                    $('#alert-more-product').html("Bạn đã tải hết sản phẩm");
                }
            }, 1000); // Giả lập thời gian tải dữ liệu
        }

        function loadPageContent(page) {
            data = {};
            data.id = $("#catId").val();
            data.page = page;
            console.log(data);
            $.post("?mod=product&site=load_more_product_foryou_bycate", data).done(function(e) {
                $('.product-grid').append(e);
            });
            // Thực hiện mã để tải nội dung từ trang page
            // Ví dụ: Sử dụng AJAX để gửi yêu cầu lên máy chủ và nhận lại dữ liệu
            // Sau đó, bạn có thể thêm dữ liệu vào phần tử hiển thị nội dung
            // Ví dụ: $('#content').append(data);
        }
    });
</script>