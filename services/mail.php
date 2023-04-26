<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

//file_put_contents('./test_letters/'.time().'.log',$msg, FILE_APPEND);
$_fileName=time();

	$msg=file_get_contents("php://stdin");

	//$msg=file_get_contents("/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/1491298593.log");

	file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', $msg, FILE_APPEND);
	chmod('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', 0755);

	ob_start();

if( !empty( $msg ) ){
	list($header, $body) = explode("\n\n", $msg, 2);
}else{
	$header=$body='';
}
$frommail = $tomail = '';
$headerArr = explode("\n", $header);
foreach ($headerArr as $str) {
  if (strpos($str, 'To:') === 0) {
	$tomail = $str;
  }
  if (strpos($str, 'From:') === 0) {
	$frommail = $str;
  }
}
$tomail=trim( $tomail );
$frommail=trim( $frommail );
preg_match( "/\b([a-z0-9._-]+@[a-z0-9.-]+)\b/i", $tomail, $_mathch );
if( isset( $_mathch[0] ) ){
	$data['letterid']=substr( $_mathch[0], 0, strrpos( $_mathch[0], '@' ) );
}
preg_match( "/\b([a-z0-9._-]+@[a-z0-9.-]+)\b/i", $frommail, $_mathch );
if( isset( $_mathch[0] ) ){
	$data['email']=$_mathch[0];
}
$data['name']='';
if( strpos( $frommail, '"' ) !== false ){
	$data['name']=substr( $frommail, strpos( $frommail, '"' )+1, stripos( $frommail, '"' )-strpos( $frommail, '"' )-1 );
}elseif( empty( $data['name'] ) ){
	$data['name']=substr( $data['email'], 0, stripos( $data['email'], '@' ) );
}

file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\n".serialize( $data ), FILE_APPEND);

$data['message']=$msg;

//var_dump( strlen( $data['letterid'] ) == 32 );



if( strlen( $data['letterid'] ) == 32 ){
	chdir( dirname(__FILE__) );
	chdir( '../' );
	try{
		require_once './library/WorkHorse.php'; // starter
		WorkHorse::shell();
		$obj=new Project_Mooptin_Autoresponders();
		$obj->sendAutorespond( $data );
	}catch( Exception $e ) {
		file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\nError: ".$e->getMessage(), FILE_APPEND);
	}
}

//var_dump( 'end' );

	$out = ob_get_contents();
	ob_end_clean();

	file_put_contents('/data/www/'.Zend_Registry::get( 'config' )->domain->host.'/html/services/test_letters/'.$_fileName.'.log', "\n\n".$out, FILE_APPEND);
