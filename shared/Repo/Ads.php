<?php

namespace Repo;

class Ads extends \Repo\Main {

    public function getMonthPointUsed($page_id) {

        $sql = "SELECT SUM(score) as val
            FROM adsclicks cl
            INNER JOIN adscampaign ca ON ca.id = cl.campaign_id
            WHERE
            (
                cl.date_click >= DATE_FORMAT(NOW(), '%Y-%m-01')
                AND
                cl.date_click < DATE_FORMAT(NOW() + INTERVAL 1 MONTH, '%Y-%m-01')
            )
            AND cl.page_id = ".intval($page_id);

        return $this->db->fetch_one($sql)['val'];
    }

    public function getMonthCampaignPointUsed($page_id) {

        $sql = "SELECT SUM(score_total) as val
            FROM adscampaign
            WHERE
            (
                date_start >= DATE_FORMAT(NOW(), '%Y-%m-01')
                AND
                date_start < DATE_FORMAT(NOW() + INTERVAL 1 MONTH, '%Y-%m-01')
            )
            AND status = 1
            AND page_id = ".intval($page_id);

        return $this->db->fetch_one($sql)['val'];
    }

}