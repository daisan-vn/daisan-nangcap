<?php
define('FILE_NAME', __DIR__ . "/logger.txt");

file_put_contents(FILE_NAME, file_get_contents(FILE_NAME) . "\n----\n" . time());
