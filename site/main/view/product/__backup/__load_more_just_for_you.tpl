{foreach from=$result item=data}
<div class="col-xl-2 col-lg-3 col-md-3 col-6 mb-3">
	<div class="card border-0 ">
		<div class="product-list-item">
			<div class="list-item-img">
				<a href="{$data.url}" target="_blank"><img data-src="{$data.avatar}" class="img-fluid"
						loading="lazy"></a>
			</div>
			<div class="list-item-info">
				<h3 class="text-nm-1"><a href="{$data.url}" target="_blank"
						class="text-twoline text-dark">{$data.name}</a></h3>
				<div class="product-item-price text-oneline">
					<b>{$data.price}{if $data.pricemax gt 0}-{$data.pricemax|number_format}{/if}</b>
					{if $data.price neq 0}<span class="unit">/ {$data.unit}</span>{/if}
				</div>
				<p class="product-item-order">{$data.minorder} {$data.unit} (Min.Order)</p>
			</div>
		</div>
	</div>
</div>
{/foreach}
<script>
	$(document).ready(function () {
		var lazyloadImages;

		if ("IntersectionObserver" in window) {
			lazyloadImages = document.querySelectorAll('img[loading="lazy"]');
			var imageObserver = new IntersectionObserver(function (entries, observer) {
				console.log(observer);
				entries.forEach(function (entry) {
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

			lazyloadImages.forEach(function (image) {
				imageObserver.observe(image);
			});
		} else {
			var lazyloadThrottleTimeout;
			lazyloadImages = $('img[loading="lazy"]');

			function lazyload() {
				if (lazyloadThrottleTimeout) {
					clearTimeout(lazyloadThrottleTimeout);
				}

				lazyloadThrottleTimeout = setTimeout(function () {
					var scrollTop = $(window).scrollTop();
					lazyloadImages.each(function () {
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