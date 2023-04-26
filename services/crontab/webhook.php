<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

chdir( dirname(__FILE__) );
chdir( '../../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();


exit;

$_whdir='/data/www/app.ifunnels.com/html/services/test_webhook';
if( isset( $_SERVER['HTTP_HOST'] ) && $_SERVER['HTTP_HOST'] == 'cnm.local' ){
	$_whdir='z:\\home\\cnm.local\\svn\\trunk\\services\\test_webhook';
}
Core_Files::dirScan( $arrTmp, $_whdir );
$_arrEvents=$_arrUnsubscribe=array();
foreach( $arrTmp[$_whdir] as $_fileName ){
	$_jsonData=file_get_contents( $_whdir.DIRECTORY_SEPARATOR.$_fileName );
	$_arrEventsThis=unserialize( $_jsonData );
	if( !empty( $_arrEventsThis ) ){
		foreach( $_arrEventsThis as $_event ){
			$_smtpId=explode( '.', $_event['sg_message_id'] )[0];
			if( !isset( $_arrEvents[$_smtpId] ) ){
				$_arrEvents[$_smtpId]=array('events'=>array(), 'email'=>'');
			}
			$_arrEvent=array();
			$_flgUnsubscribe=false;
			switch( $_event['event'] ){
				case 'bounce': $_arrEvent['bounced']=1;break;
				case 'click': $_arrEvent['clicked']=1;break;
				case 'delivered': $_arrEvent['delivered']=1;break;
				case 'open': $_arrEvent['opened']=1;break;
				case 'spamreport': $_arrEvent['spam']=1;break;
				case 'group_resubscribe': break;
				case 'processed': break;
				case 'dropped': break;
				case 'deferred': break;
				case 'unsubscribe': $_flgUnsubscribe=true;break;
				case 'group_unsubscribe': $_flgUnsubscribe=true;break;
			}
			if( !empty( $_arrEvent ) ){
				$_arrEvents[$_smtpId]['email']=$_event['email'];
				$_arrEvents[$_smtpId]['events'][$_event['timestamp']]=$_arrEvent+(isset($_arrEvents[$_smtpId]['events'][$_event['timestamp']])?$_arrEvents[$_smtpId]['events'][$_event['timestamp']]:array());
			}
			if( $_flgUnsubscribe ){
				$_arrUnsubscribe[$_smtpId]=$_event['email'];
			}
		}
	}
}
$_s8r=new Project_Efunnel_Smtpids(); // тут пишем в общий список, т.к. от sendgrid не приходит user_id
$_s8r->withSmtpId( array_keys( $_arrEvents ) )->getList( $_arrUsers );
$_dataUpdate=$_useEmails=$_useSmtpIds=array();
foreach( $_arrUsers as $_user ){
	foreach( $_arrEvents as $_smtpId=>$_smtpData ){
		if( $_smtpId == $_user['smtp'] && $_smtpData['email'] == $_user['email'] ){
			if( !isset( $_dataUpdate[$_user['user_id']] ) ){
				$_dataUpdate[$_user['user_id']]=array();
			}
			if( !isset( $_useSmtpIds[$_user['user_id']] ) ){
				$_useSmtpIds[$_user['user_id']]=array();
			}
			if( !isset( $_useEmails[$_user['user_id']] ) ){
				$_useEmails[$_user['user_id']]=array();
			}
			if( !isset( $_dataUpdate[$_user['user_id']][$_smtpId] ) ){
				$_dataUpdate[$_user['user_id']][$_smtpId]=array();
			}
			$_dataUpdate[$_user['user_id']][$_smtpId]['email']=$_smtpData['email'];
			$_dataUpdate[$_user['user_id']][$_smtpId]['smtp']=$_smtpId;
			$_useSmtpIds[$_user['user_id']][$_smtpId]=$_smtpId;
			$_useEmails[$_user['user_id']][$_smtpData['email']]=$_smtpData['email'];
			$_dataUpdate[$_user['user_id']][$_smtpId]['events']=$_smtpData['events'];
		}
	}
	foreach( $_arrUnsubscribe as $_smtpId=>$_smtpData ){
		if( $_smtpId == $_user['smtp'] && $_smtpData == $_user['email'] ){
			if( !isset( $_dataUpdate[$_user['user_id']] ) ){
				$_dataUpdate[$_user['user_id']]=array();
			}
			if( !isset( $_useSmtpIds[$_user['user_id']] ) ){
				$_useSmtpIds[$_user['user_id']]=array();
			}
			if( !isset( $_useEmails[$_user['user_id']] ) ){
				$_useEmails[$_user['user_id']]=array();
			}
			if( !isset( $_dataUpdate[$_user['user_id']][$_smtpId] ) ){
				$_dataUpdate[$_user['user_id']][$_smtpId]=array();
			}
			$_useSmtpIds[$_user['user_id']][$_smtpId]=$_smtpId;
			$_useEmails[$_user['user_id']][$_smtpData]=$_smtpData;
			$_dataUpdate[$_user['user_id']][$_smtpId]['unsubscribe']=true;
		} 
	}
}
unset( $_arrUsers, $_arrEvents, $_arrUnsubscribe );
try{
	Core_Sql::setConnectToServer( 'lpb.tracker' );
	//========
	foreach( $_dataUpdate as $_userId => $_updateEvents ){
		/*
		$_arrEvents=Core_Sql::getAssoc( 'SELECT id as event_id, search_var as value FROM s8rs_events_'.$_userId.' WHERE search_var IN ('.Core_Sql::fixInjection( $_useSmtpIds[$_userId] ).')' );
		$_arrEventIds=array();
		foreach( $_arrEvents as $_data ){
			$_arrEventIds[$_data['event_id']]=$_data['event_id'];
		}
		*/
		$_arrS8rs=Core_Sql::getAssoc( 'SELECT d.id, d.email, d.ip, d.tags, d.name, d.settings, d.added, e.id as event_id, e.search_var as value FROM s8rs_'.$_userId.' d JOIN s8rs_events_'.$_userId.' e ON d.id=e.sub_id WHERE e.search_var IN ('.Core_Sql::fixInjection( $_useSmtpIds[$_userId] ).') AND d.email IN ('.Core_Sql::fixInjection( $_useEmails[$_userId] ).')' );
		$_arrMassUpdate=array();
		foreach( $_arrS8rs as $_s8rData ){
			foreach( $_updateEvents[$_s8rData['value']]['events'] as $_time=>$_actions ){
				foreach( $_actions as $_addName=>$_addValue ){
					$_arrMassUpdate[]='("'.$_s8rData['event_id'].'","'.$_addName.'","'.$_addValue.'")';
				}
			}
			foreach( $_updateEvents[$_s8rData['value']]['unsubscribe'] as $_time=>$_actions ){
				foreach( $_actions as $_addName=>$_addValue ){
					
					'campaign_type="'.Project_Subscribers_Events::EF_ID.'" WHERE id="'.$_event_id.'" AND campaign_type="'.Project_Subscribers_Events::EF_ID.'"'; // lead_id==1 ef_id==2 ef_unsubscribe_id==3 ef_removed_id==4 auto_id=5
					
					$_arrMassDelete[]='(`event_id`="'.$_s8rData['event_id'].'" AND `name`="ef_id")';
				}
			}
		}
		if( !empty( $_arrMassUpdate ) ){
			Core_Sql::setExec( 'INSERT INTO s8rs_parameters_'.$_userId.' (`event_id`,`name`,`value`) VALUES '.implode( ',', $_arrMassUpdate ) );
		}
		if( !empty( $_arrMassDelete ) ){
			Core_Sql::setExec( 'DELETE FROM s8rs_parameters_'.$_userId.' WHERE '.implode( ' OR ', $_arrMassDelete ) );
		}
	}
	//========
	Core_Sql::renewalConnectFromCashe();
} catch(Exception $e) {
	Core_Sql::renewalConnectFromCashe();
}
foreach( $arrTmp[$_whdir] as $_fileName ){
	unlink( $_whdir.DIRECTORY_SEPARATOR.$_fileName );
}
?>