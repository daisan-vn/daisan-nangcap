<div class="homepage">
    <div class="container">
        <!-- <ul class="nav">
		<li class="nav-item"><a class="nav-link text-dark" href="#">Date:04/13/2020
				– 05/13/2020 </a></li>
		<li class="nav-item"><a class="nav-link text-dark" href="#">Section:Arts,Books,Business</a></li>
		<li class="nav-item"><a class="nav-link text-dark" href="#">Type:Article</a></li>
	</ul> -->
        <div class="my-4">
            <div class="my-4">
                <div id="resulPost">
                    {foreach from=$result item=data}
                    <div class="row row-no post_item mb-3">
                        <div class="col-md-2 pr-2">
                            <p class="card-text">
                                <span class="text-secondary">{$data.created|date_format:"%A,
                                    %B %e, %Y"}</span>
                            </p>
                        </div>
                        <div class="col-md-7 col-7">
                            <h3 class="post_title text-lg text-mbig text-b">
                                <a href="{$data.url}" class="text-dark">{$data.title}</a>
                            </h3>
                            <p class="mb-0 text-mnm-1 text-threeline d-none d-sm-block">{$data.description}</p>
                        </div>
                        <div class="col-md-3 col-5">
                            <a href="{$data.url}"><img src="{$data.avatar}" class="img-fluid pl-2"></a>
                        </div>
                    </div>
                    {/foreach}
                </div>
                <a href="javascript:; " onclick="loadMore(this) " class="viewmore ">Xem thêm <b></b></a>
            </div>
        </div>
    </div>
</div>
<script>
    var all_post = '{$out.number}';
</script>
<script>
    var page = 1;
    limit = 10;
    number = page * limit;
    if (number > all_post) {
        $(".view_more").addClass("hide");
    }

    function loadMore() {
        page = page + 1;
        number = page * limit;
        $.post('?mod=posts&site=ajax_loadmore', {
            'page': page,
        }).done(function(e) {
            if (number > all_post) {
                $(".view_more").addClass("hide");
            } else {
                $("#resulPost").append(e);
            }
        });
    }
</script>