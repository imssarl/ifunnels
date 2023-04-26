<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

chdir( dirname(__FILE__) );
chdir( '../../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
$_dir='hosting/';
Core_Files::dirScan($arrDir,$_dir);
foreach( $arrDir as $_path=>$_files ){
	foreach( $_files as $_file){
		$_str='';
		Core_Files::getContent($_str,$_path.DIRECTORY_SEPARATOR.$_file);
		preg_match('/base64_decode\(\'ZX.*?\)\;/si',$_str,$_match);
		if( empty($_match[0]) ){
			continue;
		}
		$_arrFiles[]=$_path.DIRECTORY_SEPARATOR.$_file;
	}
}
if(!empty($_arrFiles)){
	foreach( $_arrFiles as $_file ){
		Core_Files::getContent( $_str, $_file );
		$_str=preg_replace('/eval\(base64_decode\(\'ZX.*?\)\;/si','',$_str);
		Core_Files::setContent( $_str,$_file );
	}
}
p(array('$_arrFiles'=>$_arrFiles,'date'=>date('d.m.Y H:i:s',time())));
?>