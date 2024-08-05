<?php

namespace Lib\DB;

class Help {

    public static function get_like_case($field, $key, $score = 1, $prefix = true, $postfix = true) {
        return ' WHEN '.$field. " LIKE '".($prefix? '%': '').$key.($postfix? '%': '')."' THEN ".$score. ' ';
    }
     
    public static function get_like_query($field, $key) {
        $words = array_filter(explode(' ', $key), function($item) { return !empty($item); });
        $len_words = count($words);
        
        $like_query_list = [];
        $score_idx = 0;
    
        // if ($len_words > 3) {
        //     for ($i=0; $i<$len_words-3; $i++) {
        //         $t_key = $words[$i]. ' '.$words[$i+1]. ' '.$words[$i+2]. ' '.$words[$i+3];
        //         $t_query_list = [];
        //         if ($i == 0) {
        //             $t_query_list[] = self::get_like_case($field, $t_key, 1.5, false);
        //         }
        //         $t_query_list[] = self::get_like_case($field, $t_key, 1);
        //         $like_query_list[] = ' (CASE ' .implode(' ', $t_query_list). ' ELSE 0 END) AS X'.$score_idx++;
        //     }
        // }
    
        if ($len_words > 2) {
            for ($i=0; $i<$len_words-2; $i++) {
                $t_key = $words[$i]. ' '.$words[$i+1]. ' '.$words[$i+2];
                $t_query_list = [];
                // if ($i == 0) {
                //     $t_query_list[] = self::get_like_case($field, $t_key, 1.5, false);
                // }
                $t_query_list[] = self::get_like_case($field, $t_key, 1);
                $like_query_list[] = ' (CASE ' .implode(' ', $t_query_list). ' ELSE 0 END) AS X'.$score_idx++;
            }
        }
        
        if ($len_words > 1) {
            for ($i=0; $i<$len_words-1; $i++) {
                $t_key = $words[$i]. ' '.$words[$i+1];
                $t_query_list = [];
                // if ($i == 0) {
                //     $t_query_list[] = self::get_like_case($field, $t_key, 1.5, false);
                // }
                $t_query_list[] = self::get_like_case($field, $t_key, 1);
                $like_query_list[] = ' (CASE ' .implode(' ', $t_query_list). ' ELSE 0 END) AS X'.$score_idx++;
            }
        }
    
        for ($i=0; $i<$len_words; $i++) {
            $t_key = $words[$i];
            $t_query_list = [];
            if ($i == 0) {
                $t_query_list[] = self::get_like_case($field, $t_key, 1.5, false);
            }
            $t_query_list[] = self::get_like_case($field, $t_key, 1);
            $like_query_list[] = ' (CASE ' .implode(' ', $t_query_list). ' ELSE 0 END) AS X'.$score_idx++;
        }
    
        $score_label_list = [];
        for ($i=0; $i<$score_idx; $i++) {
            $score_label_list[] = 'X'.$i;
        }
    
        return [
            'query' => implode(",\n", $like_query_list),
            'score' => '('.implode('+', $score_label_list).')',
        ];
    }
}
