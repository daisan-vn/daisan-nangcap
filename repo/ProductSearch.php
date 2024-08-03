<?php

namespace Repo;

class ProductSearch extends \Repo\Main {

    protected $limit = 20;  
    protected $index = 'search-products';
    protected $src = SITE_SRC_NAME;
    protected $bucket_size = 10000;
    protected $type_key = 'page_id';
    protected $max_item_same_type = 1;
    protected $max_jump = 100;

    protected $elastic;
    // protected $page;

    protected function __construct() {
        parent::__construct();
        $this->elastic = \Lib\Elasticsearch::instance();
        // $this->page = \Lib\Dbo\Page::instance();
    }

    protected function rankingFunction($key) {
        return [
            [
                'filter' => [
                    'term' => [
                        'metas.page_name' => 'hoachat'
                    ]
                ],
                'weight' => 2
            ],
            [
                'filter' => [
                    'bool' => [
                        'should' => [
                            [
                                'prefix' => [
                                    'metas.page' => 'daisan'
                                ]
                            ],
                            [
                                'match_phrase' => [
                                    'metas.page' => 'Đại Sàn'
                                ]
                            ],
                            [
                                'prefix' => [
                                    'metas.page' => 'homepro'
                                ]
                            ],
                        ]
                    ]
                ],
                'weight' => 0.05
            ],
            // [
            //     'filter' => [
            //         'match' => [
            //             'metas.page' => $key
            //         ]
            //     ],
            //     'weight' => 1
            // ],
            [
                'filter' => [
                    'term' => [
                        'pagefee' => 1
                    ]
                ],
                'weight' => 1
            ],
            [
                'filter' => [
                    'term' => [
                        'ismain' => 1
                    ]
                ],
                'weight' => 1
            ],
            [
                'filter' => [
                    'term' => [
                        'featured' => 1
                    ]
                ],
                'weight' => 0.5
            ],
            [
                'filter' => [
                    'term' => [
                        'promo' => 1
                    ]
                ],
                'weight' => 0.5
            ]
        ];

        // return [
        //     [
        //         'script_score' => [
        //             'script' => "
        //                 return (doc['featured'].value / 25) + (doc['promo'].value / 25) + (doc['ismain'].value / 1) + (doc['pagefee'].value / 1);
        //             "
        //         ]
        //     ]
        // ];
    }

    public function getOptionByArray($input) {
        $option = [];

        // offset, limit
        if (isset($input['offset'])) {
            $option['offset'] = intval($input['offset']);
        }

        if (isset($input['limit'])) {
            $option['limit'] = intval($input['limit']);
        }

        // category
        if (isset($input['cat'])) {
            $option['tax_ids'] = $input['cat'];
        }

        // page
        if (isset($input['page'])) {
            $option['page_ids'] = $input['page'];
        }

        // page fee
        if (isset($input['assessment_company'])) {
            $option['pagefee'] = $input['assessment_company'];
        }

        // page verify
        if (isset($input['is_verified'])) {
            $option['is_verify'] = $input['is_verified'];
        }

        // page oem
        if (isset($input['is_oem'])) {
            $option['is_oem'] = $input['is_oem'];
        }

        // page promo
        if (isset($input['is_promo'])) {
            $option['is_promo'] = $input['is_promo'];
        }

        // is_readytoship
        if (isset($input['is_readytoship'])) {
            $option['is_readytoship'] = $input['is_readytoship'];
        }

        // min order
        if (isset($input['minorder'])) {
            $option['minorder'] = $input['minorder'];
        }

        // min price
        if (isset($input['minprice'])) {
            $option['minprice'] = $input['minprice'];
        }

        // max price
        if (isset($input['maxprice'])) {
            $option['maxprice'] = $input['maxprice'];
        }

        // location
        if (isset($input['location'])) {
            $option['location_ids'] = $input['location'];
        }

        return $option;
    }

