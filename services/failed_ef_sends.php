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

$_userId=1;

try{
	Core_Sql::setConnectToServer( 'lpb.tracker' );
	//========
	$_emails=Core_Sql::getField( 'SELECT p.email FROM (SELECT COUNT(*) as counter, c.email as email FROM s8rs_parameters_'.$_userId.' a JOIN s8rs_events_'.$_userId.' b ON a.event_id=b.id JOIN s8rs_'.$_userId.' c ON c.id=b.sub_id WHERE a.name="message_id" GROUP BY c.email ) p WHERE p.counter>500;' );
	foreach( $_emails as $_em ){
		$_arrData=Core_Sql::getAssoc( 'SELECT e.id, f.value FROM s8rs_'.$_userId.' d JOIN s8rs_events_'.$_userId.' e ON d.id=e.sub_id JOIN s8rs_parameters_'.$_userId.' f ON e.id=f.event_id WHERE d.email="'.$_em.'" AND f.name="message_id" ORDER BY e.added' );
		$_id2count=array();
		foreach( $_arrData as $_ef ){
			if( !isset( $_id2count[$_ef['value']] ) ){
				$_id2count[$_ef['value']]=array();
			}
			$_id2count[$_ef['value']][]=$_ef['id'];
			
		}
		foreach( $_id2count as $_mId => &$_evIds ){
			if( count( $_evIds ) > 2 ){
				array_shift($_evIds);
				array_shift($_evIds);
				
echo "Remove for ".$_em." message ".$_mId." count ".count( $_evIds );
				
				Core_Sql::setExec( 'DELETE FROM s8rs_events_'.$_userId.' WHERE id IN ('.Core_Sql::fixInjection($_evIds).')' );
				Core_Sql::setExec( 'DELETE FROM s8rs_parameters_'.$_userId.' WHERE event_id IN ('.Core_Sql::fixInjection($_evIds).')' );
			}
		}
	}
	//========
	Core_Sql::renewalConnectFromCashe();
} catch(Exception $e) {
	Core_Sql::renewalConnectFromCashe();
	return $this;
}