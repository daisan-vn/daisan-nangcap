<div class="main-content-wrap">

    <div class="container-fluid container-cate mt-0">

        {include file='../includes/header_shop.tpl'}

        <div class="shop_main">

            <div class="row row-no">

                <div class="col-xl-3">

                    <div class="shop_category-navleft d-none d-sm-block">

                        <h2>Danh mục sản phẩm</h2>

                        <ul class="">

                            {foreach from=$product_category key=k item=v} {if $k lt 6}

                            <li class="nav-item"><a href="{$profile.url}?site=products&cat={$v.id}">{$v.name}</a></li>

                            {/if} {/foreach} {if $k gte 6}

                            <div class="collapse" id="more">

                                {foreach from=$product_category key=k item=v} {if $k gte 6}

                                <li class="nav-item"><a href="{$profile.url}?site=products&cat={$v.id}">{$v.name}</a>

                                </li>

                                {/if} {/foreach}

                            </div>

                            <li><a type="button" class="hmenu-more" data-toggle="collapse" href="#more" role="button" aria-expanded="false">

									Xem tất cả <i class="fa fa-chevron-down"></i>

								</a>

                            </li>

                            {/if}

                        </ul>

                    </div>

                </div>

                <div class="col-xl-9">

                    <div class="shop_category-content">

                        <div class="d-block d-sm-none px-3 pb-3 border-bottom">Sắp xếp: <a data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Chọn lọc</a>

                            <div class="collapse" id="collapseExample">

                                <div class="">

                                    <ul class="nav flex-column">

                                        <li class="nav-item">

                                            <a class="nav-link px-0 active" href="{$out.url}&sort=newest">Hàng mới</a>

                                        </li>

                                        <li class="nav-item">

                                            <a class="nav-link px-0 " href="{$out.url}&sort=discount_desc">Giảm giá

												nhiều</a>

                                        </li>

                                        <li class="nav-item">

                                            <a class="nav-link px-0 " href="{$out.url}&sort=price_asc">Giá thấp</a>

                                        </li>

                                        <li class="nav-item">

                                            <a class="nav-link px-0 " href="{$out.url}&sort=price_desc">Giá cao</a>

                                        </li>

                                    </ul>

                                </div>

                            </div>

                        </div>

                        <h2 class="px-3 d-none d-sm-block">Tất Cả Sản Phẩm: <span>{$out.number} kết quả</span></h2>

                        <div class="shop_main-productfilter p-3 border-top border-bottom">

                            <div class="pr-3">Sắp xếp theo</div>

                            <div class="flex-grow-1 bd-highlight">

                                <ul class="nav nav-pills">

                                    <li class="nav-item">

                                        <a class="nav-link {if !$smarty.get.sort}active{/if}" href="{$out.url}">Chọn

											lọc</a>

                                    </li>

                                    <li class="nav-item">

                                        <a class="nav-link {if $smarty.get.sort eq 'newest'} active {/if}" href="{$out.url}&sort=newest">Hàng mới</a>

                                    </li>

                                    <li class="nav-item">

                                        <a class="nav-link {if $smarty.get.sort eq 'discount_desc'} active {/if}" href="{$out.url}&sort=discount_desc">Giảm giá nhiều</a>

                                    </li>

                                    <li class="nav-item">

                                        <a class="nav-link {if $smarty.get.sort eq 'price_asc'} active {/if}" href="{$out.url}&sort=price_asc">Giá thấp</a>

                                    </li>

                                    <li class="nav-item">

                                        <a class="nav-link {if $smarty.get.sort eq 'price_desc'} active {/if}" href="{$out.url}&sort=price_desc">Giá cao</a>

                                    </li>

                                </ul>

                            </div>

                            <div class="form-group form-check">

                                <input type="checkbox" class="form-check-input" id="exampleCheck1">

                                <label class="form-check-label" for="exampleCheck1">Sản phẩm hỗ trợ giao nhanh

									bởi

									Daisan</label>

                            </div>

                        </div>

                        <div class="row row-nm">

                            {foreach from=$result item=v}

                            <div class="col-xl-3 col-6 mb-3">

                                <div class="shop_main-product-item">

                                    <div class="card border-0 rounded-8">

                                        <div class="p-3">

                                            <div class="list-item-img">

                                                <a href="{$v.url}"><img src="{$v.avatar}" class='img-fluid'></a>

                                            </div>

                                            <div class="list-item-info">

                                                <h3 class="text-nm-1"><a href="{$v.url}" class='text-twoline text-dark'>{$v.name}</a></h3>

                                                {if $v.promo eq 0} {if $v.price eq 'Liên hệ'}

                                                <p>Giá bán: <b>{$v.price_show}</b></p>

                                                {else}

                                                <p class="product-item-price">{$v.price_show}</p>

                                                {/if} {else}

                                                <p class="product-item-price">{$v.price_promo}</p>

                                                <p>

                                                    <span class="price-old">{$v.price_show}</span>

                                                    <span class="price-promo">-{$v.promo}%</span>

                                                </p>

                                                {/if}

                                                <p class="mt-1"><b>{$v.minorder} {$v.unit}</b> (Min Order)</p>

                                            </div>

                                        </div>

                                    </div>

                                </div>

                            </div>

                            {/foreach}



                        </div>

                        <div class="text-center my-3">

                            {if $paging}

                            <hr>

                            <div class="mb-3">{$paging}</div>

                            {/if}

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>