<?php

namespace Service;

class Ads extends \Service\Main {

    // public function click($product_id, $user_id = 0, $option = []) {
    //     $campaign_id = $option['campaign_id'] ?? 0;
    //     $token =  $option['token'] ?? '';
    // }

    public function resetDailyPoint() {
        $db = \Lib\DB::instance();
        $check_sql = "SELECT IF((SELECT date_click FROM adsclicks ORDER BY id DESC LIMIT 1)=DATE(NOW()), 0, 1) AS is_update";
        $is_update = $db->fetch_one($check_sql)['is_update'];
        if ($is_update) {
            $db->update('adscampaign', ['score_daily_used' => 0], 'score_daily_used > 0');
        }
    }
}