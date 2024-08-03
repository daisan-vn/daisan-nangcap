{if $is_mobile}
<header id="mheader" class="oem d-block d-sm-none">
    <div class="mtophead">
        <div class="d-flex justify-content-between bd-highlight p-4">
            <div class="bd-highlight">
                <a href=""><img src="{$arg.stylesheet}images/arrow-l.png"></a>
            </div>
            <div class="bd-highlight text-lg">Nhà Cung Cấp Hàng Đầu</div>
            <div class="bd-highlight">&nbsp;</div>
        </div>
    </div>

    <div class="head_menu">
        <div class="head_menu_scoll">
            <ul class="nav" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link active tab-item" data-toggle="pill" href="#tax-0">Toàn bộ danh mục</a>
                </li>
                {foreach from=$a_main_category key=k item=data}
                <li class="nav-item " role="presentation">
                    <a class="nav-link tab-item" data-toggle="pill" href="#tax-{$data.id}">{$data.name}</a>
                </li>
                {/foreach}
            </ul>
        </div>
    </div>
</header>
{/if}
<div class="main-content-wrap">
    <div class="toprank-list d-none d-sm-block">
        {foreach from=$banner item = data} {if $data.position eq 6}
        <div class="banner-container" style="background: url('{$data.image}');background-size: 100%;">
        </div>
        {/if} {/foreach}
    </div>
    <div class="recommend-layout toprandking">
        <div class="container-cate">
            <h3>Nhà Cung Cấp Hàng Đầu</h3>
            <p>Tìm nhà cung cấp dựa trên những gì quan trọng nhất đối với bạn</p>
        </div>
    </div>
</div>

<div class="tab-category">
    <div class="container-cate">
        {if !$is_mobile}
        <ul class="nav nav-pills mb-3" id="pills-tab-oem" role="tablist">
            <li class="nav-item" role="presentation">
                <a class="nav-link active tab-item" data-toggle="pill" href="#tax-0">Tất cả danh  mục</a>
            </li>
            {foreach from=$a_main_category key=k item=data}
            <li class="nav-item" role="presentation">
                <a class="nav-link tab-item" data-toggle="pill" href="#tax-{$data.id}">{$data.name}</a>
            </li>
            {/foreach}
        </ul>
        {/if}
        <div class="tab-content" id="pills-tabContent">
            <div class="tab-pane fade show active" id="tax-0">
                <h3 class="tab-content-title">Nhà cung cấp với những khách hàng đặt nhiều hơn 1 đơn hàng trong vòng 90 ngày</h3>

                <div class="card border-0" id="Loaddb-0">
                    {foreach from=$result key=k item=data}
                    <div class="supplier-rank-card">
                        <div class="card-body section-new-products">
                            <div class="row">
                                <div class="col-xl-4">
                                    <div class="d-flex">
                                        {if $k lt 10}
                                        <div class="rank-index-flag">{$k+1}</div>
                                        {/if}
                                        <div class="base-info-right">
                                            <a href="{$data.url}" class="text-dark">{$data.name}</a>
                                            <div class="tag-list">
                                                <i class="fa fa-clock-o col-yearexp"></i>
                                                <span class="join-year"><span class="value">{$data.yearexp}</span><span class="unit">YRS</span></span>
                                                {if $data.package_id ne 0}
                                                <i class="fa fa-gg-circle col-gold"></i>
                                                <span>VIP</span> {/if} {if $data.is_verification ne 0}
                                                <i class="fa fa-check col-verify-1"></i>
                                                <span class="col-verify">Đã xác minh</span> {/if} {if $data.is_oem ne 0}
                                                <i class="fa fa-share-alt col-gold"></i>
                                                <span>OEM</span> {/if}
                                            </div>
                                            <!-- <div class="rank-type-tag mb-2">90% + tỷ lệ đặt hàng lại</div> -->
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-8">
                                    <div class="row d-flex justify-content-center align-items-center ">
                                        <div class="col-xl-4 key-data d-none d-md-block">
                                            <div class="item">
                                                <div class="title">
                                                    Tỉnh thành
                                                </div>
                                                <div class="value">{$data.province}</div>
                                            </div>
                                        </div>
                                        <div class="col-xl-5 product-showcase">
                                            <div class="row row-sm">
                                                {foreach from=$data.metas.products key=k item=v} {if $k lt 3}
                                                <div class="col">
                                                    <a href="{$v.url}" class="overlay-link"></a>
                                                    <div class="new-product-box-img">
                                                        <img src="{$v.avatar}" class="img-fluid zoom-in">
                                                    </div>
                                                </div>
                                                {/if} {/foreach}
                                            </div>
                                        </div>
                                        <div class="col-xl-3 d-none d-md-block">
                                            <div class="contact">
                                                <ul class="nav flex-column">
                                                    <li class="nav-item">
                                                        <a class="text-dark" target="_blank" href="{$data.url}"><img class="icon" src="{$arg.stylesheet}images/TB1P2wrmO_1gK0jSZFqXXcpaXXa-24-24.png" height="12"><span class="pl-2">Đến gian hàng</span></a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="text-dark" target="_blank" href="{$data.url_contact}"><img class="icon" src="{$arg.stylesheet}images/TB1jSAnmFT7gK0jSZFpXXaTkpXa-24-22.png" height="12"><span class="pl-2">Liên hệ nhà cung cấp</span></a>
                                                    </li>
                                                </ul>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--end supplier-rank-card-->
                    {/foreach}
                </div>
            </div>
            {foreach from=$a_main_category key=k item=data}
            <div class="tab-pane fade" id="tax-{$data.id}">
                <h3 class="tab-content-title">Nhà cung cấp với những khách hàng đặt nhiều hơn 1 đơn hàng trong vòng 90 ngày</h3>
                <div class="card border-0" id="Loaddb-{$data.id}"></div>
            </div>
            {/foreach}
        </div>
    </div>
</div>
</div>
<script>
    $('.nav-pills').scrollingTabs({
        scrollToTabEdge: true,
        cssClassLeftArrow: 'fa fa-angle-left',
        cssClassRightArrow: 'fa fa-angle-right',
        disableScrollArrowsOnFullyScrolled: true,
        handleDelayedScrollbar: true,
        forceActiveTab: true
    });

    var a_tab = {};
    a_tab.page = 1;
    a_tab.id = 0;
    $('.tab-item').click(function() {
        var h = $(this).attr('href');
        var a_h = h.split('-');
        var data = {};
        data.id = a_h[1];
        console.log(data.id);
        $('#Loaddb-' + a_h[1]).load('?mod=page&site=load_more_toprank', data);
        a_tab.id = a_h[1];
        $(window).scrollTop(0);
        a_tab.page = 1;
    });

    $(window).scroll(function() {
        var h = $(document).height() - $(window).height() - $('footer').height();
        if ($(window).scrollTop() >= h) {
            a_tab.page = a_tab.page + 1;
            if (a_tab.page < 11) {
                $.post('?mod=page&site=load_more_toprank', a_tab, function(data) {
                    $('#Loaddb-' + a_tab.id).append(data);
                    //console.log(a_tab);
                });
            }
        }
    });
</script>