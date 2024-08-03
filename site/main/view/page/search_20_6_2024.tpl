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

<div class="main-content-wrap">
    <div class="container-fluid">
        <div class="p-sm-3">
            <div class="filter_tab">
                <nav class="nav">
                    <a class="nav-link {if !isset($smarty.get.type)} active {/if}" href="./supplier">Tất cả nhà cung cấp</a>
                    <a class="nav-link {if $filter.verify}active{/if}" href="javascript:void(0)"><input type="checkbox" id="verify" {if $filter.verify}checked{/if} onchange="filter()">&nbsp;Nhà cung cấp đã được xác minh</a>
                    <a class="nav-link {if $filter.oem}active{/if}" href="javascript:void(0)"><input type="checkbox" id="oem" {if $filter.oem}checked{/if} onchange="filter()">&nbsp;Đơn vị gia công (OEM)</a>
                </nav>
            </div>
            <div class="row row-nm">
                <div class="col-xl-2">
                    <div class="card filter border-0">
                        <div class="card-body">
                            <div class="left-filters__filter-wrapper">
                                <h3>Danh mục sản phẩm</h3>
                                <ul class="nav flex-column collapse" id="collapseFilter" aria-expanded="false">
                                    {foreach from=$a_main_category key=k item=v}
                                    <li><a href="{$arg.domain}supplier/search?k={$smarty.get.k}&cat={$v.id}">{$v.name}</a></li>
                                    {/foreach}
                                </ul>
                                <a role="button" class="collapsed" data-toggle="collapse" href="#collapseFilter" aria-expanded="false" aria-controls="collapseExample"></a>
                                <h3 class="mt-3">Tỉnh/Thành phố</h3>
                                <div class="filter_location" id="Province">
                                    <ul class="nav flex-column">
                                        {foreach from=$tax.province key=k item=v}
                                        <li class="nav-item">
                                            <input class="form-input" type="checkbox" value="{$v.Id}" {if in_array($v.Id,$filter.a_province)}checked{/if}> {$v.Name}
                                        </li>
                                        {/foreach}
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-10">
                    {foreach from=$result item=data}
                    <div class="supplier-item-info bg-white rounded-lg mb-3">
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
                    {/foreach} {if $paging}
                    <div class="filter__search-pagination mb-3">
                        <div class="card card-body border-0">
                            {$paging}
                        </div>
                    </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</div>
<!--end main-content-->

<input type="hidden" value="{$out.url}" id="filter_url">

<script>
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
</script>
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