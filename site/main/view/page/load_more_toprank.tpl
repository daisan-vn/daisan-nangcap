{foreach from=$result key=k item=data}
<div class="supplier-rank-card">
    <div class="card-body">
        <div class="row">
            <div class="col-xl-4">
                <div class="d-flex">
                    {if $k lt 10 AND $out.page eq 1}
                    <div class="rank-index-flag">{$k+1}</div>
                    {/if}
                    <div class="base-info-right">
                        <a href="{$data.url}" class="text-dark">{$data.name}</a>
                        <div class="tag-list">
                            <i class="fa fa-clock-o col-yearexp"></i>
                            <span class="join-year"><span class="value">
										{$data.yearexp}
									</span><span class="unit">
										YRS
									</span></span>
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
{/foreach}