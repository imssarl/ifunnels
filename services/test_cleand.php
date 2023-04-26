<?php
chdir( dirname(__FILE__) );
chdir( '../' );
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
error_reporting(E_ALL);


p( Zend_Registry::get( 'config' )->domain->url );

if( !isset( $argv[1] ) ){
	$argv[1]=1;
}else{
	$argv[1]++;
}
if( $argv[1] == 100 ){
	exit;
}
var_dump( $argv[1] );

var_dump( pcntl_exec( $_SERVER['_'], $argv) );