<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

chdir( dirname(__FILE__) );
chdir( '../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();
Core_Errors::off();
p(time());
if( !empty($_POST['package_id'])&&!empty($_POST['user_id'])){
	$_package=new Core_Payment_Package();
	$_package->onlyOne()->withIds( $_POST['package_id'] )->getList( $_arrPack );
	$_POST['click2sell_id']=$_arrPack['click2sell_id'];
	echo '<a href="./click2sell.php?p='.Core_Payment_Encode::encode($_POST).'">click to pay</a>';
	die();
}
if( empty($_GET['p']) ){
	$_user=new Core_Users_Management();
	$_user->withOrder('d.email--dn')->getList($_arrUsers);
	echo '<form action="" method="post">';
	echo '<select name="user_id">';
	foreach( $_arrUsers as $_item ){
		echo "<option value='{$_item['id']}'>".$_item['email'];
	}
	echo '</select>';

	$_package=new Core_Payment_Package();
	$_package->withHided()->getList( $_arrPack );
	echo '<select name="package_id">';
	foreach( $_arrPack as $_item ){
		echo "<option value='{$_item['id']}'>".$_item['title'];
	}
	echo '</select>';
	echo '<input type="submit" value="Get Link">';
	echo '</form>';
	die();
}else {
	$_arrParams['acquirer_transaction_id']=1;
	$_arrParams['c2s_transaction_id']=1;
	$_arrParams['purchase_date']=1;
	$_arrParams['purchase_time']=1;
	$_arrParams['payment_type']=1;
	$_arrParams['transaction_type']='Subscription';
	$_arrParams['payment_status']='OK';
	$_arrParams['subscription_status']=1;
	$_arrParams['buyer_name']='Gary';
	$_arrParams['buyer_surname']='Blaine';
	$_arrParams['buyer_address']='n/a';
	$_arrParams['buyer_city']='n/a';
	$_arrParams['buyer_province']='n/a';
	$_arrParams['buyer_zip']='n/a';
	$_arrParams['buyer_country']='Australia';
	$_arrParams['buyer_email']=1;
	$_arrParams['buyer_phone']='n/a';
	$_arrParams['product_price']=1;
	$_arrParams['product_id']=1;
	$_arrParams['product_name']=1;
	$_arrParams['merchant_name']=1;
	$_arrParams['merchant_username']=1;
	$_arrParams['affiliate_username']=1;
	$_arrParams['cp_p']=$_GET['p'];
	$_curl=Core_Curl::getInstance();
	$_curl->setPost( $_arrParams )->getContent( 'https://'.Zend_Registry::get('config')->engine->project_domain.'/services/payment.php?type=Clicktosell' );
	p(array($_curl->getError(),$_curl->getResponce()));
}

?>