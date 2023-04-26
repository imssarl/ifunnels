<?php

/**
 * WorkHorse Framework
 *
 * @category WorkHorse
 * @package Core_Module
 * @license http://opensource.org/licenses/ MIT License
 * @copyright Copyright (c) 2005-2010, Rodion Konnov
 * @author Rodion Konnov <kindzadza@mail.ru>
 * @date 24.02.2010
 * @version 6.5
 */


/**
 * Site starter
 *
 * @category WorkHorse
 * @package Core_Module
 * @copyright Copyright (c) 2005-2010, Rodion Konnov
 * @license http://opensource.org/licenses/ MIT License
 */
error_reporting(E_ALL);
ini_set('display_errors', '1');
header('X-XSS-Protection: 1');

/**
 * т.к. старый код кривой Magic Quotes влючены иначе он будет безбожно глючить
 * код движка работает с отключенными Magic Quotes посему программно чистим
 * массивы от них.
 *
 * @return void
 */
 if( isset($_REQUEST['function']) && $_REQUEST['function'] == 'call_user_func_array' ){
	header( 'HTTP/1.0 404 Not Found' );
	exit;
}
if (get_magic_quotes_gpc()) {
	function magicQuotes_awStripslashes(&$value, $key) {$value = stripslashes($value);}
	$gpc = array(&$_GET, &$_POST, &$_COOKIE, &$_REQUEST);
	array_walk_recursive($gpc, 'magicQuotes_awStripslashes');
}
header( "HTTP/1.0: 200 OK\n" );
if (version_compare(phpversion(), '5.6.0', '<')===true) {
	echo '<div style="margin:80px 40px 70px 200px;">Whoops, it looks like you have an invalid PHP version. Wh supports PHP 5.6.0 or newer.</div>';
	exit;
}
//$_t1=xdebug_time_index();
$_GLOBALS['sql_log']=array();
require_once './library/WorkHorse.php'; // starter
WorkHorse::run();
//$_t2=xdebug_time_index();
//echo $_t2-$_t1;

//echo "<br data='".var_export( $_GLOBALS['sql_log'] )."'>";

?>