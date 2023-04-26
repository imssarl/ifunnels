<?php

class Project_Deliver_Log extends Core_Data_Storage
{
    protected $_table  = 'deliver_log';
    protected $_fields = array('id', 'data', 'added');

    /** Installing */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_log");
        Core_Sql::setExec(
            "CREATE TABLE `deliver_log` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`data` TEXT NULL DEFAULT NULL,
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
			ENGINE=InnoDB;"
        );
    }

    public function beforeSet()
    {
        $this->_data->setFilter(['clear']);
        $this->_data->setElement('data', json_encode($this->_data->filtered['data']));

        return true;
    }

    public static function log($data)
    {
        $instance = new self();

        $instance
            ->setEntered(['data' => $data])
            ->set();
    }
}
