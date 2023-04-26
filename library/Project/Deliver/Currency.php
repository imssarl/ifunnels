<?php

class Project_Deliver_Currency
{
    /**
     * При добавлении новой валюты добавить так же
     * в файл /skin/ifunnels-studio/src/js/helper.js
     * метод getCode
     */

    const DEFAULT_CURRENCY = 'USD';

    const ABBRS = [
        'USD' => '&#36;',
        'CAD' => '&#36;',
        'AUD' => '&#36;',
        'NZD' => '&#36;',
        'EUR' => '&#8364;',
        'GBP' => '&#163;',
    ];

    public static function getCode($abbr)
    {
        if (empty(self::ABBRS[$abbr])) {
            return self::ABBRS[self::DEFAULT_CURRENCY];
        }

        return self::ABBRS[$abbr];
    }

    public static function getDefaultCurrency()
    {
        $crawler = new Core_Sql_Qcrawler();
        $crawler->set_select('currency');
        $crawler->set_from('deliver_site');
        $crawler->set_where('user_id = ' . Core_Users::$info['id']);
        $crawler->set_group('currency');
        $crawler->set_order('COUNT(*) DESC');
        $crawler->set_limit(1);

        $currency = Core_Sql::getCell($crawler->get_result_full());

        return !empty($currency) ? $currency : 'USD';
    }
}
