<div class="main-content-wrap">
    <div class="container-fluid">
        <div class="row row-nm">
            <div class="col-xl-3 d-none d-sm-block">
                <div class=" card border-0 rounded-8 menu-category-nav">
                    <h3 class="text-lg px-3 pt-3">CATEGORIES</h3>
                    <ul class="pb-3">
                        {foreach from=$a_category_all key=k item=data} {if $k lt 10}
                        <li class="nav-item mega-menu-has-child">
                            <a href="{$data.url}" class="nav-link">
								{$data.name}<span class="pull-right cate-banner-chevron"><i
										class="fa fa-chevron-right"></i></span>
							</a>
                            <div class="mega-menu-dropdown mega-menu-category card border-0">
                                <ul class="nav flex-column rounded-8">
                                    {foreach from=$data.sub item=sub}
                                    <li class="nav-item"><a class="nav-link" href="{$sub.url}">{$sub.name}</a></li>
                                    {/foreach}
                                </ul>
                            </div>
                        </li>
                        {/if} {/foreach}
                    </ul>
                </div>
            </div>
            <div class="col-xl-9">
                <div class="category-slide">
                    <div class="owl-carousel owl-category">
                        {foreach from=$a_slider item=data}
                        <div class="item">
                            <a href="{$data.alias}"><img data-src="{$data.image}" alt="" class="rounded-8" loading="lazy"></a>
                        </div>
                        {/foreach}
                    </div>
                </div>
                <!--end cate-banner-slide-->
                <div class="card border-0 rounded-8 categoty-bottom-slider">
                    <div class="card-body">
                        <ul class="nav row row-sm">
                            {foreach from=$a_category_hot key=k item=data}
                            <li class="col-xl-2 col-3 nav-item text-center {if $k ge 7}d-none d-sm-block{/if}">
                                <a class="nav-link" href="{$data.url}">
                                    <img src="{$arg.stylesheet}images/loading.gif" data-src="{$data.image}" class="img-fluid" loading="lazy" alt="{$data.name}">
                                    <span></span>
                                </a>
                                <p>{$data.name}</p>
                            </li>
                            {/foreach}
                            <li class="col-xl-2 col-3 nav-item text-center d-block d-sm-none">
                                <a class="nav-link" href="javascript:void(0)" id="collapse_all_category">
                                    <img data-src="{$arg.stylesheet}images/H0e9c53982dc7407f9abc86bb5b2145bf4.webp" class="img-fluid">
                                </a>
                                <p>Tất cả</p>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <!--end row-->
        {if !$is_mobile}
        <section class="mt-3">
            <!-- Daisan Ads - Ad Display Code -->
            <div id="adm-container-8"></div>
            <script data-cfasync="false" type="text/javascript" async src="//daisanads.com/display/items.php?8&2&728&90&4&0&0"></script>
            <!-- Daisan Ads - Ad Display Code  -->
        </section>
        {/if}
        <section class="section-product-rated">
            <div class="section-title">
                <h2 class="title-not-line">Top Sản Phẩm</h2>
            </div>
            <div class="rounded-8 product-rated">
                <div class="row row-nm">
                    {foreach from=$db.product_hot key=k item=v}
                    <div class="col-xl-2 col-sm-3 col-6 mb-2">
                        <div class="rank-index offericon">{$k+1}</div>
                        <a href="{$v.url}" class="texr-dark"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" class="rounded-8 img-fluid" loading="lazy" alt="{$v.name}">
                            <h3 class="line-2 title-h3">{$v.name}</h3>
                        </a>
                    </div>
                    {/foreach}
                </div>
            </div>
        </section>

        <section class="">
            <div class="section-title">
                <h2 class="title-not-line">Top nhà cung cấp hàng đầu</h2>
            </div>
            <div class="row row-nm">
                {foreach from=$db.page_top item=v}
                <div class="col-xl-3">
                    <div class="card rounded-8 border-0 new-product-box">
                        <div class="d-flex bd-highlight pb-2 px-sm-3 pt-2">
                            <div class="media">
                                <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.logo}" class="mr-3" alt="{$v.name}" width="40" loading="lazy" alt="{$v.name}">
                                <div class="media-body">
                                    <h3 class="mt-0 text-oneline text-nm"><a href="{$v.url}" class="text-dark">{$v.name}</a></h3>
                                    <div class="yrs">
                                        <span class="number">{$v.yearexp}</span> YRS
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row row-sm px-sm-3 pb-sm-3 px-0">
                            {foreach from=$v.products key=kp item=p}
                            <div class="col-xl-6 col-md-6 col-6 ">
                                <div class="item text-center">
                                    <a href="{$p.url}" class="overlay-link"></a>
                                    <div class="new-product-box-img">
                                        <img class="img-fluid" src="{$arg.stylesheet}images/loading.gif" data-src="{$p.avatar}" loading="lazy" alt="{$p.name}">
                                    </div>
                                    <p class="price price-m mb-0">
                                        <span class="price_old text-b">{$p.price}</span>
                                    </p>
                                    <p></p>
                                    <p class="line-1">{$p.name}</p>
                                </div>
                            </div>
                            {/foreach}
                        </div>
                        <!-- end row -->
                    </div>
                </div>
                <!--end col-xl-3-->
                {/foreach}
            </div>
        </section>
        {if count($db.product_promo) gt 2}
        <section class="section-weeklydeals d-none d-sm-block">
            <div class="section-title">
                <h2 class="title-not-line">Sản phẩm khuyến mại trong tuần</h2>
            </div>
            <div class="row row-no weeklydeals-wrapper">
                <div class="col-xl-4 left">
                    <img src="{$arg.stylesheet}images/TB1nvKOvxD1gK0jSZFyXXciOVXa-400-260.webp" class="img-fluid">
                    <div class="text-wrapper">
                        <h3>Khuyến mãi trong tuần</h3>
                        <p class="mb-3">Ưu đãi hàng tuần giảm giá từ 10%</p>
                        <a href="./product/promotions?categoryId={$out.id}" class="btn btn-primary rounded-pill">Xem
							thêm</a>
                    </div>
                </div>
                <div class="col-xl-8">
                    <div class="card-group">
                        {foreach from=$db.product_promo key=k item=v}
                        <div class="card card-product-item">
                            <div class="card-body">
                                <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" class="card-img-top" alt="{$v.name}" loading="lazy" alt="{$v.name}"></a>
                                <div class="list-item-info">
                                    <h3 class="text-nm-1">
                                        <a href="{$v.url}" class="text-oneline text-dark">{$v.name}</a>
                                    </h3>
                                    <div class="product-item-price text-oneline">
                                        {$v.price} {$v.pricemax}{if $v.pricemax ne null}<span class="unit"> /
											{$v.unit}</span>{/if}
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                </div>
            </div>
        </section>
        <!--end section-weeklydeals-->
        {/if}
        <section class="section-category-new d-none d-sm-block">
            <div class="section-title">
                <h2 class="title-not-line">Sản phẩm mới đăng</h2>
            </div>
            <div class="row row-no weeklydeals-wrapper">
                <div class="col-xl-4 left">
                    <img src="{$arg.stylesheet}images/loading.gif" data-src="{$arg.stylesheet}images/TB1HOiIvuT2gK0jSZFvXXXnFXXa-400-260.png_400x400.webp" class="img-fluid" loading="lazy">
                    <div class="text-wrapper">
                        <h3>Sản phẩm mới</h3>
                        <p class="mb-3">Tổng hợp sản phẩm mới cập nhật</p>
                        <a href="./product/new?categoryId={$out.id}" class="btn btn-primary rounded-pill">Xem thêm</a>
                    </div>
                </div>
                <div class="col-xl-8">
                    <div class="card-group">
                        {foreach from=$db.product_new key=k item=v}
                        <div class="card card-product-item">
                            <div class="card-body">
                                <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" class="card-img-top" alt="{$v.name}" loading="lazy"></a>
                                <div class="list-item-info">
                                    <h3 class="text-nm-1">
                                        <a href="{$v.url}" class="text-oneline text-dark">{$v.name}</a>
                                    </h3>
                                    <div class="product-item-price text-oneline">
                                        {$v.price} {$v.pricemax}{if $v.pricemax ne null}<span class="unit"> /
											{$v.unit}</span>{/if}
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                </div>
            </div>
        </section>
        <!--end section-category-new-->
        <section class="">
            <div class="section-title">
                <h2 class="title-not-line">Nhà máy gia công theo yêu cầu</h2>
            </div>
            <div class="row row-nm">
                {foreach from=$db.page_oem item=v}
                <div class="col-xl-4">
                    <div class="card rounded-8 border-0 new-product-box">
                        <div class="d-flex bd-highlight pb-2 px-sm-3 pt-2">
                            <div class="media">
                                <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.logo}" class="mr-3" alt="{$v.name}" width="40" loading="lazy">
                                <div class="media-body">
                                    <h3 class="mt-0 text-oneline text-nm"><a href="{$v.url}" class="text-dark">{$v.name}</a></h3>
                                    <div class="yrs">
                                        <span class="number">{$v.yearexp|default:1}</span>YRS
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row row-sm px-sm-3 pb-sm-3 px-0">
                            <div class="col-xl-9 col-md-6">
                                <div class="video-poster">
                                    <a href="{$v.products[0]['url']}"><img class="video-poster-img" data-src="{$v.products[0]['avatar']}" loading="lazy"></a>
                                    <!--<img class="video-icon"
										src="https://s.alicdn.com/@img/tfs/TB1ewXwsrj1gK0jSZFuXXcrHpXa-82-82.png">-->
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="product-list">
                                    {foreach from=$v.products key=kp item=p} {if $kp gt 0}
                                    <div class="item text-center mb-3">
                                        <a href="{$p.url}" class="overlay-link">
                                            <img class="img-fluid" src="{$arg.stylesheet}images/loading.gif" data-src="{$p.avatar}" loading="lazy">
                                        </a>
                                    </div>
                                    {/if} {/foreach}
                                </div>
                            </div>

                        </div>
                        <!-- end row -->
                    </div>
                </div>
                <!--end col-xl-4-->
                {/foreach}
            </div>
        </section>
        <section class="section-product-recommend">
            <div class="section-title">
                <h2 class="title-not-line">Sản phẩm gợi ý cho bạn</h2>
            </div>
            <div class="row row-nm">
                {foreach from=$db.product_foryou key=k item=v}
                <div class="col-xl-5th col-sm-5th ">
                    <div class="card border-0 rounded-8 mb-3">
                        <div class="product-list-recommend">
                            <div class="list-item-img">
                                <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" class="img-fluid" loading="lazy"></a>
                            </div>
                            <div class="list-item-info">
                                <h3 class="text-nm-1">
                                    <a href="{$v.url}" class="text-twoline text-dark">{$v.name}</a>
                                </h3>
                                <div class="product-item-price text-oneline">
                                    {$v.price} {$v.pricemax}<span class="unit"> / {$v.unit} </span>
                                </div>
                                <p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>
                            </div>
                        </div>
                    </div>
                </div>
                {/foreach}

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
<script type="text/javascript">
    $('#collapse_all_category').on('click', function() {
        $(".filter").addClass("active");
        $('.overlay').fadeIn();
    });
</script>