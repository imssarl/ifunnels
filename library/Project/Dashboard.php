<?php

class Project_Dashboard
{
    private $cfg = [
        'lead'    => '',
        'pb_view' => '',
    ];

    private $table_lead    = '';
    private $table_pb_view = '';

    public function __construct()
    {
        $this->_userid = Core_Users::$info['id'];
    }

    public function getStatistics(&$arr)
    {
        $out = [];

        $out['currency'] = Project_Deliver_Currency::getDefaultCurrency();

        try {
            Core_Sql::setConnectToServer('lpb.tracker');

            $out['today'] = [
                'leads'    => $this->getCountLeadsToday(),
                'visitors' => $this->getTotalVisitorsToday(),
            ];

            $out['30days'] = [
                'leads'      => $this->getCountLeadsLast30Day(),
                'visitors'   => $this->getTotalVisitorsLast30Day(),
                'top5funnel' => $this->getTop5Funnels(),

            ];

            Core_Sql::renewalConnectFromCashe();
        } catch (Exception $e) {
            Core_Sql::renewalConnectFromCashe();
        }

        $out['today']['sales']  = $this->getTotalSalesToday() / 100;
        $out['30days']['sales'] = $this->getTotalSalesLast30Day() / 100;

        if (!empty($out['30days']['top5funnel'])) {
            $lpb = array_filter($out['30days']['top5funnel'], function ($value) {
                return $value['type'] == '0';
            });

            $pb = array_filter($out['30days']['top5funnel'], function ($value) {
                return $value['type'] == '1';
            });

            if (!empty($lpb)) {
                $funnel = new Project_Squeeze();
                $funnel
                    ->withIds(array_column($lpb, 'funnel'))
                    ->onlyOwner()
                    ->keyRecordForm()
                    ->getList($funnelList);

                foreach ($out['30days']['top5funnel'] as &$value) {
                    $value['name'] = 'Funnel #' . $funnelList[$value['funnel']]['id'];
                    $value['url']  = $funnelList[$value['funnel']]['url'];
                }
            }

            if (!empty($pb)) {
                $studio = new Project_Pagebuilder_Sites();
                $studio
                    ->withIds(array_column($pb, 'funnel'))
                    ->keyRecordForm()
                    ->onlyOwner()
                    ->getList($studioList);

                foreach ($out['30days']['top5funnel'] as &$value) {
                    $value['name'] = $studioList[$value['funnel']]['sites_name'];
                    $value['url']  = $studioList[$value['funnel']]['url'];
                }
            }
        }

        $out['30days']['top5Sales']        = $this->getTop5Sales();
        $out['30days']['top5LeadChannels'] = $this->getTop5LeadChannels();

        $arr = $out;

        // p($out);
    }

    /**
     * Return count leads added today
     *
     * @return int
     */
    private function getCountLeadsToday()
    {
        if (!Core_Acs::haveRight(['site1_funnels' => ['dashboard']]) && !Core_Acs::haveRight(['email_funnels' => ['frontend_settings']]) && !Core_Acs::haveRight(['site1_mooptin' => ['create']])) {
            return 0;
        }

        $crawler = new Core_Sql_Qcrawler();
        $crawler->set_select('COUNT(id) as count');
        $crawler->set_from(sprintf('s8rs_%s d', $this->_userid));
        $crawler->set_where('d.added >= ' . strtotime('today'));

        $result = Core_Sql::getCell($crawler->get_result_full());

        return $result;
    }

    /**
     * Return count leads added last 30 days
     *
     * @return int
     */
    private function getCountLeadsLast30Day()
    {
        if (!Core_Acs::haveRight(['site1_funnels' => ['dashboard']]) && !Core_Acs::haveRight(['email_funnels' => ['frontend_settings']]) && !Core_Acs::haveRight(['site1_mooptin' => ['create']])) {
            return 0;
        }

        $crawler = new Core_Sql_Qcrawler();
        $crawler->set_select('COUNT(id) as count');
        $crawler->set_from(sprintf('s8rs_%s d', $this->_userid));
        $crawler->set_where('d.added >= ' . strtotime('-30 day'));

        return Core_Sql::getCell($crawler->get_result_full());
    }

