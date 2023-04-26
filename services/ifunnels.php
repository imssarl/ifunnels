<?php
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT');
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir( dirname(__FILE__) );
chdir( '../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
ob_start();

if(isset($_POST['_hiddenInputSiteID'])){
	$_mailer=new Core_Mailer();
	$_mailer
		->setVariables( array('fields' => $_POST) )
		->setTemplate( 'ifunnel_emailto' )
		->setSubject( $_POST['_subject'] )
		->setPeopleTo( array( 'email'=>$_POST['_emailto'], 'name'=> 'iFunnels Module' ) )
		->setPeopleFrom( array( 'name' => Zend_Registry::get('config')->engine->project_sysemail->name, 'email' => Zend_Registry::get('config')->engine->project_sysemail->email ) )
		->sendOneToMany();
	$_outError = ob_get_contents();
	if( !empty( $_outError ) ){
		$_writer=new Zend_Log_Writer_Stream( Zend_Registry::get('config')->path->absolute->logfiles.'Project_hiddenInputSiteID.log' );
		$_writer->setFormatter( new Zend_Log_Formatter_Simple("%timestamp% %priorityName% (%priority%): %message%\r\n") );
		$_logger=new Zend_Log( $_writer );
		$_logger->info($_outError);
	}
	ob_end_clean();
	echo json_encode(array( 'success' ));
	exit();
}

$_mooptinId = Core_Payment_Encode::decode( $_REQUEST['id'] );
$_REQUEST['id'] = $_mooptinId[0];

if (!empty($_SERVER["HTTP_CLIENT_IP"])) {
	$ip = $_SERVER["HTTP_CLIENT_IP"];
} elseif (!empty($_SERVER["HTTP_X_FORWARDED_FOR"])) {
	$ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
} else {
	$ip = $_SERVER["REMOTE_ADDR"];
}

$_REQUEST['ip'] = $ip;

$obj=new Project_Mooptin_Autoresponders();
$obj->sendAutorespond( $_REQUEST, $arrCallback );

$out = ob_get_contents();
ob_end_clean();
echo substr($out, 1, strlen($out) - 2);

?>