<div class="main-content-wrap">
    <!--
    <div class="search__header text-center">
        <h1 class="search__header__title">Kết quả cho: {$out.key|default:''}</h1>
    </div>
    <div class="search__suggestions">
        {foreach from=$out.a_keyword key=k item=v}
        <a href="{$v.url}" class="image-tag" onclick="setViewKey({$v.id});">
            <div class="image-tag__img" style="background: url('{$v.image}');">
            </div>
            {$v.name}
        </a>
        {/foreach}

    </div>
-->
    <!-- <div class="ads-product my-3 swiper-container swiper-adsproduct">
        <div class="swiper-wrapper">
            {foreach from=$ads item=v}
            <div class="swiper-slide">
                <div class="item card rounded-0">
                    <div class="adsproduct-list">
                        <div class="list-item-img">
                            <a href="{$v.url}?{$v.url_ads}" target="_blank"><img src="{$v.avatar}" class="rounded-8 img-fluid"></a>
                        </div>
                        <div class="list-item-info">
                            <div class="post-item__title">
                                <h3 class="text-nm"><a href="{$v.url}?{$v.url_ads}" class="text-twoline" target="_blank">{$v.name}</a></h3>
                            </div>
                            <div class="product-item-price text-oneline text-b">
                                {$v.price}
                            </div>
                            <p class="pt-1 mb-0"><a href="{$v.url_page}?{$v.url_ads}" class="text-twoline text-dark" title="{$v.metas.page}">{$v.metas.page}</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            {/foreach}
        </div>
    </div> -->
    <div class="container-fluid">
        <div class="banner mb-3">
            {foreach from=$banner item = data} {if $data.position eq 7}
            <img data-src="{$data.image}" class="w-100" loading="lazy"> {/if} {/foreach}
        </div>

        {if $ads}
        <div class="card card-body border-0 mb-3">

            <div class="owl-carousel owl-theme owl-adsproduct">
                {foreach from=$ads key=k item=v}
                <div class="item card rounded-8">
                    <div class="product-list-recommend">
                        <div class="list-item-img">
                            <a href="{$v.url}?{$v.url_ads}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" class="img-fluid" loading="lazy" alt="{$v.name}"></a>
                        </div>
                        <div class="list-item-info">
                            <h3 class="text-nm-1"><a href="{$v.url}?{$v.url_ads}" class="text-twoline text-dark">{$v.name}</a></h3>
                            <div class="product-item-price text-oneline">
                                {$v.price}
                            </div>
                            <p class="pt-1 mb-0"><a href="{$v.url_page}?{$v.url_ads}" class="text-oneline" title="{$v.metas.page}">{$v.metas.page}</a>
                            </p>
                        </div>
                    </div>
                    <span class="ads_product_label">Đề xuất</span>
                </div>
                {/foreach} {if $out.isads neq 1 && count($ads) gt 20}
                <div class="d-flex justify-content-center flex-column text-center view-all-productads">
                    <a href="{$out.link_ads}" class="shadow-sm p-3 bg-white rounded-circle icon-view-all"><i
                            class="fa fa-long-arrow-right" aria-hidden="true"></i></a>
                    <a href="{$out.link_ads}" class="mt-2">Xem tất cả</a>
                </div>
                {/if}
            </div>
        </div>
        {/if}
        <div class="row row-nm">
            <div class="col-xl-2">
                <div class="card filter border-0">
                    <div class="card-body">
                        {if count($out.a_category) gt 0}
                        <div class="left-filters__filter-wrapper">
                            <h3>Danh mục</h3>
                            <ul class="nav flex-column">
                                {foreach from=$out.a_category item=v}
                                <li><a href="{$v.url}">{$v.name}</a></li>
                                {/foreach}
                            </ul>
                        </div>
                        {/if}
                        <div class="left-filters__filter-wrapper my-3">
                            <h3>Loại nhà cung cấp</h3>
                            <ul class="nav flex-column">
                                {foreach from=$out.a_supplier_type key=k item=v}
                                <li>
                                    <a href="{$v.url}">
                                        <i class="fa {if $v.active}fa-check-square-o{else}fa-square-o{/if} fa-fw text-lg"></i> {$v.title}
                                    </a>
                                </li>
                                {/foreach}
                            </ul>
                        </div>
                        <div class="left-filters__filter-wrapper my-3">
                            <h3>Loại sản phẩm</h3>
                            <ul class="nav flex-column">
                                {foreach from=$out.a_product_type key=k item=v}
                                <li>
                                    <a href="{$v.url}">
                                        <i class="fa {if $v.active}fa-check-square-o{else}fa-square-o{/if} fa-fw text-lg"></i> {$v.title}
                                    </a>
                                </li>
                                {/foreach}
                            </ul>
                        </div>
                        <div class="left-filters__filter-wrapper my-3">
                            <h3>Min. Order</h3>
                            <div class="input-group mb-3">
                                <input type="text" class="form-control rounded" id="filter_minorder" placeholder="Less than" value="{$filter.minorder}">
                                <div class="ml-2">
                                    <button type="button" onclick="filter();" class="btn btn-sm rounded-pill px-4">OK</button>
                                </div>
                            </div>
                        </div>
                        <div class="left-filters__filter-wrapper my-3">
                            <h3>Mức giá</h3>
                            <div class="input-group mb-3">
                                <input type="text" class="form-control rounded" id="filter_minprice" placeholder="Min" value="{$filter.minprice}">
                                <span class="mx-2">-</span>
                                <input type="text" class="form-control rounded" id="filter_maxprice" placeholder="Max" value="{$filter.maxprice}">
                                <div class="ml-2">
                                    <button type="button" onclick="filter();" class="btn btn-sm rounded-pill px-4">OK</button>
                                </div>
                            </div>
                        </div>
                        <div class="left-filters__filter-wrapper my-3">
                            <div class="panel panel-default">
                                <div class="panel-heading" role="tab" id="heading1">
                                    <h3 class="panel-title">
                                        <a class="collapsed" role="button" data-toggle="collapse" href="#collapse1">
                                            <i class="more-less fa fa-angle-up pull-right"></i> Địa điểm
                                        </a>
                                    </h3>
                                </div>
                                <div id="collapse1" class="panel-collapse collapse in show" role="tabpanel" aria-labelledby="heading1">
                                    <div class="panel-body">
                                        <div class="input-group mb-3">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text bg-transparent" id="basic-addon1"><i
                                                        class="fa fa-search"></i></span>
                                            </div>
                                            <input type="text" class="form-control" placeholder="search">
                                        </div>
                                        <div class="country-region__groups">
                                            <ul class="left-sidebar-ul">
                                                {foreach from=$out.a_location item=v}
                                                <li>
                                                    <a href="{$v.url}">
                                                        <i class="fa {if in_array($v.Id,$filter.a_location)}fa-check-square-o{else}fa-square-o{/if} text-lg" aria-hidden="true"></i> {$v.Name}
                                                    </a>
                                                </li>
                                                <li>
                                                    {/foreach}
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--end left-filters-->
                    </div>
                </div>
            </div>
            <div class="col-xl-10 overflow-hidden">
                <div class="page-keyword-block ">
                    <div class="card card-body border-0 rounded-0">
                        <div class="block-body overflow-hidden">
                            <!-- Swiper -->
                            <div class="swiper-container swiper-keyword">
                                <div class="swiper-wrapper">
                                    {foreach from=$out.a_keyword item=v}
                                    <div class="swiper-slide">
                                        <div class="item-col swiper-item-keyword">
                                            <!-- <div class="image-tag__img">
                                                <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.image}" class="img-fluid rounded-circle" alt=" {$v.name}" loading="lazy"></a>
                                            </div> -->
                                            <a href="{$v.url}" class="image-tag__text">
                                                {$v.name}
                                            </a>
                                        </div>
                                    </div>
                                    {/foreach}
                                </div>
                                <div class="swiper-button-next"></div>
                                <div class="swiper-button-prev"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="d-flex pl-3 py-3 pr-0 refine-filters__result-section">
                    <div class=" flex-grow-1 align-self-center refine-filters__result-left">
                        <!-- <b>{$out.number|default:0}</b> kết quả cho "{$out.key|default:''}" 
						<b>Danh sách sản phẩm cho từ khóa "{$out.key|default:''}"</b>-->
                    </div>
                    <div class="refine-filters__result-right">
                        <ul class="nav">
                            <li class="nav-item nav-link d-none d-sm-block"><b>Sắp xếp theo:</b></li>
                            <li class="nav-item nav-link ischild d-none d-sm-block">Độ phù hợp <i class="fa fa-angle-down"></i>
                                <ul class="nav">
                                    <li class="nav-item"><a href="{$out.url}" class="nav-link text-dark">Độ phù hợp</a>
                                    </li>
                                    <li class="nav-item"><a href="{$out.url}&sort=price" class="nav-link text-dark">Giá
                                            bán tốt</a></li>
                                </ul>
                            </li>
                            <li class="nav-item"><a href="./product?k={$smarty.get.k}&t=0&type=grid" class="nav-link text-dark "><i class="fa fa-th-large" aria-hidden="true"></i></a>
                            </li>
                            <li class="nav-item"><a href="./product?k={$smarty.get.k}&t=0&type=list" class="nav-link text-dark active"><i class="fa fa-list-ul"
                                        aria-hidden="true"></i></a></li>
                            <li class="nav-item nav-link d-block d-sm-none" id="collapse_filter"><i class="fa fa-sort-amount-desc fa-fw" aria-hidden="true"></i> Lọc</li>
                        </ul>
                    </div>
                    <div class="refine-filters__result-right"></div>
                </div>
                <div class="search-result__content view-list">
                
                {if $out.isads neq 1 AND false}
                    <div class="row row-nm product-top">
                        {foreach from=$top key=k item=v}
                        <div class="col-xl-4 col-lg-4 col-md-4">
                            <div class="card card-body border-1 mb-3 product-top__item">
                                <div class="item-result__content">
                                    <div class="media">
                                        <span class="product-top__number">{$k+1}</span>
                                        <div class="item-img">
                                            {if count($v.a_img) gt 1}
                                            <div class="owl-carousel owl__product-search">
                                                {foreach from=$v.a_img item=img}
                                                <div class="item">
                                                    <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$img}" class="img-fluid zoom-in" loading="lazy" alt=" {$v.name}"></a>
                                                </div>
                                                {/foreach}
                                            </div>
                                            {else}
                                            <div class="item">
                                                <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.a_img[0]}" class="img-fluid zoom-in" loading="lazy"></a>
                                            </div>
                                            {/if}
                                        </div>
                                        <div class="media-body ml-4">
                                            <div class="search-item-info">
                                                <h3 class="text-nm-2"><a href="{$v.url}" class="text-dark">{$v.name}</a>
                                                </h3>
                                                <div class="product-item-price mt-3">
                                                    {if $v.promo neq 0}
                                                    <div class="price-sale">
                                                        {$v.price_promo}
                                                    </div>
                                                    {/if}
                                                    <div class="{if $v.promo neq 0}price-promotion{/if}">
                                                        {if $v.price eq 'Liên hệ'}
                                                        <span>Giá bán:</span> {/if} {$v.price} {if $v.price ne 'Liên hệ'} {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                {/if}

                    <div class="row row-sm">
                        <div class="col-md-9">
                             {foreach from=$top key=k item=v}
                            <div class="card card-body border-0 rounded-0 mb-sm-3 mx-sm-2">
                                <div class="item-result__content">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="media">
                                                <div class="item-img">
                                                    {if count($v.a_img) gt 1}
                                                    <div class="owl-carousel owl__product-search">
                                                        {foreach from=$v.a_img item=img}
                                                        <div class="item">
                                                            <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$img}" class="img-fluid zoom-in" loading="lazy" alt="{$v.name}"></a>
                                                        </div>
                                                        {/foreach}
                                                    </div>
                                                    {else}
                                                    <div class="item">
                                                        <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.a_img[0]}" class="img-fluid zoom-in" loading="lazy" alt="{$v.name}"></a>
                                                    </div>
                                                    {/if}
                                                </div>
                                                <div class="media-body ml-4">
                                                    <div class="search-item-info">
                                                        <h3 class="text-nm-2"><a href="{$v.url}" class="text-dark">{$v.name}</a>
                                                        </h3>
                                                        <div class="product-item-price text-oneline mt-3">
                                                            {if $v.price eq 'Liên hệ'}
                                                            <span>Giá bán:</span> {/if} {$v.price} {if $v.price ne 'Liên hệ'}
                                                            <span class="unit">/ {$v.metas.unit}</span> {/if}
                                                        </div>
                                                        <div class="py-2 d-none d-sm-block">
                                                            <ul class="m-0 p-0">
                                                                {foreach from=$v.specs key=k item=v} {if $k lt 5}
                                                                <li>{$v.name}: {$v.value}</li>
                                                                {/if} {/foreach}
                                                            </ul>
                                                        </div>
                                                        <a href="{$v.url}" class="d-none d-sm-block">Xem chi tiết...</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="seller-info d-none d-sm-block">
                                                <div class="media mb-2">
                                                    <div class="media-body">
                                                        <h3 class="mt-0 text-oneline seller-intro-title">
                                                            <a href="{$v.url_page}" title="{$v.metas.page}">{$v.metas.page}<i
                                                                    class="fa fa-angle-right"
                                                                    aria-hidden="true"></i></a>
                                                        </h3>
                                                        <span class="yrs mr-2">
                                                            <b
                                                                class="number">{$v.metas.page_year|default:1}</b><small>YRS</small>
                                                        </span> {if $v.metas.page_fee gt 0}
                                                        <i class="fa fa-gg-circle col-gold"></i> {/if} {if $v.metas.page_verify}
                                                        <i class="fa fa-check col-verify-1"></i>
                                                        <span class="col-verify">Đã xác minh</span> {/if}
                                                    </div>
                                                </div>
                                                <div class="d-flex align-items-center mt-3">
                                                    <div class=""><a href="{$v.url_rfq}" class="btn btn-contact rounded-pill">Liên
                                                            hệ nhà cung cấp</a>
                                                    </div>
                                                    <div class="px-2 d-none d-sm-block">
                                                        <a href="{$v.url_addcart}"><i class="fa fa-plus"></i> Đặt
                                                            hàng</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    <!--
									<div class="d-none d-sm-block">
										<div class="row mt-3">
											{foreach from=$v.page_metas key=k item=v}
											<div class="col">
												<div class="media">
													<img src="{$v.avatar}" class="mr-3 border" alt="{$v.name}" width="75">
													<div class="media-body">
														<h5 class="mt-0 text-sm-1">{$v.name}</h5>
														<p><a href="{$v.url}">Xem chi tiết ></a></p>
													</div>
												</div>
											</div>
											{/foreach}
										</div>
									</div>-->
                                </div>
                            </div>
                            {/foreach} 

                            {foreach from=$result key=k item=v}
                            <div class="card card-body border-0 rounded-0 mb-sm-3 mx-sm-2">
                                <div class="item-result__content">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="media">
                                                <div class="item-img">
                                                    {if count($v.a_img) gt 1}
                                                    <div class="owl-carousel owl__product-search">
                                                        {foreach from=$v.a_img item=img}
                                                        <div class="item">
                                                            <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$img}" class="img-fluid zoom-in" loading="lazy" alt="{$v.name}"></a>
                                                        </div>
                                                        {/foreach}
                                                    </div>
                                                    {else}
                                                    <div class="item">
                                                        <a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.a_img[0]}" class="img-fluid zoom-in" loading="lazy" alt="{$v.name}"></a>
                                                    </div>
                                                    {/if}
                                                </div>
                                                <div class="media-body ml-4">
                                                    <div class="search-item-info">
                                                        <h3 class="text-nm-2"><a href="{$v.url}" class="text-dark">{$v.name}</a>
                                                        </h3>
                                                        <div class="product-item-price text-oneline mt-3">
                                                            {if $v.price eq 'Liên hệ'}
                                                            <span>Giá bán:</span> {/if} {$v.price} {if $v.price ne 'Liên hệ'}
                                                            <span class="unit">/ {$v.metas.unit}</span> {/if}
                                                        </div>
                                                        <div class="py-2 d-none d-sm-block">
                                                            <ul class="m-0 p-0">
                                                                {foreach from=$v.specs key=k item=v} {if $k lt 5}
                                                                <li>{$v.name}: {$v.value}</li>
                                                                {/if} {/foreach}
                                                            </ul>
                                                        </div>
                                                        <a href="{$v.url}" class="d-none d-sm-block">Xem chi tiết...</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="seller-info d-none d-sm-block">
                                                <div class="media mb-2">
                                                    <div class="media-body">
                                                        <h3 class="mt-0 text-oneline seller-intro-title">
                                                            <a href="{$v.url_page}" title="{$v.metas.page}">{$v.metas.page}<i
                                                                    class="fa fa-angle-right"
                                                                    aria-hidden="true"></i></a>
                                                        </h3>
                                                        <span class="yrs mr-2">
                                                            <b
                                                                class="number">{$v.metas.page_year|default:1}</b><small>YRS</small>
                                                        </span> {if $v.metas.page_fee gt 0}
                                                        <i class="fa fa-gg-circle col-gold"></i> {/if} {if $v.metas.page_verify}
                                                        <i class="fa fa-check col-verify-1"></i>
                                                        <span class="col-verify">Đã xác minh</span> {/if}
                                                    </div>
                                                </div>
                                                <div class="d-flex align-items-center mt-3">
                                                    <div class=""><a href="{$v.url_rfq}" class="btn btn-contact rounded-pill">Liên
                                                            hệ nhà cung cấp</a>
                                                    </div>
                                                    {if $v.internal_sale}
                                                    <div class="px-2 d-none d-sm-block">
                                                        <a href="{$v.url_addcart}"><i class="fa fa-plus"></i> Đặt
                                                            hàng</a>
                                                    </div>
                                                    {/if}
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    <!--
									<div class="d-none d-sm-block">
										<div class="row mt-3">
											{foreach from=$v.page_metas key=k item=v}
											<div class="col">
												<div class="media">
													<img src="{$v.avatar}" class="mr-3 border" alt="{$v.name}" width="75">
													<div class="media-body">
														<h5 class="mt-0 text-sm-1">{$v.name}</h5>
														<p><a href="{$v.url}">Xem chi tiết ></a></p>
													</div>
												</div>
											</div>
											{/foreach}
										</div>
									</div>-->
                                </div>
                            </div>
                            {/foreach} 
                            {if $ads}
                            <div class="filter__search-ads mb-3">
                                <div class="card card-body border-0">
                                    <div class="owl-carousel owl-theme owl-adsproduct-bottom">
                                        {foreach from=$ads key=k item=v}
                                        <div class="item card rounded-8">
                                            <div class="product-list-recommend">
                                                <div class="list-item-img">
                                                    <a href="{$v.url}?{$v.url_ads}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" class="img-fluid" loading="lazy" alt="{$v.name}"></a>
                                                </div>
                                                <div class="list-item-info">
                                                    <h3 class="text-nm-1"><a href="{$v.url}?{$v.url_ads}" class="text-twoline text-dark">{$v.name}</a></h3>
                                                    <div class="product-item-price text-oneline">
                                                        {$v.price}
                                                    </div>
                                                    <p class="pt-1 mb-0"><a href="{$v.url_page}?{$v.url_ads}" class="text-twoline" title="{$v.metas.page}">{$v.metas.page}</a>
                                                    </p>

                                                </div>
                                            </div>
                                        </div>
                                        {/foreach}
                                    </div>
                                </div>
                            </div>
                            {/if}
                        </div>
                        <div class="col-md-3">
                            <div class="d-none d-sm-block">
                                <!-- Daisan Ads - Ad Display Code -->
                                <div id="adm-container-25"></div>
                                <script data-cfasync="false" async type="text/javascript" src="//daisanads.com/display/items.php?25&2&300&600&4&0&0"></script>
                                <!-- Daisan Ads - Ad Display Code -->
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>


        <div class="filter__search-pagination mb-3">
            <div class="card card-body border-0">
                {$paging}
            </div>
        </div>

        <!--
		{if $out.a_keyword}
		<div class="filter__search-keyword mb-3">
			<div class="card card-body border-0">
				<ul class="nav">
					<li class="nav-item nav-link">Tìm kiếm liên quan:</li>
					{foreach from=$out.a_keyword item=v}
					<li class="nav-item">
						<a class="nav-link" href="{$v.url}">{$v.name}</a>
					</li>
					{/foreach}
				</ul>
			</div>
		</div>
		{/if}-->
        <!--end filter__search-keyword-->
    </div>
