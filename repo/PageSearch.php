<?php

namespace Repo;

class PageSearch extends \Repo\Main {

    protected $limit = 20;  
    protected $index = 'search-products';
    protected $src = SITE_SRC_NAME;

    protected $elastic;

    protected function __construct() {
        parent::__construct();
        $this->elastic = \Lib\Elasticsearch::instance();
    }

    protected function rankingFunction($key) {
        return [
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
            [
                'filter' => [
                    'term' => [
                        'pagefee' => 1
                    ]
                ],
                'weight' => 1
            ],
        ];

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

        // location
        if (isset($input['a_province'])) {
            $option['location_ids'] = $input['a_province'];
        }

        if (isset($input['gold'])) {
            $option['pagefee'] = $input['gold'];
        }

        return $option;
    }

    public function getIdsFromSearch($key, $option = []) {
        $key = mb_strtolower(trim(preg_replace('#\s+#', ' ', $key)), 'utf-8');
        $key_wildcard = '*'.str_replace(' ', '*', $key).'*';

        // $url_query = 'filter_path=aggregations.shop.buckets.detail.hits.hits._source.metas.page_id,aggregations.shop.buckets.product_count';
        $url_query = 'filter_path=aggregations.shop.buckets.detail.hits.hits._source.metas.page_id';

        $_option = [
            'offset' => 0,
            'limit'=> 1000
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
        
        // is verify
        if (!empty($option['is_verify'])) {
            $where[] = [
                'term' => [
                    'pageverify' => 1
                ]
            ];
        }

        // is oem
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
            'size' => 0,
            '_source' => [],
            'query' => [
                'function_score' => [
                    'query' => [
                        'bool' => [
                            'must' => [
                                [
                                    'bool' => [
                                        'should' => [
                                            [
                                                'wildcard' => [
                                                    'metas.page' => [
                                                        'value' => $key_wildcard,
                                                    ]
                                                ]
                                            ],
                                            [
                                                'match_phrase_prefix' => [
                                                    'metas.page' => [
                                                        'query' => $key,
                                                        'slop' => 3
                                                    ]
                                                ]
                                            ],
                                            [
                                                'match_phrase_prefix' => [
                                                    'name' => [
                                                        'query' => $key,
                                                        'slop' => 3,
                                                        'boost' => 100
                                                    ]
                                                ]
                                            ]
                                        ]
                                    ]
                                ],
                                ...$where
                            ],
                            'filter' => [
                                [
                                    'term' => [
                                        'src' => $this->src
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
            'aggs' => [
                'shop' => [
                    'terms' => [
                        'field' => 'metas.page_id',
                        'size' => $option['limit']
                    ],
                    'aggs' => [
                        'detail' => [
                            'top_hits' => [
                                'size' => 1,
                                '_source' => [
                                    'includes' => ['metas.page_id']
                                ]
                            ]
                        ],
                        // 'product_count' => [
                        //     'value_count' => [
                        //         'field' => 'metas.page_id'
                        //     ]
                        // ]
                    ]
                ]
            ]
        ];

        // source
        if (isset($option['source']) && is_array($option['source'])) {
            $query['_source'] = $option['source'];
        }

        // response
        $res = $this->elastic->search($this->index, $query, $url_query);
        $res = $res['aggregations']['shop']['buckets']?? [];

        $ids = [];
        foreach ($res as $item) {
            $ids[] = $item['detail']['hits']['hits'][0]['_source']['metas']['page_id'];
        }

        return $ids;
    }

}