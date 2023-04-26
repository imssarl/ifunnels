<?php

/** Connect Stripe-php library */
require_once Zend_Registry::get('config')->path->absolute->library . 'vendor' . DIRECTORY_SEPARATOR . 'autoload.php';

class Project_Deliver extends Core_Data_Storage
{

    protected $_table = 'deliver_stripe';

    /**
     * @param [id] ==> Record id in a table
     * @param [user_id] ==> User Id in the iFunnel
     * @param [client_id] ==> Company Id from stripe.com
     * @param [stripe_user_id] ==> User Id from stripe.com
     * @param [status] ==> Сonnected or not connected, values [0 - connected, 1 - not connected]
     * @param [settings] ==> Response in base64 from stripe.com
     * @param string [rewardful_api_key] ==> Rewardful API Key
     * @param [added] ==> Unixtime code when a record is created
     */
    protected $_fields = array('id', 'user_id', 'client_id', 'stripe_user_id', 'status', 'settings', 'rewardful_api_key', 'added');

    /** Installing */
    public static function install()
    {
        Core_Sql::setExec("DROP TABLE IF EXISTS deliver_stripe");
        Core_Sql::setExec(
            "CREATE TABLE `deliver_stripe` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`user_id` INT(11) NOT NULL DEFAULT '0',
				`client_id` VARCHAR(100) NULL DEFAULT NULL,
				`stripe_user_id` VARCHAR(100) NULL DEFAULT NULL,
				`status` TINYINT NULL DEFAULT '0',
				`settings` TEXT NULL,
				`rewardful_api_key` VARCHAR(255) NULL DEFAULT NULL,
				`added` INT(11) UNSIGNED NOT NULL DEFAULT '0',
				UNIQUE INDEX `id` (`id`)
			)
			COLLATE='utf8_general_ci'
			ENGINE=InnoDB;"
        );
    }

    public function beforeSet()
    {
        $this->_data->setFilter(array('empty_to_null'));

        /** Set field [status] */
        $this->_data->setElement('status', (empty($this->_data->filtered['settings']->stripe_user_id) ? 0 : 1));

        /** Set field [user_id] */
        $this->_data->setElement('user_id', Core_Users::$info['id']);

        /** Set field [stripe_user_id] */
        if (!empty($this->_data->filtered['settings']->stripe_user_id)) {
            $this->_data->setElement('stripe_user_id', $this->_data->filtered['settings']->stripe_user_id);
        }

        $this->_data->setElement('client_id', Project_Deliver_Stripe::getClientId());

        /** Encode [setting] field */
        if (!empty($this->_data->filtered['settings'])) {

            $account_info = Project_Deliver_Stripe::getAccountInfo($this->_data->filtered['settings']->stripe_user_id);

            if (isset($account_info['error'])) {
                return Core_Data_Errors::getInstance()->setError($account_info['message']);
            }

            $this->_data->setElement('settings', base64_encode(serialize(['account' => $account_info, 'response' => $this->_data->filtered['settings']])));
        }

        return true;
    }

    public static function getAuthData($code)
    {
        \Stripe\Stripe::setApiKey(Project_Deliver_Stripe::getSecretKey());

        try {
            $response = \Stripe\OAuth::token([
                'grant_type' => 'authorization_code',
                'code'       => $code,
            ]);
        } catch (Exception $e) {
            return ['error' => true, 'message' => $e->getMessage()];
        }

        return $response;
    }

    /** Return [redirect_uri] for auth link the stripe */
    public static function getRedirectUrl()
    {
        return urlencode(sprintf(
            '%s://%s%s',
            (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https' : 'http'),
            $_SERVER['SERVER_NAME'],
            Core_Module_Router::getCurrentUrl(
                array(
                    'name'   => 'site1_deliver',
                    'action' => 'settings',
                )
            )
        ));
    }

    private $_withUserId = false;
    public function withUserId($user_id)
    {
        if (!empty($user_id)) {
            $this->_withUserId = $user_id;
        }

        return $this;
    }

    private $_withAccountInfo = false;
    public function withAccountInfo()
    {
        $this->_withAccountInfo = true;

        return $this;
    }

    protected function assemblyQuery()
    {
        parent::assemblyQuery();

        if (!empty($this->_withUserId)) {
            $this->_crawler->set_where('d.user_id=' . Core_Sql::fixInjection($this->_withUserId));
        }
    }

    protected function init()
    {
        parent::init();
        $this->_withUserId = false;
    }

    public function getList(&$mixRes)
    {
        parent::getList($mixRes);

        if (!empty($mixRes)) {
            if (array_key_exists('0', $mixRes)) {
                foreach ($mixRes as &$item) {
                    $item['settings'] = unserialize(base64_decode($item['settings']));
                }
            } else {
                $mixRes['settings'] = unserialize(base64_decode($mixRes['settings']));

                if ($this->_withAccountInfo) {
                    $stripe_account_data = Project_Deliver_Stripe::getAccountInfo(Project_Deliver_Stripe::getAccountId());

                    if (!isset($stripe_account_data['error'])) {
                        $mixRes['company_data'] = array(
                            'business_name' => $stripe_account_data->business_name,
                            'support_email' => $stripe_account_data->support_email,
                            'support_url'   => $stripe_account_data->support_url,
                        );
                    }

                    $this->_withAccountInfo = false;
                }
            }
        }

        $this->init();
        return $this;
    }

    public static function getRewardfulAPIKey(&$buffer)
    {
        $instnc = new self();

        $instnc
            ->withUserId(Core_Users::$info['id'])
            ->onlyOne()
            ->getList($data);

        $buffer = !empty($data['rewardful_api_key']) ? $data['rewardful_api_key'] : false;
    }
}
