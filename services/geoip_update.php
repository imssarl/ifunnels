<?php
chdir( dirname(__FILE__) );
chdir( '../' );
set_time_limit(0);
ignore_user_abort(true);
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
error_reporting(E_ALL);
ini_set('display_startup_errors',1);
ini_set('display_errors',1);


//Core_Sql::setConnectToServer( 'syndication.qjmpz.com' );
//var_dump( ip2long('37.214.34.224'), Core_Sql::getKeyRecord('SELECT * FROM getip_countries2ip WHERE ip_start <= ' . ip2long('37.214.34.224') . ' AND ' . ip2long('37.214.34.224') . ' <= ip_end') );

if( empty( $_POST['code'] ) || $_POST['code']!='HNIIHNQHXP9F' ){
	echo '<form method="post" action="" enctype="multipart/form-data"><input type="file" name="csv" /><input type="text" name="code" /><input type="checkbox" name="flg_clean" value="1" />clean<button type="submit" >Update</button></form>';
	exit;
}

try{
	Core_Sql::setConnectToServer( 'syndication.qjmpz.com' );
	// список стран
	//=========
	if( $_POST['flg_clean'] == 1 ){
		Core_Sql::setExec( "TRUNCATE `getip_countries2ip`;" );
		Core_Sql::setExec( "ALTER TABLE `getip_countries2ip` CHANGE COLUMN `ip_start` `ip_start` BIGINT UNSIGNED NULL DEFAULT '0' AFTER `id`, CHANGE COLUMN `ip_end` `ip_end` BIGINT UNSIGNED NULL DEFAULT '0' AFTER `ip_start`;" );
	}
	$_countries=Core_Sql::getKeyVal('SELECT * FROM getip_countries');

	$_arrImport=array();
	$filename = Core_Files::getBaseName( $_FILES['csv']['name'] );
	$tmppath = Zend_Registry::get('config')->path->absolute->user_files.'temp/'.$filename;
	if( copy( $_FILES['csv']['tmp_name'], $tmppath ) ){
		$_time=time();
		if( ( $handle = fopen( $tmppath , "r") ) !== false ){
			// парсим csv в массив
			$_arrSaveList=array_map('str_getcsv', file( $tmppath ));
			foreach( $_arrSaveList as $_data ){
				$_countryName=$_data[3];
				if( $_countryName == '-' ){
					$_countryName="Undefined";
				}
				if( strpos( $_countryName, ',' ) !== false ){
					$_cArr=explode( ',', $_countryName );
					$_countryName=trim( $_cArr[1] ).' '.trim( $_cArr[0] );
				}
				$_countryId=array_search( $_countryName, $_countries );
				if( empty( $_countryId ) ){
					$_countryId=Core_Sql::setInsert( 'getip_countries', array('name'=>$_countryName ) );
					$_countries[$_countryId]=$_countryName;
				}
				$_arrImport[]='('.$_data[0].','.$_data[1].','.$_countryId.')';
				if( count( $_arrImport ) == 100 ){
					Core_Sql::setExec( 'INSERT INTO `getip_countries2ip` (`ip_start`,`ip_end`,`country_id`) VALUES '.implode(',',$_arrImport) );
					$_arrImport=array();
				}
			}
			Core_Sql::setExec( 'INSERT INTO `getip_countries2ip` (`ip_start`,`ip_end`,`country_id`) VALUES '.implode(',',$_arrImport) );
		}
		
	}
	unlink( $tmppath );

	//=========
Core_Sql::renewalConnectFromCashe();
} catch(Exception $e){
	
	p( $e );
	
	Core_Sql::renewalConnectFromCashe();
}

?>