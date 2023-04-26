<?php
chdir( dirname(__FILE__) );
chdir( '../' );
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);

require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();


try {
	Core_Sql::setConnectToServer( 'lpb.tracker' );
	//========
	
	
	$_arrUpdates=Core_Sql::getAssoc("SELECT b.sub_id, a.value, COUNT(a.VALUE) AS coutlimit, MIN(b.id) as minimumid FROM s8rs_parameters_1 a JOIN s8rs_events_1 b ON a.event_id=b.id JOIN s8rs_1 c ON b.sub_id=c.id WHERE a.NAME='ef_id' GROUP BY a.value, b.sub_id");
	
	foreach( $_arrUpdates as $_data ){
		$_arrDestroy=array();
		
		if( $_data['coutlimit'] > 1000 ){
			
			/*
			$_arrCheck=Core_Sql::getAssoc("SELECT a.*, COUNT(a.event_id) AS checkcount  FROM s8rs_parameters_1 a JOIN s8rs_events_1 b ON a.event_id=b.id WHERE b.sub_id='".$_data['sub_id']."' GROUP BY a.event_id");
			
			foreach( $_arrCheck as $_check ){
				if( $_check['checkcount'] == 1 && $_check['id']!=$_data['minimumid'] ){
					$_arrDestroy[]=$_check['event_id'];
				}
			}
			if( count( $_arrDestroy ) > 0 ){
				Core_Sql::setExec( 'DELETE FROM s8rs_parameters_1 WHERE event_id IN ('.implode(',', $_arrDestroy).')' );
				Core_Sql::setExec( 'DELETE FROM s8rs_events_1 WHERE id IN ('.implode(',', $_arrDestroy).')' );
			}
			*/
			echo "Clean Email id ".$_data['sub_id']." found ".$_data['coutlimit']." and remove ".count( $_arrDestroy )." errors\n";
		}
	
		
	}
	
	//========
	Core_Sql::renewalConnectFromCashe();
}catch(Exception $e) {
	echo date(DATE_RFC822).': '.$e->getMessage()."\n";
	Core_Sql::renewalConnectFromCashe();
}