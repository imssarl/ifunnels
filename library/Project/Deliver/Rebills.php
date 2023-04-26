<?php

class Project_Deliver_Rebills extends Core_Data_Storage
{
    protected $_table  = 'deliver_payment_rebills';
    protected $_fields = ['id', 'user_id', 'payment_id', 'invoice_id', 'membership_id', 'customer_id', 'amount', 'status', 'data', 'added'];

    private $_withCustomerName   = false;
    private $_withMembershipName = false;
    private $_withCurrency       = false;
    private $_withFilter         = false;
    private $_withLimit          = false;
    private $_withEmail          = false;
    private $_onlySuccess        = false;
    private $_onlyFailed         = false;
    private $_withInvoiceId      = false;

    /** Installing */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_payment_rebills");
        Core_Sql::setExec(
            "CREATE TABLE `deliver_payment_rebills` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `user_id` INT(11) NOT NULL DEFAULT '0',
                `payment_id` INT(11) NOT NULL DEFAULT '0',
                `invoice_id` TEXT NULL,
                `membership_id` INT(11) NULL DEFAULT '0',
                `customer_id` VARCHAR(255) NULL DEFAULT NULL,
                `amount` INT(11) NOT NULL DEFAULT '0',
                `status` VARCHAR(255) NULL DEFAULT NULL,
                `data` TEXT NULL,
                `added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
                UNIQUE INDEX `id` (`id`)
            )
            COLLATE='utf8_general_ci'
            ENGINE=InnoDB"
        );
    }

    public function withEmail($email)
    {
        $this->_withEmail = $email;
        return $this;
    }

    public function withCustomerName()
    {
        $this->_withCustomerName = true;
        return $this;
    }

    public function withMembershipName()
    {
        $this->_withMembershipName = true;
        return $this;
    }

    public function withCurrency()
    {
        $this->_withCurrency = true;
        return $this;
    }

    public function withFilter($filter)
    {
        if (!empty($filter['time'])) {
            $this->withTime($filter['time'], $filter['date_from'], $filter['date_to']);
        }
        return $this;
    }

    public function withTime($_type, $from, $to)
    {
        $_now = time();
        switch ($_type) {
            case Project_Statistics_Api::TIME_ALL:$this->_withTime = ['from' => 0, 'to' => $_now];
                break;
            case Project_Statistics_Api::TIME_TODAY:$this->_withTime = ['from' => strtotime('today'), 'to' => $_now];
                break;
            case Project_Statistics_Api::TIME_YESTERDAY:$this->_withTime = ['from' => strtotime('yesterday'), 'to' => strtotime('today')];
                break;
            case Project_Statistics_Api::TIME_LAST_7_DAYS:$this->_withTime = ['from' => $_now - 60 * 60 * 24 * 7, 'to' => $_now];
                break;
            case Project_Statistics_Api::TIME_THIS_MONTH:$this->_withTime = ['from' => strtotime('first day of this month'), 'to' => $_now];
                break;
            case Project_Statistics_Api::THIS_YEAR:$this->_withTime = ['from' => strtotime('first day of January ' . date('Y')), 'to' => $_now];
                break;
            case Project_Statistics_Api::TIME_LAST_YEAR:$this->_withTime = ['from' => $_now - 60 * 60 * 24 * 365, 'to' => $_now];
                break;
            case 8:
                $_from = $from;
                if (!is_int($from)) {
                    $_from = strtotime($from);
                }
                $_to = $to;
                if (!is_int($to)) {
                    $_to = strtotime($to);
                }

                $this->_withTime = ['from' => $_from, 'to' => $_to];
                break;
        }

        return $this;
    }

    public function withLimit($limit)
    {
        if (is_integer($limit)) {
            $this->_withLimit = $limit;
        }

        return $this;
    }

    public function onlySuccess()
    {
        $this->_onlySuccess = true;
        return $this;
    }

    public function onlyFailed()
    {
        $this->_onlyFailed = true;
        return $this;
    }

    public function withInvoiceId($invoice_id)
    {
        $this->_withInvoiceId = $invoice_id;
        return $this;
    }

    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if ($this->_withCustomerName) {
            $this->_crawler->set_select('c.email as customer_email');
            $this->_crawler->set_from('RIGHT JOIN deliver_customer c ON c.customer_id = d.customer_id');
        }

        if ($this->_withEmail) {
            if (!$this->_withCustomerName) {
                $this->_crawler->set_from('RIGHT JOIN deliver_customer c ON c.customer_id = d.customer_id AND c.email LIKE "%' . Core_Sql::fixInjection($this->_withEmail) . '%"');
            } else {
                $this->_crawler->set_where('c.email LIKE "%' . Core_Sql::fixInjection($this->_withEmail) . '%"');
            }
        }

        if ($this->_withMembershipName) {
            $this->_crawler->set_select('m.name as membership');
            $this->_crawler->set_from('RIGHT JOIN deliver_membership m ON m.id = d.membership_id');
        }

        // TODO при $this->_withMembershipName работать не будет!
        if ($this->_withCurrency) {
            $this->_crawler->set_select('s.currency as currency');
            $this->_crawler->set_from('RIGHT JOIN `deliver_site` s ON s.id = m.site_id');
        }

        if ($this->_withTime) {
            $this->_crawler->set_where('d.added >= ' . $this->_withTime["from"] . ' AND d.added <= ' . $this->_withTime["to"]);
        }

        if ($this->_withLimit) {
            $this->_crawler->set_limit($this->_withLimit);
        }

        // Only Success
        if ($this->_onlySuccess) {
            $this->_crawler->set_where('d.status IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');
        }

        // Only Failed
        if ($this->_onlyFailed) {
            $this->_crawler->set_where('d.status NOT IN (' . Core_Sql::fixInjection(['trial', 'succeeded', 'active', 'refunded']) . ')');
        }

        if($this->_withInvoiceId) {
            $this->_crawler->set_where('d.invoice_id IN (' . Core_Sql::fixInjection($this->_withInvoiceId) . ')');
        }

        // $this->_crawler->get_sql($_strSql, $this->_paging);
        // var_dump($_strSql);
    }

    protected function init()
    {
        $this->_withCustomerName   = false;
        $this->_withMembershipName = false;
        $this->_withCurrency       = false;
        $this->_withEmail          = false;
        $this->_withFilter         = false;
        $this->_withLimit          = false;
        $this->_onlySuccess        = false;
        $this->_onlyFailed         = false;
        $this->_withInvoiceId      = false;
    }

    public function getPaging(&$arrRes)
    {
        parent::getPaging($arrRes);

        $param = [];

        if ($arrRes['recall'] > 0) {
            $param = array_filter($_GET, function ($key) {
                return strcmp('page', $key) !== 0;
            }, ARRAY_FILTER_USE_KEY);
        }

        $param = array_unique($param);

        if (!empty($param)) {
            $param = http_build_query($param);

            $arrRes['urlmin'] .= '&' . $param;
            $arrRes['urlminus'] .= '&' . $param;
            $arrRes['urlplus'] .= '&' . $param;
            $arrRes['urlmax'] .= '&' . $param;

            foreach ($arrRes['num'] as &$num) {
                $num['url'] .= '&' . $param;
            }
        }

        return $this;
    }

    public function beforeSet()
    {
        $this->_data->setFilter(['clear']);

        if (empty($this->_data->filtered['invoice_id'])) {
            return Core_Data_Errors::getInstance()
                ->setError('Parameter invoice must not be empty');
        }

        $this
            ->withInvoiceId($this->_data->filtered['invoice_id'])
            ->onlyOne()
            ->getList($rebillData);

        if (!empty($rebillData)) {
            $this->_data->setElement('id', $rebillData['id']);
        }

        return true;
    }

    /**
     * Add new record
     *
     * @param [array] $data
     * @return boolean
     */
    public static function add($data, $amount, $invoice_id)
    {
        $payment = new Project_Deliver_Subscription();
        $payment
            ->withSubscriptionId($data->id)
            ->onlyOne()
            ->getList($subData);

        $_this = new self();
        return $_this
            ->setEntered(
                [
                    'user_id'       => $subData['user_id'],
                    'payment_id'    => $subData['id'],
                    'invoice_id'    => $invoice_id,
                    'membership_id' => $subData['plan_id'],
                    'customer_id'   => $data->customer,
                    'amount'        => $amount,
                    'status'        => $data->status,
                    'data'          => json_encode($data),
                ]
            )
            ->set();
    }

    /**
     * Return structured data for a legend
     *
     * @param [array] $arrPayments
     * @return array
     */
    public static function getTree($arrPayments)
    {
        $response = [];
        $flg_year = $flg_month = $flg_day = false;
        $output   = [];

        if (!empty($arrPayments)) {
            $response = [];
            foreach ($arrPayments as $payment) {
                if (!isset($response[date('Y', $payment['added'])])) {
                    $response[date('Y', $payment['added'])] = [];
                }

                if (!isset($response[date('Y', $payment['added'])][date('n', $payment['added'])])) {
                    $response[date('Y', $payment['added'])][date('n', $payment['added'])] = [];
                }

                if (!isset($response[date('Y', $payment['added'])][date('n', $payment['added'])][date('d', $payment['added'])])) {
                    $response[date('Y', $payment['added'])][date('n', $payment['added'])][date('d', $payment['added'])] = 0;
                }

                $response[date('Y', $payment['added'])][date('n', $payment['added'])][date('d', $payment['added'])] += 1;
            }
        }

        if (empty($response)) {return [];}

        if (count($response) > 1) {
            $flg_year = true;
        } else if (count($response[key($response)]) > 1) {
            $flg_month = true;
        } else {
            $flg_day = true;
        }

        if ($flg_year) {
            foreach ($response as $year => $month) {
                foreach ($month as $value) {
                    $output[$year] = array_sum(array_values($value));
                }
            }
        }

        $year = key($response);

        if ($flg_month) {
            foreach ($response[$year] as $month => $value) {
                $output[join('-', [$year, $month])] = array_sum($value);
            }
        }

        if ($flg_day) {
            $month = key($response[$year]);

            foreach ($response[$year][$month] as $day => $value) {
                $output[join('-', [$year, $month, $day])] = $value;
            }
        }

        return $output;
    }
}