    /**
     * Return total count visitors at today
     *
     * @return int
     */
    private function getTotalVisitorsToday()
    {
        if (!Core_Acs::haveRight(['site1_ecom_funnels' => ['create']])) {
            return 0;
        }

        $pb = new Core_Sql_Qcrawler();
        $pb->set_select('d.id');
        $pb->set_from('pb_view_' . $this->_userid . ' d');
        $pb->set_where('d.added >= ' . strtotime('today'));

        $lpb     = new Core_Sql_Qcrawler();
        $crawler = new Core_Sql_Qcrawler();

        $crawler->set_union_select($pb);

        if (Core_Sql::getCell("SHOW TABLES LIKE 'lpb_view_$this->_userid'") !== false) {
            $lpb->set_select('d.id');
            $lpb->set_from('lpb_view_' . $this->_userid . ' d');
            $lpb->set_where('d.added >= ' . strtotime('today'));

            $crawler->set_union_select($lpb);
        }

        $crawler->set_select('COUNT(*) AS count');
        $crawler->set_from('(' . $crawler->gen_union_full() . ') p');

        return Core_Sql::getCell($crawler->get_result_full());
    }

    /**
     * Return total count visitors from last 30 days
     *
     * @return int
     */
    private function getTotalVisitorsLast30Day()
    {
        if (!Core_Acs::haveRight(['site1_ecom_funnels' => ['create']])) {
            return 0;
        }

        $pb = new Core_Sql_Qcrawler();
        $pb->set_select('d.id');
        $pb->set_from('pb_view_' . $this->_userid . ' d');
        $pb->set_where('d.added >= ' . strtotime('-30 day'));

        $lpb     = new Core_Sql_Qcrawler();
        $crawler = new Core_Sql_Qcrawler();
        $crawler->set_union_select($pb);

        if (Core_Sql::getCell("SHOW TABLES LIKE 'lpb_view_$this->_userid'") !== false) {
            $lpb->set_select('d.id');
            $lpb->set_from('lpb_view_' . $this->_userid . ' d');
            $lpb->set_where('d.added >= ' . strtotime('-30 day'));
            $crawler->set_union_select($lpb);
        }

        $crawler->set_select('COUNT(*) AS count');
        $crawler->set_from('(' . $crawler->gen_union_full() . ') p');

        return Core_Sql::getCell($crawler->get_result_full());
    }

    /**
     * Return total sales at today
     *
     * @return int
     */
    private function getTotalSalesToday()
    {
        $crawler = new Core_Sql_Qcrawler();

        $payment = new Core_Sql_Qcrawler();
        $payment->set_select('p.amount');
        $payment->set_from('deliver_payment p');
        $payment->set_where('p.added >= ' . strtotime('today'));
        $payment->set_where('p.user_id = ' . $this->_userid);
        $payment->set_where('p.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');

        $rebill = new Core_Sql_Qcrawler();
        $rebill->set_select('r.amount');
        $rebill->set_from('deliver_payment_rebills r');
        $rebill->set_where('r.added >= ' . strtotime('today'));
        $rebill->set_where('r.user_id = ' . $this->_userid);
        $rebill->set_where('r.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');

        $crawler->set_union_select($payment);
        $crawler->set_union_select($rebill);

        $crawler->set_select('IFNULL(SUM(p.amount), 0) as total');
        $crawler->set_from('(' . $crawler->gen_union_full() . ') p');

        return Core_Sql::getCell($crawler->get_result_full());
    }

