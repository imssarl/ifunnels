<?php
exit();
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir( dirname(__FILE__) );
chdir( '../' );
if( empty( $_GET['ip'] ) ){
	die('error');
}
require_once 'library/GeoIp/autoload.php';
$client=new GeoIp2\WebService\Client( 77745, 'HNIIHNQHXP9F' );
$record=$client->city($_GET['ip']);
$_data=array();
if( isset( $_GET['city'] ) && !empty( $_GET['city'] ) ){
	$_data[]=$record->city->name;
}
if( isset( $_GET['country'] ) && !empty( $_GET['country'] ) ){
	$_arrCountries=explode( ':', $_GET['country'] );
	$_flgShow0=false;
	$_subdivision=( ( is_int( @$record->subdivisions[0]->geonameId ) && @$record->subdivisions[0]->geonameId != 0 )?$record->subdivisions[0]->geonameId:0);
	foreach( $_arrCountries as $_country ){
		if( $_country == $record->country->isoCode.( ( $_subdivision != 0 )?".".$_subdivision:'') ){
			$_data[]='0';
			$_flgShow0=true;
			break;
		}
	}
	if( $_flgShow0 ){
		$_data[]=$_subdivision;
	}else{
		$_data[]=$record->country->isoCode;
		$_data[]=$_subdivision;
	}
}
echo( implode( ':', $_data ) );
exit;
?>