<?php

class Project_Deliver_Webhook extends Core_Data_Storage
{

    protected $_table = 'deliver_webhook_log';

    protected $_fields = array('id', 'membership_id', 'data', 'response', 'added');

    private $_withMembership = false;

    /** Installing */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_webhook_log");
        Core_Sql::setExec(
            "CREATE TABLE `deliver_webhook_log` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`membership_id` INT(11) NOT NULL DEFAULT '0',
				`data` TEXT NULL DEFAULT NULL,
				`response` TEXT NULL DEFAULT NULL,
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
			ENGINE=InnoDB;"
        );
    }

    /**
     * Callback before set record
     *
     * @return boolean
     */
    public function beforeSet()
    {
        $this->_data->setFilter(['trim', 'empty_to_null']);
        $this->_data->setElement('data', json_encode($this->_data->filtered['data']));

        if (!empty($this->_data->filtered['response'])) {
            $this->_data->setElement('response', base64_encode(serialize($this->_data->filtered['response'])));
        }

        return true;
    }

    public function withMembership($ids)
    {
        $this->_withMembership = $ids;
        return $this;
    }

    /**
     * Query builder
     *
     * @return void
     */
    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if ($this->_withMembership) {
            $this->_crawler->set_where('d.membership_id IN (' . Core_Sql::fixInjection($this->_withMembership) . ')');
        }
    }

    /**
     * Reset value of variables to default
     *
     * @return void
     */
    protected function init()
    {
        $this->_withMembership = false;
    }

    /**
     * Undocumented function
     *
     * @param [int] $membership_id
     * @param array $data
     * @return boolean
     */
    public static function send($membership_id, $data = [], $test = false)
    {
        $instance = new self();

        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($membership_id)
            ->onlyOne()
            ->getList($membershipData);

        if (empty($membershipData) || empty($membershipData['webhook_url'])) {
            return false;
        }

        $ch = curl_init($membershipData['webhook_url']);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type:application/json']);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($ch);
        curl_close($ch);

        if (!$test) {
            return $instance
                ->setEntered([
                    'membership_id' => $membership_id,
                    'data'          => $data,
                    'response'      => $response,
                ])
                ->set();
        }

        return true;
    }

    public function getList(&$mixRes)
    {
        parent::getList($mixRes);

        if (empty($mixRes)) {
            return $this;
        }

        if (isset($mixRes[0])) {
            foreach ($mixRes as &$item) {
                $item['data']     = json_decode($item['data'], true);
                $item['response'] = unserialize(base64_decode($item['response']));

                if (json_decode($item['response']) !== false) {
                    $item['response'] = json_decode($item['response'], true);
                }
            }
        } else {
            $mixRes['data']     = json_decode($mixRes['data'], true);
            $mixRes['response'] = unserialize(base64_decode($mixRes['response']));

            if (json_decode($mixRes['response']) !== false) {
                $item['response'] = json_decode($mixRes['response'], true);
            }
        }

        return $this;
    }
}
