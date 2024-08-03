<p>Url: {$data.url|default:''}</p>
<div class="row row-sm">
	<div class="col-md-4">
		<img src="{$data.image|default:$arg.noimg}" width="100%" class="thumbnail">
	</div>
	<div class="col-md-8">
		<h3>{$data.name|default:''}</h3>
	</div>
</div>