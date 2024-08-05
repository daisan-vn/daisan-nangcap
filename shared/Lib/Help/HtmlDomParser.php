<?php

namespace Lib\Help;

require 'simplehtmldom_1_5/simple_html_dom.php';


class HtmlDomParser {

	static public function file_get_html() {
		return call_user_func_array('\simplehtmldom_1_5\file_get_html', func_get_args());
	}

	static public function str_get_html() {
		return call_user_func_array('\simplehtmldom_1_5\str_get_html', func_get_args());
	}

}