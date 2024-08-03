{foreach from=$result key=k item=v}
<div class="col-xl-5th col-lg-5th col-md-5th col-sm-5th mb-3">
	<div class="card border-0 rounded-8">
		<div class="product-list-recommend">
			{if $k lt 10 AND $out.page eq 1}
			<div class="rank-index offericon">{$k+1}</div>
			{/if}
			<div class="list-item-img">
				<a href="{$v.url}"><img src="{$arg.stylesheet}images/loading.gif" data-src="{$v.avatar}" alt="{$v.name}" class="img-fluid" loading="lazy"></a>
			</div>
			<div class="list-item-info">
				<h3 class="text-nm-1"><a href="{$v.url}" class="text-twoline text-dark">{$v.name}</a></h3>
				<div class="product-item-price text-oneline">{$v.price} {$v.pricemax}</div>
				<p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>
			</div>
		</div>
	</div>
</div>
{/foreach}

<script>
	/*
	document.addEventListener("DOMContentLoaded", function () {
		if ('loading' in HTMLImageElement.prototype) {
			const images = document.querySelectorAll('img[loading="lazy"]');
			images.forEach(img => {
				img.src = img.dataset.src;
			});
		} else {
			// Dynamically import the LazySizes library
			const script = document.createElement('script');
			script.src =
				'https://cdnjs.cloudflare.com/ajax/libs/lazysizes/5.3.2/lazysizes.min.js';
			document.body.appendChild(script);
		}
	});*/

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
	})
</script>