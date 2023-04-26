<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

chdir( dirname(__FILE__) );
chdir( '../' );
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();


switch( $_GET['ajax'] ) {
    case 'pages':
        $listPages = Core_Sql::getKeyVal( 'SELECT `id` FROM `pb_pages` p WHERE p.`pagethumb` IS NULL' );
        $listPages = array_keys( $listPages );
        
        echo json_encode( $listPages );
        
        exit();
    break;

    case 'make':
        $thumbPath = Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp' . DIRECTORY_SEPARATOR . 'pagethumbs' . DIRECTORY_SEPARATOR;

        if( ! file_exists( $thumbPath ) ) {
            mkdir( Zend_Registry::get('config')->path->absolute->pagebuilder . 'tmp' . DIRECTORY_SEPARATOR . 'pagethumbs' );
        }

        if( empty( $_POST['pageid'] ) ) exit;

        $pageID = $_POST['pageid'];
        $screenshotUrl = 'https://app.ifunnels.com/ifunnels-studio/loadsinglepage/?id=' . $pageID;
        $filename = 'pagethumb_' . $pageID . '.jpg';


        $screen = new Project_Pagebuilder_Screenshot();
        $screenshot = $screen->make_screenshot( $screenshotUrl, $filename, '500x0', $thumbPath );
        
        $page = new Project_Pagebuilder_Pages();
        if ($screenshot !== false){
            $page->setEntered(array('id' => $pageID, 'pagethumb' => 'tmp/pagethumbs/' . $screenshot))->set();
        } 
        echo json_encode( array( 'status' => true, 'pagethumb' => $screenshot ) );
        exit();
    break;

    default:
    break;
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script src="js/bundle.js"></script>
</body>
</html>