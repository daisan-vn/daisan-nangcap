
<div class="bgcover" style="background-image:url({$info.avatar})">
    <div class="bgtrans">
        <div class="postdetail__info">
            <h1>{$info.title}</h1>
            <div class="newsitem__timepost ">
                <span>{$info.created}</span>
            </div>
        </div>
    </div>
</div>

<section class="postdetail big">
    <div class="postdetail__block">
        <!--{if $info.avatar_status neq 1}
        <div class="postdetail__info p-3">
            <h1 class="postdetail__title">{$info.title}</h1>
            <div class="newsitem__timepost ">
                <span>{$info.created}</span>
            </div>
        </div>
        {/if}-->
        <div class="postdetail__content">
            <p class="mb-0 pb-0">{$info.description}</p>
            <div id="toc_container">
                <p class="toc_title">
                    Mục lục bài viết [<a href='javascript:void(null)' class='toc_list' onclick='hideTOC()'>Ẩn</a><a
                        href='javascript:void(null)' id='showTOC' style="display: none;" onclick='showTOC()'>Hiển
                        thị</a>]
                </p>
                <ol data-toc="div.postdetail__content" data-toc-headings="h2,h3,h4" class="toc_list"></ol>
                </ul>
            </div>
            {$info.content}
        </div>
        <div class="postdetail__other">
            <div class="block-head d-flex justify-content-between ">
                <h2>Bài viết liên quan</h2>
            </div>
            <div class="row row-nm newsrelate">
                {foreach from=$a_other item=v}
                <li class="col-md-4">
                    <a href="{$v.url}" class="newsrelate__img">
                        <img src="{$v.avatar}" alt="{$v.title}"></a>
                    <h3 class="newsitem__title ">
                        <a href="{$v.url}">{$v.title}</a>
                    </h3>
                    </a>
                </li>
                {/foreach}
            </div>
        </div>
    </div>
</section>
<script src="{$arg.stylesheet}js/jquery.toc.min.js"></script>
<script>
    var hideTOC = function () {
        var hideThese = document.getElementsByClassName("toc_list");
        for (var i = 0; i < hideThese.length; i++) {
            hideThese[i].style.display = "none";
        }
        document.getElementById("showTOC").style.display = "";
    }
    var showTOC = function () {
        var showThese = document.getElementsByClassName("toc_list");
        for (var i = 0; i < showThese.length; i++) {
            showThese[i].style.display = "";
        }
        document.getElementById("showTOC").style.display = "none";
    }
    $(document).ready(function () {
        $("#toc_list").toc({
            content: "div.postdetail__content",
            headings: "h2,h3,h4"
        });
    });
</script>