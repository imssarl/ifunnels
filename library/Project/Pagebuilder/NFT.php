<?php

class Project_Pagebuilder_NFT
{
    public static $poligonscan = '674B7BPAYENQ1E83Y3EW9SD22WV4M3996Q';
    public static $etherscan   = 'QRZSH1RKUUDQNQDU84TAD37QJD5DR3P6DE';

    const ETHER   = 1;
    const POLYGON = 137;
    const RINKEBY = 4;
    const ROPSTEN = 3;
    const GOERLI  = 5;

    // https://api.etherscan.io/api?module=contract&action=getabi&address=0x827acb09a2dc20e39c9aad7f7190d9bc53534192&apikey=QRZSH1RKUUDQNQDU84TAD37QJD5DR3P6DE
    // https://api.polygonscan.com/api?module=contract&action=getabi&address=0x827acb09a2dc20e39c9aad7f7190d9bc53534192&apikey=674B7BPAYENQ1E83Y3EW9SD22WV4M3996Q
    // https://api-ropsten.etherscan.io/api?module=contract&action=getabi&address=0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413&apikey=YourApiKeyToken
    // https://api-rinkeby.etherscan.io/api?module=contract&action=getabi&address=0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413&apikey=YourApiKeyToken
    // https://api-goerli.etherscan.io/api?module=contract&action=getabi&address=0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413&apikey=YourApiKeyToken

    public static function getABI($network, $contract)
    {
        $ch = curl_init();

        $settings_curl = [
            CURLOPT_RETURNTRANSFER => true,
        ];

        switch ($network) {
            case self::ETHER:default:
                $settings_curl[CURLOPT_URL] = sprintf("https://api.etherscan.io/api?module=contract&action=getabi&address=%s&apikey=%s", $contract, self::$etherscan);
                break;

            case self::POLYGON:
                $settings_curl[CURLOPT_URL] = sprintf("https://api.polygonscan.com/api?module=contract&action=getabi&address=%s&apikey=%s", $contract, self::$poligonscan);
                break;

            case self::RINKEBY:
                $settings_curl[CURLOPT_URL] = sprintf("https://api-rinkeby.etherscan.io/api?module=contract&action=getabi&address=%s&apikey=%s", $contract, self::$etherscan);
                break;

            case self::ROPSTEN:
                $settings_curl[CURLOPT_URL] = sprintf("https://api-ropsten.etherscan.io/api?module=contract&action=getabi&address=%s&apikey=%s", $contract, self::$etherscan);
                break;

            case self::GOERLI:
                $settings_curl[CURLOPT_URL] = sprintf("https://api-goerli.etherscan.io/api?module=contract&action=getabi&address=%s&apikey=%s", $contract, self::$etherscan);
                break;
        }

        curl_setopt_array($ch, $settings_curl);
        $response = json_decode(curl_exec($ch));

        if ($response->message === 'OK') {
            return $response->result;
        }

        throw new Exception($response->result, 1);
    }
}
