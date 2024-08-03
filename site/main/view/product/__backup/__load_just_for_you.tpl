{if !$is_mobile}
<div class="swiper-container swiper-products">
    <div class="swiper-wrapper">
        {foreach from=$result item=v}
        <div class="swiper-slide product-item">
            <a href="{$v.url}" target="_blank " class="product-item__img-field">
                <div class="product-item__img-field-inner">
                    <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" class="lazy" loading="lazy">
                </div>

            </a>
            <h3 class="product-item__title"><a href="{$v.url}">{$v.name}</a></h3>
            <div class="product-item__rating">
                <div class="rating__group-col d-flex text-sm">
                    <div class="rating__rating-star-field">
                        <i class="fa fa-star" aria-hidden="true"></i>
                        <i class="fa fa-star" aria-hidden="true"></i>
                        <i class="fa fa-star" aria-hidden="true"></i>
                        <i class="fa fa-star" aria-hidden="true"></i>
                        <i class="fa fa-star" aria-hidden="true"></i>
                    </div>
                    <div class="rating__label-field">
                        {$v.views}
                    </div>
                </div>
            </div>
            <div class="product-item__price-col pt-2">
                <div class="product-item-price text-oneline">
                    {$v.price}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if} {if $v.price neq 0}<span class="unit">/ {$v.unit}</span>{/if}
                </div>
                <p class="product-item-order mb-0">{$v.minorder} {$v.unit} (Tối thiểu)</p>
            </div>
            <div class="product-item__info-other">

            </div>
        </div>
        {/foreach}
    </div>
    <!-- scrollbar -->
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
</div>
{/if} {if $is_mobile}
<div class="category-card card card-body">
    {foreach from=$result key=k item=v} {if $k lt 8}
    <div class="media mb-3">
        <a href="{$v.url}" class="mr-3">
            <img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.avatar} 50w" style="max-width: 135px; height:85px; object-fit: contain;" alt="{$v.name}" loading="lazy">
        </a>
        <div class="media-body">
            <a href="{$v.url}" class="product-card__title">
                            {$v.name}
                        </a>
            <div class="product-card__info-row">
                <div class="product-card__price-col">
                    <div class="product-item-price text-oneline">
                        {$v.price}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if} {if $v.price neq 0}
                        <span class="unit">/ {$v.unit}</span>{/if}
                    </div>
                    <p class="product-item-order mb-0">{$v.minorder} {$v.unit} (Tối thiểu)</p>
                </div>
            </div>
        </div>
    </div>
    {/if} {/foreach}
    <div class="category-card__see-more text-oneline"><a href="./product/justforyou">Xem tất cả</a>
    </div>
</div>
{/if}
<script>
    $(document).ready(function() {
        var lazyloadImages;
        if ("IntersectionObserver" in window) {
            lazyloadImages = document.querySelectorAll('img[loading="lazy"]');
            var imageObserver = new IntersectionObserver(function(entries, observer) {
                console.log(observer);
                entries.forEach(function(entry) {
                    if (entry.isIntersecting) {
                        var image = entry.target;
                        image.src = image.dataset.src;
                        image.classList.remove("lazy");
                        imageObserver.unobserve(image);
                    }
                });
            }, {
                root: document.querySelector("body"),
                rootMargin: "0px 0px 500px 0px"
            });

            lazyloadImages.forEach(function(image) {
                imageObserver.observe(image);
            });
        } else {
            var lazyloadThrottleTimeout;
            lazyloadImages = $('img[loading="lazy"]');

            function lazyload() {
                if (lazyloadThrottleTimeout) {
                    clearTimeout(lazyloadThrottleTimeout);
                }

                lazyloadThrottleTimeout = setTimeout(function() {
                    var scrollTop = $(window).scrollTop();
                    lazyloadImages.each(function() {
                        var el = $(this);
                        if (el.offset().top < window.innerHeight + scrollTop + 500) {
                            var url = el.attr("data-src");
                            el.attr("src", url);
                            el.removeClass("lazy");
                            lazyloadImages = $('img[loading="lazy"]');
                        }
                    });
                    if (lazyloadImages.length == 0) {
                        $(document).off("scroll");
                        $(window).off("resize");
                    }
                }, 20);
            }

            $(document).on("scroll", lazyload);
            $(window).on("resize", lazyload);
        }
    })
</script>
<script>
    var Swipes = new Swiper('.swiper-products', {
        loop: false,
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        slidesPerGroup: 7,
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
            // when window width is >= 900px
            900: {
                slidesPerView: 7,
                spaceBetween: 10
            },
            // when window width is >= 1300px
            1300: {
                slidesPerView: 7,
                spaceBetween: 20
            }
        }
    });
</script>