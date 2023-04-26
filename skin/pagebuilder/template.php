<?php
error_reporting(0);

$_arrZeroData = @file_get_contents("./limits.count");

if (@filemtime("./limits.count") < time() - 3 * 60 * 60 || $_arrZeroData == "true") {
    $_arrZeroData = @file_get_contents("http://qjmpz.com/services/pb_subscribers.php?uid=[%userid%]");
    @file_put_contents("./limits.count", $_arrZeroData);
}

if ($_arrZeroData == "true") {
    header("Location: http://qjmpz.com/services/lpb_redirect.php");
    exit;
}

ob_start();

function parsing($test_enabled, $protect, $html)
{
    $html = base64_decode($html);
    if (!$test_enabled && !$protect) {
        return $html;
    }

    $doc = new DOMDocument;
    $doc->loadHTML($html);

    $xDom = new DOMXPath($doc);

    /** PROTECTED BEGIN */
    if ($protect && !empty([%membership_ids%])) {
        $is_auth = false;

        if (!empty($_COOKIE['token'])) {
            if ($curl = curl_init()) {
                curl_setopt($curl, CURLOPT_URL, 'https://app.ifunnels.com/services/deliver-signin.php');
                curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($curl, CURLOPT_POST, true);
                curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode(['token' => str_replace(" ", "+", $_COOKIE['token']), 'pageid' => [%pageid%], 'memberships' => [%membership_ids%], 'ip' => getUserIp()]));

                $response = json_decode(curl_exec($curl));
                curl_close($curl);

                if ($response !== false && $response->status) {
                    $is_auth     = true;
                    $nodeProtect = $xDom->query('//div[@class="protected"]')->item(0);
                    $nodeProtect->parentNode->removeChild($nodeProtect);
                }
            }
        }

        if (!$is_auth) {
            $nodePage = $xDom->query('//div[@class="page"]')->item(0);
            $nodePage->parentNode->removeChild($nodePage);

            $nodePopups = $xDom->query('//div[@id="popups"]')->item(0);
            $nodePopups->parentNode->removeChild($nodePopups);
        }
    }
    /** PROTECTED END */

    /** TEST AB BEGIN */
    if ($test_enabled) {
        $default_option  = '#';
        $current_option  = $_COOKIE['testab'];
        $stylesheet      = $xDom->query('//link[@href="https://fasttrk.net/services/testab.css.php"]')->item(0);
        $stylesheet_path = $stylesheet->getAttribute('href');

        if (!empty($current_option)) {
            $stylesheet->setAttribute('href', $stylesheet_path . '?' . http_build_query(['testab' => $current_option]));
            $xDom->query('//body')->item(0)->setAttribute('data-variant-current', $current_option);
        } else if ($curl = curl_init()) {
            curl_setopt($curl, CURLOPT_URL, 'https://fasttrk.net/services/testab/option.php');
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_POST, true);
            curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query(['pageid' => [%pageid%] ]));

            $response = json_decode(curl_exec($curl));
            curl_close($curl);

            if ($response !== false) {
                $default_option = $response->current_option;
            }

            $xDom->query('//body')->item(0)->setAttribute('data-variant-current', $default_option);
            $stylesheet->setAttribute('href', $stylesheet_path . '?' . http_build_query(['testab' => $default_option]));
            setcookie('testab', $default_option, time() + 365 * 24 * 60 * 60);
        }
    }
    /** TEST AB END */

    return $doc->saveHTML();
}

echo parsing( [%test%], [%protect%], '[%html%]' );

$_content = ob_get_contents();
ob_end_clean();

function getUserIp()
{
    if (!empty($_SERVER["HTTP_CLIENT_IP"])) {
        $ip = $_SERVER["HTTP_CLIENT_IP"];
    } elseif (!empty($_SERVER["HTTP_X_FORWARDED_FOR"])) {
        $ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
    } else {
        $ip = $_SERVER["REMOTE_ADDR"];
    }

    return $ip;
}

$_queryString   = array();
$_queryString[] = "ip=" . getUserIp();
$_queryString[] = "city=1";
$_arrZeroData   = @file_get_contents("https://[%domain%]/services/geoip.php?" . implode("&", $_queryString));
$_arrZeroData   = explode(":", $_arrZeroData);
$city           = "City";

if (!empty($_arrZeroData[0]) && @$_arrZeroData[0] !== "error") {
    $city = @$_arrZeroData[0];
}

$_content = str_replace(array("#city#", "[[city]]"), $city, $_content);
preg_match_all("|\[\[([a-zA-Z0-9: ]+)\]\]|ims", $_content, $_match);

foreach ($_match[1] as $_data) {
    $_defaultValue = $_name = "";
    if (strpos($_data, ":") !== false) {
        $_defaultValue = explode(":", $_data);
        $_name         = $_defaultValue[0];
        $_defaultValue = $_defaultValue[1];
    } else {
        $_name = $_data;
    }

    if (isset($_GET[$_name]) && !empty($_GET[$_name])) {
        $_replace = htmlspecialchars($_GET[$_name]);
    } else {
        $_replace = $_defaultValue;
    }

    $_content = preg_replace("|\[\[" . quotemeta($_data) . "\]\]|ims", $_replace, $_content);
}

echo $_content;
