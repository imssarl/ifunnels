<?php
header( 'Access-Control-Allow-Origin: *' );
set_time_limit( 0 );
ignore_user_abort( true );
error_reporting( E_ALL );
ini_set( 'display_errors', '1' );

chdir( dirname( __FILE__ ) );
chdir( '../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

if( $input = json_decode( file_get_contents( 'php://input' ) ) ) {
	$signIn = new Project_Deliver_SignIn();

	if( isset( $input->token ) ) {
		ob_clean();
		echo json_encode( [ 'status' => $signIn->isAuthorized( $input->token, $input->memberships, $input->pageid, $input->ip ) ] );
		exit();
	} else {
		$response = $signIn->auth( $input->login, $input->password, $input->memberships, $input->pageid );

		ob_clean();
		echo json_encode( $response );
		exit();
	}
} 

/** Create new membership signin */

// $signIn->setEntered( [ 'customer_id' => 53, 'membership_id' => 11 ] )->set();

http_response_code( 200 );

?>