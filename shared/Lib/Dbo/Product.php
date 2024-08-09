<?php

namespace Lib\Dbo;

class Product {

    use \Lib\Singleton;

    private $pdo, $str, $img, $taxonomy, $page;
    private $number_img_in_folder = 250;
    public $dir_img;
    public $warranty, $status, $order_status, $a_score, $ad_position;
    
    protected function __construct(){
        $this->pdo = \Lib\DB::instance();
        $this->str = \Lib\Core\Text::instance();
        $this->img = \Lib\Core\Image::instance();
        $this->taxonomy = \Lib\Dbo\Taxonomy::instance();
        $this->page = \Lib\Dbo\Page::instance();
        
        $this->dir_img = "pages/";
        $this->warranty = array(
            1 => "1 Tháng",
            2 => "2 Tháng",
            3 => "3 Tháng",
            6 => "6 Tháng",
            12 => "12 Tháng",
            18 => "18 Tháng",
            24 => "24 Tháng",
            36 => "36 Tháng",
            60 => "60 Tháng"
        );
        
        $this->order_status = array(
            0 => 'Đơn hàng mới',
            1 => 'Đang xử lý',
            2 => 'Giao hàng',
            3 => 'Thành công',
            4 => 'Hủy bỏ',
            5 => 'Trả lại'
        );
        
        $this->status = array(
            0 => "Inactive",
            1 => "Active",
            2 => 'Blocked'
        );
        
        $this->ad_position = array(
            1 => 'Top header',
            2 => 'Ad footer',
            3 => 'Top hot sidebar'
        );
    }


    public function felico_category_pattern() {
        return '/(ve|sinh|nuoc|giat|xa|tay|rua|hoa|chat|nha|lau|san|bon|cau|thong|tac|cong|thom|quan|ao|lau|sach|xit|khu|khuan|chen|bat|dia|rac|dung)/';
    }

    public function get_felico_query() {
        return "SELECT products.id FROM products
            INNER JOIN pages ON products.page_id=pages.id
            WHERE page_name='hoachat' AND products.name LIKE '%felico%'
            LIMIT 5
        ";
    }

    public function get_felico_products($cat_slug = '') {
        if (!$cat_slug || preg_match($this->felico_category_pattern(), $cat_slug)) {
            $felico_sql = "SELECT a.id,a.name,a.images,a.page_id,a.trademark,a.ordertime,a.minorder,u.name AS unit,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
                FROM (".$this->get_felico_query().") t INNER JOIN products a ON a.id = t.id
                LEFT JOIN taxonomy u ON u.id=a.unit_id
                ORDER BY a.featured DESC,a.ismain DESC,a.score DESC,a.views DESC LIMIT 5
            ";

            $result = $this->pdo->fetch_all($felico_sql);
            foreach ($result AS $k=>$item){
                $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
                $result[$k]['avatar'] = @$result[$k]['a_img'][0];
                $result[$k]['url'] = $this->get_url($item['id'], $this->str->str_convert($item['name']));
                $result[$k]['unit'] = $item['unit']==''?'Piece':$item['unit'];
                $result[$k]['pricemax'] = $item['price']==$item['pricemax']?'':'-'.number_format($item['pricemax']).'đ';
                $result[$k]['price'] = $item['price'] == 0 ? "Liên hệ" : number_format($item['price']);
            }
            return $result;
        }
        return [];
    }
    
