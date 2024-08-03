<h4>Danh sách báo giá cho nhu cầu của tôi</h4>
<hr>
<div class="mt-3">


	{foreach from=$quotations item=data}
	<div class="row row-nm">
		<div class="col-2">
			<a href="{$data.page_url}"><img class="img-thumbnail" src="{$data.page_logo}" width="100%"></a>
		</div>
		<div class="col-10">
			<h5 class="card-title mb-1"><a href="{$data.page_url}">{$data.page_name}</a></h5>
			<p class="line-2 mb-0">{$data.description}</p>
			<p>Báo giá: {$data.price|number_format}đ</p>
		</div>
	</div>
	<hr>
	{/foreach}

</div>

{literal}
<script type="text/javascript">
$(document).ready(function(){
	$('#filter_key').keypress(function(event){
	    if(event.which==13) filter();
	});
});

function filter(){
	var key = $("#filter_key").val();
	var url = "?mod=account&site=pages";
	if(key!='') url = url+"&key="+key;
	location.href =  url;
}
</script>
{/literal}