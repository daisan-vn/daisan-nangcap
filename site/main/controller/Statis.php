<?php

class Statis extends Main {

    public function product_category() {

        $img_help = \Lib\Core\Image::instance();
        $media_help = \Lib\Dbo\Media::instance();

        $cat_list_sql = "SELECT t.id, t.name, t.parent, t.keyword, mt.alias as folder, m.name as media FROM taxonomy t
                INNER JOIN media m ON m.id = t.image
                INNER JOIN taxonomy mt ON mt.id = m.taxonomy_id AND mt.type='folder' AND t.status=1
                WHERE t.type='product' AND t.status=1 ORDER BY t.id ASC";

        $cat_list = $this->pdo->fetch_all($cat_list_sql);
        foreach ($cat_list as &$item) {
            $item['media'] = $img_help->get_image($media_help->get_path($item['folder']), $item['media']);
        }

        echo json_encode($cat_list);
    }

    public function page() {

        $img_help = \Lib\Core\Image::instance();
        $page_help = \Lib\Dbo\Page::instance();

        $page_list_sql = "SELECT p.id, p.name, p.logo, p.address, p.taxonomy_id, p.phone, p.email, p.website, COUNT(o.id) AS views
            FROM pages p
            INNER JOIN useronlines o ON o.page_id=p.id
            GROUP BY o.page_id
            ORDER BY p.id ASC";

        $page_list = $this->pdo->fetch_all($page_list_sql);
        foreach ($page_list as &$item) {
            $item['logo'] = $this->img->get_image($this->page->get_folder_img($item['id']), $item['logo']);
        }

        echo json_encode($page_list);
    }

    public function product() {
        $img_help = \Lib\Core\Image::instance();
        $product_help = \Lib\Dbo\Product::instance();

        $page = isset($_REQUEST['page'])? intval($_REQUEST['page']): 1;
        if ($page < 1) {
            $page = 1;
        }
        $limit = 5000;
        $offset = ($page - 1) * $limit;

        $product_list_sql = "SELECT id, page_id, name, price, images, taxonomy_id, views
            FROM products
            WHERE status=1
            ORDER BY id ASC LIMIT {$offset}, {$limit}";

        $product_list = $this->pdo->fetch_all($product_list_sql);

        foreach ($product_list as &$item) {
            $item['images'] = implode('|', $product_help->get_images($item['images'], $item['page_id']));
        }

        echo json_encode($product_list);
    }
}