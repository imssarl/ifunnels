<?php

class Project_Pagebuilder_TestAB_Goal extends Core_Data_Storage
{

    const GOAL_LEAD = '1', GOAL_REGISTRATION = '2', GOAL_SALE = '3';

    const GOALS = [
        '1' => 'lead',
        '2' => 'registration',
        '3' => 'sale'
    ];

    protected $_table  = 'testab_pages_goal';
    protected $_fields = ['id', 'pageid', 'goal_type', 'option', 'visitor_ip', 'added'];

    private $_withPageId    = false;
    private $_withOption    = false;
    private $_withVisitorIP = false;
    private $_withGoalType  = false;
    private $_toSelectField = false;

    public function withPageId($pageid)
    {
        $this->_withPageId = $pageid;
        return $this;
    }

    public function withOption($option)
    {
        $this->_withOption = $option;
        return $this;
    }

    public function withVisitorIP($ip)
    {
        $this->_withVisitorIP = $ip;
        return $this;
    }

    public function withGoalType($types)
    {
        $this->_withGoalType = $types;
        return $this;
    }

    public function toSelectFields($fields)
    {
        $this->_toSelectField = $fields;
        return $this;
    }

    /**
     * Builder for query
     *
     * @return void
     */
    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if ($this->_withPageId) {
            $this->_crawler->set_where('d.pageid IN (' . Core_Sql::fixInjection($this->_withPageId) . ')');
        }

        if ($this->_withOption) {
            $this->_crawler->set_where('d.option IN (' . Core_Sql::fixInjection($this->_withOption) . ')');
        }

        if ($this->_withVisitorIP) {
            $this->_crawler->set_where('d.visitor_ip = ' . Core_Sql::fixInjection($this->_withVisitorIP));
        }

        if ($this->_withGoalType) {
            $this->_crawler->set_where('d.goal_type IN (' . Core_Sql::fixInjection($this->_withGoalType) . ')');
        }

        if ($this->_toSelectField) {
            $this->_crawler->clean_select();
            $this->_crawler->set_select('pageid, goal_type, d.option, count(*) as count');
        }

        // $this->_crawler->get_sql($_strSql, $this->_paging);
        // p($_strSql);
    }

    protected function init()
    {
        $this->_withPageId    = false;
        $this->_withOption    = false;
        $this->_withVisitorIP = false;
        $this->_withGoalType  = false;
        $this->_toSelectField = false;

        parent::init();
    }

    public function getList(&$mixRes)
    {
        try {
            Core_Sql::setConnectToServer('lpb.tracker');
            parent::getList($mixRes);
            Core_Sql::renewalConnectFromCashe();
        } catch (Exception $e) {
            Core_Sql::renewalConnectFromCashe();
        }

        return $this;
    }
}
