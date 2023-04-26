<?php

class Project_Deliver_DisCount extends Core_Data_Storage
{
    protected $_table        = 'deliver_discount';
    protected $_foreignTable = 'deliver_discount_product';
    protected $_fields       = ['id', 'user_id', 'name', 'flg_pause', 'recurring', 'conditional', 'discount_amount', 'discount_type', 'dynamic', 'added'];

    private $_withProductName = false;
    private $_onlyStarted     = false;

    const DISCOUNT_TYPE_DOLLARS  = '1';
    const DISCOUNT_TYPE_PERCENTS = '2';

    /**
     * Installing method
     *
     * @return void
     */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_discount");

        Core_Sql::setExec(
            "CREATE TABLE `deliver_discount` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `user_id` INT(11) NULL DEFAULT NULL,
                `name` VARCHAR(255) NULL DEFAULT NULL,
                `flg_pause` BOOLEAN NULL DEFAULT 0,
                `recurring` BOOLEAN NULL DEFAULT 0,
                `conditional` TEXT NULL DEFAULT NULL,
                `discount_amount` FLOAT NULL DEFAULT NULL,
                `discount_type` TINYINT(1) NULL DEFAULT NULL,
                `dynamic` TEXT NULL DEFAULT NULL,
                `added` INT(11) NULL DEFAULT NULL,
                UNIQUE INDEX `id` (`id`)
            )
            COLLATE='utf8_general_ci'
            ENGINE=InnoDB;"
        );

        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_discount_product");

        Core_Sql::setExec(
            "CREATE TABLE `deliver_discount_product` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `membership_id` INT(11) NULL DEFAULT NULL,
                `discount_id` INT(11) NULL DEFAULT NULL,
                UNIQUE INDEX `id` (`id`)
            )
            COLLATE='utf8_general_ci'
            ENGINE=InnoDB;"
        );
    }

    public function __get($name)
    {
        return $this->$name;
    }

    public function withProductName()
    {
        $this->_withProductName = true;
        return $this;
    }

    public function onlyStarted()
    {
        $this->_onlyStarted = true;
        return $this;
    }

    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if ($this->_onlyStarted) {
            $this->_crawler->set_where('d.flg_pause = 0');
        }
    }

    protected function beforeSet()
    {
        $this->_data->setFilter(['trim', 'clear']);

        /** Validation */
        $validators = [
            'name'            => Core_Data_Errors::getInstance()->getValidator('Zend_Validate_NotEmpty'),
            'discount_amount' => Core_Data_Errors::getInstance()->getValidator('Project_Validate_Float'),
            'products'        => Core_Data_Errors::getInstance()->getValidator('Zend_Validate_NotEmpty'),
        ];

        if (!empty($this->_data->filtered['dynamic'])) {
            if ($this->_data->filtered['dynamic']['enabled'] != '0') {
                $validators += [
                    'dynamic[duration]' => Core_Data_Errors::getInstance()->getValidator('Zend_Validate_Digits'),
                    'dynamic[rate]'     => Core_Data_Errors::getInstance()->getValidator('Zend_Validate_Digits'),
                ];
            }
        }

        if (!Core_Data_Errors::getInstance()->setData($this->_data)->setValidators($validators)->isValid()) {
            return false;
        }

        // Conditional Data
        if (!empty($this->_data->filtered['conditional'])) {
            if ($this->_data->filtered['conditional']['enabled'] == '0') {
                $this->_data->setElement('conditional', ['enabled' => '0']);
            }

            $this->_data->setElement('conditional', json_encode($this->_data->filtered['conditional']));
        }

        // Dynamic Data
        if (!empty($this->_data->filtered['dynamic'])) {
            if ($this->_data->filtered['dynamic']['enabled'] == '0') {
                $this->_data->setElement('dynamic', ['enabled' => '0']);
            } else {

            }

            $this->_data->setElement('dynamic', json_encode($this->_data->filtered['dynamic']));
        }

        $this->_data->setElement('user_id', Core_Users::$info['id']);

        if (!empty($this->_data->filtered['id'])) {
            $this->clearProducts($this->_data->filtered['id']);
        }

        return true;
    }

    protected function afterSet()
    {
        if (!empty($this->_data->filtered['products'])) {
            $this->addProducts($this->_data->filtered['id'], $this->_data->filtered['products']);
        }

        return true;
    }

    public function getList(&$mixRes)
    {
        parent::getList($mixRes);

        if (array_key_exists('0', $mixRes)) {
            foreach ($mixRes as &$item) {
                if (!empty($item['conditional'])) {
                    $item['conditional'] = json_decode($item['conditional'], true);
                }

                if (!empty($item['dynamic'])) {
                    $item['dynamic'] = json_decode($item['dynamic'], true);
                }

                $item['products'] = $this->getProducts($item['id']);
            }
        } else {
            if (!empty($mixRes)) {
                if (!empty($mixRes['conditional'])) {
                    $mixRes['conditional'] = json_decode($mixRes['conditional'], true);
                }

                if (!empty($mixRes['dynamic'])) {
                    $mixRes['dynamic'] = json_decode($mixRes['dynamic'], true);
                }

                $mixRes['products'] = $this->getProducts($mixRes['id']);
            }
        }

        $this->init();
        return $this;
    }

    protected function init()
    {
        parent::init();
        $this->_onlyStarted = false;
    }

    public function del()
    {
        $this->clearProducts($this->_withIds);
        parent::del();
    }

    /**
     * Toggle value on field flg_pause
     *
     * @param [int] $id
     * @return boolean
     */
    public static function togglePause($id)
    {
        if (empty($id)) {
            return Core_Data_Errors::getInstance()->setError('Not such DisCount ID');
        }

        $self = new self();

        $self
            ->withIds($id)
            ->onlyOwner()
            ->onlyOne()
            ->getList($disCountData);

        if (empty($disCountData)) {
            return Core_Data_Errors::getInstance()->setError('Not such DisCount ID');
        }

        Core_Sql::setUpdate($self->_table, ['id' => $id, 'flg_pause' => !$disCountData['flg_pause']]);

        return true;
    }

    /**
     * Delete foreign records
     *
     * @param [int] $id
     * @return void
     */
    private function clearProducts($id)
    {
        Core_Sql::setExec('DELETE FROM ' . $this->_foreignTable . ' WHERE discount_id = ' . $id);
    }

    /**
     * Add products to foreign table
     *
     * @param [int] $discount_id
     * @param [array] $data
     * @return void
     */
    private function addProducts($discount_id, $data)
    {
        $data = array_map(function ($id) use ($discount_id) {
            return ['membership_id' => $id, 'discount_id' => $discount_id];
        }, $data);

        Core_Sql::setMassInsert($this->_foreignTable, $data);
    }

    /**
     * Get list of products
     *
     * @param [int] $discount_id
     * @return array
     */
    private function getProducts($discount_id)
    {
        $crawler = new Core_Sql_Qcrawler();

        $crawler->set_select(join(', ', ['d.id', 'd.membership_id']));
        $crawler->set_from($this->_foreignTable . ' d');
        $crawler->set_where('d.discount_id IN (' . Core_Sql::fixInjection($discount_id) . ')');

        if ($this->_withProductName) {
            $crawler->set_select('m.name, m.frequency as type');
            $crawler->set_from('LEFT JOIN deliver_membership m ON d.membership_id = m.id');
        }

        return Core_Sql::getKeyRecord($crawler->get_result_full());
    }

    public static function getActiveDisCount($membership_id, $customer_id)
    {
        $self = new self;

        $crawler = new Core_Sql_Qcrawler();
        $crawler->set_select("d.*");
        $crawler->set_from("$self->_table d");
        $crawler->set_from("LEFT JOIN $self->_foreignTable dp ON d.id = dp.discount_id");
        $crawler->set_where("d.flg_pause = 0");
        $crawler->set_where("dp.membership_id = $membership_id");
        $crawler->set_where("d.user_id = " . Core_Users::$info['id']);

        $discounts = Core_Sql::getAssoc($crawler->get_result_full());

        if (empty($discounts)) {
            return [];
        }

        $discounts = array_map(
            function ($discount) {
                if (!empty($discount['conditional'])) {
                    $discount['conditional'] = json_decode($discount['conditional'], true);
                }

                if (!empty($discount['dynamic'])) {
                    $discount['dynamic'] = json_decode($discount['dynamic'], true);
                }

                return $discount;
            },
            $discounts
        );

        $discounts = array_filter(
            $discounts,
            function ($discount) use ($self, $customer_id, $membership_id) {
                return $self->checkConditions($discount, $customer_id, $membership_id);
            }
        );

        $discounts = array_map(
            function ($discount) use ($self) {
                return $self->calcDisCount($discount);
            },
            $discounts
        );

        return $discounts;
    }

    /**
     * Check conditions on DisCount
     *
     * @param [array] $discount
     * @return boolean
     */
    public function checkConditions($discount, $customer_id, $membership_id)
    {
        $response = true;
        $discount = $this->calcDisCount($discount);

        if ($discount['discount_amount'] <= 0) {
            return false;
        }

        if ($discount['conditional']['enabled'] == '1') {
            // Conditional Lead
            if (!empty($discount['conditional']['lead'])) {
                $crawler = new Core_Sql_Qcrawler();

                $crawler->set_select("COUNT(id) as count");
                $crawler->set_from("deliver_customer c");
                $crawler->set_where("id = $customer_id");
                $crawler->set_where("flg_lead = 1");
                $crawler->set_where("membership_id IN (" . Core_Sql::fixInjection($discount['conditional']['lead']) . ")");

                if (Core_Sql::getCell($crawler->get_result_full()) == '0') {
                    $response = false;
                } else {
                    $response = true;
                }
            }

            // Conditional Member
            if (!empty($discount['conditional']['member'])) {
                $crawler = new Core_Sql_Qcrawler();

                $crawler->set_select("COUNT(c.id) as count");
                $crawler->set_from("deliver_customer c");
                $crawler->set_from("LEFT JOIN deliver_plan_customer pc ON pc.customer_id = c.id");

                $crawler->set_where("pc.membership_id IN (" . Core_Sql::fixInjection($discount['conditional']['member']) . ")");
                $crawler->set_where("c.id = $customer_id");
                $crawler->set_where("flg_lead = 0");

                if (Core_Sql::getCell($crawler->get_result_full()) == '0') {
                    $response = false;
                } else {
                    $response = true;
                }
            }
        }

        return $response;
    }

    /**
     * Calc DisCount amount
     *
     * @param [array] $discount
     * @return array
     */
    public function calcDisCount($discount)
    {
        if ($discount['dynamic']['enabled'] == '1') {
            // Pause after X days
            if (!empty($discount['dynamic']['pause_after'])) {
                if (time() >= strtotime("+{$discount['dynamic']['pause_after']} day", $discount['added'])) {
                    return 0;
                }
            }

            $time     = time() - intval($discount['added']);
            $duration = 0;

            // Duration
            switch ($discount['dynamic']['type']) {
                case 'hours':
                default:
                    $duration = 60 * 60 * intval($discount['dynamic']['duration']);
                    break;

                case 'days':
                    $duration = 60 * 60 * 24 * intval($discount['dynamic']['duration']);
                    break;

                case 'weeks':
                    $duration = 60 * 60 * 24 * 7 * intval($discount['dynamic']['duration']);
                    break;
            }

            // Calc discount amount
            $discount['discount_amount'] -= floor($time / $duration) * floatval($discount['dynamic']['rate']);
        }

        return $discount;
    }

    public function getDiscountAmount($discount, $amount)
    {
        $discount_type   = $discount['discount_type'];
        $discount_amount = floatval($discount['discount_amount']);

        switch ($discount_type) {
            case Project_Deliver_DisCount::DISCOUNT_TYPE_DOLLARS:
                {
                    $amount -= $discount_amount * 100;
                    break;
                }

            case Project_Deliver_DisCount::DISCOUNT_TYPE_PERCENTS:
                {
                    $amount -= intval($amount * $discount_amount / 100);
                    break;
                }

            default:break;
        }

        return $amount;
    }

    /**
     * Set created date to now and flg_pause to 0
     *
     * @param [type] $discount_id
     * @return void
     */
    public static function reset($discount_id)
    {
        return Core_Sql::setUpdate('deliver_discount', ['id' => $discount_id, 'flg_pause' => 0, 'added' => time()]);
    }

    /**
     * Cron job
     * Description: Set pause discounts
     *
     * @return void
     */
    public static function run()
    {
        $self = new self;
        $self
            ->onlyStarted()
            ->getList($discountList);

        $pauseList = [];

        array_filter($discountList, function ($discount) use (&$pauseList) {
            if ($discount['dynamic']['enabled'] == '1') {

                // Pause after X days
                if (!empty($discount['dynamic']['pause_after'])) {
                    if (time() >= strtotime("+{$discount['dynamic']['pause_after']} day", $discount['added'])) {
                        $pauseList[] = ['id' => $discount['id'], 'flg_pause' => 1];
                        return false;
                    }
                }

                $time     = time() - intval($discount['added']);
                $duration = 0;

                // Duration
                switch ($discount['dynamic']['type']) {
                    case 'hours':
                    default:
                        $duration = 60 * 60 * intval($discount['dynamic']['duration']);
                        break;

                    case 'days':
                        $duration = 60 * 60 * 24 * intval($discount['dynamic']['duration']);
                        break;

                    case 'weeks':
                        $duration = 60 * 60 * 24 * 7 * intval($discount['dynamic']['duration']);
                        break;
                }

                // Calc discount amount
                $discount['discount_amount'] -= floor($time / $duration) * floatval($discount['dynamic']['rate']);

                if ($discount['discount_amount'] <= 0) {
                    $pauseList[] = ['id' => $discount['id'], 'flg_pause' => 1];
                    return false;
                }
            }
        });

        foreach ($pauseList as $value) {
            Core_Sql::setUpdate($self->_table, $value);
        }
    }
}