    public function rawSearch($key, $option = []) {
        $_option = [
            'offset' => 0,
            'limit'=> $this->limit
        ];

        $option = array_replace($_option, $option);

        // where
        $where = [];

        // category
        $tax_ids = empty($option['tax_ids'])? null: $option['tax_ids'];
        if ($tax_ids) {
            $tax_ids = \Lib\Arr::toArrayIds($tax_ids);
            $tax_clause = [];
            $tax_list = \Repo\Taxonomy::instance()->getTaxsForSearch($tax_ids, 'product');
            foreach ($tax_list as $tax) {
                $tax_clause[] = [
                    'term' => [
                        'taxonomy_id' => $tax['id']
                    ]
                ];
                $tax_clause[] = [
                    'range' => [
                        'taxonomy_id' => [
                            'gte' => $tax['lft'],
                            'lte' => $tax['rgt']
                        ]
                    ]
                ];
            }
            if ($tax_clause) {
                $where[] = [
                    'bool' => [
                        'should' => $tax_clause
                    ]
                ];
            }
        }

        // page id
        $page_ids = empty($option['page_ids'])? null: $option['page_ids'];
        if ($page_ids) {
            $page_ids = \Lib\Arr::toArrayIds($page_ids);
            $page_clause = [];
            foreach ($page_ids as $page_id) {
                $page_clause[] = [
                    'term' => [
                        'page_id' => $page_id
                    ]
                ];
            }
            if ($page_clause) {
                $where[] = [
                    'bool' => [
                        'should' => $page_clause
                    ]
                ];
            }
        }           
        // is verify
        if (!empty($option['is_verify'])) {
            $where[] = [
                'term' => [
                    'pageverify' => 1
                ]
            ];
        }

        // is oem       3
        if (!empty($option['is_oem'])) {
            $where[] = [
                'term' => [
                    'pageoem' => 1
                ]
            ];
        }

        // page fee
        if (!empty($option['pagefee'])) {
            $where[] = [
                'term' => [
                    'pagefee' => 1
                ]
            ];
        }

        // ready to ship
        if (!empty($option['is_readytoship'])) {
            $where[] = [
                'range' => [
                    'number' => ['gt' => 0]
                ]
            ];
        }

        // is promo
        if (!empty($option['is_promo'])) {
            $where[] = [
                'range' => [
                    'promo' => ['gt' => 0]
                ]
            ];
        }

        // min order
        $min_order = isset($option['minorder'])? intval($option['minorder']): 0;

        if ($min_order > 0) {
            $where[] = [
                'range' => [
                    'minorder' => ['gte' => $min_order]
                ]
            ];
        }

        // min price
        $min_price = isset($option['minprice'])? intval($option['minprice']): 0;

        if ($min_price > 0) {
            $where[] = [
                'range' => [
                    'metas.pricemin' => ['gte' => $min_price]
                ]
            ];
        }

        // max price
        $max_price = isset($option['maxprice'])? intval($option['maxprice']): 0;

        if ($max_price > 0) {
            $where[] = [
                'range' => [
                    'metas.pricemax' => ['lte' => $max_price]
                ]
            ];
        }

        // location
        $location_ids = empty($option['location_ids'])? null: $option['location_ids'];

        if ($location_ids) {
            $location_ids = \Lib\Arr::toArrayIds($location_ids);
            $location_clause = [];
            foreach ($location_ids as $location_id) {
                $location_clause[] = [
                    'term' => [
                        'location_id' => $location_id
                    ]
                ];
            }
            if ($location_clause) {
                $where[] = [
                    'bool' => [
                        'should' => $location_clause
                    ]
                ];
            }
        }

        // query
        $query = [
            'from' => $option['offset'],
            'size' => $option['limit'],
            '_source' => [],
            'query' => [
                'function_score' => [
                    'query' => [
                        'bool' => [
                            'must' => [
                                [
                                    'multi_match' => [
                                        'query' => $key,
                                        'fields' => ['name^2', 'content'],
                                        'type' => 'most_fields'
                                    ]
                                ],
                                ...$where
                            ],
                            'filter' => [
                                [
                                    'term' => [
                                        'src' => $this->src
                                    ]
                                ],
                                [
                                    'term' => [
                                        'src_type' => 'internal'
                                    ]
                                ]
                            ]
                        ],
                    ],
                    'functions' => $this->rankingFunction($key),
                    'score_mode' => 'sum',
                    'boost_mode' => 'multiply'
                ]
            ],
        ];

        // source
        if (isset($option['source']) && is_array($option['source'])) {
            $query['_source'] = $option['source'];
        }

        // response
        return $this->elastic->search($this->index, $query);
    }

