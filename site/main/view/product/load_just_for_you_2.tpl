<div class="row row-nm">

	{foreach from=$result item=data}

	<div class="col-xl-2 col-lg-3 col-md-3 col-6 mb-3">

		<div class="card border-0 ">

			<div class="product-list-item">

				<div class="list-item-img">

					<a href="{$data.url}"><img src="{$data.avatar}" class="img-fluid"></a>

				</div>

				<div class="list-item-info">

					<h3 class="text-nm-1"><a href="{$data.url}" class="text-twoline text-dark">{$data.name}</a></h3>

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

</div>

<div id="Loaddb"></div>

{literal}

<script>

var page = 0;

$(window).scroll(function () {

	var h = $(document).height() - $(window).height() - $('footer').height();

	if ($(window).scrollTop() >= h) {

		page = page + 1;

		console.log(page);

		if (page < 3) {

			$.post('?mod=product&site=load_more_just_for_you', {'page':page}, function (data) {

				$('#Loaddb').append(data);

			});

		}

	}

});	

</script>

{/literal}