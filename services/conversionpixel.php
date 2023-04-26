<?php
set_time_limit(0);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', '1');

header('Location: http://fasttrk.net/services/conversionpixel.php?param='.$_GET['param'].'&squeeze_id='.$_GET['squeeze_id']);
?>