<?php

class Tool extends Main {

    public function __construct() {
        ini_set('display_errors', 1);
        error_reporting(E_ALL);

        parent::__construct();
    }

    protected function getImagePath($page_id, $image) {
        return __ROOT.'site/upload/pages/'.$page_id.'/'.$image;
    }

    protected function haveProductError($page_id, $product_id, $type) {
        return $this->pdo->fetch_one('SELECT id FROM producterrors WHERE product_id='.$product_id.' AND page_id='.$page_id.' AND error_type=\'image\' LIMIT 1');
    }

    public function scan_product_image_error() {
        $limit = 10000;
        $page = isset($_GET['page'])? intval($_GET['page']): 1;
        if ($page < 1) { $page = 1; }
        $offset = ($page - 1) * $limit;
        $errors = [];
        $products = $this->pdo->fetch_all('SELECT id, page_id, images FROM products ORDER BY id ASC LIMIT '.$limit.' OFFSET '.$offset);
        if ($products) {
            foreach ($products as $product) {
                $images = explode(';', $product['images']);
                $image_errors = [];
                foreach ($images as $image) {
                    $image_file = $this->getImagePath($product['page_id'], $image);
                    if (!is_file($image_file)) {
                        $image_errors[] = $image;
                    }
                }
                if ($image_errors) {
                    $errors[] = [
                        'product_id' => $product['id'],
                        'page_id' => $product['page_id'],
                        'error_type' => 'image',
                        'metas' => json_encode([
                            'images' => $image_errors
                        ])
                    ];
                }
            }
            foreach ($errors as $error) {
                $have_error = $this->haveProductError($error['page_id'], $error['product_id'], $error['error_type']);
                if ($have_error) {
                    $this->pdo->update('producterrors', $error, 'id='.$have_error['id']);
                }
                else {
                    $this->pdo->insert('producterrors', $error);
                }
            }
            echo 'Doing...';
            echo '<meta http-equiv="refresh" content="0; url=/?mod=tool&site=scan_product_image_error&page='.($page+1).'">';
        }
        else {
            echo 'DONE.';
        }
    }
}