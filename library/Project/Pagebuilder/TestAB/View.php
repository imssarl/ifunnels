<?php

class Project_PageBuilder_TestAB_View extends Core_Data_Storage
{
    protected $_table  = 'testab_pages_view';
    protected $_fields = ['id', 'pageid', 'current_option', 'visitor_ip', 'added'];

    private $_withPageId        = false;
    private $_withCurrentOption = false;
    private $_withVisitorIP     = false;
    private $_toSelectField     = false;

    public function withPageId($pageid)
    {
        $this->_withPageId = $pageid;
        return $this;
    }

    public function withCurrentOption($option)
    {
        $this->_withCurrentOption = $option;
        return $this;
    }

    public function withVisitorIP($ip)
    {
        $this->_withVisitorIP = $ip;
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

        if ($this->_withCurrentOption) {
            $this->_crawler->set_where('d.current_option IN (' . Core_Sql::fixInjection($this->_withCurrentOption) . ')');
        }

        if ($this->_withVisitorIP) {
            $this->_crawler->set_where('d.visitor_ip = ' . Core_Sql::fixInjection($this->_withVisitorIP));
        }

        if ($this->_toSelectField) {
            $this->_crawler->clean_select();
            $this->_crawler->set_select('pageid, current_option, count(*) as count');
        }

        // $this->_crawler->get_sql($_strSql, $this->_paging);
        // p($_strSql);
    }

    protected function init()
    {
        $this->_withPageId        = false;
        $this->_withCurrentOption = false;
        $this->_withVisitorIP     = false;
        $this->_toSelectField     = false;
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
