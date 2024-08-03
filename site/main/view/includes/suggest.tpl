<div id="suggest" class="suggest">
    {if isset($hcache.key)}
    <div class="suggest__historysearch">
        <div class="suggest__title">
            <span>Tìm kiếm gần đây</span>&nbsp;<a href="javascript:void(0)" onclick="ClearHistory();"><svg
                    xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                    width="16px" height="16px" viewBox="0 0 16 16" version="1.1">
                    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                        <g id="Search->-Suggestions-(Empty-Query)"
                            transform="translate(-586.000000, -74.000000)">
                            <g id="Popup" transform="translate(457.000000, 33.000000)">
                                <g id="Recent-Searches" transform="translate(12.000000, 40.000000)">
                                    <g id="24px-(4)" transform="translate(116.000000, 0.000000)">
                                        <path
                                            d="M9,1.5 C4.8525,1.5 1.5,4.8525 1.5,9 C1.5,13.1475 4.8525,16.5 9,16.5 C13.1475,16.5 16.5,13.1475 16.5,9 C16.5,4.8525 13.1475,1.5 9,1.5 Z M12.75,11.6925 L11.6925,12.75 L9,10.0575 L6.3075,12.75 L5.25,11.6925 L7.9425,9 L5.25,6.3075 L6.3075,5.25 L9,7.9425 L11.6925,5.25 L12.75,6.3075 L10.0575,9 L12.75,11.6925 Z"
                                            id="Shape" fill="#9E9E9E" fill-rule="nonzero"></path>
                                        <polygon id="Path" points="0 0 18 0 18 18 0 18"></polygon>
                                    </g>
                                </g>
                            </g>
                        </g>
                    </g>
                </svg></a>
        </div>
        <ul class="nav px-3">
            {foreach from=$hcache.key item=data}
            <li class="nav-item d-flex justify-content-between"><a class="historysearch__key"
                    href="{$arg.url_search}product?k={$data|escape:'url'}&t=0">{$data}&nbsp;<svg
                        xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                        width="18px" height="18px" viewBox="0 0 18 18" version="1.1">
                        <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                            <g id="Search->-Suggestions-(Empty-Query)"
                                transform="translate(-558.000000, -114.000000)">
                                <g id="Navbar">
                                    <g id="Popup" transform="translate(457.000000, 33.000000)">
                                        <g id="Recent-Searches" transform="translate(12.000000, 40.000000)">
                                            <g id="24px-(3)" transform="translate(84.000000, 38.000000)">
                                                <path
                                                    d="M17.5,14 L16.71,14 L16.43,13.73 C17.41,12.59 18,11.11 18,9.5 C18,5.91 15.09,3 11.5,3 C7.91,3 5,5.91 5,9.5 C5,13.09 7.91,16 11.5,16 C13.11,16 14.59,15.41 15.73,14.43 L16,14.71 L16,15.5 L21,20.49 L22.49,19 L17.5,14 Z M11.5,14 C9.01,14 7,11.99 7,9.5 C7,7.01 9.01,5 11.5,5 C13.99,5 16,7.01 16,9.5 C16,11.99 13.99,14 11.5,14 Z"
                                                    id="Shape" fill="#9E9E9E" fill-rule="nonzero"></path>
                                                <polygon id="Path" points="0 0 24 0 24 24 0 24"></polygon>
                                            </g>
                                        </g>
                                    </g>
                                </g>
                            </g>
                        </g>
                    </svg></a>
            </li>
            {/foreach}
        </ul>
    </div>
    <!--end suggest__historysearch-->
    {/if}
    <div class="suggest__title">
        <span>Tìm kiếm theo danh mục</span>
    </div>
    <ul class="suggest__collections nav px-3 row row-nm">
        {foreach from=$a_main_category item=data}
        <li class="nav-item col-md-4 mb-3">
            <a href="{$data.url|default:'#'}" class="collections-item nav-link">
                <div class="img-col"><img src="{$data.thumb}" class="img-fluid" alt="{$data.name}"></div>
                <div class="info-col">
                    <div class="collections-item__title" id="search_cate_{$data.id}">
                        {$data.name}
                    </div>
                    <div class="collections-item__number">
                     {$a_cate_number[$data.id]|number_format} sản phẩm   
                    </div>
                </div>
            </a>
        </li>
        {/foreach}
    </ul>
    
    <div class="suggest__title">
        <span>Tìm kiếm phổ biến</span>
    </div>
    <ul class="nav px-3">
        {foreach from=$key_trend item=data}
        <li class="nav-item d-flex justify-content-between"><a class="trendsearch__key"
                href="{$arg.url_search}product?k={$data.name}&t=0"><img src="{$data.avatar}"
                    class="img-item rounded-circle" width="50" height="50">{$data.name}</a>
        </li>
        {/foreach}
    </ul>
</div>