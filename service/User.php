<?php

namespace Service;

class User extends \Service\Main {

    public function __construct() {
        $this->repo = \Repo\User::instance();
    }

    public function register($data = []) {
        $user = null;
        if (!empty($data['email'])) {
            $user = $this->repo->getByEmail($data['email'], 'id');
        }
        if (!$user && !empty($data['username'])) {
            $user = $this->repo->getByUsername($data['username'], 'id');
        }

        if ($user) {
            // update password ....
            if (!empty($data['password'])) {
                $this->repo->update('id='.$user['id'], [
                    'password' => $data['password']
                ]);
            }
        }
        else {
            $this->repo->create($data);
        }
    }
}