<?php

# Libraries for module user
// define("LIB_CORE_DBO", 			"Core:vsc_pdo");
// define("LIB_CORE_IMAGE", 		"Core:vsc_image");
// define("LIB_CORE_STRING", 		"Core:vsc_string");
// define("LIB_CORE_LANG", 		"Core:vsc_languages");
// define("LIB_CORE_PAGINATION", 	"Core:vsc_pagination");
// define("LIB_CORE_SITEMAPXML", 	"Core:vsc_sitemapxml");
// define("LIB_CORE_API", 	        "Core:vsc_api");

// define("LIB_HELP_HTMLPARSE", 	"Help:simple_html_dom");
// define("LIB_HELP_PHPMAILER", 	"Help:PHPMailer:Autoload");
// define("LIB_HELP_FACEBOOK", 	"Help:Facebook:autoload");
// define("LIB_HELP_HTMLDOM",   	"Help:PhpSimple:HtmlDomParser");

// define("LIB_DBO_USER", 			"Dbo:DboUser");
// define("LIB_DBO_POST", 			"Dbo:DboPosts");
// define("LIB_DBO_HELP", 			"Dbo:DboHelp");
// define("LIB_DBO_TAXONOMY", 		"Dbo:DboTaxonomy");
// define("LIB_DBO_MEDIA", 		"Dbo:DboMedia");
// define("LIB_DBO_MENU",          "Dbo:DboMenu");
// define("LIB_DBO_AI", 			"Dbo:DboAi");
// define("LIB_DBO_PAGE", 			"Dbo:DboPage");
// define("LIB_DBO_SERVICE", 		"Dbo:DboService");
// define("LIB_DBO_PRODUCT", 		"Dbo:DboProduct");
// define("LIB_DBO_JOB", 			"Dbo:DboJob");

define("PRODUCT_GRID", 		"../product/search.tpl");
define("PRODUCT_LIST", 		"../product/search_list.tpl");

define("URL_ERROR_PAGE", "./errorpage");

// define('URL_API_MAIN', 'http://'.$_SERVER['HTTP_HOST'].'/projects/daisan.api/');
// define('URL_API_MAIN', 'http://product.ds_api.hodine.com/');

define('URL_API_MAIN', 'http://api-product.daisan.vn/');

define('ELASTIC_URL',  'http://api-search.daisan.vn');
define('ELASTIC_AUTH_TYPE', 'USER'); // API || USER
define('ELASTIC_API',   'dVoxb2Y0NEIzNW5EWDg2anBKS186bmFHdTRqTXpTSktGQ3hDSHFjeVh2dw==');
define('ELASTIC_USER',  'elastic');
define('ELASTIC_PASS',  '123456');

define('SITE_SRC_NAME',  'construction');


//domain apify
define('APIFY_DOMAIN',      'https://api.apify.com');
//token user
define('APIFY_TOKEN_USER',      'apify_api_debgPZENFwffNWkOocBXsnBAJdE57f0S3RUn');
//apify param
define('APIFY_FAST_GOOGLE_SCRAPER',             'Eva4hfW3EyWE7pVu2');
define('APIFY_GOOGLE_NEWS_SCRAPER',             'mfB8OsXLfdeiQpkql');
define('APIFY_GOOGLE_IMAGES_SCRAPER',           'tnudF2IxzORPhg4r8');
define('APIFY_GOOGLE_SEARCH',                   'VlCMEHUh98kZWWaSU');
define('APIFY_GOOGLE_SHOPPING_INSIGHTS',        'aLTexEuCetoJNL9bL');
define('APIFY_SUPER_FAST_GOOGLE_NEWS_SCRAPER',  'v2y7x1v2Muk1NlPyZ');
define('APIFY_YOUTUBE_SCRAPER',                 'h7sDV53CddomktSi5');

//name index elastic
define('ELASTIC_INDEX_SEARCH_PRODUCTS',  'search-products');
define('ELASTIC_INDEX_ELASTIC_APIFY',    'elastic_apify');
define('ELASTIC_INDEX_NEWS_APIFY',       'news_apify');
define('ELASTIC_INDEX_IMAGES_APIFY',     'images_apify');
define('ELASTIC_INDEX_VIDEOS_APIFY',     'videos_apify');
define('ELASTIC_INDEX_BOOKS_APIFY',      'books_apify');
