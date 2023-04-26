<?php

class Project_Pagebuilder_TestAB extends Core_Data_Storage
{
    const DEFAULT_OPTION = '#';
    protected $_table    = 'testab_pages';
    protected $_fields   = ['id', 'pageid', 'access_options', 'current_option', 'days', 'visitors', 'auto_optimize', 'weight', 'added'];

    private $_withPageId   = false;
    private $_withViewStat = false;
    private $_withGoalStat = false;

    protected function beforeSet()
    {
        $this->_data->setFilter('empty_to_null');

        if (empty($this->_data->filtered['days'])) {
            $this->_data->setElement('days', 0);
        }

        if (empty($this->_data->filtered['visitors'])) {
            $this->_data->setElement('visitors', 0);
        }

        if (empty($this->_data->filtered['auto_optimize'])) {
            $this->_data->setElement('auto_optimize', 0);
        }

        $this->_data->setElement('weight', json_encode($this->_data->filtered['weight']));

        return true;
    }

    public function set()
    {
        try {
            Core_Sql::setConnectToServer('syndication.qjmpz.com');
            parent::set();
            Core_Sql::renewalConnectFromCashe();
        } catch (Exception $e) {
            Core_Sql::renewalConnectFromCashe();
            return false;
        }

        return true;
    }

    public function withPageId($pageid)
    {
        $this->_withPageId = $pageid;
        return $this;
    }

    public function withViewStat()
    {
        $this->_withViewStat = true;
        return $this;
    }

