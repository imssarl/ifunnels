<?php

class Project_Pagebuilder_Quiz {
    private $_table = 'pb_quiz_';
    private $_crawler;
    private $_withTime   = false;
    private $_withSiteId = false;

    public function __construct($_uid = false) {
        if ($uid === false) {
            $_uid = Core_Users::$info['id'];
        }

        $this->_table .= $_uid;

        try {
            Core_Sql::setConnectToServer('lpb.tracker');
            Core_Sql::setExec("CREATE TABLE IF NOT EXISTS `pb_quiz_" . $_uid . "` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`pb_site_id` INT(11) NULL DEFAULT NULL,
				`pb_page_id` INT(11) NULL DEFAULT NULL,
                `quiz_id` VARCHAR(255) NULL DEFAULT NULL,
				`quiz_answer_index` INT(11) NULL DEFAULT NULL,
				`ip` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`country_id` INT(4) NOT NULL DEFAULT '0',
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
            ENGINE=InnoDB");

            Core_Sql::renewalConnectFromCashe();
        } catch (Exception $e) {
            Core_Sql::renewalConnectFromCashe();
            return $this;
        }
    }

    public function withTime($_type, $_from, $_to) {
        $_now = time();
        switch ($_type) {
            case Project_Statistics_Api::TIME_ALL:
                $this->_withTime = array('from' => 0, 'to' => $_now);
                break;
            case Project_Statistics_Api::TIME_TODAY:
                $this->_withTime = array('from' => strtotime('today'), 'to' => $_now);
                break;
            case Project_Statistics_Api::TIME_YESTERDAY:
                $this->_withTime = array('from' => strtotime('yesterday'), 'to' => strtotime('today'));
                break;
            case Project_Statistics_Api::TIME_LAST_7_DAYS:
                $this->_withTime = array('from' => $_now - 60 * 60 * 24 * 7, 'to' => $_now);
                break;
            case Project_Statistics_Api::TIME_THIS_MONTH:
                $this->_withTime = array('from' => strtotime('first day of this month'), 'to' => $_now);
                break;
            case Project_Statistics_Api::THIS_YEAR:
                $this->_withTime = array('from' => strtotime('first day of January ' . date('Y')), 'to' => $_now);
                break;
            case Project_Statistics_Api::TIME_LAST_YEAR:
                $this->_withTime = array('from' => $_now - 60 * 60 * 24 * 365, 'to' => $_now);
                break;
            case 8:
                $this->_withTime = array('from' => strtotime($_from), 'to' => strtotime($_to));
                break;
        }
        return $this;
    }

    public function withFilter($arrFilter) {
        if (!empty($arrFilter['time'])) {
            $this->withTime($arrFilter['time'], @$arrFilter['date_from'], @$arrFilter['date_to']);
        }
        return $this;
    }

    /**
     * Setter withSiteId
     *
     * @param [int] $site_id
     * @return [object] - Return instance of class
     */
    public function withSiteId($site_id) {
        $this->_withSiteId = $site_id;
        return $this;
    }

    protected function assemblyQuery() {
        $this->_crawler->set_select('d.*');
        $this->_crawler->set_from("{$this->_table} d");

        if (!empty($this->_withIds)) {
            $this->_crawler->set_where('d.id IN (' . Core_Sql::fixInjection($this->_withIds) . ')');
        }

        if (!empty($this->_withSiteId)) {
            $this->_crawler->set_where('d.pb_site_id = ' . Core_Sql::fixInjection($this->_withSiteId) );
        }

        if (!empty($this->_withTime)) {
            $this->_crawler->set_where("d.added >={$this->_withTime['from']} AND d.added <={$this->_withTime['to']}");
        }

        if (!empty($this->_withGroup)) {
            $this->_crawler->set_group($this->_withGroup);
        }
    }

    public function getList(&$mixRes) {
        $this->_crawler = new Core_Sql_Qcrawler();
        $this->assemblyQuery();
        $this->_crawler->get_result_full($_strSql);

        try {
            Core_Sql::setConnectToServer('lpb.tracker');
            $mixRes = Core_Sql::getAssoc($_strSql);
            Core_Sql::renewalConnectFromCashe();
        } catch (Exception $e) {
            Core_Sql::renewalConnectFromCashe();
        }

        $out = [];

        if (!empty($mixRes)) {
            $site_ids = array_unique(array_column($mixRes, 'pb_site_id'));
            $page_ids = array_unique(array_column($mixRes, 'pb_page_id'));

            $site = new Project_Pagebuilder_Sites();
            $site
                ->withIds($site_ids)
                ->keyRecordForm()
                ->getList($sites);

            $page = new Project_Pagebuilder_Pages();
            $page
                ->withIds($page_ids)
                ->keyRecordForm()
                ->getList($pages);

            foreach ($mixRes as $record) {
                $url = "{$sites[$record['pb_site_id']]['url']}{$pages[$record['pb_page_id']]['pages_name']}.php";
                if (empty($out[$url][$record['quiz_id']][$record['quiz_answer_index']])) {
                    $out[$url][$record['quiz_id']][$record['quiz_answer_index']] = 0;
                }

                $out[$url][$record['quiz_id']][$record['quiz_answer_index']] += 1;
            }
        }

        $mixRes = $out;
        return $this;
    }
}
