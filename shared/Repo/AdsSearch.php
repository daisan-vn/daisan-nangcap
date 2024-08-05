<?php

namespace Repo;

class ProductSearch extends \Repo\Main {

    protected $limit = 20;
    protected $index = 'search-ads';
    protected $src = SITE_SRC_NAME;

    protected $elastic;

    protected function __construct() {
        parent::__construct();
        $this->elastic = \Lib\Elasticsearch::instance();
    }

    protected function rankingFunction() {
        return [];
    }

    public function rawSearch($key, $option = []) {
        
    }

    public function update($id) {

    }

    public function remove($id) {

    }

    public function updateAll($page = 1) {
        
    }

}