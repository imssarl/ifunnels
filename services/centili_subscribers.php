<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

$_fields=array( 'id', 'aggregator', 'status', 'errormessage', 'event_type', 'clientid', 'revenuecurrency', 'phone', 'amount', 'service', 'transactionid', 'enduserprice', 'country', 'mno', 'mnocode', 'revenue', 'interval', 'opt_in_channel', 'sign', 'userid', 'added' );

$_keys=$_vars=array();

$sql_link=mysql_connect('localhost', 'track_cnm', 'fArQAet_1w');
$sql_db=mysql_select_db('track_cnm', $sql_link);
//$sql_link=mysql_connect('localhost', 'root', 'root');
//$sql_db=mysql_select_db('db_cnm', $sql_link);

foreach( $_fields as $_field ){
	if( isset( $_GET[$_field] ) ){
		$_keys[]=$_field;
		$_vars[]=mysql_real_escape_string( $_GET[$_field] );
	}
}
$_keys[]='added';
$_vars[]=time();
$_keys[]='aggregator';
$_vars[]='centili';

if( !empty( $_keys ) ){
	$result=mysql_query( 'INSERT INTO billing_aggregator (`'.implode('`,`', $_keys ).'`) VALUES (\''.implode('\',\'', $_vars ).'\')' );
}

mysql_close( $sql_link );

if( isset( $_GET['status'] )
	&& isset( $_GET['event_type'] )
	&& $_GET['status'] == 'success'
	&& $_GET['event_type'] == 'opt_in'
){
	if( isset( $_GET['revenue'] )
		&& isset( $_GET['clientid'] )
		&& !empty( $_GET['revenue'] )
		&& !empty( $_GET['clientid'] )
		&& $_GET['revenue'] != 0
	){
		$_link='http://www.igo.pe/aff_lsr?offer_id=190&adv_sub=CENTILI&amount='.@urlencode( $_GET['revenue'] ).'&transaction_id='.@urlencode( $_GET['clientid'] );
		if( $_GET['test'] === 'true' ){
			echo( $_link. "<br/>" );
		}else{
			$ch=curl_init();
			curl_setopt($ch, CURLOPT_URL, $_link);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($ch, CURLOPT_HEADER, 0);
			/*$output = */curl_exec($ch);
			curl_close($ch);
		}
	}
	if( isset( $_GET['phone'] ) 
		&& !empty( $_GET['phone'] ) 
	){
		$_link='https://zapier.com/hooks/catch/ocdoqb/?phone='.@urlencode( $_GET['phone'] );
		if( $_GET['test'] === 'true' ){
			echo( $_link. "<br/>" );
		}else{
			$ch=curl_init();
			curl_setopt($ch, CURLOPT_URL, $_link);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($ch, CURLOPT_HEADER, 0);
			/*$output = */curl_exec($ch);
			curl_close($ch);
		}
	}
	header("HTTP/1.1 200 OK");
	exit;
}
header("HTTP/1.1 404 Not Found");
exit;
?>