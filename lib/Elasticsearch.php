<?php

namespace Lib;

class Elasticsearch {

    use \Lib\Singleton;

    public function http($type, $path, $data = []) {

        $ch = curl_init();
        $url = rtrim(ELASTIC_URL, '/').'/'.ltrim($path, '/');
        
        switch ($type) {
            case 'POST':
                curl_setopt($ch, CURLOPT_POST, true);
                if (is_string($data)){
                    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
                }
                elseif (is_array($data)) {
                    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
                }
                break;
            case 'PUT':
                if ($data) {
                    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));			 					
                }
                break;
            // default:
            //     if ($data) {
            //         $url = sprintf('%s?%s', $url, http_build_query($data));
            //     }
        }
                
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $type);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);

        if (ELASTIC_AUTH_TYPE == 'API') {
            curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Bearer ' . ELASTIC_API]);
        }
        else {
            curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
            curl_setopt($ch, CURLOPT_USERPWD, ELASTIC_USER.':'.ELASTIC_PASS);
        }

        $response = curl_exec($ch);

        if (curl_errno($ch)) {
            return false;
        } else {
            return json_decode($response, true);
        }

        curl_close($ch);
    }

    // public function getClient() {
    //     require_once '../../vendor/autoload.php';
    //     return \Elastic\Elasticsearch\ClientBuilder::create()->setHosts([ELASTIC_URL])->setApiKey(ELASTIC_API)->build();
    // }

    public function get($index, $id = '', $param = []) {
        return $this->http('GET', '/'.$index.'/_doc' . $id, $param);
    }

    public function get_count($index, $param = []) {
        return $this->http('GET', '/'.$index.'/_count', $param);
    }

    public function getByQuery($index, $param = []) {
        return $this->http('POST', '/'.$index.'/_search', $param);
    }

    public function create($index, $data = [], $id = '') {
        $this->http('POST', '/'.$index.'/_doc' . ($id? '/'.$id: ''), $data);
    }

    public function update($index, $data = [], $id) {
        $this->http('POST', '/'.$index.'/_doc/'.$id, $data);
    }

    public function updateByQuery($index, $query = [], $conflicts = 'proceed') {
        $this->http('POST', '/'.$index.'/_update_by_query?conflicts='.$conflicts, $query);
    }

    public function remove($index, $id) {
        $this->http('DELETE', '/'.$index.'/_doc/'.$id);
    }

    public function removeByQuery($index, $query = []) {
        $this->http('POST', '/'.$index.'/_delete_by_query', $query);
    }

    public function search($index, $param = []) {
        $data = $this->http('POST', '/'.$index.'/_search', $param);
        return is_array($data) ? $data : [];
    }

    public function search_all_total($index, $param = []) {
        $data = $this->http('POST', '/'.$index.'/_search?scroll=1m', $param);
        return is_array($data) ? $data : [];
    }

    public function _bulk($data){
        return $this->http('POST', '/_bulk' , $data);
    }

    public function putSettings($data){
        return $this->http('PUT', '_settings', $data);
    }
}