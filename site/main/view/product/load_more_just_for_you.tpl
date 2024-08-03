{foreach from=$result item=v}
<div class="col-xl-2 col-lg-3 col-md-3 col-6 mb-3">
    <div class="card border-0 ">
        <div class="product-list-item">
            <div class="list-item-img">
                <a href="{$v.url}" target="_blank" class="d-block overflow-hidden"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" data-srcset="{$v.logo} 50w " alt="{$v.name} " class="img-fluid img-item lazy zoom-in-1" loading="lazy"></a>
            </div>
            <div class="list-item-info">
                <h3 class="text-nm-1"><a href="{$v.url}" target="_blank" class="text-twoline text-dark">{$v.name}</a></h3>
                <div class="product-item-price text-oneline">
                    {$v.price}{if $v.pricemax gt 0}-{$v.pricemax|number_format}{/if} {if $v.price neq 0}<span class="unit">/ {$v.unit}</span>{/if}
                </div>
                <p class="product-item-order">{$v.minorder} {$v.unit} (Min.Order)</p>
            </div>
        </div>
    </div>
</div>
{/foreach}
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
    });
</script>