    public function getIdsFromSearch($key, $option = []) {
        $option['source'] = ['id'];
        $response = $this->rawSearch($key, $option);
        $product_list = $response['hits']['hits']?? [];
        $product_ids = [];
        foreach ($product_list as $item) {
            $product_ids[] = $item['_source']['id'];
        }
        return $product_ids;
    }

    public function search($key, $option = []) {
        $response = $this->rawSearch($key, $option);
        $product_list = $response['hits']['hits']?? [];
        foreach ($product_list as &$item) {
            $item = $item['_source'];
        }
        return $product_list;
    }

    public function getBag($data, $bag_size, $bag = 0) {
        $bags = [];
        $max_item_same_type = $this->max_item_same_type;
        $max_jump = $this->max_jump;
        $len_data = count($data);
        $total_bag = ceil($len_data / $bag_size);
        $bag = min($bag, $total_bag - 1);
        $is_selected = [];
        $len_data_left = $len_data;
        $start_index = -1;
        for ($i=0; $i<=$bag; $i++) {
            $bags[$i] = [];
            $group_type_count = [];
            $len_current_bag = 0;
            $tmp_max_same_type = $max_item_same_type - 1;
            while (($len_current_bag < $bag_size) && ($len_data_left > 0)) {
                $tmp_max_same_type = $tmp_max_same_type + 1;
                $is_continue = true;
                for ($j=$start_index+1; $j<$len_data; $j++) {
                    if ($len_current_bag >= $bag_size) {
                        break;
                    }
                    if (empty($is_selected[$j])) {
                        $item = $data[$j];
                        $type = $item['_source'][$this->type_key];
                        if (empty($group_type_count[$type])) {
                            $group_type_count[$type] = 0;
                        }
                        if ($group_type_count[$type] < $tmp_max_same_type) {
                            $group_type_count[$type]++;
                            $is_selected[$j] = true;
                            $len_data_left--;
                            $len_current_bag++;
                            $bags[$i][] = $item;
                        }
                        else {
                            $is_continue = false;
                            if ($j - $start_index > $max_jump) {
                                break;
                            }
                        }
                        if ($is_continue) {
                            $start_index = $j;
                        }
                    }
                }
            }
            // $max_item_same_type = $tmp_max_same_type;
        }
        return $bags[$bag] ?? [];
    }

    // public function searchByIds($ids = [], $option = []) {
    //     if (isset($ids[0]) && is_array($ids[0])) {
    //         $ids = array_map(function($item) { return $item['_source']['id']; }, $ids);
    //     }
    //     $query = [
    //         'size' => count($ids),
    //         'query' => [
    //             'bool' => [
    //                 'must' => [
    //                     [
    //                         'terms' => [
    //                             'id' => $ids
    //                         ]
    //                     ]
    //                 ],
    //                 'filter' => [
    //                     [
    //                         'term' => [
    //                             'src' => $this->src
    //                         ]
    //                     ]
    //                 ]
    //             ]
                
    //         ],
    //         'sort' => [
    //             [
    //                 '_script' => [
    //                     'type' => 'number',
    //                     'script' => [
    //                         'lang' => 'painless',
    //                         'source' => "params.order.indexOf((int)doc['id'].value)",
    //                         'params' => [
    //                             'order' => $ids
    //                         ]
    //                     ],
    //                     'order' => 'ASC'
    //                 ]
    //             ]
    //         ]
    //     ];
    //     if (isset($option['source'])) {
    //         $query['_source'] = $option['source'];
    //     }
    //     $res = $this->elastic->search($this->index, $query);
    //     $product_list = $res['hits']['hits'] ?? [];
    //     foreach ($product_list as &$item) {
    //         $item = $item['_source'];
    //     }
    //     return $product_list;
    // }

