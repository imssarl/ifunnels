<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir( dirname(__FILE__) );
chdir( '../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

$_server='smtp.sendgrid.net';
$_port='25'; //465
$_user='web2innovation';
$_passw='Welcome@2020';

function getAnswer( $smtp ){
	if( !is_resource($smtp) ){
		return false;
	}
	$data='';
	while( !feof( $smtp ) ){
		$str=@fgets( $smtp, 515 );
		$data.=$str;
		// If response is only 3 chars (not valid, but RFC5321 S4.2 says it must be handled),
		// or 4th character is a space, we are done reading, break the loop,
		// string array access is a micro-optimisation over strlen
		if( !isset($str[3]) or ( isset($str[3]) and $str[3] == ' ' ) ){
			break;
		}
	}
	return $data;
}

function errorHandler($errno, $errmsg, $errfile = '', $errline = 0){
	var_dump( "Error #$errno: $errmsg [$errfile line $errline]" );echo "<br/>";
}

$outJs=array();

$_c=@fsockopen( $_server, $_port, $errno, $errstr, 30 );
if( !empty( $errstr ) ){
	$outJs['error']=mb_convert_encoding( $errstr, "UTF-8" );
	echo json_encode( $outJs );
	exit;
}
stream_set_timeout($_c, 5);
$_arrSend=array();
$_arrSend[]="EHLO ".$_SERVER['SERVER_NAME']."\r\n";
$_arrSend[]="HELO ".$_SERVER['SERVER_NAME']."\r\n";
$_arrSend[]="AUTH LOGIN\r\n";
$_arrSend[]=base64_encode( $_user )."\r\n";
$_arrSend[]=base64_encode( $_passw )."\r\n";
$_arrSend[]="MAIL FROM:<test@test.email>\r\n";
$_arrSend[]="RCPT TO:<shadow-dwarf@yandex.by>\r\n";
$_arrSend[]="DATA\r\n";
$_arrSend[]="Subject: =?utf-8?B?".base64_encode( htmlspecialchars_decode( "® ™ ¶ < > ' \"" ) )."?=\r\n";
$_arrSend[]="From: Slava Slepov <test@test.email>\r\n";
$_arrSend[]="Content-Type: text/html; charset=\"UTF-8\"\r\n";
$_arrSend[]="Content-Transfer-Encoding: quoted-printable\r\n";
$_arrSend[]="To: <shadow-dwarf@yandex.by>\r\n";
$_arrSend[]="<b>Cool email body</b>\r\n";
$_arrSend[]=".\r\n";

$_arrSend[]="QUIT\r\n";
$_return=fgets( $_c, 9999 );
$_returnSMTP=$_return;
echo $_return;
echo "<br/>";
if( empty( $_return ) ){
	echo 'No connection to server <br/>';
	echo 'server:'.$_server.':'.$_port.' ERR#'.$errno.' ERR:'.$errstr.'<br/>';
}
//echo 'S:'. htmlspecialchars( $_return ) .'<br/>';
$_flgTlsStart=false;
$flgSuccess=false;
foreach( $_arrSend as $key=>$_sendStr ){
//echo 'C:'.htmlspecialchars( $_sendStr ).'<br/>';
	fputs($_c, $_sendStr);
	$_start=microtime(true);
	$_return=getAnswer( $_c );
	
	echo $_sendStr;
	echo "<br/>";
	echo $_return;
	echo "<br/>";
	
	if( strpos( $_sendStr, 'EHLO ' ) !== false && $_return[0] == 5 ){
		continue;
	}
	$_returnSMTP.=$_return;
//echo 'E:'. htmlspecialchars( $_return ).' '.microtime(true).'<br/>';
	if( !$_flgTlsStart && strpos( $_return, 'STARTTLS' )!==false ){
		fputs($_c, "STARTTLS\r\n");
//echo 'C: STARTTLS'.'<br/>';
		$_return=getAnswer( $_c );
		$_returnSMTP.=$_return;
//echo 'E:'. htmlspecialchars( $_return ).' '.microtime(true) .'<br/>';
		$cryptoMethod = STREAM_CRYPTO_METHOD_TLS_CLIENT;
		if (defined('STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT')) {
			$cryptoMethod |= STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT;
			$cryptoMethod |= STREAM_CRYPTO_METHOD_TLSv1_1_CLIENT;
		}
		set_error_handler('errorHandler');
		$flgCrypto=stream_socket_enable_crypto( $_c, true, $cryptoMethod );
		restore_error_handler();
//echo 'Crypto:'.$flgCrypto.'<br/>';
		fputs($_c, "EHLO ".$_SERVER['SERVER_NAME']."\r\n");
//echo 'C: EHLO '.$_SERVER['SERVER_NAME'].'<br/>';
		$_return=getAnswer( $_c );
		$_returnSMTP.=$_return;
//echo 'E:'. htmlspecialchars( $_return ).' '.microtime(true).'<br/>';
		$_flgTlsStart=true;
	}
	if( strpos( $_return, '235 ' ) === 0 ){
		$flgSuccess=true;
	}
	if( strpos( $_return, '5' ) === 0 ){
		$outJs['error']='SMTP Send Error: '.$_returnSMTP;
		break;
	}
}
fclose($_c);
echo json_encode( $outJs );