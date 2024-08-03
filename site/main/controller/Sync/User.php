<?php

class SyncUser {

    public function register() {
        $data = \Request::postAll();

        $user_service = \Service\User::instance();
        $user_service->register($data);
    }
}