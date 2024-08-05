<?php

namespace Lib\Core;

class Api {

    use \Lib\Singleton;

    public function get_array($obj, array $post_value, $method=URL_API_MAIN){
        $a_obj = explode('#', $obj);
        $url = $method.'?mod='.$a_obj[0].'&site='.$a_obj[1];
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_POST, 1);
        if(is_array($post_value)) curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($post_value));
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        $result = curl_exec($curl);
        curl_close($curl);
        $result = json_decode($result, true);
        if(!is_array($result)) $result = [];
        return $result;
    }
    
    public function get_str($obj, array $post_value, $method=URL_API_MAIN){
        $a_obj = explode('#', $obj);
        $url = $method.'?mod='.$a_obj[0].'&site='.$a_obj[1];
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_POST, 1);
        if(is_array($post_value)) curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($post_value));
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        $result = curl_exec($curl);
        curl_close($curl);
        return $result;
    }
    
    public function check_debug($obj, array $post_value, $method=URL_API_MAIN){
        $a_obj = explode('#', $obj);
        $url = $method.'?mod='.$a_obj[0].'&site='.$a_obj[1];
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_POST, 1);
        if(is_array($post_value)) curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($post_value));
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        $result = curl_exec($curl);
        curl_close($curl);
        var_dump($result);
    }


    //max excute 30 url/1s
    public function get_data_actor_apify($lst_urls){
        // $ch = curl_init();
        // curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        // curl_setopt($ch, CURLOPT_URL,$url);
        // $result=curl_exec($ch);
        // curl_close($ch);

        // $array = json_decode($result, true);

        // return $array;
        $totalUrl = count($lst_urls);
        $curl_arr = [];
        $master = curl_multi_init();

        for($i = 0; $i < $totalUrl; $i++)
        {
            $url = $lst_urls[$i];
            $curl_arr[$i] = curl_init($url);
            curl_setopt($curl_arr[$i], CURLOPT_RETURNTRANSFER, true);
            curl_multi_add_handle($master, $curl_arr[$i]);
        }
        do {
            curl_multi_exec($master, $running);
        } while($running > 0);

        for($i = 0; $i < $totalUrl; $i++)
        {
            $results[] = curl_multi_getcontent($curl_arr[$i]);
            // $arr_rs = array_merge($arr_rs, $results);
        }
        return $results;
    }
}