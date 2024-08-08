{if $tags}
<div class="home-tag-block clearfix ">
    <div class="block-head d-flex justify-content-between align-items-center ">
        <h2>Chủ đề hot</h2>
        <!--<a href="#" class="block-head__viewmore">Xem tất cả</a>-->
    </div>
    <div class="block-body ">
        <ul class="hot-lst ">
            {foreach from = $tags item=v}
            <li>
                <a href="{$v.url}" target="_blank ">
                    {$v.name}
                </a>
            </li>
            {/foreach}
        </ul>
    </div>
</div>
{/if} {if $post_views}
<div class="home-summarycomment-block clearfix ">
    <div class="block-head d-flex justify-content-between ">
        <h2>Bài viết xem nhiều</h2>
    </div>
    <ul class="list-unstyled ">
        {foreach from=$post_views key=k item=v}
        <li class="media ">
            <span>{$k+1}</span>
            <div class="media-body ">
                <h3 class="text-nm"><a href="{$v.url}">{$v.title}</a>
                </h3>
            </div>
        </li>
        {/foreach}
    </ul>
</div>
{/if}

<!--
<div class="home-product-block clearfix ">
    <div class="block-head d-flex justify-content-between ">
        <h3>Sản phẩm</h3>
    </div>
    <ul class="list-unstyled ">
        <li class="media ">
            <img src="https://cdn.tgdd.vn/Products/Images/42/250624/realme-q5-pro-400x400.jpg " alt="... " width="70 ">
            <div class="d-block d-sm-none">
                <h3> Realme Q5 Pro</h3>
                <p>7.990.000₫</p>
            </div>
            <div class="media-body d-none d-sm-block">
                <h3> Realme Q5 Pro</h3>
                <p>7.990.000₫</p>
            </div>
        </li>
        <li class="media ">
            <img src="https://cdn.tgdd.vn/Products/Images/42/250624/realme-q5-pro-400x400.jpg " alt="... " width="70 ">
            <div class="d-block d-sm-none">
                <h3> Realme Q5 Pro</h3>
                <p>7.990.000₫</p>
            </div>
            <div class="media-body d-none d-sm-block">
                <h3> Realme Q5 Pro</h3>
                <p>7.990.000₫</p>
            </div>
        </li>
        <li class="media ">
            <img src="https://cdn.tgdd.vn/Products/Images/42/250624/realme-q5-pro-400x400.jpg " alt="... " width="70 ">
            <div class="d-block d-sm-none">
                <h3> Realme Q5 Pro</h3>
                <p>7.990.000₫</p>
            </div>
            <div class="media-body d-none d-sm-block">
                <h3> Realme Q5 Pro</h3>
                <p>7.990.000₫</p>
            </div>
        </li>
        <li class="media ">
            <img src="https://cdn.tgdd.vn/Products/Images/42/250624/realme-q5-pro-400x400.jpg " alt="... " width="70 ">
            <div class="d-block d-sm-none">
                <h3> Realme Q5 Pro</h3>
                <p>7.990.000₫</p>
            </div>
            <div class="media-body d-none d-sm-block">
                <h3> Realme Q5 Pro</h3>
                <p>7.990.000₫</p>
            </div>
        </li>
    </ul>
</div>-->
<div class="home-newspromotion-block clearfix ">
    <div class="block-head d-flex justify-content-between ">
        <h2>{$taxs.p2.name}</h2>
    </div>
    <ul class="newspromotion ">
        {foreach from=$taxs.p2.posts item=v}
        <li>
            <a href="{$v.url}">
                <img width="380 " height="215 " src="{$v.avatar}">
                <h3>{$v.title}</h3>
            </a>
        </li>
        {/foreach}
    </ul>
</div>
<!--
<div class="home-summaryevent-block clearfix ">
    <div class="block-head d-flex justify-content-between ">
        <h3>Sự kiện</h3>
    </div>
    <ul class="summaryevent ">
        <li>
            <a href="/tin-tuc/su-kien/su-kien-ra-mat-laptop-intel-core-the-he-12-763 ">
                <div class="calen ">
                    <i class="iconnews-calendar "></i>
                    <strong>15/04</strong>
                </div>
                <h3>Sự Kiện Ra Mắt Laptop Intel Core Thế Hệ 12</h3>
                <span class="ddevent "><i class="iconnews-dd "></i>Việt Nam</span>
            </a>
        </li>
        <li>
            <a href="/tin-tuc/su-kien/su-kien-ra-mat-laptop-intel-core-the-he-12-763 ">
                <div class="calen ">
                    <i class="iconnews-calendar "></i>
                    <strong>15/04</strong>
                </div>
                <h3>Sự Kiện Ra Mắt Laptop Intel Core Thế Hệ 12</h3>
                <span class="ddevent "><i class="iconnews-dd "></i>Việt Nam</span>
            </a>
        </li>
        <li>
            <a href="/tin-tuc/su-kien/su-kien-ra-mat-laptop-intel-core-the-he-12-763 ">
                <div class="calen ">
                    <i class="iconnews-calendar "></i>
                    <strong>15/04</strong>
                </div>
                <h3>Sự Kiện Ra Mắt Laptop Intel Core Thế Hệ 12</h3>
                <span class="ddevent "><i class="iconnews-dd "></i>Việt Nam</span>
            </a>
        </li>
    </ul>
</div>-->
{if $taxs.p3}
<div class="home-slidenews-block clearfix ">
    <div class="block-head d-flex justify-content-between align-items-center ">
        <h2>{$taxs.p3.name}</h2>
        <a href="{$taxs.p3.url}" class="block-head__viewmore">Xem tất cả</a>
    </div>
    <div class="swiper-container slidenews ">
        <div class="swiper-wrapper ">
            {foreach from=$taxs.p3.posts item=v}
            <div class="swiper-slide ">
                <a href="{$v.url}" rel="nofollow " target="_blank "><img src="{$v.avatar}"></a>
                <div class="slidenews__item ">
                    <a href="{$v.url}"><span>{$v.title}</span></a>
                </div>
            </div>
            {/foreach}
        </div>
        <!-- If we need pagination -->
        <div class="swiper-pagination "></div>
    </div>
</div>
{/if}