    /**
     * Return total sales from last 30 days
     *
     * @return int
     */
    private function getTotalSalesLast30Day()
    {
        $crawler = new Core_Sql_Qcrawler();

        $payment = new Core_Sql_Qcrawler();
        $payment->set_select('p.amount');
        $payment->set_from('deliver_payment p');
        $payment->set_where('p.added >= ' . strtotime('-30 day'));
        $payment->set_where('p.user_id = ' . $this->_userid);
        $payment->set_where('p.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');

        $rebill = new Core_Sql_Qcrawler();
        $rebill->set_select('r.amount');
        $rebill->set_from('deliver_payment_rebills r');
        $rebill->set_where('r.added >= ' . strtotime('-30 day'));
        $rebill->set_where('r.user_id = ' . $this->_userid);
        $rebill->set_where('r.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');

        $crawler->set_union_select($payment);
        $crawler->set_union_select($rebill);

        $crawler->set_select('IFNULL(SUM(p.amount), 0) as total');
        $crawler->set_from('(' . $crawler->gen_union_full() . ') p');

        return Core_Sql::getCell($crawler->get_result_full());
    }

    /**
     * Return top 5 funnels from Squeeze and Studio for last 30 days
     *
     * @return array
     */
    private function getTop5Funnels()
    {
        if (!Core_Acs::haveRight(['site1_funnels' => ['dashboard']]) && !Core_Acs::haveRight(['email_funnels' => ['frontend_settings']]) && !Core_Acs::haveRight(['site1_mooptin' => ['create']])) {
            return [];
        }

        $crawler = new Core_Sql_Qcrawler();
        $lpb     = new Core_Sql_Qcrawler();

        if (Core_Sql::getCell("SHOW TABLES LIKE 'lpb_view_$this->_userid'") !== false) {
            $lpb->set_select('COUNT(*) as views, squeeze_id as funnel, 0 as type, added');
            $lpb->set_from('lpb_view_' . $this->_userid);
            $lpb->set_where('added >= ' . strtotime('-30 day'));
            $lpb->set_group('squeeze_id');
            $lpb->set_order('views DESC');
            $lpb->set_limit(5);

            $crawler->set_union_select($lpb);
        }

        $pb = new Core_Sql_Qcrawler();
        $pb->set_select('COUNT(*) as views, pb_id as funnel, 1 as type, added');
        $pb->set_from('pb_view_' . $this->_userid);
        $pb->set_where('added >= ' . strtotime('-30 day'));
        $pb->set_group('pb_id');
        $pb->set_order('views DESC');
        $pb->set_limit(5);

        $crawler->set_union_select($pb);

        $crawler->set_select('funnel, type, views, added');
        $crawler->set_from('(' . $crawler->gen_union_full() . ') p');
        $crawler->set_order('views DESC');
        $crawler->set_limit(5);

        return Core_Sql::getAssoc($crawler->get_result_full());
    }

    private function getTop5Sales()
    {
        $crawler = new Core_Sql_Qcrawler();

        $crawler->set_select('COUNT(id) as count, membership_id');
        $crawler->set_from('deliver_payment');
        $crawler->set_where('user_id = ' . $this->_userid);
        $crawler->set_where('status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');
        $crawler->set_group('membership_id');
        $crawler->set_order('count DESC');
        $crawler->set_limit(5);

        $salesData = Core_Sql::getAssoc($crawler->get_result_full());

        if (empty($salesData)) {
            return [];
        }

        $crawler = new Core_Sql_Qcrawler();
        $crawler->set_select('m.name, m.home_page_url, s.name as site_name, m.type');
        $crawler->set_from('deliver_membership m');
        $crawler->set_from('LEFT JOIN deliver_site s ON m.site_id = s.id');
        $crawler->set_where('m.id IN (' . Core_Sql::fixInjection(array_column($salesData, 'membership_id')) . ')');

        return Core_Sql::getAssoc($crawler->get_result_full());
    }

    private function getTop5LeadChannels()
    {
        $crawler = new Core_Sql_Qcrawler();
        $crawler->set_select('*');
        $crawler->set_from('mooptin');
        $crawler->set_where('user_id = ' . $this->_userid);
        $crawler->set_order('id DESC');
        $crawler->set_limit(5);

        return Core_Sql::getAssoc($crawler->get_result_full());
    }
}
