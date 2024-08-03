<div class="main-content-wrap">

	<div class="container container-cate">

		<nav aria-label="breadcrumb">

			<ol class="breadcrumb">

				{$breadcrumb}

			</ol>

		</nav>

		<section class="section-product-recommend">

			{if count($a_category) eq 0}

			<div class="section-title">

				<h2 class="title-not-line">{$out.number|number_format|default:0} sản phẩm trong "{$taxonomy.name}"</h2>

			</div>

			<div class="row row-nm">

				{foreach from=$result item=v}
				<div class="col-xl-5th col-sm-5th col-6 mb-3">
					<div class="card border-0 rounded-8">
						<div class="product-list-recommend">

							<div class="list-item-img">

								<a href="{$v.url}"><img src="{$v.avatar}" class="img-fluid"></a>

							</div>

							<div class="list-item-info">

								<h3 class="text-nm-1"><a href="{$v.url}" class="text-twoline text-dark">{$v.name}</a>

								</h3>

								<div class="product-item-price text-oneline">

									{$v.price} {$v.pricemax}

									<span class="unit">/ {$v.unit}</span>

								</div>

								<p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>

							</div>

						</div>

					</div>

				</div>

				{/foreach}

			</div>

			{else}

			<div class="row row-nm">

				<div class="col-xl-5th col-sm-5th mb-3 d-none d-md-block">

					<div id="nav-pindex" class="pt-3">

						{foreach from=$a_category item=v}

						<p><a href="{$v.url}">{$v.name}</a></p>

						{/foreach}

					</div>

				</div>
				<div class="col">
					<div class="section-title">
						<h2 class="title-not-line">{$out.number|number_format|default:0} sản phẩm trong
							"{$taxonomy.name}"</h2>
					</div>

					<div class="row row-nm">
						<div class="col-12">
							{if isset($out.a_keyword)}
							<div class="search__suggestions mb-3">
								{foreach from=$out.a_keyword key=k item=v}
								<a href="{$v.url}" class="image-tag" onclick="setViewKey({$v.id});">
									<div class="image-tag__img" style="background: url('{$v.image}');">
									</div>
									{$v.name}
								</a>
								{/foreach}
							</div>
							{/if}
						</div>
						{foreach from=$result item=v}
						<div class="col-md-3 col-6 mb-3">

							<div class="card border-0 rounded-8">

								<div class="product-list-recommend">

									<div class="list-item-img">

										<a href="{$v.url}"><img src="{$v.avatar}" class="img-fluid"></a>

									</div>

									<div class="list-item-info">

										<h3 class="text-nm-1"><a href="{$v.url}"
												class="text-twoline text-dark">{$v.name}</a></h3>

										<div class="product-item-price text-oneline">

											{$v.price} {$v.pricemax}

											<span class="unit">/ {$v.unit}</span>

										</div>

										<p class="product-item-order">{$v.minorder} {$v.unit} (Min. Order)</p>

									</div>

								</div>

							</div>

						</div>

						{/foreach}

					</div>





				</div>

			</div>

			{/if}

			<div class="mt-3">{$paging}</div>

		</section>

	</div>

</div>