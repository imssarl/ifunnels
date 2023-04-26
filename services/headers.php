<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT');

$path = join(DIRECTORY_SEPARATOR, [__DIR__, '..', 'usersdata', 'temp', 'log_files']);

file_put_contents($path . DIRECTORY_SEPARATOR . date("d-m-Y", time()) . "_headers.log", json_encode(getallheaders()) . PHP_EOL, FILE_APPEND);