</div>
<input type="hidden" value="{$out.filter_url}" id="filter_url">
<!-- Optional JavaScript -->
<script>
    function filter() {
        var url = $('#filter_url').val();
        var minorder = $('#filter_minorder').val();
        var minprice = $('#filter_minprice').val();
        var maxprice = $('#filter_maxprice').val();
        if (minorder != '' && minorder > 0) url += '&minorder=' + minorder;
        if (minprice != '' && minprice > 0) url += '&minprice=' + minprice;
        if (maxprice != '' && maxprice > 0) url += '&maxprice=' + maxprice;
        location.href = url;
    }

    function setViewKey(id) {
        var data = {};
        data.id = id;
        data.ajax_action = 'set_view_keyword';
        $.post("?mod=product&site=ajax_handle", data).done(function(e) {});
    }
    $(".open-mega-menu").click(function() {
        $('body').addClass('no-scroll-active')
        $('.mega-menu').addClass('active');
        $('.overlay').fadeIn();
    });
    $(".close-mega").click(function() {
        $('body').removeClass('no-scroll-active')
        $('.mega-menu').removeClass('active');
        $('.overlay').fadeOut();
    });
    $('#collapse_filter').on('click', function() {
        $(".filter").addClass("active");
        $('.overlay').fadeIn();
    });
    $('.close_filter').on('click', function() {
        $(".filter").removeClass("active");
        $('.overlay').fadeOut();
    });
    $('.overlay').on('click', function() {
        $('.filter').removeClass('active');
        $('.overlay').fadeOut();
    });

    function goback() {
        $(".mega-menu-dropdown-header").removeClass("show");
    }

    function showUlCategory() {
        $(".mega-menu-dropdown-header").toggleClass('hmenu-translateX');
    }
    $('.owl-category-hot').owlCarousel({
        loop: false,
        margin: 20,
        nav: true,
        dots: false,
        navText: [
            "<img src='{$arg.stylesheet}images/arrow-l.png'>",
            "<img src='{$arg.stylesheet}images/arrow-r.png'>"
        ],
        responsive: {
            0: {
                items: 3
            },
            600: {
                items: 8
            },
            1000: {
                items: 12
            }
        }
    });
    $('.owl__product-search').owlCarousel({
        loop: true,
        thumbsPrerendered: true,
        items: 1,
        nav: true,
        thumbs: true,
        navText: ["<i class='fa fa-chevron-left'></i>", "<i class='fa fa-chevron-right'></i>"]
    });

    $('.left-filters__filter-wrapper').on('hidden.bs.collapse', toggleIcon);
    $('.left-filters__filter-wrapper').on('shown.bs.collapse', toggleIcon);

    function toggleIcon(e) {
        $(e.target)
            .prev('.panel-heading')
            .find(".more-less")
            .toggleClass('fa-angle-up fa-angle-down');
    }
    $('.owl-adsproduct').owlCarousel({
        loop: false,
        margin: 10,
        nav: true,
        dots: false,
        thumbs: true,
        autoplay: false,
        slideBy: 9,
        stagePadding: 50,
        smartSpeed: 50,
        navText: ["<i class='fa fa-chevron-left'></i>",
            "<i class='fa fa-chevron-right'></i>"
        ],
        responsive: {
            0: {
                items: 2,
            },
            600: {
                items: 2,
            },
            1000: {
                items: 9,
            }
        }
    });
    $('.owl-adsproduct-bottom').owlCarousel({
        loop: false,
        margin: 10,
        nav: true,
        dots: false,
        thumbs: true,
        autoplay: false,
        slideBy: 5,
        stagePadding: 50,
        smartSpeed: 50,
        navText: ["<i class='fa fa-chevron-left'></i>",
            "<i class='fa fa-chevron-right'></i>"
        ],
        responsive: {
            0: {
                items: 2,
            },
            600: {
                items: 2,
            },
            1000: {
                items: 5,
            }
        }
    });