    public function withGoalStat()
    {
        $this->_withGoalStat = true;
        return $this;
    }

    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if ($this->_withPageId) {
            $this->_crawler->set_where('d.pageid IN (' . Core_Sql::fixInjection($this->_withPageId) . ')');
        }
    }

    protected function init()
    {
        parent::init();
        $this->_withPageId = false;
    }

    public function getList(&$mixRes)
    {
        try {
            Core_Sql::setConnectToServer('syndication.qjmpz.com');
            parent::getList($mixRes);

            if (empty($mixRes)) {
                return $this;
            }

            if (array_key_exists("0", $mixRes)) {
                foreach ($mixRes as &$item) {
                    $item['access_options'] = json_decode($item['access_options'], true);
                    $item['weight']         = json_decode($item['weight'], true);
                }
            } else {
                $mixRes['access_options'] = json_decode($mixRes['access_options'], true);
                $mixRes['weight']         = json_decode($mixRes['weight'], true);
            }

            Core_Sql::renewalConnectFromCashe();
        } catch (Exception $e) {
            Core_Sql::renewalConnectFromCashe();
        }

        return $this;
    }

    public static function normdist($x)
    {
        $b1 = 0.319381530;
        $b2 = -0.356563782;
        $b3 = 1.781477937;
        $b4 = -1.821255978;
        $b5 = 1.330274429;
        $p  = 0.2316419;
        $c  = 0.39894228;

        if ($x >= 0.0) {
            $t = 1.0 / (1.0 + $p * $x);
            return (1.0 - $c * exp(-$x * $x / 2.0) * $t *
                ($t * ($t * ($t * ($t * $b5 + $b4) + $b3) + $b2) + $b1));
        } else {
            $t = 1.0 / (1.0 - $p * $x);
            return ($c * exp(-$x * $x / 2.0) * $t *
                ($t * ($t * ($t * ($t * $b5 + $b4) + $b3) + $b2) + $b1));
        }
    }

    public static function getDataOfStats($pages)
    {
        $_this = new self();

        $_this
            ->withPageId($pages)
            ->getList($arrTest);

        $out = $options = [];

        if (empty($arrTest)) {
            return $out;
        }

        foreach ($arrTest as $test) {
            $out[$test['pageid']] = array_fill_keys($test['access_options'], ['view' => 0, 'lead' => 0, 'registration' => 0, 'sale' => 0]);
            $options += $test['access_options'];
        }

        $view = new Project_Pagebuilder_TestAB_View();
        $view
            ->withPageId($pages)
            ->withCurrentOption($options)
            ->toSelectFields(true)
            ->withGroup('pageid, current_option')
            ->getList($viewsData);

        foreach ($viewsData as $view) {
            $out[$view['pageid']][$view['current_option']]['view'] = $view['count'];
        }

        $goal = new Project_Pagebuilder_TestAB_Goal();
        $goal
            ->withPageId($pages)
            ->withOption($options)
            ->toSelectFields(true)
            ->withGroup(['pageid', 'goal_type', 'd.option'])
            ->getList($goalsData);

        foreach ($goalsData as $goal) {
            $out[$goal['pageid']][$goal['option']][Project_Pagebuilder_TestAB_Goal::GOALS[$goal['goal_type']]] = $goal['count'];
        }

        foreach ($out as $pageid => &$stats) {
            $base = $stats['#'];

            $crt = [
                'lead'         => round($base['lead'] / $base['view'], 2),
                'registration' => round($base['registration'] / $base['view'], 2),
                'sale'         => round($base['sale'] / $base['view'], 2),
            ];

            // $base_se = round(sqrt($crt['lead'] * (1 - $crt['lead']) / $base['view']), 2);
            $se = [
                'lead' => round(sqrt($crt['lead'] * (1 - $crt['lead']) / $base['view']), 2),
                'reg'  => round(sqrt($crt['reg'] * (1 - $crt['reg']) / $base['view']), 2),
                'sale' => round(sqrt($crt['sale'] * (1 - $crt['sale']) / $base['view']), 2),
            ];

            array_walk($stats, function (&$stat, $variant) use ($crt, $se) {
                $crt_lead = round($stat['lead'] / $stat['view'], 2);
                $crt_reg  = round(intval($stat['registration']) / $stat['view'], 2);
                $crt_sale = round(intval($stat['sale']) / $stat['view'], 2);

                $variation_se      = round(sqrt($crt_lead * (1 - $crt_lead) / $stat['view']), 2);
                $variation_se_reg  = round(sqrt($crt_reg * (1 - $crt_reg) / $stat['view']), 2);
                $variation_se_sale = round(sqrt($crt_sale * (1 - $crt_sale) / $stat['view']), 2);

                $stat['calc']      = sprintf("%s &mdash; %s", ($crt_lead - 1.96 * $variation_se) * 100, ($crt_lead + 1.96 * $variation_se) * 100);
                $stat['calc_reg']  = sprintf("%s &mdash; %s", ($crt_reg - 1.96 * $variation_se_reg) * 100, ($crt_reg + 1.96 * $variation_se_reg) * 100);
                $stat['calc_sale'] = sprintf("%s &mdash; %s", ($crt_sale - 1.96 * $variation_se_sale) * 100, ($crt_sale + 1.96 * $variation_se_sale) * 100);

                if ($variant != '#') {
                    $stat['improvement']      = round(($crt_lead - $crt['lead']) / $crt['lead'], 2) * 100;
                    $stat['improvement_reg']  = round(($crt_reg - $crt['registration']) / $crt['registration'], 2) * 100;
                    $stat['improvement_sale'] = round(($crt_sale - $crt['sale']) / $crt['sale'], 2) * 100;

                    $stat['z_score']      = ($crt['lead'] - $crt_lead) / sqrt(pow($se['lead'], 2) + pow($variation_se, 2));
                    $stat['z_score_reg']  = ($crt['registration'] - $crt_reg) / sqrt(pow($se['reg'], 2) + pow($variation_se_reg, 2));
                    $stat['z_score_sale'] = ($crt['sale'] - $crt_sale) / sqrt(pow($se['sale'], 2) + pow($variation_se_sale, 2));

                    $stat['p_value']      = round(self::normdist($stat['z_score']), 2);
                    $stat['p_value_reg']  = round(self::normdist($stat['z_score_reg']), 2);
                    $stat['p_value_sale'] = round(self::normdist($stat['z_score_sale']), 2);

                    $stat['chance_to_win']      = (1 - $stat['p_value']) * 100;
                    $stat['chance_to_win_reg']  = (1 - $stat['p_value_reg']) * 100;
                    $stat['chance_to_win_sale'] = (1 - $stat['p_value_sale']) * 100;
                }

                $stat['crt']      = $crt_lead * 100;
                $stat['crt_reg']  = $crt_reg * 100;
                $stat['crt_sale'] = $crt_sale * 100;
            });
        }

        return $out;
    }
}
