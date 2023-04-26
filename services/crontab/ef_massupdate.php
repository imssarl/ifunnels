<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');
chdir(dirname(__FILE__));
chdir('../../');
require_once './library/WorkHorse.php'; // starter
WorkHorse::shell();

$_dirName = Zend_Registry::get('config')->path->absolute->crontab . 'mass_updater';
Core_Files::dirScan($arrFiles, $_dirName, true);
$_currentFile = array_shift($arrFiles[$_dirName]);
$_currentData = file_get_contents($_dirName . DIRECTORY_SEPARATOR . $_currentFile);

echo '/*** START ****\/';
echo date('d-m-Y h:i:s', time()) . "\n";

try {
    $removed = unlink($_dirName . DIRECTORY_SEPARATOR . $_currentFile);
    echo "Remove current " . $_currentFile . " Status: " . (int) $removed . "\n";
} catch (Exception $e) {
    echo "Cant remove currnet " . $_currentFile . "\n";
    echo $e->getMessage() . "\n";
}

$_arrData = array();

if (!empty($_currentData)) {
    $_arrData = explode(PHP_EOL, $_currentData);
    if (count($_arrData) == 1) {
        $_arrData = explode("\n", $_currentData);
    }
}

if (count($_arrData) < 2) { // 0 - пользователь, 1 - ссылка
    echo "EXIT()\n\n";
    exit;
}

Core_Users::getInstance()->setById($_arrData[0]);
$_arrNextQuery = $_arrQuery = unserialize($_arrData[3]);

if ($_arrNextQuery === false) {
    $_arrNextQuery = $_arrQuery = array();
}

if (empty($_arrQuery['page'])) {
    $_arrQuery['page']     = 1;
    $_arrNextQuery['page'] = 2;
} else {
    $_arrNextQuery['page']++;
}

$_class  = trim($_arrData[1], "\r");
$_method = trim($_arrData[2], "\r");

$_obj    = new $_class();
$_return = $_obj->$_method($_arrQuery);

echo "User " . $_arrData[0] . " new " . $_class . "->" . $_method . " return " . (int) $_return . "\n";

if ($_return === true) {
    $filename = microtime(true);
    file_put_contents(
        Zend_Registry::get('config')->path->absolute->crontab . 'mass_updater' . DIRECTORY_SEPARATOR . $filename . '.mu',
        Core_Users::$info['id'] . PHP_EOL . $_class . PHP_EOL . $_method . PHP_EOL . serialize(array_filter($_arrNextQuery))
    );

    echo "Create new file: $filename.mu";

    echo "Next page " . $_arrNextQuery['page'] . "\n";
} else {
    if (isset($_obj->cronErrorLog)) {
        echo implode("\n", $_obj->cronErrorLog) . "\n";
    }
}

echo '/*** END ***\/' . "\n\n";

Core_Users::getInstance()->retrieveFromCashe();