</script>
{literal}
<script>
    var Swipes = new Swiper('.swiper-keyword', {
        loop: false,
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        slidesPerView: 'auto',
        freeMode: true,
        setWrapperSize: true,
        visibilityFullFit: true,
        autoResize: true,
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        // autoplay: {
        //     delay: 2000,
        // },
        breakpoints: {
            // when window width is >= 320px
            320: {
                slidesPerView: 3,
                spaceBetween: 10
            },
            // when window width is >= 480px
            480: {
                slidesPerView: 5,
                spaceBetween: 20
            },
            900: {
                slidesPerView: 12,
                spaceBetween: 20
            },
            // when window width is >= 640px
            1300: {
                slidesPerView: 12,
                spaceBetween: 20
            }
        }
    });
</script>

{/literal}
<script>
    var Swipes = new Swiper('.swiper-adsproduct', {
        loop: false,
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        autoplay: {
            delay: 3000,
        },
        breakpoints: {
            // when window width is >= 320px
            320: {
                slidesPerView: 2,
                spaceBetween: 10
            },
            // when window width is >= 480px
            480: {
                slidesPerView: 5,
                spaceBetween: 20
            },
            900: {
                slidesPerView: 8,
                spaceBetween: 10
            },
            // when window width is >= 640px
            1300: {
                slidesPerView: 8,
                spaceBetween: 10
            }
        }
    });
</script>