    function get_list($page_id=0, $category_id=0, $where=null, $limit=null, $page_url=null, $order = null){
        // $_t = microtime(true);

        if($page_id!=0 && $page_url==null) $page_url = URL_PAGE."?pageId=".$page_id;
        
        $where = $where!=null?" AND $where":null;
        $sql = "SELECT a.id,a.name,a.images,a.trademark,a.ordertime,u.name AS unit,a.minorder,a.page_id,
                a.ismain,a.featured,a.taxonomy_id,a.created,a.promo,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a
                LEFT JOIN pages b ON b.id=a.page_id AND b.status=1
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 $where";
        if($page_id!=0) $sql .= " AND a.page_id=$page_id";
        if($category_id!=0){
            $sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$category_id) AND (SELECT rgt FROM taxonomy WHERE id=$category_id))
                ORDER BY lft)";
        }
        if ($order != null && strpos($where, 'taxonomy_id') === false) {
            $order = preg_replace('/,\s*rand\(\)/i', '', $order);
        }
        if($order!= null) {
            $sql .= " ORDER BY $order";
        }
        if($limit!=null) $sql .= " LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = $this->str->str_convert($item['name'])."-".$item['id'].".html";
            $result[$k]['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
            $result[$k]['url_page'] = $this->page->get_pageurl($item['page_id']);
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = @$item['price']==@$item['pricemax']?'':number_format(@$item['pricemax']).'đ';
            $result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']).'đ';
            $result[$k]['price_show'] = $result[$k]['price'].($result[$k]['pricemax']==''?'':'-'.$result[$k]['pricemax']);
            $result[$k]['price_promo'] = $this->get_price_promo($item['price'], $item['pricemax'], $item['promo']);
        }

        // echo "<div style='display:none;'>".(microtime(true) - $_t)." | ".$sql."</div>\n";

        return $result;
    }


    // function __get_list($page_id=0, $category_id=0, $where=null, $limit=null, $page_url=null, $order = null){
    //     if($page_id!=0 && $page_url==null) $page_url = URL_PAGE."?pageId=".$page_id;

    //     if($category_id!=0){
    //         # tách fetch taxonomy riêng ra
    //         $taxonomy = $this->pdo->fetch_one("SELECT lft, rgt FROM taxonomy WHERE id={$category_id} LIMIT 1");
    //         if ($taxonomy) {
    //             $taxonomy_sql = "LEFT JOIN taxonomy t ON t.id=a.taxonomy_id AND t.type='product' AND (lft BETWEEN {$taxonomy['lft']} AND {$taxonomy['rgt']})";
    //         }
    //         else {
    //             $taxonomy_sql = '';
    //         }
    //     }
        
    //     $where = $where!=null?" AND $where":null;

    //     $sql = "SELECT a.id,a.name,a.images,a.trademark,a.ordertime,u.name AS unit,a.minorder,a.page_id,
    //             a.ismain,a.featured,a.taxonomy_id,a.created,a.promo,
    //             IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
    //             IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
	// 			FROM products a
    //             LEFT JOIN pages b ON b.id=a.page_id AND b.status=1
    //             LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
    //             ".$taxonomy_sql."
	// 			WHERE a.status=1 $where";

    //     if($page_id!=0) $sql .= " AND a.page_id=$page_id";
    //     if($order!= null) $sql .= " ORDER BY $order";
    //     if($limit!=null) $sql .= " LIMIT $limit";

    //     $result = $this->pdo->fetch_all($sql);

    //     foreach ($result AS $k=>$item){
    //         $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
    //         $result[$k]['avatar'] = @$result[$k]['a_img'][0];
    //         $result[$k]['url'] = $this->str->str_convert($item['name'])."-".$item['id'].".html";
    //         $result[$k]['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
    //         $result[$k]['url_page'] = $this->page->get_pageurl($item['page_id']);
    //         $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
    //         $result[$k]['pricemax'] = @$item['price']==@$item['pricemax']?'':number_format(@$item['pricemax']).'đ';
    //         $result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']).'đ';
    //         $result[$k]['price_show'] = $result[$k]['price'].($result[$k]['pricemax']==''?'':'-'.$result[$k]['pricemax']);
    //         $result[$k]['price_promo'] = $this->get_price_promo($item['price'], $item['pricemax'], $item['promo']);
    //     }
    //     return $result;
    // }


    function get_price_promo($min, $max, $promo=0, $end=null){
        $rt = null;
        if($min==$max && $min>0 && $promo>0){
            $rt = number_format($min * ((100-$promo)/100)).'đ';
        }elseif($max>$min && $min>0 && $promo>0){
            $rt = number_format($min * ((100-$promo)/100)).'đ';
            $rt .= ' - ';
            $rt .= number_format($max * ((100-$promo)/100)).'đ';
        }
        return $rt;
    }
    
    function get_price_show($min, $max){
        $rt = 'Liên hệ';
        if($min==$max && $min>0){
            $rt = number_format($min).' đ';
        }elseif($max>$min && $min>0){
            $rt = number_format($min).' <span style="font-weight: 400; color: #888;">-</span> '.number_format($max).' đ';
        }
        return $rt;
    }
    
    function get_list_group_bypage($category_id=0, $where=null, $limit=null){
        $where = $where!=null?" AND $where":null;
        $sql = "SELECT a.id,a.name,a.images,a.trademark,u.name AS unit,a.minorder,a.page_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a
                LEFT JOIN pages b ON b.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1 $where";
        if($category_id!=0){
            $sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$category_id) AND (SELECT rgt FROM taxonomy WHERE id=$category_id))
                ORDER BY lft)";
        }
        $sql .= " GROUP BY a.page_id HAVING price>0 ORDER BY a.featured";
        if($limit!=null) $sql .= " LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = $this->str->str_convert($item['name'])."-".$item['id'].".html";
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = @$item['price']==@$item['pricemax']?'':'-'.number_format(@$item['pricemax']).'đ';
            $result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']).'đ';
            $result[$k]['price_show'] = $result[$k]['price'].($result[$k]['pricemax']==''?'':'-'.$result[$k]['pricemax']);
        }

        return $result;
    }
    
    
    function get_list_bycate($id=0, $where=null, $limit=null, $order=null){
        $where = $where!=null?" AND $where":null;
        $sql = "SELECT a.id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,a.taxonomy_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a
                LEFT JOIN pages b ON b.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1 $where";
        if($id!=0){
            $sql .= " AND a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                    AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$id) AND (SELECT rgt FROM taxonomy WHERE id=$id))
                    ORDER BY lft)";
        }
        if($order!= null) $sql .= " ORDER BY $order";
        if($limit!=null) $sql .= " LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = @$item['price']==@$item['pricemax']?'':'-'.number_format(@$item['pricemax']).'đ';
            $result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']).'đ';
            $result[$k]['url'] = $this->get_url($item['id'], $item['name']);
        }
        return $result;
    }
    
    
    function get_list_simple($where=null, $limit=null, $order=null){
        $where = $where!=null?" AND $where":null;
        $sql = "SELECT a.id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,a.taxonomy_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price
				FROM products a LEFT JOIN pages b ON b.id=a.page_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1 $where HAVING price>0";
                //GROUP BY a.page_id
        if($order!= null) $sql .= " ORDER BY $order";
        if($limit!=null) $sql .= " LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['url'] = $this->get_url($item['id'], $item['name']);
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']).'đ';
        }
        return $result;
    }
    
    function get_list_promo($where=null, $limit=null, $order=null){
        $where = $where!=null?" AND $where":null;
        // $sql = "SELECT a.id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,a.taxonomy_id,a.promo,
        //         IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price
		// 		FROM products a
        //         LEFT JOIN pages b ON b.id=a.page_id
        //         LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
		// 		WHERE a.status=1 AND b.status=1 AND a.promo>0 AND a.promo_date>='".date('Y-m-d')."' $where";
         $sql = "SELECT a.id,a.name,a.images,u.name AS unit,a.minorder,a.page_id,a.taxonomy_id,a.promo,
         IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price
         FROM products a
         LEFT JOIN pages b ON b.id=a.page_id
         LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
         WHERE a.status=1 AND b.status=1 AND a.promo>0 $where";       
        if($order!= null) $sql .= " ORDER BY $order";
        if($limit!=null) $sql .= " LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['url'] = $this->get_url($item['id'], $item['name']);
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['price_sale'] = number_format($item['price'] - $item['price']*($item['promo']/100)).'đ';
        }
        return $result;
    }
    
    
    function get_list_of_page($where=null, $limit=null, $order=null){
        $where = $where!=null?" AND $where":null;
        $sql = "SELECT b.id,b.name,b.images,u.name AS unit,b.minorder,a.id AS page_id,b.taxonomy_id
				FROM pages a
                LEFT JOIN products b ON a.id=b.page_id
                LEFT JOIN taxonomy u ON u.id=b.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND b.status=1 $where GROUP BY b.page_id";
        if($order!= null) $sql .= " ORDER BY $order";
        if($limit!=null) $sql .= " LIMIT $limit";
        
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['price'] = @$item['price'] == 0 ? "Liên hệ" : number_format(@$item['price']);
        }
        return $result;
    }
    
    
    function get_list_bypage($page_id, $where=null, $limit=null){
        $page_url = URL_PAGE."?pageId=".$page_id;
        $where = $where!=null?" AND $where":null;
        $sql = "SELECT a.id,a.name,a.images,a.trademark,u.name AS unit,a.minorder,a.page_id,
                a.ismain,a.featured,a.taxonomy_id,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
				FROM products a 
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
				WHERE a.status=1 AND a.page_id=$page_id $where ORDER BY a.id DESC";
        if($limit!=null) $sql .= " LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = $this->get_url($item['id'], $item['name'], $page_url);
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = $item['price']==$item['pricemax']?0:$item['pricemax'];
            $result[$k]['price'] = $item['price'] == 0 ? "Liên hệ" : number_format($item['price']);
        }
        return $result;
    }
    
    function get_p_value(array $product){
        $product['a_img'] = $this->get_images($product['images'], $product['page_id']);
        $product['avatar'] = @$product['a_img'][0];
        $product['url'] = $this->get_url($product['id'], $product['name']);
        $product['unit'] = $product['unit']=='' ? 'piece' : $product['unit'];
        $product['pricemax'] = $product['price']==$product['pricemax']?0:$product['pricemax'];
        $product['price'] = $product['price'] == 0 ? "Liên hệ" : number_format($product['price']);
        return $product;
    }
    
    function get_list_inarray(array $arr_id){
        $a_sql = [];
        foreach ($arr_id AS $item){
            $a_sql[] = "SELECT a.id,a.name,a.images,a.trademark,a.ordertime,a.page_id,u.name AS unit,c.name AS category,a.minorder
    				FROM products a
                    LEFT JOIN pages b ON b.id=a.page_id
                    LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
                    LEFT JOIN taxonomy c ON c.id=a.taxonomy_id AND c.type='product'
    				WHERE a.id=$item";
        }
        $a = implode(" UNION ALL ", $a_sql);
        
        $result = $this->pdo->fetch_all(implode(" UNION ALL ", $a_sql));
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            if (empty($item['price'])) {
                $item['price'] = 0;
            }
            if (empty($item['pricemax'])) {
                $item['pricemax'] = 0;
            }
            $result[$k]['pricemax'] = $item['price']==$item['pricemax']?0:$item['pricemax'];
            $result[$k]['price'] = $item['price'] == 0 ? "Liên hệ" : number_format($item['price']);
        }
        return $result;
    }
    
    function get_adsproducts($key_id=0, $tax_id=0, $limit=null, $notid=[]){
        global $location;
        $today = date("Y-m-d");
        $where = null;
        if(count($notid)>0) $where .= " AND a.id NOT IN (".implode(',', $notid).")";
        if($key_id!=0 || $tax_id!=0){
            //$where .= " AND (FIND_IN_SET($key_id, a.keyword) OR a.taxonomy_id=$tax_id)";
            $where .= " AND (FIND_IN_SET($key_id, a.keyword) OR a.taxonomy_id IN (SELECT id FROM taxonomy WHERE type='product'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$tax_id) AND (SELECT rgt FROM taxonomy WHERE id=$tax_id))
                ORDER BY lft))";
        }
        if($location!=0) $where .= " AND (a.page_id IN (SELECT ad.page_id FROM pageaddress ad WHERE ad.status=1 AND ad.province_id=$location) OR a.page_id IN (SELECT p.id FROM pages p WHERE p.status=1 AND p.province_id=$location))";
        $sql = "SELECT a.id,a.name,a.images,a.trademark,a.page_id,a.ordertime,u.name AS unit,t.name AS category,a.minorder,
                a.ability,pa.name AS pagename,pa.address AS pageaddress,pa.phone,pa.isphone,pa.date_start,c.score_daily,
                IFNULL((SELECT l.Name FROM locations l WHERE l.Id = pa.province_id LIMIT 1),0) AS Location,
                IFNULL((SELECT SUM(ac.score) FROM adsclicks ac WHERE ac.campaign_id=b.campaign_id AND ac.date_click='".date('Y-m-d')."'), 0) AS total_today,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS price,
                IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
                FROM adsproducts b
                LEFT JOIN products a ON a.id=b.product_id
                LEFT JOIN adscampaign c ON c.id=b.campaign_id
                LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'
                LEFT JOIN taxonomy t ON t.id=a.taxonomy_id AND t.type='product'
                LEFT JOIN pages pa ON pa.id=a.page_id
                WHERE a.status=1 AND b.status=1 AND c.status=1 AND pa.status=1 AND pa.score_ads>0
                    AND c.date_start<='$today' AND c.date_finish>='$today' $where
                HAVING score_daily>total_today
                ORDER BY b.score DESC LIMIT $limit";
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = "?mod=product&site=adsclick&id=".$item['id'];
            $result[$k]['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
            $result[$k]['url_page'] = $this->page->get_pageurl($item['page_id']);
            $result[$k]['unit'] = $item['unit']=='' ? 'piece' : $item['unit'];
            $result[$k]['pricemax'] = $item['price']==$item['pricemax']?0:number_format($item['pricemax']);
            $result[$k]['price'] = $item['price'] == 0 ? "Liên hệ" : number_format($item['price']);
            $result[$k]['yearexp'] = $this->page->get_yearexp($item['date_start']);
            $result[$k]['name']=$this->get_title($item['name'],null);
            if($this->pdo->check_exist("SELECT 1 FROM pageaddress WHERE province_id=$location AND page_id=".$item['page_id']))
                $result[$k]['info_page']=$this->page->info_page_location($item['page_id'],$location);
        }
        return $result;
    }
   
    function get_detail($detail=[]){
        $detail = is_array($detail) ? $detail : [];
        if(count($detail)>0){
            $detail['a_img'] = $this->get_images($detail['images'], $detail['page_id']);
            $detail['avatar'] = @$detail['a_img'][0];
            $detail['url'] = $this->get_url($detail['id'], $detail['name']);
            $detail['url_addcart'] = "?mod=product&site=addcart&pid=".$detail['id'];
        }
        return $detail;
    }
    
    function get_product_fullvalue($category_id=0, $where=null, $limit=null){
        $where = $where!=null?" AND $where":null;
        $sql = "SELECT a.id,a.name,a.images,a.trademark,a.ordertime,a.ability,a.page_id,a.minorder,
				b.name AS pagename,b.address AS pageaddress,
				(SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1) AS price,
				(SELECT t.name FROM taxonomy t WHERE t.id=a.taxonomy_id) AS category
				FROM products a LEFT JOIN pages b ON b.id=a.page_id
				WHERE a.status=1 AND b.status=1";
        if($category_id!=0){
            $a_category_id = $this->taxonomy->get_all_category_id($category_id);
            $sql .= " AND a.taxonomy_id IN (".implode(",", $a_category_id).")";
        }
        if($where!=null) $sql .= $where;
        if($limit!=null) $sql .= " LIMIT $limit";
        
        $result = $this->pdo->fetch_all($sql);
        foreach ($result AS $k=>$item){
            $result[$k]['a_img'] = $this->get_images($item['images'], $item['page_id']);
            $result[$k]['avatar'] = @$result[$k]['a_img'][0];
            $result[$k]['url'] = "?mod=product&site=detail&pid=".$item['id'];
            $result[$k]['url_addcart'] = "?mod=product&site=addcart&pid=".$item['id'];
            $result[$k]['url_page'] = URL_PAGE."?PageId=".$item['page_id'];
        }
        return $result;
    }
    function get_product_keyword($where){
        $where = ($where==''||$where==null) ? "1=1" : $where;
        $sql = "SELECT name FROM keywords WHERE $where";
        $result = $this->pdo->fetch_all($sql);
        $a_field = [];
        foreach ($result AS $k=>$item){
            $a_field[$k]['name'] = $item['name'];
            $a_field[$k]['url'] = "product?k=".str_replace(" ","+", trim($item['name']))."&t=0";
        }
        return $a_field;
    }
    
    function get_url($id, $alias=null, $type='product'){
        $url = DOMAIN;
        if($alias==null) $url .= $type."/".$id;
        else $url .= $this->str->str_convert($alias)."-".$id.".html";
        return $url;
    }
    
    function get_avatar($page_id, $images=null){
        $a_img = $this->get_images($images, $page_id);
        return isset($a_img[0])?$a_img[0]:NO_IMG;
    }
    
    function get_folder_img($id){
        $result = $this->pdo->fetch_one("SELECT page_id FROM products WHERE id=".$id);
        return $this->dir_img.$result['page_id']."/";
    }
    
    
    function get_folder_img_upload($id){
        return DIR_UPLOAD.$this->get_folder_img($id);
    }
    
    function set_score(){
        $a_score = array(
            'view' => 1,
            'favorites' => 2,
            'contact' => 5,
            'order' => 5,
            'order_success' => 7,
            'page_v1' => 300,
            'page_v2' => 500,
            'page_v3' => 1000
        );
        $this->a_score = $a_score;
    }
    
    
    function get_keyword_id($key){
        $id = 0;
        if(strlen($key)>2 && strlen($key)<=50){
            $keyword = $this->pdo->fetch_one("SELECT id FROM keywords WHERE name='$key'");
            $id = intval(@$keyword['id']);
            if(!$keyword){
                $data = [];
                $data['name'] = $key;
                $data['created'] = time();
                $id = $this->pdo->insert('keywords', $data);
            }
        }
        return $id;
    }
    function get_title($title, $key)
    {
        $a_words = explode(" ", $key);
        foreach ($a_words as $value) {
            if (strpos(strtoupper($title), strtoupper($value)) !== false) {
                $title = str_replace($value, "<font color='#f60'>" . $value . "</font>", $title);
            }
        }
        return $title;
    }
    function get_product_price($price, $promo=0, $prefix="đ"){
        $value = "<span class=\"price\">Liên hệ</span>";
        if(intval($price)!=$promo){
            $value = "<span class=\"price\">".number_format(intval($promo))."$prefix</span>";
            $value .= "&nbsp;<span class=\"price\">&nbsp;-&nbsp;".number_format(intval($price))."$prefix </span>";
        }elseif(intval($promo)!=0){
            $value = "<span class=\"price\">".number_format(intval($price))."$prefix</span>";
        }
        return $value;
    }

    function get_folder_img_s3($id){
        $result = $this->pdo->fetch_one("SELECT page_id FROM products WHERE id=".$id);
        return $this->dir_img.$result['page_id']."/";
    }

    function get_url_img($page_id){
        return URL_IMAGE.'pages/'.$page_id.'/';
    }
    
    function get_images($str, $page_id, $thumb=1){
        $folder = $this->get_url_img($page_id);
        $a_images = explode(";", $str);
        $a_img = [];
        foreach ($a_images AS $v){
            if($v!='') $a_img[] = $folder.$v;
        }
        return $a_img;
    }

    function daily_reset() {
        
    }
    
    function ads_click($product_id, $user_id){
        $campaign_id = isset($_GET['campaign']) ? intval($_GET['campaign']) : 0;
        $token = isset($_GET['token']) ? trim($_GET['token']) : '';
        if($product_id && $campaign_id && $token!=''){
            if(!$this->pdo->check_exist("SELECT 1 FROM adsclicks WHERE product_id=".$product_id." AND user_id=".$user_id." AND token='".$token."'")){
                $ad = $this->pdo->fetch_one("SELECT id,page_id,score,campaign_id FROM adsproducts WHERE campaign_id=".$campaign_id." AND product_id=".$product_id);
                $data = [];
                $data['page_id'] = $ad['page_id'];
                $data['score'] = $ad['score'];
                //$data['user_ip'] = getenv('HTTP_CLIENT_IP') ?: getenv('HTTP_X_FORWARDED_FOR') ?: getenv('HTTP_X_FORWARDED') ?: getenv('HTTP_FORWARDED_FOR') ?: getenv('HTTP_FORWARDED') ?: getenv('REMOTE_ADDR');
                $data['user_ip'] = $this->str->get_client_ip();
                $data['campaign_id'] = $campaign_id;
                $data['user_id'] = $user_id;
                $data['product_id'] = $product_id;
                $data['token'] = $token;
                $data['date_click'] = date('Y-m-d');
                $data['created'] = time();
                $details = json_decode(file_get_contents("http://ipinfo.io/".$this->str->get_client_ip()."/json"));
                if($details){
                    $a_address = [];
                    if(isset($details->region)) $a_address[] = $details->region;
                    if(isset($details->city)) $a_address[] = $details->city;
                    if(isset($details->country)) $a_address[] = $details->country;
                    $data['user_location'] = implode(', ', $a_address);
                    unset($a_address);
                }
                $this->pdo->insert('adsclicks', $data);
                $this->pdo->query("UPDATE adsproducts SET number_click=number_click+".$ad['score']." WHERE id=".$ad['id']);
                $this->pdo->query("UPDATE adscampaign
                                    SET score_daily_used=score_daily_used+".$ad['score'].",
                                        score_used=score_used+".$ad['score']."
                                    WHERE id=".$ad['campaign_id']);
            }
        }
    }
    
    
    function save_product(array $a_value, $page_id){
        $data['page_id'] = $page_id;
        $data['name'] = $this->get_true_value(@$a_value['name']);
        $data['code'] = $this->get_true_value(@$a_value['sku']);
        $data['description'] = $this->get_true_value(@$a_value['description']);
        $data['keyword'] = $this->get_true_value(@$a_value['category']);
        $data['price'] = $this->get_true_value(@$a_value['price']);
        $data['trademark'] = $this->get_true_value(@$a_value['brand']);
        $data['source'] = @$a_value['url'];
        $data['user_id'] = @$a_value['user_id'];
        $data['created'] = time();
        $data['status']=1;
        
        $domain = parse_url($data['source'], PHP_URL_SCHEME)."://".parse_url($data['source'], PHP_URL_HOST);
        $rt['code'] = 0;
        if($data['price']==0){
            $rt['msg'] = "Không có giá bán";
        }elseif(@$a_value['is_product']==0){
            $rt['msg'] = "Nội dung không phù hợp";
        }elseif(@$a_value['image']==null || $data['name']==null || $page_id==0){
            $rt['msg'] = "Nội dung bị thiếu";
        }elseif($db=$this->pdo->fetch_one("SELECT id FROM products WHERE source='".$data['source']."'")){
            $this->pdo->update('products', $data, 'id='.$db['id']);
            $rt['code'] = 1;
            $rt['msg'] = 'Update sản phẩm '.$db['id'];
        }elseif($this->pdo->check_exist("SELECT 1 FROM products WHERE name='".$data['name']."' AND source LIKE '$domain%'")){
            $rt['msg'] = "Sản phẩm đã tồn tại";
        }elseif($product_id = $this->pdo->insert('products', $data)){
            $data['images'] = $this->img->upload_image_auto_resize_fromurl($this->get_folder_img($product_id), @$a_value['image'], 400);
            $this->pdo->update('products', $data, "id=$product_id");
            $this->save_keywords($data['keyword'], $product_id);
            
            $data = [];
            $data['product_id'] = $product_id;
            $data['version'] = 'Giá';
            $data['price'] = @$a_value['price'];
            $this->pdo->insert('productprices', $data);
            
            $a_value['a_metas'] = is_array(@$a_value['a_metas'])?$a_value['a_metas']:[];
            foreach ($a_value['a_metas'] AS $k=>$item){
                if($k!='' && $item!=''){
                    $data = [];
                    $data['meta_key'] = $k;
                    $data['meta_value'] = $item;
                    $data['product_id'] = $product_id;
                    $this->pdo->insert('productmetas', $data);
                }
            }
            
            $rt['code'] = 1;
            $rt['msg'] = "Thêm mới sản phẩm";
        }else{
            $rt['msg'] = "Không lưu được";
        }
        unset($data);
        return $rt;
    }
    
    
    function update_product(array $a_value){
        $data = [];
        //$data['page_id'] = $page_id;
        $data['name'] = $this->get_true_value(@$a_value['name']);
        $data['code'] = $this->get_true_value(@$a_value['sku']);
        $data['description'] = $this->get_true_value(@$a_value['description']);
        $data['keyword'] = $this->get_true_value(@$a_value['category']);
        $data['price'] = $this->get_true_value(@$a_value['price']);
        $data['trademark'] = $this->get_true_value(@$a_value['brand']);
        $data['created'] = time();
        $db = $this->pdo->fetch_one("SELECT id FROM products WHERE id=".$a_value['id']);
        $rt['code'] = 0;
        if($data['price']==0 || @$a_value['is_product']==0){
            $rt['msg'] = "Nội dung không phù hợp";
            $this->pdo->query("DELETE FROM products WHERE id=".$db['id']);
        }else{
            $this->pdo->update('products', $data, 'id='.$db['id']);
            $rt['code'] = 1;
            $rt['msg'] = 'Update sản phẩm '.$db['id'];
        }
        unset($data);
        return $rt;
    }
    
    
    
    function get_true_value($str){
        $str = str_replace("&nbsp;", "", $str);
        return $str;
    }
    
    function save_keywords($keywords, $product_id){
        $a_keywords = explode(",", $keywords);
        $a_keywords = @array_unique($a_keywords);
        foreach ($a_keywords AS $item){
            $item = trim($item);
            $item = str_replace(".", "", $item);
            $item = str_replace("  ", " ", $item);
            if(strlen($item)<=50 && strlen($item)>2){
                $keyword = $this->pdo->fetch_one("SELECT id FROM keywords WHERE name='$item' LIMIT 1");
                if(!$keyword){
                    $data['created'] = time();
                    $data['name'] = $item;
                    $this->pdo->insert('keywords', $data);
                    unset($data);
                }
            }
        }
    }
    
    
    function get_sql_productsearch($key){
        $sql = "SELECT a.product_id AS id,a.name,a.page_id,a.images,
				CASE WHEN a.name='".$key."' THEN 5 WHEN a.name LIKE '".$key." %' THEN 3
                WHEN a.name LIKE '".$key."%' THEN 1 WHEN a.name LIKE '% ".$key." %' THEN 1
                WHEN a.name LIKE '%".$key."%' THEN 1 ELSE 0 END AS S1";
        $a_key = explode(' ', $key);
        $c_key = count($a_key);
        if($c_key>=3 && $c_key<=4){
            $new_a_key = [];
            for($i=0; $i<=($c_key-2); $i++){
                $new_a_key[] = $a_key[$i].' '.$a_key[$i+1];
            }
            foreach ($new_a_key AS $k=>$v){
                if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 ELSE 0 END AS FG";
                $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 WHEN a.name LIKE '% $v %' THEN 1.5 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS XG".$k;
            }
        }
        if($c_key>=4 && $c_key<=8){
            $new_a_key_3c = [];
            for($i=0; $i<=($c_key-3); $i++){
                $new_a_key_3c[] = $a_key[$i].' '.$a_key[$i+1].' '.$a_key[$i+2];
            }
            foreach ($new_a_key_3c AS $k=>$v){
                if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 ELSE 0 END AS F3C";
                $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1.5 WHEN a.name LIKE '% $v %' THEN 1.5 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS X3C".$k;
            }
            
        }
        if($c_key>1 && $c_key<=8){
            foreach ($a_key AS $k=>$v){
                if($k==0) $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 0.5 ELSE 0 END AS F";
                $sql .= ",CASE WHEN a.name LIKE '$v %' THEN 1 WHEN a.name LIKE '% $v %' THEN 1 WHEN a.name LIKE '%$v%' THEN 0.5 ELSE 0 END AS X".$k;
            }
        }
        $sql .= " FROM productsearch a WHERE 1=1";
        $values = "(S1";
        if($c_key>1 && $c_key<=8){
            $values .= "+F";
            foreach ($a_key AS $k=>$v){
                $values .= "+X".$k;
            }
        }
        if($c_key>=3 && $c_key<=4){
            $values .= "+FG";
            foreach ($new_a_key AS $k=>$v){
                $values .= "+XG".$k;
            }
        }
        $values .= ")";
        
        $sql .= " ORDER BY S1 DESC,$values DESC";
        return $sql;
    }

}