    public function searchByIds($items = [], $option = []) {
        if ($items) {
            $order_dict = [];
            $ids = [];
            foreach ($items as $pos => $item) {
                $order_dict[$item['_id']] = $pos;
                $ids[] = $item['_id'];
            }

            $query = [
                'size' => count($ids),
                'query' => [
                    'ids' => [
                        'values' => $ids
                    ]
                    
                ]
            ];
            if (isset($option['source'])) {
                $query['_source'] = $option['source'];
            }
            $res = $this->elastic->search($this->index, $query);
            $product_list = $res['hits']['hits'] ?? [];

            usort($product_list, function ($first, $second) use ($order_dict) {
                return $order_dict[$first['_id']] - $order_dict[$second['_id']];
            });

            foreach ($product_list as &$item) {
                $item = $item['_source'];
            }

            return $product_list;
        }
        return [];
    }

    public function bestSearch($key, $option = []) {
        $source = $option['source'] ?? [];
        $limit = $option['limit'] ?? $this->limit;
        $offset = $option['offset'] ?? 0;
        $option['offset'] = 0;
        $option['limit'] = 1000;
        $option['source'] = ['id', $this->type_key];
        $res = $this->rawSearch($key, $option);
        $item_list = $this->getBag($res['hits']['hits']?? [], $limit, floor($offset / $limit));
        return $this->searchByIds($item_list, ['source' => $source]);
    }

    public function getIndexID($id) {
        return $this->src.'_'.$id;
    }

    public function getIndexData($item) {
        $data = [];

        return $data;
    }

    public function baseItemSQL() {
        // return " SELECT a.id,a.name,a.description,a.images,a.minorder,a.page_id,a.number,a.featured,a.taxonomy_id,a.promo,a.ismain,a.isimport,
        //     a.trademark,a.ordertime,a.views,u.name AS unit,
        //     a.status as product_status, p.status as page_status,
        //     p.name AS page, p.phone, p.page_name, p.date_start, p.package_end, p.logo, p.package_id, p.is_oem, p.is_verification, p.province_id,
        //     IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price ASC LIMIT 1), 0) AS pricemin,
        //     IFNULL((SELECT p.price FROM productprices p WHERE p.product_id=a.id ORDER BY p.price DESC LIMIT 1), 0) AS pricemax
        //     FROM products a
        //     LEFT JOIN pages p ON p.id=a.page_id
        //     LEFT JOIN taxonomy u ON u.id=a.unit_id AND u.type='product_unit'";
        return "";
    }

    public function update($id) {
        $sql = $this->baseItemSQL()." AND id={$id} LIMIT 1";
        $product = $this->db->fetch_one($sql);
        if ($product['product_status'] && $product['page_status']) {
            $this->elastic->update($this->index, $this->getIndexData($product), $this->getIndexID($id));
        }
        else {
            $this->remove($id);
        }
    }

    public function remove($id) {
        $this->elastic->remove($this->index, $this->getIndexID($id));
    }

    public function removeNotActive() {
        // remove product in page not active
        
        $sql = "SELECT id FROM pages WHERE status <> 1";
        $pages = $this->db->fetch_all($sql);

        foreach ($pages as $page) {
            $this->elastic->removeByQuery($this->index, [
                'query' => [
                    'bool' => [
                        'must' => [
                            [
                                'term' => [
                                    'page_id' => $page['id']
                                ]
                            ]
                        ],
                        'filter' => [
                            [
                                'term' => [
                                    'src' => $this->src
                                ]
                            ]
                        ]
                    ]
                ]
            ]);
        }

        // remove product not active, chia nho job ra
        // query theo da dong bo hay chua, ko rat nhieu viec

        $sql = "SELECT id FROM products WHERE status <> 1";
        $products = $this->db->fetch_all($sql);

        foreach ($products as $product) {
            $this->remove($product['id']);
        }
    }

    public function updateAll($page = 1) {
        $page = intval($page);
        $limit = $this->bucket_size;
        $offset = ($page - 1) * $limit;

        $sql = $this->baseItemSQL()." WHERE a.status=1 AND p.status=1 ORDER BY a.id ASC LIMIT {$offset}, {$limit}";
        $result = $this->pdo->fetch_all($sql);

        foreach ($result as $item) {
            $this->elastic->update($this->index, $this->getIndexData($item), $this->getIndexID($item['id']));
        }

        return count($result);
    }

    public function buildIndex() {
        // xây cấu trúc index
        // loại bỏ phân biệt không dấu, có dấu
    }
    
    // HỆ THỐNG LOGGING LAST UPDATE
    // HẸ THỐNG LẬP LỊCH
    // HÀM TẠO INDEX

}