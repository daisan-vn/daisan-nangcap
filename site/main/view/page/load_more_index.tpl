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
{/foreach} {literal}
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